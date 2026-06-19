<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>

<%
Connection con = null;

try {

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") + "database/shopping.db";

    con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

    Statement stmt = con.createStatement();

    stmt.executeUpdate("PRAGMA journal_mode=WAL;");

    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS products(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "name TEXT," +
        "price REAL," +
        "image TEXT," +
        "description TEXT)"
    );

    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS cart(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "user_email TEXT," +
        "product_name TEXT," +
        "price REAL," +
        "image TEXT," +
        "quantity INTEGER)"
    );

    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS orders(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "user_email TEXT," +
        "total REAL)"
    );

    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS order_items(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "order_id INTEGER," +
        "product_name TEXT," +
        "price REAL," +
        "quantity INTEGER)"
    );

    out.println("DB Initialized Successfully");

} catch(Exception e){
    out.println(e);
}
finally{
    try { if(con != null) con.close(); } catch(Exception e){}
}
%>