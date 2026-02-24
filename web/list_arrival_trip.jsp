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
        <%@include file="includes/navbar.jsp" %>

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
            <%-- Thêm thanh tìm kiếm theo Biển số xe --%>
            <div class="search-box">
                <form action="MainController" method="POST" class="filter-bar">
                    <input type="text" name="searchArrivalTruck" class="inp-search" 
                           placeholder="Nhập biển số xe cần tìm" 
                           value="<%= request.getParameter("searchArrivalTruck") != null ? request.getParameter("searchArrivalTruck") : ""%>">

                    <input type="submit" name="SearchArrivalByTruck" value="Tìm xe đến" class="btn-filter">
                </form>
            </div>
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
    </body>
</html>