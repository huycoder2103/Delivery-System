<%-- 
    Document   : list_trip
    Created on : Feb 15, 2026, 8:30:03 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Chuyến Xe Đi</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/list_trip.css">
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

    <div class="list-container">
        <%-- Form lọc dữ liệu và thêm mới dùng name --%>
        <form action="MainController" method="POST" class="filter-bar">
            <input type="date" name="tripDate">
            <select name="destStation">
                <option value="">-- Tất Cả Các Trạm Đến --</option>
            </select>
            
            <%-- SỬA: Dùng name để định danh hành động --%>
            <input type="submit" name="ViewTripList" value="Xem" class="btn-filter">
            <input type="submit" name="AddTrip" value="Thêm Chuyến Xe Đi" class="btn-cyan">
        </form>

        <h3>DANH SÁCH CHUYẾN XE ĐI</h3>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Mã</th>
                        <th style="text-align:left">Chuyến Xe</th>
                        <th>Trạm Đi</th>
                        <th>Trạm Đến</th>
                        <th>Biển Số</th>
                        <th>NV Tạo</th>
                        <th>Thời Gian Tạo</th>
                        <th>Handling</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<String[]> tripList = (List<String[]>) request.getAttribute("TRIP_LIST");
                        if (tripList != null && !tripList.isEmpty()) {
                            int count = 1;
                            for (String[] t : tripList) {
                    %>
                    <tr>
                        <td><%= count++ %></td>
                        <td style="color: #3c8dbc; font-weight: bold;"><%= t[0] %></td>
                        <td class="route-info"><%= t[1] %></td>
                        <td><%= t[2] %></td>
                        <td><%= t[3] %></td>
                        <td><%= t[4] %></td>
                        <td><%= t[5] %></td>
                        <td><%= t[6] %></td>
                        <td>
                            <%-- SỬA: Form xử lý hàng dùng name định danh --%>
                            <form action="MainController" method="POST" style="display: inline;">
                                <input type="hidden" name="tripID" value="<%= t[0] %>">
                                <input type="submit" name="ListHang" value="List Hàng" class="btn-action btn-blue">
                                <input type="submit" name="EditTrip" value="Sửa" class="btn-action btn-blue">
                                <input type="submit" name="TransferGoods" value="Chuyển Hàng" class="btn-action btn-cyan">
                            </form>
                        </td>
                    </tr>
                    <%      }
                        } else { %>
                    <tr><td colspan="9" style="padding: 20px; color: #888; text-align: center;">Không có dữ liệu chuyến xe.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    
</body>
</html>