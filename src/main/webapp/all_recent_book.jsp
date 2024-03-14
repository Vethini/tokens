<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.entity.BookDtls"%>
<%@ page import="com.entity.User"%>
<%@ page import="com.DAO.BookDAOImpl"%>
<%@ page import="java.util.*"%>
<%@ page import="com.DB.DBConnect"%>
<%@ page import="com.Utils.EncryptionDecryptionServlet"%> <!-- Import the EncryptionDecryptionServlet -->
<%@ page import="jakarta.servlet.http.HttpSession"%> <!-- Import HttpSession -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>All Recent Book</title>
    <%@ include file="all_component/allCss.jsp" %>
    <style type="text/css">
        .card-ho:hover {
            background-color: #fcf7f7;
        }

        ::-webkit-scrollbar {
            display: none;
        }
    </style>
</head>
<body>
<%@include file="all_component/navbar.jsp" %>
<div class="container-fluid p-4">
    <div class="row d-flex align-items-center">
        <% User u = (User) session.getAttribute("userObj"); %>
        
        <%
            BookDAOImpl dao2 = new BookDAOImpl(DBConnect.getConn());
            List<BookDtls> list2 = dao2.getAllRecentBooks();
            for (BookDtls b : list2) {
                // Encrypt the book ID
                String encryptedBid = EncryptionDecryptionServlet.encrypt(Integer.toString(b.getBookId()));
                session.setAttribute("encryptedBid", encryptedBid);
        %>
            <div class="col-md-3 m-0.5 pb-2">
                <div class="card card-ho">
                    <div class="card-body text-center">
                        <p><%= b.getRefId() %></p>
                        <p><%= b.getBookName() %></p>
                        <p><%= b.getAuthor() %></p>
                        <p> Category: <%= b.getBookCategory() %> </p>
                        <div class="row d-flex justify-content-around">
                            <% if (b.getBookCategory().equals("Old")) { %>
                                <a href="view_books.jsp?encryptedBookId=<%= encryptedBid %>" class="btn btn-success btn-sm mr-1">View Details</a>
                                <a href="" class="btn btn-danger btn-sm"><i class="fa-solid fa-indian-rupee-sign"></i> <%= b.getPrice() %></a>
                            <% } else { %>
                                <form action="cart" method="post">
                                    <% if (u == null) { %>
                                        <a href="login.jsp" class="btn btn-danger btn-sm mr-1"><i class="fa-solid fa-cart-plus fa-2xs"></i> Add Cart</a>
                                    <% } else { %>
                                        <button type="submit" class="btn btn-danger btn-sm mr-1"><i class="fa-solid fa-cart-plus fa-2xs"></i> Add Cart</button>
                                    <% } %>
                                    <input type="hidden" name="encryptedBookId" value="<%= encryptedBid %>">
                                </form>
                                <form action="view_books.jsp" method="post">
                                    <input type="hidden" name="encryptedBookId" value="<%= encryptedBid %>">
                                    <button type="submit" class="btn btn-success btn-sm mr-1">View Details</button>
                                </form>
                                <a href="" class="btn btn-danger btn-sm"><i class="fa-solid fa-indian-rupee-sign"></i> <%= b.getPrice() %></a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
