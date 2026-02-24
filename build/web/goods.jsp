<%-- 
    Document   : goods
    Created on : Feb 15, 2026, 5:28:26 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bộ phận Nhận hàng </title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/goods.css">
</head>
<body>
   <%
            String fullName = (String) session.getAttribute("FULLNAME");
            if (fullName == null)
                fullName = "Nhân Viên";
        %>

        <div class="navbar">
            <div class="company-name">CÔNG TY</div>
            <div class="user-menu" onclick="toggleDropdown()">
                <span class="user-name">👤 <%= fullName%> ▼</span>
                <div id="userDropdown" class="dropdown-content">
                    <div class="user-header">
                        <p><strong><%= fullName%></strong></p>
                        <small><%= session.getAttribute("EMAIL") != null ? session.getAttribute("EMAIL") : ""%></small>
                    </div>
                    <div class="user-footer">
                        <form action="MainController" method="POST">
                            <input type="submit" name="Logout" value="Đăng Xuất" class="btn-logout">
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function toggleDropdown() {
                var d = document.getElementById("userDropdown");
                d.style.display = (d.style.display === "block") ? "none" : "block";
            }
        </script>

    <div class="section-title">
        <span>BỘ PHẬN NHẬN HÀNG</span>
        <p>Hệ thống quản lý hàng hóa và chuyến vận chuyển</p>
    </div>

    <div class="container-goods">
        <%-- HÀNG 1 - Ô 1: Nhận Hàng --%>
        <form action="MainController" method="POST" class="card-tile bg-cyan">
            <input type="submit" name="CreateOrder" value="" class="tile-submit">
            <div class="card-body">
                <div class="icon">📦</div>
                <h2>NHẬN HÀNG</h2>
                <p>Lập vận đơn hàng gửi mới</p>
            </div>
            <div class="card-footer">Truy cập hệ thống ➜</div>
        </form>

        <%-- HÀNG 1 - Ô 2: Danh Sách Nhận Hàng --%>
        <form action="MainController" method="POST" class="card-tile bg-blue">
            <input type="submit" name="ViewOrderList" value="" class="tile-submit">
            <div class="card-body">
                <div class="icon">📑</div>
                <h2>DS NHẬN HÀNG</h2>
                <p>Quản lý và tra cứu đơn hàng</p>
            </div>
            <div class="card-footer">Truy cập hệ thống ➜</div>
        </form>

        <%-- HÀNG 2 - Ô 1: DS Chuyến Xe Đi --%>
        <form action="MainController" method="POST" class="card-tile bg-green">
            <input type="submit" name="ViewTripList" value="" class="tile-submit">
            <div class="card-body">
                <div class="icon">🚚</div>
                <h2>DS CHUYẾN XE ĐI</h2>
                <p>Điều phối xe xuất trạm</p>
            </div>
            <div class="card-footer">Truy cập hệ thống ➜</div>
        </form>

        <%-- HÀNG 2 - Ô 2: DS Chuyến Xe Đến --%>
        <form action="MainController" method="POST" class="card-tile bg-yellow">
            <input type="submit" name="ViewArrivalTripList" value="" class="tile-submit">
            <div class="card-body">
                <div class="icon">🏁</div>
                <h2>DS CHUYẾN XE ĐẾN</h2>
                <p>Xác nhận xe về trạm</p>
            </div>
            <div class="card-footer">Truy cập hệ thống ➜</div>
        </form>
    </div>

    <div style="text-align: center; margin-top: 40px; margin-bottom: 50px;">
        <form action="MainController" method="POST">
            <input type="submit" name="GoHome" value="⬅ Quay lại Trang chủ" class="btn-back-home">
        </form>
    </div>
</body>
</html>