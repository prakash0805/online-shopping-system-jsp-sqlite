
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String userName = (String)session.getAttribute("userName");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PANDIYAN STORE - Home</title>
<link rel="stylesheet" href="css/style.css">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Poppins", Arial, sans-serif;
}

body {
    background: #f4f6f9;
    color: #c816a7;
    line-height: 1.6;
}

/* Header */
header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 18px 60px;
    background: #2c446a; /* dark corporate blue */
    color: #fff;
    box-shadow: 0 4px 12px rgba(130, 33, 33, 0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
}

header .logo {
    font-size: 22px;
    font-weight: 700;
    letter-spacing: 1px;
}

header nav a {
    margin: 0 12px;
    text-decoration: none;
    color: #cbd5e1;
    font-weight: 500;
    transition: color 0.3s ease;
}

header nav a:hover {
    color: #38bdf8; /* cyan accent */
}

/* Welcome message */
.welcome {
    text-align: center;
    margin: 20px 0;
    font-size: 18px;
    font-weight: 600;
    color: #3669cd;
}

/* Hero Section */
.hero {
    background: linear-gradient(135deg, rgba(235, 21, 189, 0.6), rgba(0,0,0,0.8)),
                url("https://images.unsplash.com/photo-1606788075761-7a5a7a7a7a7a") no-repeat center center/cover;
    min-height: 70vh;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #fff;
    text-align: center;
}

.hero-content h1 {
    font-size: 40px;
    margin-bottom: 15px;
    font-weight: 700;
}

.hero-content p {
    font-size: 18px;
    margin-bottom: 25px;
    color: #e4dfe6;
}

.hero-content .btn {
    display: inline-block;
    margin: 10px;
    padding: 12px 28px;
    background: #38bdf8;
    color: #fff;
    border-radius: 30px;
    text-decoration: none;
    font-weight: 600;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.hero-content .btn:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 18px rgba(56,189,248,0.5);
}

/* Footer */
footer {
    background: #14203a;
    color: #62839a;
    text-align: center;
    padding: 20px;
    margin-top: 40px;
    font-size: 14px;
}

footer p {
    margin: 0;
}

</style>

</head>

<body>

<header>

    <div class="logo">
        PANDIYAN STORE
    </div>

    <nav>

        <a href="Home.jsp">Home</a>

        <a href="Product.jsp">Products</a>

        <a href="Cart.jsp">Cart</a>

        <a href="Orders.jsp">Orders</a>

        <% if(userName == null){ %>

            <a href="Register.jsp">Register</a>

            <a href="Login.jsp">Login</a>

        <% } else { %>

            <a href="Logout.jsp">Logout</a>

        <% } %>

    </nav>

</header>

<% if(userName != null){ %>

<div class="welcome">

    Welcome,
    <strong><%= userName %></strong>

</div>

<% } %>

<section class="hero">

    <div class="hero-content">

        <h1>
            Welcome to Pandiyan Store
        </h1>

        <p>
            Fresh Fruits, Vegetables and Groceries
            at the Best Prices.
        </p>

        <a href="Product.jsp" class="btn">
            Shop Now
        </a>

        <% if(userName == null){ %>

        <a href="Register.jsp" class="btn">
            Join Us
        </a>

        <% } %>

    </div>

</section>

<footer>

    <p>
        © 2026 Pandiyan Store. All Rights Reserved.
    </p>

</footer>

</body>
</html>
```
