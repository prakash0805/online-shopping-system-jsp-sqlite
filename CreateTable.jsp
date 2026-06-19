<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jspf" %>

<%
try {

    Statement stmt = con.createStatement();

    // Users Table
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS users (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "name TEXT NOT NULL," +
        "email TEXT UNIQUE NOT NULL," +
        "password TEXT NOT NULL" +
        ")"
    );

    // Products Table
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS products (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "name TEXT NOT NULL," +
        "price REAL NOT NULL," +
        "image TEXT," +
        "description TEXT" +
        ")"
    );

    // Orders Table
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS orders (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "user_email TEXT NOT NULL," +
        "total REAL NOT NULL," +
        "order_date DATETIME DEFAULT CURRENT_TIMESTAMP" +
        ")"
    );

    // Order Items Table
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS order_items (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "order_id INTEGER," +
        "product_name TEXT," +
        "price REAL," +
        "quantity INTEGER," +
        "FOREIGN KEY(order_id) REFERENCES orders(id)" +
        ")"
    );

    out.println("<h2>Tables Created Successfully!</h2>");

} catch(Exception e) {
    out.println("Error : " + e.getMessage());
}

if(con != null){
    con.close();
}
%>