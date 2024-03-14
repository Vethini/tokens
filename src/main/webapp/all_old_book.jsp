<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.entity.*" %>
<%@ page import="com.DAO.BookDAOImpl" %>
<%@ page import="com.DB.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.Utils.*" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>All Old Book</title>
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
        <%
            BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());
            List<BookDtls> list = dao.getAllOldBooks();
            for (BookDtls b : list) {
                // Encrypt the book ID
                String encryptedBookId = EncryptionDecryptionServlet.encrypt(Integer.toString(b.getBookId()));
        %>
        <div class="col-md-3 m-0.5 pb-2">
            <div class="card card-ho">
                <div class="card-body text-center">
                    <p><%= b.getRefId() %></p>
                    <p><%= b.getBookName() %></p>
                    <p><%= b.getAuthor() %></p>
                    <p> Category: <%= b.getBookCategory() %> </p>
                    <div class="row d-flex justify-content-around">
                    <!-- Link to view_books.jsp with encrypted book ID -->
                    <form action="view_books.jsp" method="post">
                        <input type="hidden" name="encryptedBookId" value="<%= encryptedBookId %>">
                        <button type="submit" class="btn btn-success btn-sm mr-1">View Details</button>
                    </form>
                    <a href="" class="btn btn-danger btn-sm"><i class="fa-solid fa-indian-rupee-sign"></i> <%= b.getPrice() %></a>
                </div>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</div>

</body>
</html>
