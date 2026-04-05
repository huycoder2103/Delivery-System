<%@page import="dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thùng Rác - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
    <style>
        .header-trash { background: linear-gradient(135deg, #34495e, #2c3e50); }
        .del-text { text-decoration: line-through; color: #95a5a6; }
        .btn-restore-m { background: #27ae60; color: white; padding: 6px 12px; border-radius: 6px; border: none; cursor: pointer; font-size: 0.8rem; }
        .btn-perm-m { background: #e74c3c; color: white; padding: 6px 12px; border-radius: 6px; border: none; cursor: pointer; font-size: 0.8rem; margin-left: 5px; }
        .btn-restore-m:hover { background: #219150; }
        .btn-perm-m:hover { background: #c0392b; }
    </style>
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        List<OrderDTO> trash = (List<OrderDTO>) request.getAttribute("TRASH_LIST");
        String sucMsg = (String) request.getAttribute("SUCCESS_MESSAGE");
        int count = trash != null ? trash.size() : 0;
    %>

    <div style="max-width: 1450px; margin: 20px auto; padding: 0 20px;">
        
        <div class="modern-page-header header-trash">
            <h3>🗑️ THÙNG RÁC — ĐƠN HÀNG ĐÃ XÓA</h3>
            <span style="font-weight: 700; opacity: 0.9;"><%= count %> đơn</span>
        </div>

        <% if (sucMsg != null) { %> <div class="alert-success">✅ <%= sucMsg %></div> <% } %>

        <div class="modern-card" style="background: #fff9e6; border-left: 5px solid #f1c40f; color: #7f8c8d; font-size: 0.9rem;">
            ⚠️ Lưu ý: Các đơn hàng ở đây có thể được <strong>Khôi phục</strong> hoặc <strong>Xóa vĩnh viễn</strong>.
        </div>

        <div class="modern-card" style="padding: 0; overflow: hidden;">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Mã Đơn</th>
                        <th>Tên Hàng</th>
                        <th>Trạm Gửi</th>
                        <th>Trạm Nhận</th>
                        <th>NV Nhập</th>
                        <th>Cước Phí</th>
                        <th>Ngày Nhận</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (trash != null && !trash.isEmpty()) {
                        int i = 1;
                        for (OrderDTO o : trash) {
                    %>
                    <tr>
                        <td><%= i++ %></td>
                        <td class="del-text"><strong><%= o.getOrderID() %></strong></td>
                        <td><%= o.getItemName() %></td>
                        <td><%= o.getSendStation() %></td>
                        <td><%= o.getReceiveStation() %></td>
                        <td><%= o.getStaffInput() %></td>
                        <td style="color: #e74c3c; font-weight: 700;"><%= String.format("%,.0f", o.getAmount()) %>đ</td>
                        <td style="font-size: 0.8rem; color: #888;"><%= o.getReceiveDate() %></td>
                        <td>
                            <form action="GoodsController" method="POST" style="display:inline;">
                                <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                                <input type="submit" name="RestoreOrder" value="↩ Khôi phục" class="btn-restore-m">
                            </form>
                            <form action="GoodsController" method="POST" style="display:inline;"
                                  onsubmit="return confirm('XÓA VĨNH VIỄN đơn này? Thao tác không thể hoàn tác!');">
                                <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                                <input type="submit" name="PermanentDeleteOrder" value="✕ Xóa hẳn" class="btn-perm-m">
                            </form>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="9" style="padding: 50px; color: #999;">📭 Thùng rác trống.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 20px;">
            <form action="GoodsController" method="POST">
                <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-modern btn-secondary-modern">
            </form>
        </div>
    </div>
</body>
</html>
