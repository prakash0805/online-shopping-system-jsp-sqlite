<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>

<%
String userEmail = (String)session.getAttribute("userEmail");

if(userEmail == null){
    response.sendRedirect("Login.jsp");
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

    Statement stmt = con.createStatement();

    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS orders(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "user_email TEXT," +
        "full_name TEXT," +
        "address TEXT," +
        "city TEXT," +
        "pincode TEXT," +
        "phone TEXT," +
        "payment_method TEXT," +
        "total REAL," +
        "order_date DATETIME DEFAULT CURRENT_TIMESTAMP)"
    );

    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS order_items(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "order_id INTEGER," +
        "product_name TEXT," +
        "price REAL," +
        "quantity INTEGER)"
    );

}catch(Exception e){
    out.println(e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Your Orders</title>
<link rel="stylesheet" href="css/style.css">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Poppins", Arial, sans-serif;
}

body {
    background: linear-gradient(135deg, rgba(235, 21, 189, 0.6), rgba(0,0,0,0.8)); /* stylish gradient */
    min-height: 100vh;
    color: #fff;
}

/* Container */
.container {
    width: 90%;
    margin: 40px auto;
}

/* Heading */
h2 {
    text-align: center;
    margin-bottom: 30px;
    font-size: 28px;
    font-weight: bold;
    color: #ffeaa7;
}

/* Order Card */
.order-card {
    background: rgba(255,255,255,0.1);
    padding: 20px;
    margin-bottom: 25px;
    border-radius: 18px;
    backdrop-filter: blur(12px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.order-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 12px 35px rgba(0,0,0,0.6);
}

/* Order Header */
.order-header {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    border-bottom: 1px solid rgba(255,255,255,0.2);
    padding-bottom: 10px;
    margin-bottom: 15px;
}

.order-header h3 {
    color: #22ef17;
    font-weight: 600;
}

.status {
    padding: 6px 14px;
    border-radius: 20px;
    background: linear-gradient(135deg, #43cea2, #185a9d);
    color: #fff;
    font-size: 13px;
    font-weight: 600;
}

/* Order Details */
.details p {
    margin: 6px 0;
    color: #ddd;
}

/* Items Table */
.items {
    margin-top: 15px;
}

.items h4 {
    margin-bottom: 10px;
    color: #ffeaa7;
}

.items table {
    width: 100%;
    border-collapse: collapse;
    backdrop-filter: blur(8px);
    border-radius: 12px;
    overflow: hidden;
}

.items th {
    background: rgba(0,0,0,0.6);
    color: #fff;
    padding: 10px;
    text-transform: uppercase;
    font-size: 14px;
}

.items td {
    padding: 10px;
    border-bottom: 1px solid rgba(255,255,255,0.2);
    text-align: center;
    color: #eee;
}

.items tr:hover {
    background: rgba(255,255,255,0.05);
}

/* Actions */
.actions {
    margin-top: 30px;
    text-align: center;
}

.actions a {
    display: inline-block;
    margin: 10px;
    padding: 12px 20px;
    text-decoration: none;
    color: #fff;
    border-radius: 30px;
    font-weight: 600;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.home {
    background: linear-gradient(135deg, #ccd9de, #3b82f6);
}

.shop {
    background: linear-gradient(135deg, #ff416c, #ff4b2b);
}

.actions a:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(255,255,255,0.6);
}

/* Empty Orders */
.empty {
    text-align: center;
    font-size: 22px;
    margin-top: 40px;
    color: #ddd;
}

</style>

</head>

<body>

<div class="container">

<h2>Your Orders</h2>

<%

try{

    ps = con.prepareStatement(
        "SELECT * FROM orders WHERE user_email=? ORDER BY id DESC"
    );

    ps.setString(1,userEmail);

    rs = ps.executeQuery();

    boolean hasOrders = false;

    while(rs.next()){

        hasOrders = true;

        int orderId = rs.getInt("id");
%>

<div class="order-card">

    <div class="order-header">

        <h3>Order ID : <%= orderId %></h3>

        <div class="status">Processing</div>

    </div>

    <div class="details">

        <p><b>Name :</b> <%= rs.getString("full_name") %></p>
        <p><b>Address :</b> <%= rs.getString("address") %>, <%= rs.getString("city") %> - <%= rs.getString("pincode") %></p>
        <p><b>Phone :</b> <%= rs.getString("phone") %></p>
        <p><b>Payment :</b> <%= rs.getString("payment_method") %></p>
        <p><b>Total :</b> ₹ <%= rs.getDouble("total") %></p>
        <p><b>Date :</b> <%= rs.getString("order_date") %></p>

    </div>

    <div class="items">

        <h4>Items</h4>

        <table>

        <tr>
            <th>Product</th>
            <th>Price</th>
            <th>Quantity</th>
        </tr>

<%
        PreparedStatement itemPs =
            con.prepareStatement(
                "SELECT * FROM order_items WHERE order_id=?"
            );

        itemPs.setInt(1,orderId);

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

</div>

<%
    }

    if(!hasOrders){
%>

<div class="empty">
    No orders found.
</div>

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

<div class="actions">

    <a href="Home.jsp" class="home">Back to Home</a>
    <a href="Product.jsp" class="shop">Continue Shopping</a>

</div>

</div>

</body>
</html>
```
