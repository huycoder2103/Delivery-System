<%@page import="dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hàng Trên Chuyến Xe</title>
    <link rel="stylesheet" href="css/home.css">
    <style>
        body { background:#f4f7f6; font-family:'Segoe UI',sans-serif; }
        .page-wrap { max-width:1250px; margin:16px auto 30px; background:#fff; border-radius:6px; border:1px solid #ddd; box-shadow:0 2px 8px rgba(0,0,0,.06); }
        .hdr { background:linear-gradient(135deg,#8e44ad,#9b59b6); color:#fff; padding:13px 20px; border-radius:6px 6px 0 0; display:flex; justify-content:space-between; align-items:center; }
        .hdr h3 { margin:0; font-size:.95rem; }
        .hdr .meta { font-size:.8rem; opacity:.9; margin-top:4px; }
        .hdr .badge { background:rgba(255,255,255,.22); padding:2px 8px; border-radius:10px; margin-right:6px; font-weight:700; }
        .count-badge { background:rgba(255,255,255,.28); padding:4px 14px; border-radius:20px; font-weight:700; font-size:.9rem; white-space:nowrap; }
        .body { padding:16px 20px 22px; }
        .summary { display:flex; gap:12px; margin-bottom:14px; }
        .sum-card { flex:1; background:#f8f9fa; border:1px solid #eee; border-radius:6px; padding:11px 16px; text-align:center; }
        .sum-card .val { font-size:1.35rem; font-weight:800; color:#2c3e50; }
        .sum-card.green .val { color:#27ae60; }
        .sum-card.blue  .val { color:#2980b9; }
        .sum-card .lbl { font-size:.73rem; color:#888; margin-top:2px; }
        table { width:100%; border-collapse:collapse; font-size:.86rem; }
        th { background:#8e44ad; color:#fff; padding:10px 12px; text-align:left; font-size:.78rem; text-transform:uppercase; }
        td { padding:9px 12px; border-bottom:1px solid #eee; }
        tr:hover td { background:#faf5ff; }
        .money { color:#27ae60; font-weight:700; }
        .st-shipped  { background:#d5f5e3; color:#1e8449; padding:2px 9px; border-radius:9px; font-size:.74rem; font-weight:700; }
        .st-pending  { background:#fdebd0; color:#a04000; padding:2px 9px; border-radius:9px; font-size:.74rem; font-weight:700; }
        .st-received { background:#d6eaf8; color:#1a5276; padding:2px 9px; border-radius:9px; font-size:.74rem; font-weight:700; }
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
    List<OrderDTO> orders = (List<OrderDTO>) request.getAttribute("ORDER_LIST");
    int count = orders != null ? orders.size() : 0;
    double total = 0;
    if (orders != null) for (OrderDTO o : orders) total += o.getAmount();
%>

<div class="page-wrap">
    <div class="hdr">
        <div>
            <h3>📋 DANH SÁCH HÀNG TRÊN CHUYẾN XE</h3>
            <div class="meta">
                <span class="badge">Chuyến: <%= tripID != null ? tripID : "-" %></span>
                <span class="badge">Lộ trình: <%= tripRoute != null ? tripRoute : "-" %></span>
            </div>
        </div>
        <span class="count-badge"><%= count %> đơn hàng</span>
    </div>

    <div class="body">
        <div class="summary">
            <div class="sum-card blue">
                <div class="val"><%= count %></div>
                <div class="lbl">Tổng Đơn Hàng</div>
            </div>
            <div class="sum-card green">
                <div class="val"><%= String.format("%,.0f", total) %>đ</div>
                <div class="lbl">Tổng Cước Phí</div>
            </div>
        </div>

        <% if (orders != null && !orders.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Mã Đơn</th>
                    <th>Tên Hàng</th>
                    <th>Người Gửi</th>
                    <th>SĐT Gửi</th>
                    <th>Người Nhận</th>
                    <th>SĐT Nhận</th>
                    <th>Trạm Nhận</th>
                    <th>Cước</th>
                    <th>Trạng Thái</th>
                    <th>Ghi Chú</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int i = 1;
                    for (OrderDTO o : orders) {
                        String stClass = "st-shipped";
                        if ("Đã Nhận".equals(o.getTr())) stClass = "st-received";
                        else if ("Chưa Chuyển".equals(o.getTr())) stClass = "st-pending";
                %>
                <tr>
                    <td><%= i++ %></td>
                    <td><strong style="color:#8e44ad"><%= o.getOrderID() %></strong></td>
                    <td><strong><%= o.getItemName() %></strong></td>
                    <td><%= o.getSenderName() != null ? o.getSenderName() : "-" %></td>
                    <td><%= o.getSenderPhone() != null ? o.getSenderPhone() : "-" %></td>
                    <td><%= o.getReceiverName() != null ? o.getReceiverName() : "-" %></td>
                    <td><%= o.getReceiverPhone() != null ? o.getReceiverPhone() : "-" %></td>
                    <td><%= o.getReceiveStation() != null ? o.getReceiveStation() : "-" %></td>
                    <td class="money"><%= String.format("%,.0f", o.getAmount()) %>đ</td>
                    <td><span class="<%= stClass %>"><%= o.getTr() != null ? o.getTr() : "-" %></span></td>
                    <td style="max-width:120px;word-wrap:break-word;font-size:.78rem;color:#666;">
                        <%= o.getNote() != null ? o.getNote() : "" %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="no-data">
            <div style="font-size:2rem;margin-bottom:8px;">📭</div>
            <p>Chưa có đơn hàng nào được gán lên chuyến xe này.</p>
        </div>
        <% } %>

        <form action="GoodsController" method="POST">
            <input type="submit" name="ViewTripList" value="⬅ Quay lại DS Chuyến Xe" class="btn-back">
        </form>
    </div>
</div>

</body>
</html>
