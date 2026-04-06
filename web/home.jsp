<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

    <style>
        .shift-widget {
            background: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .shift-info h4 { margin: 0; color: #333; }
        .shift-status { margin-top: 5px; font-weight: bold; }
        .status-active { color: #28a745; }
        .status-inactive { color: #6c757d; }
        .shift-stats { display: flex; gap: 20px; margin-top: 10px; }
        .stat-item { background: #f8f9fa; padding: 5px 15px; border-radius: 20px; font-size: 0.9em; }
        .btn-shift { padding: 10px 25px; border-radius: 25px; border: none; font-weight: bold; cursor: pointer; transition: 0.3s; text-decoration: none; }
        .btn-start { background: #28a745; color: white; }
        .btn-start:hover { background: #218838; }
        .btn-end { background: #dc3545; color: white; }
        .btn-end:hover { background: #c82333; }
    </style>

    <div class="home-container">
        <!-- --- SHIFT MANAGEMENT WIDGET --- -->
        <div class="shift-widget">
            <div class="shift-info">
                <h4>Ca làm việc hiện tại</h4>
                <div class="shift-status">
                    <c:choose>
                        <c:when test="${not empty sessionScope.CURRENT_SHIFT}">
                            <span class="status-active">🟢 Đang trong ca (Mã ca: #${sessionScope.CURRENT_SHIFT.shiftID})</span>
                            <div class="shift-stats">
                                <div class="stat-item">✅ Đã giao: <b>${empty SHIFT_SUMMARY.deliveredOrders ? 0 : SHIFT_SUMMARY.deliveredOrders}</b></div>
                                <div class="stat-item">🚚 Đang đi: <b>${empty SHIFT_SUMMARY.deliveringOrders ? 0 : SHIFT_SUMMARY.deliveringOrders}</b></div>
                                <div class="stat-item">💰 Doanh thu: <b><fmt:formatNumber value="${empty SHIFT_SUMMARY.totalRevenue ? 0 : SHIFT_SUMMARY.totalRevenue}" type="number" groupingUsed="true"/> K</b></div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <span class="status-inactive">⚪ Chưa bắt đầu ca làm việc</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="shift-actions">
                <c:choose>
                    <c:when test="${empty sessionScope.CURRENT_SHIFT}">
                        <a href="MainController?StartShift=true&action=start" class="btn-shift btn-start">🚀 BẮT ĐẦU CA</a>
                    </c:when>
                    <c:otherwise>
                        <a href="MainController?EndShift=true&action=end" class="btn-shift btn-end" onclick="return confirm('Bạn muốn kết thúc ca làm việc này?')">🛑 KẾT THÚC CA</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <!-- ------------------------------- -->

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
