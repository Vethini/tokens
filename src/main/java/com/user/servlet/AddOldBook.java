package com.user.servlet;

import java.io.IOException;

import com.DAO.BookDAOImpl;
import com.DB.DBConnect;
import com.entity.BookDtls;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add_old_Books")
// below @multipartconfig is important when we use file upload in form
@MultipartConfig
public class AddOldBook extends HttpServlet{

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        try {
            // Get parameters from request
            String bookname = req.getParameter("bname");
            String author = req.getParameter("author");
            String price = req.getParameter("price");
            String categories = "Old";
            String status = "Active";
            String referenceId = req.getParameter("referenceId");
            
            // Retrieve user email from request
            String userEmail = (String) req.getSession().getAttribute("userEmail");
            System.out.println(userEmail);
            // Set user email attribute in the session
            HttpSession session = req.getSession();
            session.setAttribute("userEmail", userEmail);
            
            // Create a BookDtls object
            BookDtls b = new BookDtls(bookname, author, price, categories, status, referenceId, userEmail);
            
            // Initialize BookDAOImpl and add the book to the database
            BookDAOImpl daoImpl = new BookDAOImpl(DBConnect.getConn());
            boolean f = daoImpl.addBooks(b);
            
            // Redirect based on the result of adding the book
            if(f) {
                session.setAttribute("succMsg", "Book added successfully");
                resp.sendRedirect("sell_book.jsp");
            } else {
                session.setAttribute("failedMsg", "Something went wrong on the server");
                resp.sendRedirect("sell_book.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("error.jsp"); // Redirect to an error page in case of an exception
        }
        
    }

    
}
