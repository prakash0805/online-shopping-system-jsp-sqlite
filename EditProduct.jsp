<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>

<%
String admin = (String)session.getAttribute("admin");

if(admin == null){
    response.sendRedirect("AdminLogin.jsp");
    return;
}

String id = request.getParameter("id");

if(id == null){
    response.sendRedirect("ViewProducts.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String name = "";
String price = "";
String image = "";
String description = "";

try {

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") + "database/shopping.db";

    con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

    // =========================
    // UPDATE PRODUCT
    // =========================
    if("POST".equalsIgnoreCase(request.getMethod())){

        String n = request.getParameter("name");
        String p = request.getParameter("price");
        String img = request.getParameter("image");
        String desc = request.getParameter("description");

        ps = con.prepareStatement(
            "UPDATE products SET name=?, price=?, image=?, description=? WHERE id=?"
        );

        ps.setString(1, n);
        ps.setDouble(2, Double.parseDouble(p));
        ps.setString(3, img);
        ps.setString(4, desc);
        ps.setInt(5, Integer.parseInt(id));

        ps.executeUpdate();
        ps.close();

        response.sendRedirect("ViewProducts.jsp");
        return;
    }

    // =========================
    // LOAD PRODUCT
    // =========================
    ps = con.prepareStatement("SELECT * FROM products WHERE id=?");
    ps.setInt(1, Integer.parseInt(id));

    rs = ps.executeQuery();

    if(rs.next()){
        name = rs.getString("name");
        price = String.valueOf(rs.getDouble("price"));
        image = rs.getString("image");
        description = rs.getString("description");
    }

} catch(Exception e){
    out.println("<h3 style='color:red;text-align:center;'>" + e.getMessage() + "</h3>");
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
<title>Edit Product</title>

<style>

body{
    font-family:Arial;
    background:#f2f2f2;
    margin:0;
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
}

textarea{
    height:100px;
    resize:none;
}

button{
    width:100%;
    padding:12px;
    background:#3498db;
    color:white;
    border:none;
    cursor:pointer;
    border-radius:8px;
    font-size:16px;
}

button:hover{
    background:#1abc9c;
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

<h2>✏️ Edit Product</h2>

<form method="post">

    <input type="text" name="name" value="<%= name %>" required>

    <input type="text" name="price" value="<%= price %>" required>

    <input type="text" name="image" value="<%= image %>" required>

    <textarea name="description" required><%= description %></textarea>

    <button type="submit">Update Product</button>

</form>

<a href="ViewProducts.jsp">← Back</a>

</div>

</body>
</html>