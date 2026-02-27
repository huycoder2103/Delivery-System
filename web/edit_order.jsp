<%@page import="dto.OrderDTO"%>
<%@page import="dto.StationDTO"%>
<%@page import="dto.UserDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Hàng Hóa</title>
    <link rel="stylesheet" href="css/home.css">
    <style>
        body { background: #f5f6f7; font-family: 'Segoe UI', sans-serif; }

        .edit-wrap {
            max-width: 1420px;
            margin: 14px auto 30px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 3px;
        }

        /* Header thanh tiêu đề */
        .edit-title {
            text-align: center;
            padding: 12px 0 8px;
            border-bottom: 3px solid #c8a800;
        }
        .edit-title h2 {
            font-size: 1.05rem;
            font-weight: 700;
            text-decoration: underline;
            margin: 0;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* Toolbar với tab và nút lưu */
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 16px;
            border-bottom: 1px solid #e8e8e8;
            background: #fafafa;
        }
        .toolbar-tab {
            font-size: 0.86rem;
            color: #333;
            font-weight: 500;
            border-bottom: 2px solid #c8a800;
            padding-bottom: 2px;
        }
        .btn-save {
            background: #27ae60;
            color: #fff;
            border: none;
            padding: 8px 26px;
            border-radius: 4px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            transition: background .2s;
        }
        .btn-save:hover { background: #1e8449; }

        /* Alert thông báo */
        .alert-warn {
            margin: 10px 16px;
            background: #fdf6e3;
            border: 1px solid #e8d48a;
            border-left: 4px solid #c8a800;
            padding: 9px 14px 9px 12px;
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
            margin: 0 16px 8px;
            padding: 9px 14px;
            background: #f8d7da;
            color: #721c24;
            border-radius: 3px;
            font-size: 0.86rem;
            font-weight: 600;
        }

        /* Form */
        .form-body { padding: 12px 16px 20px; }

        .row2  { display: grid; grid-template-columns: 1fr 1fr;         gap: 12px; margin-bottom: 12px; }
        .row4  { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: 12px; margin-bottom: 12px; }
        .row14 { display: grid; grid-template-columns: 2fr 1fr;         gap: 12px; margin-bottom: 12px; }

        .field label {
            display: block;
            font-size: 0.80rem;
            font-weight: 600;
            color: #444;
            margin-bottom: 5px;
        }
        .field input[type="text"],
        .field input[type="number"],
        .field select,
        .field textarea {
            width: 100%;
            padding: 7px 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 0.86rem;
            box-sizing: border-box;
            transition: border-color .2s;
            background: #fff;
            font-family: inherit;
        }
        .field input:focus, .field select:focus, .field textarea:focus {
            border-color: #3498db;
            outline: none;
        }
        .field textarea { resize: vertical; min-height: 76px; }

        hr.divider { border: none; border-top: 1px dashed #e0e0e0; margin: 14px 0 12px; }

        .footer-bar { padding: 0 16px 16px; }
        .btn-back {
            background: #6c757d; color: #fff;
            border: none; padding: 7px 20px;
            border-radius: 4px; cursor: pointer; font-weight: 600;
        }
        .btn-back:hover { background: #545b62; }
    </style>
</head>
<body>
<%@include file="includes/navbar.jsp" %>

<%
    OrderDTO order = (OrderDTO) request.getAttribute("EDIT_ORDER");
    List<StationDTO> stations = (List<StationDTO>) request.getAttribute("STATION_LIST");
    List<UserDTO>    staffList = (List<UserDTO>)   request.getAttribute("STAFF_LIST");
    String errMsg = (String) request.getAttribute("ERROR_MESSAGE");

    if (order == null) {
        response.sendRedirect("GoodsController?ViewOrderList=true");
        return;
    }

    String[] goodsTypes = {"Hàng Hóa","Vé Xe","Bưu Phẩm","Tài Liệu","Đồ Dễ Vỡ","Thực Phẩm","Khác"};
    String curCt = order.getCt() != null ? order.getCt() : "";
%>

<div class="edit-wrap">
    <!-- Tiêu đề -->
    <div class="edit-title">
        <h2>Chỉnh Sửa Hàng Hóa</h2>
    </div>

    <form action="GoodsController" method="POST">
        <input type="hidden" name="orderID" value="<%= order.getOrderID() %>">

        <!-- Toolbar -->
        <div class="toolbar">
            <span class="toolbar-tab">Thông Tin Chỉnh Sửa</span>
            <input type="submit" name="UpdateOrder" value="Lưu Lại" class="btn-save">
        </div>

        <!-- Alert -->
        <div class="alert-warn" id="alertWarn">
            <span>- Lưu ý Hàng hóa đã thanh toán, một số nội dung không được chỉnh sửa.</span>
            <span class="close-btn" onclick="this.parentElement.style.display='none'">✕</span>
        </div>

        <% if (errMsg != null) { %>
        <div class="err-bar">❌ <%= errMsg %></div>
        <% } %>

        <div class="form-body">

            <!-- Tên hàng + Loại hàng -->
            <div class="row14">
                <div class="field">
                    <label>Tên Hàng Gửi</label>
                    <input type="text" name="itemName"
                           value="<%= order.getItemName() != null ? order.getItemName() : "" %>" required>
                </div>
                <div class="field">
                    <label>Loại Hàng Hóa - Tiền Gửi</label>
                    <select name="ct">
                        <% for (String t : goodsTypes) { %>
                        <option value="<%= t %>" <%= t.equals(curCt) ? "selected" : "" %>><%= t %></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <!-- NV + Trạm gửi + Trạm nhận + Loại hàng 2 -->
            <div class="row4">
                <div class="field">
                    <label>Nhân Viên Nhận</label>
                    <select name="staffInput">
                        <%
                            if (staffList != null) for (UserDTO u : staffList) {
                                boolean sel = u.getUserID().equals(order.getStaffInput() != null ? order.getStaffInput() : "");
                        %>
                        <option value="<%= u.getUserID() %>" <%= sel ? "selected" : "" %>><%= u.getFullName() %></option>
                        <% } %>
                    </select>
                </div>
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
                <div class="field">
                    <label>Loại Hàng Hóa - Tiền Gửi</label>
                    <select name="ct2" disabled>
                        <% for (String t : goodsTypes) { %>
                        <option value="<%= t %>" <%= t.equals(curCt) ? "selected" : "" %>><%= t %></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <hr class="divider">

            <!-- Người gửi + SĐT -->
            <div class="row2">
                <div class="field">
                    <label>Người Gửi</label>
                    <input type="text" name="senderName"
                           value="<%= order.getSenderName() != null ? order.getSenderName() : "" %>">
                </div>
                <div class="field">
                    <label>SĐT</label>
                    <input type="text" name="senderPhone"
                           value="<%= order.getSenderPhone() != null ? order.getSenderPhone() : "" %>">
                </div>
            </div>

            <!-- Người nhận + SĐT -->
            <div class="row2">
                <div class="field">
                    <label>Người Nhận</label>
                    <input type="text" name="receiverName"
                           value="<%= order.getReceiverName() != null ? order.getReceiverName() : "" %>">
                </div>
                <div class="field">
                    <label>SĐT</label>
                    <input type="text" name="receiverPhone"
                           value="<%= order.getReceiverPhone() != null ? order.getReceiverPhone() : "" %>">
                </div>
            </div>

            <!-- Thanh toán + Chưa thanh toán -->
            <div class="row2">
                <div class="field">
                    <label>Thanh Toán</label>
                    <input type="number" name="paidAmount" min="0"
                           value="<%= (int) order.getAmount() %>">
                </div>
                <div class="field">
                    <label>Chưa Thanh Toán</label>
                    <input type="number" name="remainAmount" min="0"
                           placeholder="Số tiền phí khách chưa thanh toán...">
                </div>
            </div>

            <!-- Ghi chú -->
            <div class="field">
                <label>Ghi Chú</label>
                <textarea name="note" placeholder="Nhập ghi chú..."><%= order.getNote() != null ? order.getNote() : "" %></textarea>
            </div>

        </div><!-- /form-body -->
    </form>

    <div class="footer-bar">
        <form action="GoodsController" method="POST">
            <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-back">
        </form>
    </div>
</div>

</body>
</html>
