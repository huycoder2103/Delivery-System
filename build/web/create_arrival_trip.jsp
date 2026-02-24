<%-- 
    Document   : create_arrival_trip
    Created on : Feb 15, 2026, 9:07:39 PM
    Author     : HuyNHSE190240
--%>

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

        <div class="arrival-container">
            <form id="arrivalForm" action="MainController" method="POST">
                <div class="arrival-toolbar">
                    <div class="tab-title">Thêm Chuyến Xe Đến</div>

                    <%-- SỬA TẠI ĐÂY: Dùng name để điều hướng, value để hiển thị --%>
                    <input type="submit" name="SaveArrivalTrip" value="Lưu Chuyến Xe" class="btn-save">
                </div>

                <div class="alert-warning" id="alertBox">
                    Lưu ý: Sau khi nhập chuyến xe lên, vào danh sách chuyến xe đến để nhập hàng trên chuyến xe.
                    <span class="alert-close" onclick="document.getElementById('alertBox').style.display = 'none'">×</span>
                </div>

                <div class="arrival-body">
                    <div class="form-row">
                        <div class="form-col">
                            <label>Biển Số Xe</label>
                            <select name="truckID" required>
                                <option value="">Chọn Biển Số Xe</option>
                                <option value="50293">502.93</option>
                                <option value="11111">111.11</option>
                            </select>
                        </div>
                        <div class="form-col">
                            <label>Trạm Đi</label>
                            <select name="departure">
                                <option value="">-- Chọn Trạm Đi --</option>
                                <option value="BX Tây Ninh">BX Tây Ninh</option>
                                <option value="Cẩm Giang">Cẩm Giang</option>
                            </select>
                        </div>
                        <div class="form-col">
                            <label>Trạm Đến</label>
                            <select name="destination">
                                <option value="An Sương">An Sương</option>
                            </select>
                        </div>
                        <div class="form-col">
                            <label>Chọn Giờ Đi</label>
                            <select name="departureTime">
                                <option value="">Chọn Giờ Đi</option>
                                <option value="17:00">17:00</option>
                                <option value="19:00">19:00</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <label>Tài xế</label>
                            <input type="text" name="driver" placeholder="Nhập tên tài xế">
                        </div>
                        <div class="form-col">
                            <label>Phụ xe</label>
                            <input type="text" name="assistant" placeholder="Nhập vào tên phụ xe...">
                        </div>
                    </div>

                    <div id="noteSection" style="display: none;">
                        <label>Ghi Chú</label>
                        <textarea name="note" placeholder="Nhập ghi chú..."></textarea>
                    </div>

                    <button type="button" id="btnToggle" class="btn-toggle-note" onclick="toggleNote()">Nhập Thêm Ghi Chú</button>
                </div>
            </form>
        </div>


        <script>
            function toggleNote() {
                var section = document.getElementById("noteSection");
                var btn = document.getElementById("btnToggle");
                if (section.style.display === "none") {
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