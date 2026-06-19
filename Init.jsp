<%@ page import="java.sql.*" %>

<%
Connection con = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/") + "database/shopping.db");

Statement st = con.createStatement();

st.executeUpdate("CREATE TABLE IF NOT EXISTS product_master(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,price REAL,image TEXT)");

st.executeUpdate("CREATE TABLE IF NOT EXISTS product_details(id INTEGER PRIMARY KEY AUTOINCREMENT,product_id INTEGER,description TEXT)");

st.executeUpdate("CREATE TABLE IF NOT EXISTS cart(id INTEGER PRIMARY KEY AUTOINCREMENT,user_email TEXT,product_name TEXT,price REAL,image TEXT,quantity INTEGER)");

st.executeUpdate("CREATE TABLE IF NOT EXISTS orders(id INTEGER PRIMARY KEY AUTOINCREMENT,user_email TEXT,total REAL)");

st.executeUpdate("CREATE TABLE IF NOT EXISTS order_items(id INTEGER PRIMARY KEY AUTOINCREMENT,order_id INTEGER,product_name TEXT,price REAL,quantity INTEGER)");

out.println("DB READY");

con.close();
%>
<%
Connection con = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/") + "database/shopping.db");

Statement st = con.createStatement();

st.executeUpdate(
"CREATE TABLE IF NOT EXISTS cart(" +
"id INTEGER PRIMARY KEY AUTOINCREMENT," +
"user_email TEXT," +
"product_name TEXT," +
"price REAL," +
"image TEXT," +
"quantity INTEGER)"
);

con.close();
%>