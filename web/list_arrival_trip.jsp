<%-- 
    Document   : list_arrival_trip
    Created on : Feb 15, 2026, 9:03:51 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh Sách Chuyến Xe Đến</title>
        <link rel="stylesheet" href="css/home.css">
        <link rel="stylesheet" href="css/list_arrival_trip.css">
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
            <form action="MainController" method="POST" class="filter-bar">
                <input type="date" name="arrivalDate" 
                       value="<%= request.getParameter("arrivalDate") != null ? request.getParameter("arrivalDate") : ""%>">

                <select name="departureStation">
                    <option value="">-- Tất Cả Các Trạm Đến --</option>
                </select>

                <input type="submit" name="ViewArrivalTripList" value="Xem" class="btn-filter">
                <input type="submit" name="AddArrivalTrip" value="Thêm chuyến xe đến" class="btn-cyan">
            </form>

            <h3>DANH SÁCH CHUYẾN XE ĐẾN</h3>

            <table>
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Mã</th>
                        <th>Chuyến Xe</th>
                        <th>Biển Số</th>
                        <th>Handling</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<String[]> arrivalList = (List<String[]>) request.getAttribute("ARRIVAL_LIST");
                        if (arrivalList != null && !arrivalList.isEmpty()) {
                            int count = 1;
                            for (String[] t : arrivalList) {
                    %>
                    <tr>
                        <td><%= count++%></td>
                        <td><a href="#" class="id-link"><%= t[0]%></a></td>
                        <td class="trip-info"><%= t[3]%></td>
                        <td><%= t[4]%></td>
                        <td>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="tripID" value="<%= t[0]%>">
                                <input type="submit" name="ListHang" value="List Hàng" class="btn-action btn-list">
                                <% if ("received".equals(t[9])) { %>
                                <input type="button" value="Đã nhận" class="btn-action btn-received">
                                <% } else { %>
                                <input type="submit" name="ReceiveTrip" value="Nhận Xe" class="btn-action btn-receive">
                                <% } %>
                            </form>
                        </td>
                    </tr>
                    <% }
                } else { %>
                    <tr><td colspan="5">Không có dữ liệu.</td></tr>
                    <% }%>
                </tbody>
            </table>
        </div>
        <script>
            function toggleDropdown() {
                var d = document.getElementById("userDropdown");
                d.style.display = (d.style.display === "block") ? "none" : "block";
            }
        </script>

    </body>
</html>