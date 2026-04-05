<%@page import="dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hàng Trên Chuyến Xe - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        List<OrderDTO> list = (List<OrderDTO>) request.getAttribute("ORDER_LIST");
        String tripID = (String) request.getAttribute("TRIP_ID");
        String route  = (String) request.getAttribute("TRIP_ROUTE");
    %>

    <div style="max-width: 1200px; margin: 20px auto; padding: 0 20px;">
        
        <div class="modern-page-header">
            <div>
                <h3>📦 HÀNG TRÊN CHUYẾN XE</h3>
                <p style="margin: 5px 0 0 0; font-size: 0.9rem; opacity: 0.8;">Mã chuyến: <strong><%= tripID %></strong> | Lộ trình: <%= route %></p>
            </div>
            <span style="font-weight: 700; opacity: 0.9;"><%= list != null ? list.size() : 0 %> đơn hàng</span>
        </div>

        <div class="modern-card" style="padding: 0; overflow: hidden;">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã Đơn</th>
                        <th>Tên Hàng</th>
                        <th>Người Nhận</th>
                        <th>SĐT Nhận</th>
                        <th>Trạm Nhận</th>
                        <th>Cước Phí</th>
                        <th>Ghi Chú</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (list != null && !list.isEmpty()) {
                        int i = 1;
                        for (OrderDTO o : list) {
                    %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong style="color: #1a73e8;"><%= o.getOrderID() %></strong></td>
                        <td style="font-weight: 600;"><%= o.getItemName() %></td>
                        <td><%= o.getReceiverName() %></td>
                        <td><%= o.getReceiverPhone() %></td>
                        <td><span class="badge badge-info"><%= o.getReceiveStation() %></span></td>
                        <td style="color: #27ae60; font-weight: 700;"><%= String.format("%,.0f", o.getAmount()) %>đ</td>
                        <td style="font-size: 0.8rem; color: #888; max-width: 200px;"><%= o.getNote() != null ? o.getNote() : "-" %></td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="8" style="padding: 50px; color: #999;">📭 Chuyến xe này chưa được gán đơn hàng nào.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 20px; display: flex; gap: 10px;">
            <form action="GoodsController" method="POST">
                <input type="submit" name="ViewTripList" value="⬅ Quay lại DS Chuyến Xe" class="btn-modern btn-secondary-modern">
            </form>
            <button onclick="window.print()" class="btn-modern btn-primary-modern">🖨️ In danh sách</button>
        </div>
    </div>
</body>
</html>
