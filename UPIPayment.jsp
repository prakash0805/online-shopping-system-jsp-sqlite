<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
String fullName = request.getParameter("fullName");
String address = request.getParameter("address");
String city = request.getParameter("city");
String pincode = request.getParameter("pincode");
String phone = request.getParameter("phone");
%>

<!DOCTYPE html>
<html>
<head>
<title>UPI Payment</title>

<style>
body{font-family:Arial;background:#f2f2f2;}
.container{width:500px;margin:50px auto;background:white;padding:30px;text-align:center;}
button{width:100%;padding:12px;margin:10px;background:blue;color:white;border:none;}
</style>

<script>
function pay(app){
    document.getElementById("app").value = app;
    document.getElementById("f").submit();
}
</script>

</head>

<body>

<div class="container">

<h2>UPI Payment</h2>

<form id="f" action="UPIPlaceOrder.jsp" method="post">

<input type="hidden" name="fullName" value="<%= fullName %>">
<input type="hidden" name="address" value="<%= address %>">
<input type="hidden" name="city" value="<%= city %>">
<input type="hidden" name="pincode" value="<%= pincode %>">
<input type="hidden" name="phone" value="<%= phone %>">

<input type="hidden" name="paymentApp" id="app">

<button type="button" onclick="pay('GooglePay')">Google Pay</button>
<button type="button" onclick="pay('PhonePe')">PhonePe</button>
<button type="button" onclick="pay('Paytm')">Paytm</button>

</form>

</div>

</body>
</html>