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
        List<TruckDTO>   truckList   = (List<TruckDTO>)   request.getAttribute("TRUCK_LIST");
        String errMsg = (String) request.getAttribute("ERROR_MESSAGE");
    %>

    <% if (errMsg != null) { %>
    <div style="background:#f8d7da;color:#721c24;padding:10px 20px;font-weight:bold;">❌ <%= errMsg %></div>
    <% } %>

    <div class="trip-container">
        <form id="createTripForm" action="MainController" method="POST">
            <div class="trip-toolbar">
                <div class="tab-active">Thêm Chuyến Xe Đi</div>
                <input type="submit" name="SaveNewTrip" value="💾 Lưu Chuyến Xe" class="btn-save">
            </div>

            <div class="trip-body">
                <div class="form-row">
                    <!-- Biển số xe -->
                    <div class="form-col">
                        <label>Biển Số Xe <span style="color:red">*</span></label>
                        <select name="truckID" required>
                            <option value="">-- Chọn Xe --</option>
                            <%
                                if (truckList != null) {
                                    for (TruckDTO truck : truckList) {
                                        String statusLabel = truck.isStatus() ? "" : " (Đang đi)";
                            %>
                            <option value="<%= truck.getTruckID() %>">
                                <%= truck.getLicensePlate() %><%= statusLabel %>
                            </option>
                            <%  }} %>
                        </select>
                    </div>

                    <!-- Trạm đi -->
                    <div class="form-col">
                        <label>Trạm Đi <span style="color:red">*</span></label>
                        <select name="departure" required>
                            <option value="">-- Chọn Trạm Đi --</option>
                            <% if (stationList != null) for (StationDTO s : stationList) { %>
                            <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Trạm đến -->
                    <div class="form-col">
                        <label>Trạm Đến <span style="color:red">*</span></label>
                        <select name="destination" required>
                            <option value="">-- Chọn Trạm Đến --</option>
                            <% if (stationList != null) for (StationDTO s : stationList) { %>
                            <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Giờ đi -->
                    <div class="form-col">
                        <label>Giờ Xuất Phát <span style="color:red">*</span></label>
                        <input type="time" name="departureTime" required
                               style="width:100%;padding:10px;border:1px solid #ccc;border-radius:4px;">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <label>Tài Xế</label>
                        <input type="text" name="driver" placeholder="Nhập tên tài xế...">
                    </div>
                    <div class="form-col">
                        <label>Phụ Xe</label>
                        <input type="text" name="assistant" placeholder="Nhập tên phụ xe...">
                    </div>
                </div>

                <div id="noteSection" style="display:none;">
                    <label style="font-weight:bold;display:block;margin-bottom:8px;">Ghi Chú</label>
                    <textarea name="note" placeholder="Nhập ghi chú..."
                              style="width:100%;height:80px;padding:10px;border:1px solid #3c8dbc;border-radius:4px;resize:vertical;"></textarea>
                </div>
                <button type="button" class="btn-toggle-note" onclick="toggleNote()">📝 Thêm Ghi Chú</button>
            </div>
        </form>

        <div style="padding:0 20px 20px;">
            <form action="GoodsController" method="POST">
                <input type="submit" name="ViewTripList" value="⬅ Quay lại DS Chuyến Xe"
                       class="btn-back" style="padding:9px 20px;">
            </form>
        </div>
    </div>

    <script>
        function toggleNote() {
            var s = document.getElementById("noteSection");
            var b = event.target;
            if (s.style.display === "none") {
                s.style.display = "block";
                b.textContent = "🙈 Ẩn Ghi Chú";
            } else {
                s.style.display = "none";
                b.textContent = "📝 Thêm Ghi Chú";
            }
        }
    </script>
</body>
</html>
