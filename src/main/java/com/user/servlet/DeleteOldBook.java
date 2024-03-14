package com.user.servlet;

import java.io.IOException;
import com.DAO.BookDAOImpl;
import com.DB.DBConnect;
import com.Utils.EncryptionDecryptionServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DeleteOldBookPost", urlPatterns = {"/delete_old_book"}, loadOnStartup = 1)
public class DeleteOldBook extends HttpServlet{

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            HttpSession session = req.getSession();
            String encryptedBookId = req.getParameter("encryptedBookId");
            
            // Decrypt the encrypted book ID
            String decryptedBookId = EncryptionDecryptionServlet.decrypt(encryptedBookId);
          //  System.out.println(decryptedBookId);
            if(decryptedBookId != null) {
                int bookId = Integer.parseInt(decryptedBookId);
                String email = (String) session.getAttribute("userEmail");
                System.out.println(bookId);
                System.out.println(email);
                BookDAOImpl daoImpl = new BookDAOImpl(DBConnect.getConn());
                boolean f = daoImpl.oldBookDelete(email, "Old", bookId);
                
                if(f) {
                    session.setAttribute("succMsg", "Old Book removed successfully.");
                    resp.sendRedirect("old_book.jsp");
                } else {
                    session.setAttribute("failedMsg", "Something went wrong on server.");
                    resp.sendRedirect("old_book.jsp");
                }
            } else {
                session.setAttribute("failedMsg", "Failed to decrypt the book ID.");
                resp.sendRedirect("old_book.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Error: " + e.getMessage());
            resp.sendRedirect("old_book.jsp");
        }
        
    }
}
