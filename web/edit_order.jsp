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
    <style>
        body { background: #f5f6f7; font-family: 'Segoe UI', sans-serif; }
        .edit-wrap {
            max-width: 900px;
            margin: 20px auto 30px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,.07);
        }
        .edit-title {
            text-align: center;
            padding: 14px 0 10px;
            border-bottom: 3px solid #f39c12;
        }
        .edit-title h2 {
            font-size: 1.1rem;
            font-weight: 700;
            text-decoration: underline;
            margin: 0;
            text-transform: uppercase;
            color: #2c3e50;
        }
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            border-bottom: 1px solid #e8e8e8;
            background: #fafafa;
        }
        .toolbar-tab {
            font-size: 0.88rem;
            color: #333;
            font-weight: 600;
            border-bottom: 2px solid #f39c12;
            padding-bottom: 3px;
        }
        .btn-save {
            background: #27ae60;
            color: #fff;
            border: none;
            padding: 9px 28px;
            border-radius: 4px;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            transition: background .2s;
        }
        .btn-save:hover { background: #1e8449; }

        .alert-warn {
            margin: 12px 20px 0;
            background: #fdf6e3;
            border: 1px solid #e8d48a;
            border-left: 4px solid #f39c12;
            padding: 9px 14px;
            font-size: 0.83rem;
            color: #7a5c00;
            border-radius: 3px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .close-btn { cursor: pointer; font-size: 1rem; color: #aaa; }
        .close-btn:hover { color: #555; }
        .err-bar {
            margin: 8px 20px;
            padding: 9px 14px;
            background: #f8d7da;
            color: #721c24;
            border-radius: 4px;
            font-size: 0.86rem;
            font-weight: 600;
        }
        .form-body { padding: 16px 20px 24px; }
        .row2  { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px; }
        .row3  { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 14px; margin-bottom: 14px; }
        .field label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: #555;
            margin-bottom: 5px;
        }
        .field input[type="text"],
        .field input[type="number"],
        .field select,
        .field textarea {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 0.87rem;
            box-sizing: border-box;
            transition: border-color .2s;
            font-family: inherit;
        }
        .field input:focus, .field select:focus, .field textarea:focus {
            border-color: #3498db;
            outline: none;
        }
        .field textarea { resize: vertical; min-height: 80px; }
        hr.divider { border: none; border-top: 1px dashed #e0e0e0; margin: 14px 0; }
        .section-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #888;
            text-transform: uppercase;
            letter-spacing: .5px;
            margin-bottom: 10px;
        }
        .footer-bar {
            padding: 0 20px 20px;
            display: flex;
            gap: 10px;
        }
        .btn-back {
            background: #6c757d; color: #fff;
            border: none; padding: 9px 22px;
            border-radius: 4px; cursor: pointer; font-weight: 600;
            font-size: 0.88rem;
        }
        .btn-back:hover { background: #545b62; }
        .readonly-field {
            background: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
        }
    </style>
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
            <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-back">
        </form>
    </div>
</div>

</body>
</html>
