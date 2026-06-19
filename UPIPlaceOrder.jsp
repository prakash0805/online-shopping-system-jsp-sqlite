<%@ page import="java.sql.*" %>

<%
String userEmail = (String)session.getAttribute("userEmail");

if(userEmail == null){
    response.sendRedirect("Login.jsp");
    return;
}

Class.forName("org.sqlite.JDBC");
String dbPath = application.getRealPath("/") + "database/shopping.db";
Connection con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

String fullName = request.getParameter("fullName");
String address = request.getParameter("address");
String city = request.getParameter("city");
String pincode = request.getParameter("pincode");
String phone = request.getParameter("phone");
String paymentApp = request.getParameter("paymentApp");

double total = 0;

PreparedStatement ps = con.prepareStatement("SELECT * FROM cart WHERE user_email=?");
ps.setString(1,userEmail);
ResultSet rs = ps.executeQuery();

while(rs.next()){
    total += rs.getDouble("price") * rs.getInt("quantity");
}

PreparedStatement order = con.prepareStatement(
"INSERT INTO orders(user_email,full_name,address,city,pincode,phone,payment_method,total) VALUES(?,?,?,?,?,?,?,?)",
Statement.RETURN_GENERATED_KEYS);

order.setString(1,userEmail);
order.setString(2,fullName);
order.setString(3,address);
order.setString(4,city);
order.setString(5,pincode);
order.setString(6,phone);
order.setString(7,paymentApp);
order.setDouble(8,total);

order.executeUpdate();

ResultSet keys = order.getGeneratedKeys();
int orderId = 0;
if(keys.next()) orderId = keys.getInt(1);

PreparedStatement cart = con.prepareStatement("SELECT * FROM cart WHERE user_email=?");
cart.setString(1,userEmail);
ResultSet crs = cart.executeQuery();

while(crs.next()){
    PreparedStatement item = con.prepareStatement(
    "INSERT INTO order_items(order_id,product_name,price,quantity) VALUES(?,?,?,?)");

    item.setInt(1,orderId);
    item.setString(2,crs.getString("product_name"));
    item.setDouble(3,crs.getDouble("price"));
    item.setInt(4,crs.getInt("quantity"));
    item.executeUpdate();
}

PreparedStatement clear = con.prepareStatement("DELETE FROM cart WHERE user_email=?");
clear.setString(1,userEmail);
clear.executeUpdate();

response.sendRedirect("OrderSuccess.jsp?orderId="+orderId);
%>