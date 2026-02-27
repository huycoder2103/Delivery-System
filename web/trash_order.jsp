<%@page import="dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thùng Rác - Đơn Hàng Đã Xóa</title>
    <link rel="stylesheet" href="css/home.css">
    <style>
        body { background:#f4f7f6; font-family:'Segoe UI',sans-serif; }
        .page-wrap { max-width:1350px; margin:16px auto 30px; background:#fff; border-radius:6px; border:1px solid #ddd; box-shadow:0 2px 8px rgba(0,0,0,.06); }
        .hdr { background:linear-gradient(135deg,#636e72,#2d3436); color:#fff; padding:13px 20px; border-radius:6px 6px 0 0; display:flex; justify-content:space-between; align-items:center; }
        .hdr h3 { margin:0; font-size:.95rem; }
        .count-badge { background:rgba(255,255,255,.2); padding:4px 14px; border-radius:20px; font-weight:700; font-size:.9rem; }
        .body { padding:16px 20px 22px; }
        .warn { background:#fef9e7; border:1px solid #f9e79f; border-left:4px solid #f39c12; padding:9px 14px; border-radius:4px; margin-bottom:14px; font-size:.84rem; color:#7d6608; }
        table { width:100%; border-collapse:collapse; font-size:.84rem; }
        th { background:#636e72; color:#fff; padding:10px 12px; text-align:left; font-size:.77rem; text-transform:uppercase; }
        td { padding:9px 12px; border-bottom:1px solid #eee; color:#666; }
        tr:hover td { background:#fafafa; }
        .btn-restore { background:#27ae60; color:#fff; border:none; padding:5px 11px; border-radius:4px; font-weight:700; font-size:.78rem; cursor:pointer; }
        .btn-restore:hover { background:#1e8449; }
        .btn-perm { background:#e74c3c; color:#fff; border:none; padding:5px 11px; border-radius:4px; font-weight:700; font-size:.78rem; cursor:pointer; margin-left:4px; }
        .btn-perm:hover { background:#c0392b; }
        .no-data { text-align:center; padding:36px; color:#888; }
        .btn-back { background:#6c757d; color:#fff; border:none; padding:8px 18px; border-radius:4px; cursor:pointer; font-weight:600; margin-top:14px; }
        .btn-back:hover { background:#545b62; }
        .money { color:#e74c3c; font-weight:700; }
    </style>
</head>
<body>
<%@include file="includes/navbar.jsp" %>

<%
    List<OrderDTO> trash = (List<OrderDTO>) request.getAttribute("TRASH_LIST");
    String sucMsg = (String) request.getAttribute("SUCCESS_MESSAGE");
    int count = trash != null ? trash.size() : 0;
%>

<div class="page-wrap">
    <div class="hdr">
        <h3>🗑️ THÙNG RÁC — ĐƠN HÀNG ĐÃ XÓA</h3>
        <span class="count-badge"><%= count %> đơn</span>
    </div>

    <div class="body">
        <% if (sucMsg != null) { %>
        <div style="background:#d4edda;color:#155724;padding:9px 14px;border-radius:4px;margin-bottom:12px;font-weight:600;">
            ✅ <%= sucMsg %>
        </div>
        <% } %>

        <div class="warn">
            ⚠️ Các đơn hàng ở đây đã bị <strong>xóa mềm</strong>. Bạn có thể
            <strong>khôi phục</strong> về danh sách chính hoặc
            <strong>xóa vĩnh viễn</strong> khỏi database. Xóa vĩnh viễn <u>không thể hoàn tác</u>.
        </div>

        <% if (trash != null && !trash.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Mã Đơn</th>
                    <th>Tên Hàng</th>
                    <th>Người Gửi</th>
                    <th>Trạm Gửi</th>
                    <th>Người Nhận</th>
                    <th>Trạm Nhận</th>
                    <th>NV Nhập</th>
                    <th>Cước</th>
                    <th>Ngày Nhận</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int i = 1;
                    for (OrderDTO o : trash) {
                %>
                <tr>
                    <td><%= i++ %></td>
                    <td><del style="color:#aaa"><%= o.getOrderID() %></del></td>
                    <td><%= o.getItemName() %></td>
                    <td><%= o.getSenderName() != null ? o.getSenderName() : "-" %></td>
                    <td><%= o.getSendStation() != null ? o.getSendStation() : "-" %></td>
                    <td><%= o.getReceiverName() != null ? o.getReceiverName() : "-" %></td>
                    <td><%= o.getReceiveStation() != null ? o.getReceiveStation() : "-" %></td>
                    <td><%= o.getStaffInput() != null ? o.getStaffInput() : "-" %></td>
                    <td class="money"><%= String.format("%,.0f", o.getAmount()) %>đ</td>
                    <td style="font-size:.78rem"><%= o.getReceiveDate() != null ? o.getReceiveDate() : "-" %></td>
                    <td>
                        <!-- Khôi phục -->
                        <form action="GoodsController" method="POST" style="display:inline;">
                            <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                            <input type="submit" name="RestoreOrder" value="↩ Khôi phục" class="btn-restore">
                        </form>
                        <!-- Xóa vĩnh viễn -->
                        <form action="GoodsController" method="POST" style="display:inline;"
                              onsubmit="return confirm('XÓA VĨNH VIỄN đơn <%= o.getOrderID() %>?\nThao tác này KHÔNG THỂ hoàn tác!');">
                            <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                            <input type="submit" name="PermanentDeleteOrder" value="✕ Xóa vĩnh viễn" class="btn-perm">
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="no-data">
            <div style="font-size:2.5rem;margin-bottom:10px;">🗑️</div>
            <p>Thùng rác trống. Không có đơn hàng nào bị xóa.</p>
        </div>
        <% } %>

        <form action="GoodsController" method="POST">
            <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-back">
        </form>
    </div>
</div>

</body>
</html>
