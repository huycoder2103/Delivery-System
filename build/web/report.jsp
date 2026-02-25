<%-- 
    Document   : report
    Created on : Feb 24, 2026, 11:54:14 PM
    Author     : HuyNHSE190240
--%>

<%@page import="java.util.List"%>
<%-- Giả sử bạn có class UserDTO hoặc StaffDTO để chứa dữ liệu nhân viên --%>
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
            if (role == null) role = ""; 

            // Lấy dữ liệu đã được Controller đẩy vào request
            // Sử dụng toán tử 3 ngôi để tránh hiển thị "null" nếu chưa có dữ liệu
            Object totalOrders = request.getAttribute("TOTAL_ORDERS");
            Object cancelledOrders = request.getAttribute("CANCELLED_ORDERS");
            Object totalCash = request.getAttribute("TOTAL_CASH");
        %>

        <div class="list-container">
            <div class="page-title">
                <h1><%= role.equals("AD") ? "BÁO CÁO TỔNG QUÁT (ADMIN)" : "TỔNG KẾT CA LÀM VIỆC" %></h1>
                <div class="underline"></div>
            </div>

            <div class="report-grid">
                <div class="report-card">
                    <h3>📊 Hiệu suất hàng hóa</h3>
                    <div class="stat-row">
                        <span><%= role.equals("AD") ? "Tổng đơn hệ thống:" : "Đơn đã nhận:" %></span>
                        <span class="stat-value"><%= (totalOrders != null) ? totalOrders : 0 %></span>
                    </div>
                    <div class="stat-row">
                        <span class="text-red">Số đơn đã hủy:</span>
                        <span class="stat-value text-red"><%= (cancelledOrders != null) ? cancelledOrders : 0 %></span>
                    </div>
                </div>

                <div class="report-card">
                    <h3>💰 Tài chính</h3>
                    <div class="stat-row">
                        <span>Tổng tiền thực nhận:</span>
                        <span class="stat-value text-green">
                            <%= (totalCash != null) ? totalCash : 0 %> VNĐ
                        </span>
                    </div>
                    <p class="note-text">*(Dữ liệu thực tế từ hệ thống đơn hàng)*</p>
                </div>
            </div>

            <% if (role.equals("AD")) { %>
                <div class="report-card" style="margin-top: 20px;">
                    <h3>👥 Chi tiết hiệu suất nhân viên</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Mã NV</th><th>Họ Tên</th><th>Số đơn</th><th>Doanh thu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<UserDTO> staffList = (List<UserDTO>) request.getAttribute("STAFF_LIST");
                                if (staffList != null && !staffList.isEmpty()) {
                                    for (UserDTO staff : staffList) {
                            %>
                                <tr>
                                    <td><%= staff.getUserID() %></td>
                                    <td><%= staff.getFullName() %></td>
                                    <td><%= staff.getOrderCount() %></td>
                                    <td><%= staff.getRevenue() %> VNĐ</td>
                                </tr>
                            <% 
                                    }
                                } else { 
                            %>
                                <tr><td colspan="4" style="text-align:center;">Chưa có dữ liệu nhân viên</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="report-card" style="margin-top: 20px;">
                    <h3>🔑 Chức năng Giao ca</h3>
                    <form action="MainController" method="POST">
                        <input type="hidden" name="totalOrders" value="<%= totalOrders %>">
                        <label>Ghi chú bàn giao cho ca sau:</label>
                        <textarea name="shiftNote" class="shift-note-area" placeholder="Nhập ghi chú thực tế..."></textarea>
                        <div class="btn-container">
                            <input type="submit" name="SubmitShiftReport" value="Xác nhận & Chốt ca" class="btn-cyan">
                        </div>
                    </form>
                </div>
            <% } %>
        </div>
    </body>
</html>