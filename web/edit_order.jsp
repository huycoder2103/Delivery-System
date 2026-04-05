<%@page import="dto.OrderDTO"%>
<%@page import="dto.StationDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Đơn Hàng</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/edit_order.css">
</head>
<body>
<%@include file="includes/navbar.jsp" %>

<%
    OrderDTO order = (OrderDTO) request.getAttribute("EDIT_ORDER");
    List<StationDTO> stations = (List<StationDTO>) request.getAttribute("STATION_LIST");
    String errMsg = (String) request.getAttribute("ERROR_MESSAGE");

    if (order == null) {
        response.sendRedirect("GoodsController?ViewOrderList=true");
        return;
    }
%>

<div class="edit-wrap">
    <div class="edit-title">
        <h2>✏ Chỉnh Sửa Đơn Hàng — <%= order.getOrderID() %></h2>
    </div>

    <form action="GoodsController" method="POST">
        <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
        <input type="hidden" name="orderID" value="<%= order.getOrderID() %>">

        <div class="toolbar">
            <span class="toolbar-tab">Thông Tin Chỉnh Sửa</span>
            <input type="submit" name="UpdateOrder" value="💾 Lưu Lại" class="btn-save">
        </div>

        <div class="alert-warn" id="alertWarn">
            <span>⚠ Lưu ý: Mã đơn và ngày nhận không thể thay đổi. Các thông tin khác có thể chỉnh sửa tự do.</span>
            <span class="close-btn" onclick="this.parentElement.style.display='none'">✕</span>
        </div>

        <% if (errMsg != null) { %>
        <div class="err-bar">❌ <%= errMsg %></div>
        <% } %>

        <div class="form-body">

            <!-- Tên hàng -->
            <div class="field" style="margin-bottom:14px;">
                <label>Tên Hàng Gửi <span style="color:red">*</span></label>
                <input type="text" name="itemName"
                       value="<%= order.getItemName() != null ? order.getItemName() : "" %>" required>
            </div>

            <!-- Trạm gửi + Trạm nhận -->
            <div class="row2">
                <div class="field">
                    <label>Trạm Gửi</label>
                    <select name="sendStation">
                        <%
                            if (stations != null) for (StationDTO s : stations) {
                                boolean sel = s.getStationName().equals(order.getSendStation() != null ? order.getSendStation() : "");
                        %>
                        <option value="<%= s.getStationName() %>" <%= sel ? "selected" : "" %>><%= s.getStationName() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="field">
                    <label>Trạm Nhận</label>
                    <select name="receiveStation">
                        <%
                            if (stations != null) for (StationDTO s : stations) {
                                boolean sel = s.getStationName().equals(order.getReceiveStation() != null ? order.getReceiveStation() : "");
                        %>
                        <option value="<%= s.getStationName() %>" <%= sel ? "selected" : "" %>><%= s.getStationName() %></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <hr class="divider">
            <div class="section-label">Thông Tin Người Gửi</div>

            <!-- Người gửi + SĐT -->
            <div class="row2">
                <div class="field">
                    <label>Họ Tên Người Gửi</label>
                    <input type="text" name="senderName"
                           value="<%= order.getSenderName() != null ? order.getSenderName() : "" %>">
                </div>
                <div class="field">
                    <label>Số Điện Thoại</label>
                    <input type="text" name="senderPhone"
                           value="<%= order.getSenderPhone() != null ? order.getSenderPhone() : "" %>">
                </div>
            </div>

            <hr class="divider">
            <div class="section-label">Thông Tin Người Nhận</div>

            <!-- Người nhận + SĐT -->
            <div class="row2">
                <div class="field">
                    <label>Họ Tên Người Nhận</label>
                    <input type="text" name="receiverName"
                           value="<%= order.getReceiverName() != null ? order.getReceiverName() : "" %>">
                </div>
                <div class="field">
                    <label>Số Điện Thoại</label>
                    <input type="text" name="receiverPhone"
                           value="<%= order.getReceiverPhone() != null ? order.getReceiverPhone() : "" %>">
                </div>
            </div>

            <hr class="divider">
            <div class="section-label">Thanh Toán</div>

            <!-- TR + CT -->
            <div class="row2">
                <div class="field">
                    <label>Đã Thanh Toán (TR) — nghìn đồng</label>
                    <input type="number" name="paidAmount" min="0"
                           placeholder="Số tiền đã thanh toán..."
                           value="<%= (order.getTr() != null && !order.getTr().isEmpty()) ? order.getTr() : "" %>">
                </div>
                <div class="field">
                    <label>Chưa Thanh Toán (CT) — nghìn đồng</label>
                    <input type="number" name="remainAmount" min="0"
                           placeholder="Số tiền còn nợ..."
                           value="<%= (order.getCt() != null && !order.getCt().isEmpty()) ? order.getCt() : "" %>">
                </div>
            </div>

            <hr class="divider">

            <!-- Ghi chú -->
            <div class="field">
                <label>Ghi Chú</label>
                <textarea name="note" placeholder="Nhập ghi chú..."><%= order.getNote() != null ? order.getNote() : "" %></textarea>
            </div>

        </div>
    </form>

    <div class="footer-bar">
        <form action="GoodsController" method="POST">
        <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
            <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-back">
        </form>
    </div>
</div>

    <%@include file="includes/footer.jsp" %>
</body>
</html>
