<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.entity.*" %>
<%@ page import="com.DAO.BookDAOImpl" %>
<%@ page import="java.util.*" %>
<%@ page import="com.DB.DBConnect" %>
<%@ page import="java.security.*" %>
<%@ page import="java.util.Base64" %>
<%@ page import="com.Utils.*" %>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>All New Book</title>
    <%@ include file="all_component/allCss.jsp" %>
    <style type="text/css">
        .card-ho:hover {
            background-color: #fcf7f7;
        }

        ::-webkit-scrollbar {
            display: none;
        }
    </style>
    <style type="text/css">
        .card-ho:hover{
            background-color: #fcf7f7;
        }
        ::-webkit-scrollbar {
            display: none;
        }
        body {
            background-image: url('img/book3.png');
            background-size: cover;
            background-repeat: no-repeat;
        }
        
        #toast {
            min-width: 300px;
            position: fixed;
            bottom: 30px;
            left: 50%;
            margin-left: -125px;
            background: #333;
            padding: 10px;
            color: white;
            text-align: center;
            z-index: 1;
            font-size: 18px;
            visibility: hidden;
            box-shadow: 0px 0px 100px #000;
        }
        
        #toast.display {
            visibility: visible;
            animation: fadeIn 0.5, fadeOut 0.5s 2.5s;
        }
        
        @keyframes fadeIn {from { bottom:0;
            opacity: 0;
        }
        
        to {
            bottom: 30px;
            opacity: 1;
        }
        
        }
        @keyframes fadeOut {form { bottom:30px;
            opacity: 1;
        }
        
        to {
            bottom: 0;
            opacity: 0;
        }
    }
        
    </style>
</head>
<body>
<c:if test="${not empty addCart}">
    <div id="toast">${addCart}</div>
    <script type="text/javascript">
        showToast();
        function showToast(content) {
            $('#toast').addClass("display");
            $('#toast').html(content);
            setTimeout(() => {
                $("#toast").removeClass("display");
            }, 2000)
        }
    </script>
    <c:remove var="addCart" scope="session"/>
</c:if>

<%@ include file="all_component/navbar.jsp" %>
<div class="container-fluid p-4">
    <div class="row d-flex align-items-center">
        <% User u = (User) session.getAttribute("userObj"); %>
        <%
            BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());
            List<BookDtls> list = dao.getAllNewBooks();
            for (BookDtls b : list) {
                // Encrypt the book ID
                String encryptedBid = EncryptionDecryptionServlet.encrypt(Integer.toString(b.getBookId()));
                System.out.println("Encrypted book ID: " + encryptedBid);
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
                        <a href="view_books.jsp" class="btn btn-success btn-sm mr-1">View Details</a>
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
