<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*" %>

<%
String message = "";

String userEmail = (String)session.getAttribute("userEmail");

if(userEmail == null){
    response.sendRedirect("Login.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String name = "";
double price = 0;
String image = "";
String description = "";

try {

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") + "database/shopping.db";

    con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

    Statement stmt = con.createStatement();

    // PRODUCTS TABLE
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS products(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "name TEXT NOT NULL," +
        "price REAL NOT NULL," +
        "image TEXT," +
        "description TEXT)"
    );

    // CART TABLE
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS cart(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "user_email TEXT," +
        "product_name TEXT," +
        "price REAL," +
        "image TEXT," +
        "quantity INTEGER)"
    );

    int productId = Integer.parseInt(request.getParameter("id"));

    // LOAD PRODUCT
    ps = con.prepareStatement("SELECT * FROM products WHERE id=?");
    ps.setInt(1, productId);

    rs = ps.executeQuery();

    if(rs.next()){
        name = rs.getString("name");
        price = rs.getDouble("price");
        image = rs.getString("image");
        description = rs.getString("description");
    }

    rs.close();
    ps.close();

    // ADD TO CART
    if("POST".equalsIgnoreCase(request.getMethod())){

        int quantity = Integer.parseInt(request.getParameter("quantity"));

        PreparedStatement cartPs = con.prepareStatement(
            "INSERT INTO cart(user_email,product_name,price,image,quantity) VALUES(?,?,?,?,?)"
        );

        cartPs.setString(1, userEmail);
        cartPs.setString(2, name);
        cartPs.setDouble(3, price);
        cartPs.setString(4, image);
        cartPs.setInt(5, quantity);

        cartPs.executeUpdate();
        cartPs.close();

        message = "✅ Product added to cart successfully!";
    }

} catch(Exception e){
    message = "❌ Error: " + e.getMessage();
} finally {
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(con != null) con.close(); } catch(Exception e) {}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Product Details</title>

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
    align-items: center;
}

/* Container */
.container {
    width: 85%;
    margin: 50px auto;
}

/* Product Card */
.card {
    background: rgba(255,255,255,0.1);
    display: flex;
    flex-wrap: wrap;
    padding: 30px;
    border-radius: 18px;
    backdrop-filter: blur(12px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0,0,0,0.6);
}

/* Image Section */
.image-section {
    flex: 1;
    text-align: center;
}

.image-section img {
    width: 350px;
    max-width: 100%;
    border-radius: 12px;
    transition: transform 0.4s ease;
}

.image-section img:hover {
    transform: scale(1.05);
}

/* Details Section */
.details {
    flex: 1;
    padding: 20px;
    color: #fff;
}

.details h2 {
    margin-bottom: 15px;
    font-size: 28px;
    font-weight: 700;
    color: #ffeaa7;
}

.price {
    color: #00ffae;
    font-size: 26px;
    font-weight: bold;
    margin-bottom: 15px;
}

.desc {
    margin-bottom: 20px;
    line-height: 1.6;
    color: #ddd;
    font-size: 15px;
}

/* Quantity Input */
input[type=number] {
    width: 80px;
    padding: 10px;
    margin-bottom: 15px;
    border-radius: 8px;
    border: 2px solid rgba(255,255,255,0.3);
    background: transparent;
    color: #fff;
    text-align: center;
}

/* Button */
button {
    padding: 12px 25px;
    border: none;
    background: linear-gradient(135deg, #43cea2, #185a9d);
    color: white;
    border-radius: 30px;
    cursor: pointer;
    font-weight: 600;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

button:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(67,206,162,0.8);
}

/* Message */
.message {
    margin-bottom: 15px;
    font-weight: bold;
    color: #00ffae;
    text-align: center;
}

/* Links */
.links {
    margin-top: 20px;
}

.links a {
    margin-right: 15px;
    text-decoration: none;
    color: #0deeee;
    font-weight: 600;
    transition: color 0.3s ease;
}

.links a:hover {
    color: #ffeaa7;
}


</style>

</head>

<body>

<div class="container">

    <% if(!message.equals("")) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <div class="card">

        <div class="image-section">
            <img src="<%= image %>" alt="<%= name %>">
        </div>

        <div class="details">

            <h2><%= name %></h2>

            <div class="price">
                ₹ <%= price %>
            </div>

            <div class="desc">
                <%= (description != null && !description.trim().isEmpty())
                    ? description
                    : "No description available" %>
            </div>

            <form method="post">

                Quantity:
                <br><br>

                <input type="number" name="quantity" min="1" value="1" required>

                <br><br>

                <button type="submit">Add to Cart</button>

            </form>

            <div class="links">
                <a href="Product.jsp">← Back</a>
                <a href="Cart.jsp">View Cart</a>
            </div>

        </div>

    </div>

</div>

</body>
</html>