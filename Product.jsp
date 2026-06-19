<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PANDIYAN STORE - Products</title>
<link rel="stylesheet" href="css/style.css">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Poppins", Arial, sans-serif;
}

body {
        background: linear-gradient(135deg, rgba(235, 21, 189, 0.6), rgba(0,0,0,0.8));

}

/* HEADER */
header {
    background: rgba(0,0,0,0.7);
    color: #fff;
    padding: 20px 60px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    backdrop-filter: blur(10px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.4);
}

header h1 {
    font-size: 28px;
    font-weight: 700;
    letter-spacing: 1px;
}

nav a {
    color: #fff;
    text-decoration: none;
    margin-left: 20px;
    font-weight: 500;
    transition: color 0.3s ease;
}

nav a:hover {
    color: #ff9a9e;
}


/* CONTAINER */
.container {
    width: 90%;
    margin: 40px auto;
    color: #fff;
}

.container h2 {
    text-align: center;
    margin-bottom: 20px;
    font-size: 28px;
    font-weight: bold;
}


/* GRID */
.products {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 30px;
}

/* CARD */
.card {
    background: rgba(255,255,255,0.1);
    border-radius: 16px;
    overflow: hidden;
    min-height: 450px;
}

.card img {
    width: 100%;
    height: 250px;
    object-fit: contain;
    background: white;
    padding: 10px;
}

/* CARD BODY */
.card-body {
    padding: 20px;
    text-align: center;
}

.card-body h3{
    height:50px;
    overflow:hidden;
}
/* PRICE */
.price {
    color: #00ffae;
    font-size: 20px;
    font-weight: bold;
    margin: 10px 0;
}

/* DESCRIPTION */
.desc {
    font-size: 14px;
    color: #ddd;
    margin: 10px 0;
    height: 40px;
    overflow: hidden;
}

/* BUTTON */
.btn {
    display: inline-block;
    padding: 10px 20px;
    background: linear-gradient(135deg, #43cea2, #185a9d);
    color: #fff;
    text-decoration: none;
    border-radius: 30px;
    font-weight: 600;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.btn:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(67,206,162,0.8);
}

/* FOOTER */
footer {
    background: rgba(0,0,0,0.8);
    color: #ccc;
    text-align: center;
    padding: 15px;
    margin-top: 40px;
    font-size: 14px;
}

.search-container{
    width:100%;
    display:flex;
    justify-content:flex-end;
    margin-bottom:30px;
}

.search-container form{
    display:flex;
}

.search-container input{
    width:300px;
    height:45px;
    padding:0 15px;
    border:none;
    outline:none;
    border-radius:25px 0 0 25px;
    font-size:15px;
}

.search-container button{
    height:45px;
    padding:0 20px;
    border:none;
    cursor:pointer;
    background:linear-gradient(135deg,#43cea2,#185a9d);
    color:white;
    font-weight:600;
    border-radius:0 25px 25px 0;
}
.wishlist-btn{
    display:inline-block;
    padding:10px 20px;
    background:#ff4d6d;
    color:white;
    text-decoration:none;
    border-radius:25px;
    font-weight:600;
}

.wishlist-btn:hover{
    background:#e63956;
}

</style>

</head>

<body>

<header>

    <h1>PANDIYAN STORE</h1>

    <nav>
        <a href="Home.jsp">Home</a>
        <a href="Product.jsp">Products</a>
        <a href="Cart.jsp">Cart</a>
        <a href="Orders.jsp">Orders</a>
        <a href="Logout.jsp">Logout</a>
        <a href="Wishlist.jsp">Wishlist</a>
    </nav>

</header>

   <div class="container">

    <h2>Available Products</h2>

    <div class="search-container">
        <form method="get" action="Product.jsp">
            <input type="text"
                   name="search"
                   placeholder="Search Products..."
                   value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">

            <button type="submit">Search</button>
        </form>
    </div>

    <div class="products">

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;


try{

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") + "database/shopping.db";

    con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

Statement stmt = con.createStatement();
/* COUPONS TABLE */
stmt.executeUpdate(
    "CREATE TABLE IF NOT EXISTS coupons(" +
    "id INTEGER PRIMARY KEY AUTOINCREMENT," +
    "code TEXT," +
    "discount INTEGER)"
);

stmt.executeUpdate(
    "INSERT OR IGNORE INTO coupons(id,code,discount) VALUES(1,'SAVE10',10)"
);

stmt.executeUpdate(
    "INSERT OR IGNORE INTO coupons(id,code,discount) VALUES(2,'SAVE20',20)"
);

/* CREATE WISHLIST TABLE */
stmt.executeUpdate(
    "CREATE TABLE IF NOT EXISTS wishlist(" +
    "id INTEGER PRIMARY KEY AUTOINCREMENT," +
    "product_id INTEGER UNIQUE)"
);

/* ADD TO WISHLIST */
String wishId = request.getParameter("wishlist");

if(wishId != null){

    PreparedStatement wishPs =
        con.prepareStatement(
        "INSERT OR IGNORE INTO wishlist(product_id) VALUES(?)"
    );

    wishPs.setInt(1, Integer.parseInt(wishId));
    wishPs.executeUpdate();
    wishPs.close();
}

    // SAFE TABLE CREATE
    stmt.executeUpdate(
        "CREATE TABLE IF NOT EXISTS products(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "name TEXT NOT NULL," +
        "price REAL NOT NULL," +
        "image TEXT," +
        "description TEXT)"
    );
    

   String search = request.getParameter("search");

    if(search != null && !search.trim().equals("")){

    ps = con.prepareStatement(
        "SELECT * FROM products WHERE name LIKE ?"
    );

    ps.setString(1, "%" + search + "%");

}else{

    ps = con.prepareStatement(
        "SELECT * FROM products"
    );

}

rs = ps.executeQuery();

    while(rs.next()){
%>


        <div class="card">

            <img src="<%= rs.getString("image") %>"
                 alt="<%= rs.getString("name") %>">

            <div class="card-body">

                <h3><%= rs.getString("name") %></h3>

                <div class="price">
                    ₹ <%= rs.getDouble("price") %>
                </div>

                <!-- DESCRIPTION (SAFE SHORT VERSION) -->
                <div class="desc">
                    <%= rs.getString("description") != null
                        ? (rs.getString("description").length() > 60
                            ? rs.getString("description").substring(0,60) + "..."
                            : rs.getString("description"))
                        : "" %>
                </div>

                <a class="btn"
                   href="ProductDetails.jsp?id=<%= rs.getInt("id") %>">
                    View Details
                </a>
                <br><br>

                <a class="wishlist-btn"
href="Product.jsp?wishlist=<%= rs.getInt("id") %>">
❤️ Wishlist
</a>

            </div>

        </div>

<%
    }

}catch(Exception e){
    out.println("<h3 style='color:red;text-align:center;'>" + e.getMessage() + "</h3>");
}finally{
    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}
%>

    </div>

</div>

<footer>
    <p>© 2026 Pandiyan Store. All Rights Reserved.</p>
</footer>

</body>
</html>