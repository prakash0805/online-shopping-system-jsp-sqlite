<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
String userEmail = (String)session.getAttribute("userEmail");

if(userEmail == null){
    response.sendRedirect("Login.jsp");
    return;
}

double grandTotal = 0;
double totalAmount = 0;
double discount = 0;


Class.forName("org.sqlite.JDBC");
String dbPath = application.getRealPath("/") + "database/shopping.db";
Connection con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

PreparedStatement ps = con.prepareStatement("SELECT * FROM cart WHERE user_email=?");
ps.setString(1, userEmail);
ResultSet rs = ps.executeQuery();

while(rs.next()){
    grandTotal += rs.getDouble("price") * rs.getInt("quantity");
}
totalAmount = grandTotal;

rs.close();
ps.close();
%>
<%
String coupon = request.getParameter("coupon");

if(coupon != null){

    if(coupon.equalsIgnoreCase("SAVE10")){
        discount = totalAmount * 0.10;
    }
    else if(coupon.equalsIgnoreCase("SAVE20")){
        discount = totalAmount * 0.20;
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout</title>
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
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Container */
.container {
    width: 600px;
    background: rgba(255,255,255,0.1);
    padding: 35px;
    border-radius: 18px;
    backdrop-filter: blur(12px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
    color: #fff;
}

/* Heading */
.container h2 {
    text-align: center;
    margin-bottom: 20px;
    font-size: 28px;
    font-weight: bold;
    color: #ffeaa7;
}

/* Total */
.total {
    text-align: center;
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 20px;
    color: #00ffae;
}

/* Inputs */
input, textarea, select {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    border-radius: 10px;
    border: 2px solid rgba(255,255,255,0.3);
    background: transparent;
    color: #fff;
    outline: none;
    transition: border 0.3s ease, box-shadow 0.3s ease;
}

input::placeholder, textarea::placeholder {
    color: #ddd;
}

input:focus, textarea:focus, select:focus {
    border-color: #38bdf8;
    box-shadow: 0 0 12px rgba(56,189,248,0.6);
}

/* Select */
select {
    color: #fff;
    background: rgba(0,0,0,0.3);
}

/* Button */
button {
    width: 100%;
    padding: 14px;
    background: linear-gradient(135deg, #43cea2, #185a9d);
    color: #fff;
    border: none;
    border-radius: 30px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

button:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(67,206,162,0.8);
}
.back-btn{
    display:inline-block;
    margin:20px;
    padding:10px 20px;
    background:linear-gradient(135deg,#43cea2,#185a9d);
    color:#fff;
    text-decoration:none;
    border-radius:30px;
    font-weight:600;
    transition:0.3s;
}

.back-btn:hover{
    transform:translateY(-2px);
    box-shadow:0 5px 15px rgba(67,206,162,0.5);
}
.coupon-box{
    margin:20px 0;
    text-align:center;
}

.coupon-box input{
    width:250px;
    padding:12px;
    border:none;
    border-radius:25px;
}

.coupon-box button{
    padding:12px 20px;
    border:none;
    border-radius:25px;
    background:#43cea2;
    color:white;
    cursor:pointer;
}
</style>

<script>
function processPayment(){

    var form = document.getElementById("checkoutForm");
    var payment = document.getElementById("paymentMethod").value;

    if(!form.checkValidity()){
        form.reportValidity();
        return;
    }

    if(payment === "UPI"){
        form.action = "UPIPayment.jsp";
    } else {
        form.action = "Checkout.jsp";
    }

    form.submit();
}
</script>

</head>

<body>

<div class="container">

<h2>Checkout</h2>

    <div class="coupon-box">
    <form method="post">

        <input type="text"
               name="coupon"
               placeholder="Coupon Code">

        <button type="submit">
            Apply
        </button>

    </form>
</div>



<div class="total">Grand Total: ₹ <%= grandTotal %></div>


<form method="post" id="checkoutForm">

<input type="text" name="fullName" placeholder="Full Name" required>
<textarea name="address" placeholder="Address" required></textarea>
<input type="text" name="city" required placeholder="city">
<input type="text" name="pincode" required placeholder="pincode">
<input type="text" name="phone" required placeholder = "phone no">

<select name="paymentMethod" id="paymentMethod" required>
    <option value="">Select Payment</option>
    <option value="COD">Cash on Delivery</option>
    <option value="UPI">UPI</option>
    <option value="CARD">Card</option>
</select>

<button type="button" onclick="processPayment()">Place Order</button>
<h3>Total Amount:
₹ <%= totalAmount %>
</h3>

<h3>Discount:
₹ <%= discount %>
</h3>

<h2>
Final Amount:
₹ <%= (totalAmount - discount) %>
</h2>
<a href="Product.jsp" class="back-btn">
    ← Back to Products
</a>

</form>

</div>

<%
if("POST".equalsIgnoreCase(request.getMethod()) && !"UPI".equals(request.getParameter("paymentMethod"))){

    String fullName = request.getParameter("fullName");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String pincode = request.getParameter("pincode");
    String phone = request.getParameter("phone");
    String payment = request.getParameter("paymentMethod");

    if(fullName!=null && !fullName.equals("")){

        PreparedStatement ins = con.prepareStatement(
        "INSERT INTO orders(user_email,full_name,address,city,pincode,phone,payment_method,total) VALUES(?,?,?,?,?,?,?,?)"
        );

        ins.setString(1,userEmail);
        ins.setString(2,fullName);
        ins.setString(3,address);
        ins.setString(4,city);
        ins.setString(5,pincode);
        ins.setString(6,phone);
        ins.setString(7,payment);
        ins.setDouble(8,(totalAmount - discount));
        ins.executeUpdate();
        ins.close();
        con.close();


        PreparedStatement clear = con.prepareStatement("DELETE FROM cart WHERE user_email=?");
        clear.setString(1,userEmail);
        clear.executeUpdate();

        response.sendRedirect("OrderSuccess.jsp");
        return;
    }
}
%>

</body>
</html>