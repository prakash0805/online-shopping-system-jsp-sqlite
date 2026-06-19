<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.text.SimpleDateFormat,java.util.Calendar,java.util.Date" %>

<%
String orderId = request.getParameter("orderId");

if(orderId == null){
    orderId = "N/A";
}

SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

Date orderedDate = new Date();

Calendar cal = Calendar.getInstance();
cal.setTime(orderedDate);
cal.add(Calendar.DATE, 5);

Date deliveryDate = cal.getTime();

String orderedOn = sdf.format(orderedDate);
String estimatedDelivery = sdf.format(deliveryDate);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order Success</title>

<style>
body {
    background: linear-gradient(135deg, rgba(235, 21, 189, 0.6), rgba(0,0,0,0.8));
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Success Container */
.container {
    width: 550px;
    background: rgba(255,255,255,0.1);
    text-align: center;
    padding: 40px;
    border-radius: 20px;
    backdrop-filter: blur(12px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
    color: #fff;
    animation: fadeSlide 1s ease forwards;
    transform: translateY(30px);
    opacity: 0;
}

@keyframes fadeSlide {
    to {
        transform: translateY(0);
        opacity: 1;
    }
}

/* Success Icon */
.success-icon {
    font-size: 90px;
    color: #14dc88;
    animation: pop 0.8s ease, pulse 2s infinite;
}

@keyframes pop {
    0% { transform: scale(0); }
    100% { transform: scale(1); }
}

@keyframes pulse {
    0% { text-shadow: 0 0 5px #00ffae; }
    50% { text-shadow: 0 0 20px #00ffae; }
    100% { text-shadow: 0 0 5px #00ffae; }
}

/* Heading */
h1 {
    color: #ffeaa7;
    margin: 20px 0;
    font-size: 32px;
    font-weight: bold;
    animation: fadeInText 1.2s ease;
}

@keyframes fadeInText {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
}

/* Message */
.message {
    color: #dddddd;
    margin-bottom: 25px;
    line-height: 1.8;
    font-size: 16px;
    animation: fadeInText 1.5s ease;
}

/* Info Box */
.info {
    background: rgba(255,255,255,0.1);
    padding: 20px;
    border-radius: 12px;
    margin-bottom: 30px;
    box-shadow: inset 0 0 10px rgba(255,255,255,0.2);
    animation: fadeInText 1.8s ease;
}

/* Buttons */
.buttons a {
    display: inline-block;
    margin: 10px;
    padding: 12px 22px;
    text-decoration: none;
    color: #fff;
    border-radius: 30px;
    font-weight: 600;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    animation: fadeInText 2s ease;
}

.shop { background: linear-gradient(135deg, #43cea2, #185a9d); }
.orders { background: linear-gradient(135deg, #ff416c, #ff4b2b); }
.home { background: linear-gradient(135deg, #38bdf8, #3b82f6); }

.buttons a:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(255,255,255,0.6);
}


</style>

</head>

<body>

<div class="container">

    <div class="success-icon">✓</div>

    <h1>Thank You!</h1>

    <div class="message">
        Your order has been placed successfully.  
        We appreciate your purchase from <strong>Pandiyan Store</strong>.
    </div>

    <div class="info">

        <p><strong>Order ID :</strong> #<%= orderId %></p>

        <p><strong>Ordered On :</strong> <%= orderedOn %></p>

        <p><strong>Estimated Delivery :</strong> <%= estimatedDelivery %></p>

    </div>

    <div class="buttons">

        <a href="Product.jsp" class="shop">Continue Shopping</a>

        <a href="Orders.jsp" class="orders">View Orders</a>

        <a href="Home.jsp" class="home">Back to Home</a>

    </div>

</div>

</body>
</html>