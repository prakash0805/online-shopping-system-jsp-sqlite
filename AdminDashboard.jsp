<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%
String admin = (String)session.getAttribute("admin");

if(admin == null){
    response.sendRedirect("AdminLogin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
<link rel="stylesheet" href="css/style.css">

<style>

body{
    margin:0;
    font-family:Arial;
    background:#f2f2f2;
}

/* TOP BAR */
.topbar{
    background:#2c3e50;
    color:white;
    padding:15px 20px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.topbar h2{
    margin:0;
}

/* CONTAINER */
.container{
    width:90%;
    margin:40px auto;
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
    gap:20px;
}

/* CARDS */
.card{
    background:white;
    padding:30px;
    text-align:center;
    border-radius:12px;
    box-shadow:0 0 10px rgba(0,0,0,0.2);
    transition:0.3s;
}

.card:hover{
    transform:scale(1.05);
}

.card a{
    text-decoration:none;
    color:white;
    background:#3498db;
    padding:10px 15px;
    border-radius:8px;
    display:inline-block;
    margin-top:10px;
}

.logout{
    background:red !important;
}

h1{
    text-align:center;
    margin-top:30px;
}

</style>

</head>

<body>

<div class="topbar">
    <h2>Admin Panel</h2>
    <div>Welcome, <%= admin %></div>
</div>

<h1>Dashboard</h1>

<div class="container">

    <div class="card">
        <h3>Add Product</h3>
        <a href="AddProduct.jsp">Open</a>
    </div>

    <div class="card">
        <h3>View Products</h3>
        <a href="ViewProducts.jsp">Open</a>
    </div>

    <div class="card">
        <h3>View Orders</h3>
        <a href="Orders.jsp">Open</a>
    </div>

    <div class="card">
        <h3>Logout</h3>
        <a href="AdminLogout.jsp" class="logout">Logout</a>
    </div>

</div>

</body>
</html>
```
