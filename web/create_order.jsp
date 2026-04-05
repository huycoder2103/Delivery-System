<%-- 
    Document   : create_order
    Created on : Feb 15, 2026, 6:17:46 PM
    Author     : HuyNHSE190240
--%>

<%@page import="dto.StationDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nhập Hàng Gửi</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/create_order.css">
</head>
<body>
     <%@include file="includes/navbar.jsp" %>

    <%
        List<StationDTO> stationList = (List<StationDTO>) request.getAttribute("STATION_LIST");
    %>

    <div class="order-container">
        <div class="order-header">
            <h2>NHẬP HÀNG GỬI</h2>
        </div>

        <form action="MainController" method="POST" onsubmit="return validateStations()">
            <div class="order-toolbar">
                <span>Thông tin hàng gửi</span>
                
                <%-- SỬA TẠI ĐÂY: name="SaveOrder" để điều hướng trong Controller --%>
                <input type="submit" name="SaveOrder" value="Lưu đơn hàng" class="btn-save">
            </div>

            <div class="form-body">
                <div class="form-group">
                    <label>Tên Hàng Gửi</label>
                    <input type="text" name="itemName" placeholder="Nhập Tên Hàng Gửi..." required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Trạm Gửi</label>
                        <select name="sendStation" id="sendStation" required>
                            <option value="">-- Chọn Trạm Gửi --</option>
                            <%
                                if (stationList != null) {
                                    for (StationDTO s : stationList) {
                            %>
                            <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Trạm Nhận</label>
                        <select name="receiveStation" id="receiveStation" required>
                            <option value="">-- Chọn Trạm Nhận --</option>
                            <%
                                if (stationList != null) {
                                    for (StationDTO s : stationList) {
                            %>
                            <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div>

                <script>
                    function validateStations() {
                        var send = document.getElementById("sendStation").value;
                        var receive = document.getElementById("receiveStation").value;
                        if (send === receive && send !== "") {
                            alert("❌ Trạm gửi và trạm nhận không được trùng nhau!");
                            return false;
                        }
                        return true;
                    }
                </script>

                <div class="form-row">
                    <div class="form-group">
                        <label>Người Gửi</label>
                        <input type="text" name="senderName" placeholder="Nhập vào tên người gửi...">
                    </div>
                    <div class="form-group">
                        <label>SĐT</label>
                        <input type="text" name="senderPhone" placeholder="Nhập vào số điện thoại người gửi...">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Người Nhận</label>
                        <input type="text" name="receiverName" placeholder="Nhập vào tên người nhận...">
                    </div>
                    <div class="form-group">
                        <label>SĐT</label>
                        <input type="text" name="receiverPhone" placeholder="Nhập vào số điện thoại người nhận...">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Thanh Toán</label>
                        <div class="input-addon">
                            <input type="number" name="paidAmount" placeholder="Số tiền phí khách thanh toán...">
                            <span>.000Đ</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Chưa Thanh Toán</label>
                        <div class="input-addon">
                            <input type="number" name="remainAmount" placeholder="Nhập vào phí khách chưa thanh toán...">
                            <span>.000Đ</span>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Ghi Chú (Nhân Viên Nhận)</label>
                    <textarea name="note" rows="3" placeholder="Nhập ghi chú..."></textarea>
                </div>
            </div>
        </form>
    </div>

    <div class="back-container">
        <%-- THÊM NÚT QUAY LẠI: name="ViewGoods" để Controller dẫn về trang bộ phận hàng --%>
        <form action="MainController" method="POST">
            <input type="submit" name="ViewGoods" value="⬅ Quay lại" class="btn-back">
        </form>
    </div>
</body>
</html>