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
    <div class="error-msg">❌ <%= errMsg %></div>
    <% } %>

    <div class="trip-container">
        <form id="createTripForm" action="MainController" method="POST" onsubmit="return validateTripStations()">
            <div class="trip-toolbar">
                <div class="tab-active">Thêm Chuyến Xe Đi</div>
                <input type="submit" name="SaveNewTrip" value="💾 Lưu Chuyến Xe" class="btn-save">
            </div>

            <div class="trip-body">
                <div class="form-row">
                    <!-- Biển số xe -->
                    <div class="form-col">
                        <label>Biển Số Xe <span class="required-star">*</span></label>
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
                        <label>Trạm Đi <span class="required-star">*</span></label>
                        <select name="departure" id="departure" required>
                            <option value="">-- Chọn Trạm Đi --</option>
                            <% if (stationList != null) for (StationDTO s : stationList) { %>
                            <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Trạm đến -->
                    <div class="form-col">
                        <label>Trạm Đến <span class="required-star">*</span></label>
                        <select name="destination" id="destination" required>
                            <option value="">-- Chọn Trạm Đến --</option>
                            <% if (stationList != null) for (StationDTO s : stationList) { %>
                            <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Giờ đi -->
                    <div class="form-col">
                        <label>Giờ Xuất Phát <span class="required-star">*</span></label>
                        <input type="time" name="departureTime" required>
                    </div>
                </div>

                <script>
                    function validateTripStations() {
                        var dep = document.getElementById("departure").value;
                        var dest = document.getElementById("destination").value;
                        if (dep === dest && dep !== "") {
                            alert("❌ Trạm đi và trạm đến không được trùng nhau!");
                            return false;
                        }
                        return true;
                    }
                </script>

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

                <div id="noteSection">
                    <label>Ghi Chú</label>
                    <textarea name="note" placeholder="Nhập ghi chú..."></textarea>
                </div>
                <button type="button" class="btn-toggle-note" onclick="toggleNote()">📝 Thêm Ghi Chú</button>
            </div>
        </form>

        <div class="back-trip-container">
            <form action="GoodsController" method="POST">
                <input type="submit" name="ViewTripList" value="⬅ Quay lại DS Chuyến Xe" class="btn-back">
            </form>
        </div>
    </div>

    <script>
        function toggleNote() {
            var s = document.getElementById("noteSection");
            var b = event.target;
            if (s.style.display === "none" || s.style.display === "") {
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
