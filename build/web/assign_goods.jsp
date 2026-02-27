<%@page import="dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gán Hàng Lên Xe</title>
    <link rel="stylesheet" href="css/home.css">
    <style>
        body { background:#f4f7f6; font-family:'Segoe UI',sans-serif; }
        .page-wrap { max-width:1200px; margin:16px auto 30px; background:#fff; border-radius:6px; border:1px solid #ddd; box-shadow:0 2px 8px rgba(0,0,0,.06); }
        .hdr { background:linear-gradient(135deg,#27ae60,#2ecc71); color:#fff; padding:13px 20px; border-radius:6px 6px 0 0; }
        .hdr h3 { margin:0; font-size:.95rem; }
        .hdr .meta { margin-top:5px; font-size:.8rem; opacity:.9; }
        .hdr .badge { background:rgba(255,255,255,.22); padding:2px 8px; border-radius:10px; margin-right:6px; font-weight:700; }
        .body { padding:16px 20px 22px; }
        .info { background:#eafaf1; border:1px solid #a9dfbf; border-left:4px solid #27ae60; padding:9px 14px; border-radius:4px; margin-bottom:14px; font-size:.85rem; color:#1a6b3a; }
        table { width:100%; border-collapse:collapse; font-size:.86rem; }
        th { background:#27ae60; color:#fff; padding:10px 12px; text-align:left; font-size:.78rem; text-transform:uppercase; }
        td { padding:9px 12px; border-bottom:1px solid #eee; }
        tr:hover td { background:#f0fff5; }
        .money { color:#27ae60; font-weight:700; }
        .badge-pending { background:#fdebd0; color:#a04000; padding:2px 9px; border-radius:9px; font-size:.74rem; font-weight:700; }
        .btn-assign { background:#3498db; color:#fff; border:none; padding:5px 14px; border-radius:4px; font-weight:700; font-size:.8rem; cursor:pointer; }
        .btn-assign:hover { background:#2980b9; }
        .no-data { text-align:center; padding:32px; color:#888; }
        .btn-back { background:#6c757d; color:#fff; border:none; padding:8px 18px; border-radius:4px; cursor:pointer; font-weight:600; margin-top:14px; }
        .btn-back:hover { background:#545b62; }
    </style>
</head>
<body>
<%@include file="includes/navbar.jsp" %>

<%
    String tripID    = (String) request.getAttribute("TRIP_ID");
    String tripRoute = (String) request.getAttribute("TRIP_ROUTE");
    String tripDep   = (String) request.getAttribute("TRIP_DEPARTURE");
    List<OrderDTO> orders = (List<OrderDTO>) request.getAttribute("PENDING_ORDERS");
    String sucMsg = (String) request.getAttribute("SUCCESS_MESSAGE");
%>

<div class="page-wrap">
    <div class="hdr">
        <h3>📦 GÁN HÀNG LÊN CHUYẾN XE</h3>
        <div class="meta">
            <span class="badge">Chuyến: <%= tripID != null ? tripID : "-" %></span>
            <span class="badge">Lộ trình: <%= tripRoute != null ? tripRoute : "-" %></span>
            <span class="badge">Xuất phát: <%= tripDep != null ? tripDep : "-" %></span>
        </div>
    </div>

    <div class="body">
        <% if (sucMsg != null) { %>
        <div style="background:#d4edda;color:#155724;padding:9px 14px;border-radius:4px;margin-bottom:12px;font-weight:600;">
            ✅ <%= sucMsg %>
        </div>
        <% } %>

        <div class="info">
            Các đơn hàng <strong>Chưa Chuyển</strong> có trạm gửi là
            <strong>"<%= tripDep != null ? tripDep : "" %>"</strong> — sẵn sàng gán lên chuyến này.
        </div>

        <% if (orders != null && !orders.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Mã Đơn</th>
                    <th>Tên Hàng</th>
                    <th>Người Gửi</th>
                    <th>Người Nhận</th>
                    <th>Trạm Nhận</th>
                    <th>Cước</th>
                    <th>Trạng Thái</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <% int i = 1; for (OrderDTO o : orders) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td><strong style="color:#2980b9"><%= o.getOrderID() %></strong></td>
                    <td><strong><%= o.getItemName() %></strong></td>
                    <td><%= o.getSenderName() != null ? o.getSenderName() : "-" %>
                        <% if (o.getSenderPhone() != null) { %><br><small style="color:#888"><%= o.getSenderPhone() %></small><% } %></td>
                    <td><%= o.getReceiverName() != null ? o.getReceiverName() : "-" %>
                        <% if (o.getReceiverPhone() != null) { %><br><small style="color:#888"><%= o.getReceiverPhone() %></small><% } %></td>
                    <td><%= o.getReceiveStation() != null ? o.getReceiveStation() : "-" %></td>
                    <td class="money"><%= String.format("%,.0f", o.getAmount()) %>đ</td>
                    <td><span class="badge-pending"><%= o.getTr() %></span></td>
                    <td>
                        <form action="GoodsController" method="POST" style="display:inline;"
                              onsubmit="return confirm('Gán đơn <%= o.getOrderID() %> lên chuyến <%= tripID %>?');">
                            <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                            <input type="hidden" name="tripID"  value="<%= tripID %>">
                            <input type="hidden" name="source"  value="trip">
                            <input type="submit" name="AssignOrderToTrip" value="📦 Gán lên xe" class="btn-assign">
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="no-data">
            <div style="font-size:2rem;margin-bottom:8px;">📭</div>
            <p>Không có đơn hàng chưa chuyển từ trạm <strong>"<%= tripDep != null ? tripDep : "" %>"</strong>.</p>
        </div>
        <% } %>

        <form action="GoodsController" method="POST">
            <input type="submit" name="ViewTripList" value="⬅ Quay lại DS Chuyến Xe" class="btn-back">
        </form>
    </div>
</div>

</body>
</html>
