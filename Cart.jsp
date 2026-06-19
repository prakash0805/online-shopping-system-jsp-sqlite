<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
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

double grandTotal = 0;

try {

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") + "database/shopping.db";

    con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

    Statement stmt = con.createStatement();

    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS cart(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "user_email TEXT," +
        "product_name TEXT," +
        "price REAL," +
        "image TEXT," +
        "quantity INTEGER)"
    );

    // DELETE ITEM
    String deleteId = request.getParameter("delete");
    if(deleteId != null){
        PreparedStatement del = con.prepareStatement(
            "DELETE FROM cart WHERE id=? AND user_email=?"
        );
        del.setInt(1, Integer.parseInt(deleteId));
        del.setString(2, userEmail);
        del.executeUpdate();
        del.close();
    }

    // UPDATE QUANTITY
    String updateId = request.getParameter("updateId");
    String qty = request.getParameter("qty");

    if(updateId != null && qty != null){
        PreparedStatement up = con.prepareStatement(
            "UPDATE cart SET quantity=? WHERE id=? AND user_email=?"
        );
        up.setInt(1, Integer.parseInt(qty));
        up.setInt(2, Integer.parseInt(updateId));
        up.setString(3, userEmail);
        up.executeUpdate();
        up.close();
    }

    ps = con.prepareStatement(
        "SELECT * FROM cart WHERE user_email=?"
    );
    ps.setString(1, userEmail);

    rs = ps.executeQuery();

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Cart</title>
<link rel="stylesheet" href="css/style.css">

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Poppins", Arial, sans-serif;
}

body {
        background: linear-gradient(135deg, rgba(235, 21, 189, 0.6), rgba(0,0,0,0.8));
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    padding: 40px 0;
}

/* Container */
.container {
    width: 90%;
    margin: auto;
    color: #fff;
}

/* Heading */
.container h2 {
    text-align: center;
    margin-bottom: 25px;
    font-size: 28px;
    font-weight: bold;
    color: #ffeaa7;
}

/* Table */
table {
    width: 100%;
    background: rgba(255,255,255,0.1);
    border-collapse: collapse;
    backdrop-filter: blur(12px);
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
}

th {
    background: rgba(0,0,0,0.6);
    color: #fff;
    padding: 12px;
    font-weight: 600;
    text-transform: uppercase;
}

td {
    padding: 12px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.2);
    color: #eee;
}

tr:hover {
    background: rgba(255,255,255,0.05);
}

/* Product Image */
img {
    width: 70px;
    height: 70px;
    border-radius: 10px;
    transition: transform 0.3s ease;
}

img:hover {
    transform: scale(1.1);
}

/* Inputs */
input {
    width: 60px;
    padding: 6px;
    border-radius: 6px;
    border: 2px solid rgba(255,255,255,0.3);
    background: transparent;
    color: #fff;
    text-align: center;
}

/* Buttons */
.btn {
    padding: 6px 12px;
    text-decoration: none;
    color: #fff;
    border-radius: 6px;
    font-weight: 600;
    transition: transform 0.2s ease, box-shadow 0.3s ease;
    border: none;
    cursor: pointer;
}

.update {
    background: linear-gradient(135deg, #43cea2, #185a9d);
}

.delete {
    background: linear-gradient(135deg, #ff416c, #ff4b2b);
}

.btn:hover {
    transform: scale(1.05);
    box-shadow: 0 0 12px rgba(255,255,255,0.6);
}

/* Grand Total */
.total {
    text-align: right;
    font-size: 22px;
    margin-top: 20px;
    font-weight: bold;
    color: #0bc8ee;
}

/* Checkout Button */
.checkout {
    display: inline-block;
    margin-top: 15px;
    padding: 12px 20px;
    background: linear-gradient(135deg, #38bdf8, #3b82f6);
    color: #fff;
    text-decoration: none;
    border-radius: 30px;
    font-weight: 600;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.checkout:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(56,189,248,0.8);
}
.back-btn{
    display:inline-block;
    margin:20px;
    padding:10px 20px;
    background:linear-gradient(135deg,#43cea2,#185a9d);
    color:#fff;
    text-decoration:none;
    border-radius:25px;
    font-weight:600;
    transition:0.3s;
}

.back-btn:hover{
    transform:translateY(-2px);
    box-shadow:0 5px 15px rgba(67,206,162,0.5);
}


</style>

</head>

<body>

<div class="container">

<h2>Your Cart</h2>

<table>

<tr>
    <th>Image</th>
    <th>Product</th>
    <th>Price</th>
    <th>Qty</th>
    <th>Total</th>
    <th>Action</th>
</tr>

<%
while(rs.next()){

    double total = rs.getDouble("price") * rs.getInt("quantity");
    grandTotal += total;
%>

<tr>

    <td><img src="<%= rs.getString("image") %>"></td>

    <td><%= rs.getString("product_name") %></td>

    <td>₹ <%= rs.getDouble("price") %></td>

    <td>

        <form method="get">
            <input type="hidden" name="updateId" value="<%= rs.getInt("id") %>">
            <input type="number" name="qty" value="<%= rs.getInt("quantity") %>" min="1">
            <button class="btn update">Update</button>
        </form>

    </td>

    <td>₹ <%= total %></td>

    <td>
        <a class="btn delete"
           href="Cart.jsp?delete=<%= rs.getInt("id") %>"
           onclick="return confirm('Remove item?')">
           Delete
        </a>
    </td>

</tr>

<%
}
%>

</table>

<div class="total">
    Grand Total: ₹ <%= grandTotal %>
</div>

<a class="checkout" href="Checkout.jsp">
    Proceed to Checkout
</a>
<a href="Product.jsp" class="back-btn">← Back to Products</a>

</div>

</body>
</html>

<%
} catch(Exception e){
    out.println("<h3 style='color:red;text-align:center;'>" + e.getMessage() + "</h3>");
} finally {
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(con != null) con.close(); } catch(Exception e) {}
}
%>