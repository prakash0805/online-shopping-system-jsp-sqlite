<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>

<%
String admin = (String)session.getAttribute("admin");

if(admin == null){
    response.sendRedirect("AdminLogin.jsp");
    return;
}

String msg = "";

Connection con = null;
PreparedStatement ps = null;

try {

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") + "database/shopping.db";

    con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

    Statement stmt = con.createStatement();

    // TABLE (with description)
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS products(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "name TEXT," +
        "price REAL," +
        "image TEXT," +
        "description TEXT)"
    );

    if("POST".equalsIgnoreCase(request.getMethod())) {

        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String image = request.getParameter("image");
        String description = request.getParameter("description");

        ps = con.prepareStatement(
            "INSERT INTO products(name,price,image,description) VALUES(?,?,?,?)"
        );

        ps.setString(1, name);
        ps.setDouble(2, Double.parseDouble(price));
        ps.setString(3, image);
        ps.setString(4, description);

        ps.executeUpdate();

        msg = "✅ Product Added Successfully!";
    }

} catch(Exception e) {
    msg = "❌ Error: " + e.getMessage();
} finally {
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(con != null) con.close(); } catch(Exception e) {}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Product</title>

<style>

body{
    font-family:Arial;
    background:#f2f2f2;
    margin:0;
    padding:0;
}

.container{
    width:420px;
    margin:60px auto;
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 0 15px rgba(0,0,0,0.2);
}

h2{
    text-align:center;
    margin-bottom:20px;
    color:#2c3e50;
}

input, textarea{
    width:100%;
    padding:12px;
    margin:10px 0;
    border:1px solid #ccc;
    border-radius:8px;
    font-size:14px;
}

textarea{
    height:100px;
    resize:none;
}

button{
    width:100%;
    padding:12px;
    background:#27ae60;
    color:white;
    border:none;
    cursor:pointer;
    font-size:16px;
    border-radius:8px;
    transition:0.3s;
}

button:hover{
    background:#219150;
}

.msg{
    text-align:center;
    margin-bottom:10px;
    font-weight:bold;
    color:green;
}

a{
    display:block;
    text-align:center;
    margin-top:15px;
    text-decoration:none;
    color:#3498db;
}

a:hover{
    color:#1abc9c;
}

</style>

</head>

<body>

<div class="container">

    <h2> Add Product</h2>

    <% if(!msg.equals("")) { %>
        <div class="msg"><%= msg %></div>
    <% } %>

    <form method="post">

        <input type="text" name="name" placeholder="Product Name" required>

        <input type="text" name="price" placeholder="Price" required>

        <input type="text" name="image" placeholder="images/rice.jpg" required>

        <textarea name="description" placeholder="Product Description" required></textarea>

        <button type="submit">Add Product</button>

    </form>

    <a href="AdminDashboard.jsp">← Back to Dashboard</a>

</div>

</body>
</html>