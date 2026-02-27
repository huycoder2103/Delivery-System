<%-- 
    Document   : report
    Created on : Feb 24, 2026, 11:54:14 PM
    Author     : HuyNHSE190240
--%>

<%@page import="java.util.List"%>
<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo & Giao ca</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/report.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        String role = (String) session.getAttribute("ROLE");
        if (role == null) role = "US";

        Object totalOrders     = request.getAttribute("TOTAL_ORDERS");
        Object completedOrders = request.getAttribute("COMPLETED_ORDERS");
        Object pendingOrders   = request.getAttribute("PENDING_ORDERS");
        Object totalRevenue    = request.getAttribute("TOTAL_REVENUE");
        Object todayOrders     = request.getAttribute("TODAY_ORDERS");
        Object todayRevenue    = request.getAttribute("TODAY_REVENUE");
        Object totalCash       = request.getAttribute("TOTAL_CASH");
    %>

    <div class="list-container">
        <div class="page-title">
            <h1><%= "AD".equals(role) ? "BÁO CÁO TỔNG QUÁT" : "TỔNG KẾT CA LÀM VIỆC" %></h1>
            <div class="underline"></div>
        </div>

        <div class="report-grid">
            <%-- Thẻ 1: Hiệu suất hàng hóa --%>
            <div class="report-card">
                <h3>📊 Hiệu suất đơn hàng</h3>
                <% if ("AD".equals(role)) { %>
                <div class="stat-row">
                    <span>Tổng đơn toàn hệ thống:</span>
                    <span class="stat-value"><%= totalOrders != null ? totalOrders : 0 %></span>
                </div>
                <div class="stat-row">
                    <span>Đơn hôm nay:</span>
                    <span class="stat-value"><%= todayOrders != null ? todayOrders : 0 %></span>
                </div>
                <div class="stat-row">
                    <span>Đã giao thành công:</span>
                    <span class="stat-value text-green"><%= completedOrders != null ? completedOrders : 0 %></span>
                </div>
                <div class="stat-row">
                    <span>Chờ xử lý:</span>
                    <span class="stat-value text-red"><%= pendingOrders != null ? pendingOrders : 0 %></span>
                </div>
                <% } else { %>
                <div class="stat-row">
                    <span>Đơn đã nhận hôm nay:</span>
                    <span class="stat-value"><%= totalOrders != null ? totalOrders : 0 %></span>
                </div>
                <% } %>
            </div>

            <%-- Thẻ 2: Tài chính --%>
            <div class="report-card">
                <h3>💰 Tài chính</h3>
                <% if ("AD".equals(role)) { %>
                <div class="stat-row">
                    <span>Doanh thu hôm nay:</span>
                    <span class="stat-value text-green"><%= todayRevenue != null ? todayRevenue : 0 %> VNĐ</span>
                </div>
                <div class="stat-row">
                    <span>Tổng doanh thu:</span>
                    <span class="stat-value text-green"><%= totalRevenue != null ? totalRevenue : 0 %> VNĐ</span>
                </div>
                <% } else { %>
                <div class="stat-row">
                    <span>Tiền thu hôm nay:</span>
                    <span class="stat-value text-green"><%= totalCash != null ? totalCash : 0 %> VNĐ</span>
                </div>
                <% } %>
            </div>
        </div>

        <%-- Admin: bảng nhân viên --%>
        <% if ("AD".equals(role)) { %>
        <div class="report-card" style="margin-top: 20px;">
            <h3>👥 Hiệu suất nhân viên (hôm nay)</h3>
            <table>
                <thead>
                    <tr><th>Mã NV</th><th>Họ Tên</th><th>Số đơn</th><th>Doanh thu (VNĐ)</th></tr>
                </thead>
                <tbody>
                    <%
                        List<UserDTO> staffList = (List<UserDTO>) request.getAttribute("STAFF_LIST");
                        if (staffList != null && !staffList.isEmpty()) {
                            for (UserDTO s : staffList) {
                    %>
                    <tr>
                        <td><%= s.getUserID() %></td>
                        <td><%= s.getFullName() %></td>
                        <td><%= s.getOrderCount() %></td>
                        <td><%= String.format("%,.0f", s.getRevenue()) %></td>
                    </tr>
                    <% }} else { %>
                    <tr><td colspan="4" style="text-align:center;color:#888;">Chưa có dữ liệu</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <%-- Nhân viên: form giao ca --%>
        <div class="report-card" style="margin-top: 20px;">
            <h3>🔑 Giao ca</h3>
            <form action="MainController" method="POST">
                <input type="hidden" name="totalOrders" value="<%= totalOrders %>">
                <label>Ghi chú bàn giao cho ca sau:</label>
                <textarea name="shiftNote" class="shift-note-area"
                          placeholder="VD: Còn 3 đơn chưa chuyển hàng, xe 50A-502.93 đang trên đường..."></textarea>
                <div class="btn-container">
                    <input type="submit" name="SubmitShiftReport" value="✅ Xác nhận & Chốt ca" class="btn-cyan">
                </div>
            </form>
        </div>
        <% } %>

        <div style="text-align:center; margin-top: 20px;">
            <form action="MainController" method="POST">
                <input type="submit" name="GoHome" value="⬅ Quay lại Trang chủ" class="btn-back"
                       style="padding:10px 30px; border-radius:20px;">
            </form>
        </div>
    </div>
</body>
</html>
