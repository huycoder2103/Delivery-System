<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
        String error = (String) request.getAttribute("ERROR_MESSAGE");
        String role = (String) session.getAttribute("ROLE");
    %>

    <div class="home-container">
        <% if (error != null) { %>
            <div class="alert-error" style="text-align:center; border-radius:10px; margin-bottom: 20px;">
                ❌ <%= error %>
            </div>
        <% } %>

        <div class="welcome-box">
            <h1>CHÀO MỪNG QUAY TRỞ LẠI!</h1>
            <p>Hệ thống quản lý hàng hóa & vận chuyển nội bộ</p>
            <div class="user-chip">
                <span><%= loginUser != null ? loginUser.getFullName() : "Nhân viên" %></span>
                <small>(<%= role %>)</small>
            </div>
        </div>

        <div class="menu-grid">
            <!-- 1. Quản lý hàng hóa -->
            <form action="MainController" method="POST" class="menu-card" onclick="this.submit();">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="ViewGoods" value="true">
                <div class="card-icon">📦</div>
                <h3>Quản lý hàng hóa</h3>
                <p>Nhập đơn hàng, bộ phận hàng, quản lý đơn hàng.</p>
                <button type="button" class="btn-card-action">Truy cập</button>
            </form>

            <!-- 2. Báo cáo & Thống kê -->
            <form action="MainController" method="POST" class="menu-card" onclick="this.submit();">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="ViewReports" value="true">
                <div class="card-icon">📊</div>
                <h3>Báo cáo & Thống kê</h3>
                <p>Xem doanh thu, số lượng đơn theo ngày/tháng.</p>
                <button type="button" class="btn-card-action">Xem báo cáo</button>
            </form>

            <!-- 3. Hệ thống quản trị -->
            <% if ("AD".equals(role)) { %>
            <form action="MainController" method="POST" class="menu-card admin-card" onclick="this.submit();">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="AdminPanel" value="true">
                <div class="card-icon">🛡️</div>
                <h3>Hệ thống quản trị</h3>
                <p>Quản lý nhân viên, cấu hình trạm xe, bảo mật.</p>
                <button type="button" class="btn-card-action">Vào quản trị</button>
            </form>
            <% } else { %>
            <div class="menu-card disabled">
                <div class="card-icon">🔒</div>
                <h3>Hệ thống quản trị</h3>
                <p>Chức năng dành riêng cho Quản trị viên hệ thống.</p>
                <button type="button" class="btn-card-action" disabled>Bị khóa</button>
            </div>
            <% } %>
        </div>
    </div>
    <%@include file="includes/footer.jsp" %>
</body>
</html>
