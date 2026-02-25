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
            // Lấy danh sách trạm từ request (đã được GoodsController setAttribute)
            List<StationDTO> stationList = (List<StationDTO>) request.getAttribute("STATION_LIST");
        %>

        <div class="order-container">
            <div class="order-header">
                <h2>NHẬP HÀNG GỬI</h2>
            </div>

            <form action="MainController" method="POST">
                <div class="order-toolbar">
                    <span style="color: white; font-weight: bold;">Thông tin hàng gửi</span>
                    <input type="submit" name="SaveOrder" value="Lưu đơn hàng" class="btn-save">
                </div>

                <div class="form-body">
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label>Tên Hàng Gửi</label>
                        <input type="text" name="itemName" placeholder="Nhập Tên Hàng Gửi..." required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Trạm Gửi</label>
                            <select name="sendStation" required>
                                <option value="">-- Chọn Trạm Gửi --</option>
                                <%
                                    if (stationList != null) {
                                        for (StationDTO station : stationList) {
                                %>
                                    <option value="<%= station.getStationName() %>"><%= station.getStationName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Trạm Nhận</label>
                            <select name="receiveStation" required>
                                <option value="">-- Chọn Trạm Nhận --</option>
                                <%
                                    if (stationList != null) {
                                        for (StationDTO station : stationList) {
                                %>
                                    <option value="<%= station.getStationName() %>"><%= station.getStationName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    
                    <%-- Các phần còn lại giữ nguyên như file cũ của bạn --%>
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
                    <%-- ... tiếp tục form của bạn ... --%>
                </div>
            </form>
        </div>
    </body>
</html>