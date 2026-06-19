<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Wishlist</title>

<style>

body{
    font-family:Poppins,Arial,sans-serif;
    background:linear-gradient(
        135deg,
        rgba(235,21,189,0.6),
        rgba(0,0,0,0.8)
    );
    color:white;
}

h2{
    text-align:center;
    margin:30px;
}

.products{
    width:90%;
    margin:auto;
    display:grid;
    grid-template-columns:
    repeat(auto-fit,minmax(250px,1fr));
    gap:25px;
}

.card{
    background:rgba(255,255,255,0.1);
    border-radius:15px;
    overflow:hidden;
    text-align:center;
    padding:15px;
}

.card img{
    width:100%;
    height:220px;
    object-fit:contain;
    background:white;
}

.price{
    color:#00ffae;
    font-size:20px;
    font-weight:bold;
}

.back-btn{
    display:inline-block;
    margin:20px;
    padding:10px 20px;
    background:#185a9d;
    color:white;
    text-decoration:none;
    border-radius:25px;
}

</style>

</head>

<body>

<a href="Product.jsp" class="back-btn">
← Back to Products
</a>

<h2>❤️ My Wishlist</h2>

<div class="products">

<%

try{

Class.forName("org.sqlite.JDBC");

String dbPath =
application.getRealPath("/") +
"database/shopping.db";

Connection con =
DriverManager.getConnection(
"jdbc:sqlite:" + dbPath);

PreparedStatement ps =
con.prepareStatement(

"SELECT p.* FROM products p " +
"INNER JOIN wishlist w " +
"ON p.id=w.product_id"

);

ResultSet rs = ps.executeQuery();

while(rs.next()){

%>

<div class="card">

<img src="<%= rs.getString("image") %>">

<h3>
<%= rs.getString("name") %>
</h3>

<div class="price">
₹ <%= rs.getDouble("price") %>
</div>

</div>

<%

}

rs.close();
ps.close();
con.close();

}catch(Exception e){
out.println(e.getMessage());
}

%>

</div>

</body>
</html>