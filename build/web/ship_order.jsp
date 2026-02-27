<%@page import="dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn Chuyến Xe Chuyển Hàng</title>
    <link rel="stylesheet" href="css/home.css">
    <style>
        body { background:#f4f7f6; font-family:'Segoe UI',sans-serif; }
        .page-wrap { max-width:1100px; margin:16px auto 30px; background:#fff; border-radius:6px; border:1px solid #ddd; box-shadow:0 2px 8px rgba(0,0,0,.06); }
        .hdr { background:linear-gradient(135deg,#2980b9,#3498db); color:#fff; padding:13px 20px; border-radius:6px 6px 0 0; }
        .hdr h3 { margin:0; font-size:.95rem; }
        .hdr .meta { margin-top:5px; font-size:.8rem; opacity:.9; }
        .hdr .badge { background:rgba(255,255,255,.22); padding:2px 8px; border-radius:10px; margin-right:6px; font-weight:700; }
        .body { padding:16px 20px 22px; }
        .info { background:#eaf4fb; border:1px solid #b8daf0; border-left:4px solid #3498db; padding:9px 14px; border-radius:4px; margin-bottom:14px; font-size:.85rem; color:#1a5276; }
        table { width:100%; border-collapse:collapse; font-size:.86rem; }
        th { background:#34495e; color:#fff; padding:10px 12px; text-align:left; font-size:.78rem; text-transform:uppercase; }
        td { padding:9px 12px; border-bottom:1px solid #eee; }
        tr:hover td { background:#f0f7ff; }
        .st-going { background:#d4efdf; color:#1e8449; padding:2px 9px; border-radius:9px; font-size:.74rem; font-weight:700; }
        .st-done  { background:#fadbd8; color:#922b21; padding:2px 9px; border-radius:9px; font-size:.74rem; font-weight:700; }
        .btn-pick { background:#27ae60; color:#fff; border:none; padding:5px 14px; border-radius:4px; font-weight:700; font-size:.8rem; cursor:pointer; }
        .btn-pick:hover { background:#1e8449; }
        .btn-disabled { background:#bdc3c7; color:#777; border:none; padding:5px 14px; border-radius:4px; font-size:.8rem; cursor:not-allowed; }
        .no-data { text-align:center; padding:32px; color:#888; }
        .btn-back { background:#6c757d; color:#fff; border:none; padding:8px 18px; border-radius:4px; cursor:pointer; font-weight:600; margin-top:14px; }
        .btn-back:hover { background:#545b62; }
    </style>
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
            <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-back">
        </form>
    </div>
</div>

</body>
</html>
