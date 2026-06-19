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
ResultSet itemsRs = null;

try{

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") +
                    "database/shopping.db";

    con = DriverManager.getConnection(
            "jdbc:sqlite:" + dbPath);

}catch(Exception e){
    out.println(e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Orders</title>

<style>

body{
    font-family:Arial;
    background:#f2f2f2;
}

.container{
    width:95%;
    margin:30px auto;
}

h2{
    text-align:center;
    margin-bottom:20px;
}

.order-card{
    background:white;
    padding:20px;
    margin-bottom:20px;
    border-radius:12px;
    box-shadow:0 0 10px rgba(0,0,0,0.2);
}

.header{
    display:flex;
    justify-content:space-between;
    border-bottom:1px solid #ddd;
    padding-bottom:10px;
}

.status{
    background:#3498db;
    color:white;
    padding:5px 10px;
    border-radius:15px;
}

.details p{
    margin:5px 0;
}

table{
    width:100%;
    margin-top:10px;
    border-collapse:collapse;
}

th{
    background:#2c3e50;
    color:white;
    padding:10px;
}

td{
    padding:10px;
    text-align:center;
    border:1px solid #ddd;
}

</style>

</head>

<body>

<div class="container">

<h2>All Customer Orders</h2>

<%
try{

    ps = con.prepareStatement(
        "SELECT * FROM orders ORDER BY id DESC"
    );

    rs = ps.executeQuery();

    boolean hasOrders = false;

    while(rs.next()){

        hasOrders = true;

        int orderId = rs.getInt("id");
%>

<div class="order-card">

    <div class="header">

        <h3>Order ID: <%= orderId %></h3>

        <div class="status">Processing</div>

    </div>

    <div class="details">

        <p><b>User:</b> <%= rs.getString("user_email") %></p>
        <p><b>Name:</b> <%= rs.getString("full_name") %></p>
        <p><b>Phone:</b> <%= rs.getString("phone") %></p>
        <p><b>Payment:</b> <%= rs.getString("payment_method") %></p>
        <p><b>Total:</b> ₹ <%= rs.getDouble("total") %></p>
        <p><b>Date:</b> <%= rs.getString("order_date") %></p>

    </div>

    <h4>Items</h4>

    <table>

        <tr>
            <th>Product</th>
            <th>Price</th>
            <th>Qty</th>
        </tr>

<%
        PreparedStatement itemPs =
            con.prepareStatement(
                "SELECT * FROM order_items WHERE order_id=?"
            );

        itemPs.setInt(1, orderId);

        itemsRs = itemPs.executeQuery();

        while(itemsRs.next()){
%>

        <tr>
            <td><%= itemsRs.getString("product_name") %></td>
            <td>₹ <%= itemsRs.getDouble("price") %></td>
            <td><%= itemsRs.getInt("quantity") %></td>
        </tr>

<%
        }

        itemsRs.close();
        itemPs.close();
%>

    </table>

</div>

<%
    }

    if(!hasOrders){
%>

<h3 style="text-align:center;">No Orders Found</h3>

<%
    }

}catch(Exception e){
    out.println(e.getMessage());
}finally{

    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}
%>

</div>

</body>
</html>
```
