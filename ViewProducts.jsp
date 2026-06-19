<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>

<%
String admin = (String)session.getAttribute("admin");

if(admin == null){
    response.sendRedirect("AdminLogin.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") + "database/shopping.db";

    con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

    ps = con.prepareStatement("SELECT * FROM products");

    rs = ps.executeQuery();

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Products</title>

<style>

body{
    font-family:Arial;
    background:#f2f2f2;
    margin:0;
}

.container{
    width:95%;
    margin:30px auto;
}

h2{
    text-align:center;
    margin-bottom:20px;
    color:#2c3e50;
}

table{
    width:100%;
    border-collapse:collapse;
    background:white;
    box-shadow:0 0 10px rgba(0,0,0,0.2);
}

th{
    background:#2c3e50;
    color:white;
    padding:12px;
}

td{
    padding:12px;
    text-align:center;
    border:1px solid #ddd;
}

img{
    width:70px;
    height:70px;
    object-fit:cover;
    border-radius:10px;
}

a{
    text-decoration:none;
    padding:6px 10px;
    border-radius:5px;
    color:white;
    font-size:14px;
}

.edit{
    background:#3498db;
}

.delete{
    background:#e74c3c;
}

.add{
    display:inline-block;
    margin-bottom:15px;
    padding:10px 15px;
    background:#27ae60;
    color:white;
    border-radius:8px;
}

.add:hover{
    background:#219150;
}

</style>

</head>

<body>

<div class="container">

<h2>📦 All Products</h2>

<a class="add" href="AddProduct.jsp">+ Add Product</a>

<table>

<tr>
    <th>ID</th>
    <th>Image</th>
    <th>Name</th>
    <th>Price</th>
    <th>Description</th>
    <th>Actions</th>
</tr>

<%
while(rs.next()){
%>

<tr>

    <td><%= rs.getInt("id") %></td>

    <td>
        <img src="<%= rs.getString("image") %>">
    </td>

    <td><%= rs.getString("name") %></td>

    <td>₹ <%= rs.getDouble("price") %></td>

    <td><%= rs.getString("description") %></td>

    <td>

        <a class="edit"
           href="EditProduct.jsp?id=<%= rs.getInt("id") %>">
            Edit
        </a>

        <a class="delete"
           href="DeleteProduct.jsp?id=<%= rs.getInt("id") %>"
           onclick="return confirm('Are you sure to delete?')">
            Delete
        </a>

    </td>

</tr>

<%
}

} catch(Exception e){
    out.println("<h3 style='color:red;text-align:center;'>" + e.getMessage() + "</h3>");
} finally {
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(con != null) con.close(); } catch(Exception e) {}
}
%>

</table>

</div>

</body>
</html>