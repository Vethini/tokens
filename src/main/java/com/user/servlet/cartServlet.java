package com.user.servlet;

import java.io.IOException;
import java.util.Base64;
import com.entity.*;
import com.DAO.BookDAOImpl;
import com.DAO.cartDAOimpl;
import com.DB.DBConnect;
import com.entity.BookDtls;
import com.entity.Cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.Utils.EncryptionDecryptionServlet;

@WebServlet("/cart")
public class cartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get the encrypted book ID and user ID from the request parameters
            String encryptedBid = req.getParameter("encryptedBookId");
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("userObj");
            int uid = user.getId(); // Assuming getId() returns the user ID

            String decryptedBid = EncryptionDecryptionServlet.decrypt(encryptedBid);
            int bid = Integer.parseInt(decryptedBid);

            BookDAOImpl daoImpl = new BookDAOImpl(DBConnect.getConn());
            BookDtls b = daoImpl.getBookById(bid);

            Cart cart = new Cart();
            cart.setBid(bid);
            cart.setUserId(uid);
            cart.setBookName(b.getBookName());
            cart.setAuthor(b.getAuthor());
            cart.setPrice(Double.parseDouble(b.getPrice()));
            cart.setTotalPrice(Double.parseDouble(b.getPrice()));

            cartDAOimpl dao2 = new cartDAOimpl(DBConnect.getConn());
            boolean f = dao2.addcart(cart);

            if (f) {
            	session.setAttribute("addCart", "Book added to cart");
            	System.out.println("addCart attribute set: " + session.getAttribute("addCart"));

                resp.sendRedirect("all_new_book.jsp");
            } else {
                session.setAttribute("failed", "Something Wrong Happened!");
                resp.sendRedirect("all_new_book.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
