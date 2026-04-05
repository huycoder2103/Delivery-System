<%@page import="dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn Chuyến Xe Chuyển Hàng</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/ship_order.css">
</head>
<body>
<%@include file="includes/navbar.jsp" %>

<%
    OrderDTO order = (OrderDTO) request.getAttribute("ORDER_FOR_SHIP");
    List<String[]> tripList = (List<String[]>) request.getAttribute("MATCHING_TRIPS");
    String sucMsg = (String) request.getAttribute("SUCCESS_MESSAGE");
    String sendSt = (order != null && order.getSendStation() != null) ? order.getSendStation() : "";
%>

<div class="page-wrap">
    <div class="hdr">
        <h3>🚚 CHUYỂN HÀNG — CHỌN CHUYẾN XE</h3>
        <% if (order != null) { %>
        <div class="meta">
            <span class="badge">Đơn: <%= order.getOrderID() %></span>
            <span class="badge">Hàng: <%= order.getItemName() %></span>
            <span class="badge">Trạm gửi: <%= sendSt %></span>
        </div>
        <% } %>
    </div>

    <div class="body">
        <% if (sucMsg != null) { %>
        <div style="background:#d4edda;color:#155724;padding:9px 14px;border-radius:4px;margin-bottom:12px;font-weight:600;">
            ✅ <%= sucMsg %>
        </div>
        <% } %>

        <div class="info">
            Hiển thị các chuyến xe có trạm xuất phát là <strong>"<%= sendSt %>"</strong>
            — phù hợp để chuyển đơn hàng này.
        </div>

        <% if (tripList != null && !tripList.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Mã Chuyến</th>
                    <th>Lộ Trình</th>
                    <th>Biển Số</th>
                    <th>Tài Xế</th>
                    <th>Giờ Đi</th>
                    <th>Trạng Thái</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int i = 1;
                    for (String[] t : tripList) {
                        // t[0]=tripID, t[1]=route, t[2]=dep, t[3]=dest,
                        // t[4]=truckID, t[5]=driverName, t[6]=departureTime, t[7]=status
                        boolean done = "Đã đến".equals(t[7]);
                %>
                <tr>
                    <td><%= i++ %></td>
                    <td><strong><%= t[0] %></strong></td>
                    <td style="color:#2980b9;font-weight:600;"><%= t[1] %></td>
                    <td><%= t[4] != null ? t[4] : "-" %></td>
                    <td><%= t[5] != null ? t[5] : "-" %></td>
                    <td><%= t[6] != null ? t[6] : "-" %></td>
                    <td><span class="<%= done ? "st-done" : "st-going" %>"><%= t[7] != null ? t[7] : "Đang đi" %></span></td>
                    <td>
                        <% if (!done) { %>
                        <form action="GoodsController" method="POST" style="display:inline;"
                              onsubmit="return confirm('Xác nhận chuyển hàng lên chuyến <%= t[0] %>?');">
                            <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                            <input type="hidden" name="orderID" value="<%= order != null ? order.getOrderID() : "" %>">
                            <input type="hidden" name="tripID"  value="<%= t[0] %>">
                            <input type="hidden" name="source"  value="ship">
                            <input type="submit" name="AssignOrderToTrip"
                                   value="✓ Chọn chuyến này" class="btn-pick">
                        </form>
                        <% } else { %>
                        <button class="btn-disabled" disabled>Chuyến đã đến</button>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="no-data">
            <div style="font-size:2rem;margin-bottom:8px;">🔍</div>
            <p>Không tìm thấy chuyến xe từ trạm <strong>"<%= sendSt %>"</strong>.</p>
            <p style="font-size:.82rem;color:#aaa;">Vui lòng tạo chuyến xe mới hoặc kiểm tra lại trạm gửi của đơn hàng.</p>
        </div>
        <% } %>

        <form action="GoodsController" method="POST">
            <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
            <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-back">
        </form>
    </div>
</div>

    <%@include file="includes/footer.jsp" %>
</body>
</html>
