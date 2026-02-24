<%-- 
    Document   : create_trip
    Created on : Feb 15, 2026, 8:33:25 PM
    Author     : HuyNHSE190240
--%>

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
    <%
            String fullName = (String) session.getAttribute("FULLNAME");
            if (fullName == null)
                fullName = "Nhân Viên";
        %>

        <div class="navbar">
            <div class="company-name">CÔNG TY</div>
            <div class="user-menu" onclick="toggleDropdown()">
                <span class="user-name">👤 <%= fullName%> ▼</span>
                <div id="userDropdown" class="dropdown-content">
                    <div class="user-header">
                        <p><strong><%= fullName%></strong></p>
                        <small><%= session.getAttribute("EMAIL") != null ? session.getAttribute("EMAIL") : ""%></small>
                    </div>
                    <div class="user-footer">
                        <form action="MainController" method="POST">
                            <input type="submit" name="Logout" value="Đăng Xuất" class="btn-logout">
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function toggleDropdown() {
                var d = document.getElementById("userDropdown");
                d.style.display = (d.style.display === "block") ? "none" : "block";
            }
        </script>

    <div class="trip-container">
        <%-- Form chính gửi về MainController --%>
        <form id="createTripForm" action="MainController" method="POST">
            <div class="trip-toolbar">
                <div class="tab-active">Thêm Chuyến Xe Đi</div>
                
                <%-- SỬA TẠI ĐÂY: Dùng name="SaveNewTrip" để Controller check null --%>
                <input type="submit" name="SaveNewTrip" value="Lưu Chuyến Xe" class="btn-save">
            </div>
            
            <div class="trip-body">
                <div class="form-row">
                    <div class="form-col">
                        <label>Biển Số Xe</label>
                        <select name="truckID" required>
                            <option value="">Chọn Biển Số Xe</option>
                            <option value="36435">36435</option>
                            <option value="03237">03237</option>
                        </select>
                    </div>
                    <div class="form-col">
                        <label>Trạm Đi</label>
                        <select name="departure">
                            <option value="An Sương">An Sương</option>
                        </select>
                    </div>
                    <div class="form-col">
                        <label>Trạm Đến</label>
                        <select name="destination" required>
                            <option value="">-- Chọn Trạm Đến --</option>
                            <option value="BX Tây Ninh">BX Tây Ninh</option>
                        </select>
                    </div>
                    <div class="form-col">
                        <label>Chọn Giờ Đi</label>
                        <select name="departureTime">
                            <option value="">Chọn Giờ Đi</option>
                            <option value="19:30">19h30</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <label>Tài xế</label>
                        <input type="text" name="driver" placeholder="Nhập vào tên tài xế...">
                    </div>
                    <div class="form-col">
                        <label>Phụ xe</label>
                        <input type="text" name="assistant" placeholder="Nhập vào tên phụ xe...">
                    </div>
                </div>

                <div id="noteSection" style="display: none;">
                    <label>Ghi Chú</label>
                    <textarea name="tripNote" placeholder="Nhập ghi chú..."></textarea>
                </div>

                <button type="button" id="btnToggle" class="btn-toggle-note" onclick="toggleNote()">Nhập Thêm Ghi Chú</button>
            </div>
        </form>
    </div>

   

    <script>
        function toggleNote() {
            var section = document.getElementById("noteSection");
            var btn = document.getElementById("btnToggle");
            
            if (section.style.display === "none" || section.style.display === "") {
                section.style.display = "block";
                btn.innerText = "Ẩn Ghi Chú";
            } else {
                section.style.display = "none";
                btn.innerText = "Nhập Thêm Ghi Chú";
            }
        }
    </script>
</body>
</html>