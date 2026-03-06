<%@page import="dto.TruckDTO"%>
<%@page import="dto.StationDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Chuyến Xe Đến</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/create_arrival_trip.css">
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

    <div class="arrival-container">
        <form id="arrivalForm" action="MainController" method="POST">
            <div class="arrival-toolbar">
                <div class="tab-title">Thêm Chuyến Xe Đến</div>
                <input type="submit" name="SaveArrivalTrip" value="💾 Lưu Chuyến Xe" class="btn-save">
            </div>

            <div class="alert-warning" id="alertBox">
                ⚠ Lưu ý: Sau khi thêm chuyến xe đến, vào danh sách chuyến xe đến để xem hàng trên xe.
                <span class="alert-close" onclick="document.getElementById('alertBox').style.display='none'">×</span>
            </div>

            <div class="arrival-body">
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

                    <!-- Trạm đi (xuất phát) -->
                    <div class="form-col">
                        <label>Trạm Xuất Phát <span style="color:red">*</span></label>
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
                        <select name="departureTime" required>
                            <option value="">-- Chọn Giờ --</option>
                            <option value="06:00">06:00</option>
                            <option value="08:00">08:00</option>
                            <option value="10:00">10:00</option>
                            <option value="12:00">12:00</option>
                            <option value="14:00">14:00</option>
                            <option value="16:00">16:00</option>
                            <option value="17:00">17:00</option>
                            <option value="18:00">18:00</option>
                            <option value="19:00">19:00</option>
                            <option value="20:00">20:00</option>
                            <option value="21:00">21:00</option>
                        </select>
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
                    <textarea name="note" placeholder="Nhập ghi chú..."></textarea>
                </div>
                <button type="button" id="btnToggle" class="btn-toggle-note" onclick="toggleNote()">
                    📝 Nhập Thêm Ghi Chú
                </button>
            </div>
        </form>

        <div style="padding:0 20px 20px;">
            <form action="GoodsController" method="POST">
                <input type="submit" name="ViewArrivalTripList" value="⬅ Quay lại DS Chuyến Xe Đến"
                       class="btn-back" style="padding:9px 20px;">
            </form>
        </div>
    </div>

    <script>
        function toggleNote() {
            var s = document.getElementById("noteSection");
            var b = document.getElementById("btnToggle");
            if (s.style.display === "none") {
                s.style.display = "block";
                b.textContent = "🙈 Ẩn Ghi Chú";
            } else {
                s.style.display = "none";
                b.textContent = "📝 Nhập Thêm Ghi Chú";
            }
        }
    </script>
</body>
</html>
