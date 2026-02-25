<%-- 
    Document   : create_trip
    Created on : Feb 15, 2026, 8:33:25 PM
    Author     : HuyNHSE190240
--%>

<%@page import="dto.TruckDTO"%>
<%@page import="dto.StationDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Chuyến Xe Đi</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/create_trip.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        List<StationDTO> stationList = (List<StationDTO>) request.getAttribute("STATION_LIST");
        List<TruckDTO> truckList = (List<TruckDTO>) request.getAttribute("TRUCK_LIST");
    %>

    <div class="trip-container">
        <form id="createTripForm" action="MainController" method="POST">
            <div class="trip-toolbar">
                <div class="tab-active">Thêm Chuyến Xe Đi</div>
                <input type="submit" name="SaveNewTrip" value="Lưu Chuyến Xe" class="btn-save">
            </div>
            
            <div class="trip-body">
                <div class="form-row">
                    <div class="form-col">
                        <label>Biển Số Xe</label>
                        <select name="truckID" required>
                            <option value="">Chọn Biển Số Xe</option>
                            <%
                                if (truckList != null) {
                                    for (TruckDTO truck : truckList) {
                            %>
                                <option value="<%= truck.getTruckID() %>">
                                    <%= truck.getTruckID() %> - <%= truck.getTruckType() %>
                                </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-col">
                        <label>Trạm Đi</label>
                        <select name="departure" required>
                            <option value="">-- Chọn Trạm Đi --</option>
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
                    <div class="form-col">
                        <label>Trạm Đến</label>
                        <select name="destination" required>
                            <option value="">-- Chọn Trạm Đến --</option>
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
                    <div class="form-col">
                        <label>Chọn Giờ Đi</label>
                        <input type="time" name="departureTime" required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                    </div>
                </div>
                <%-- Các phần driver, assistant giữ nguyên --%>
            </div>
        </form>
    </div>
</body>
</html>