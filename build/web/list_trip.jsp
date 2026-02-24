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
        <%@include file="includes/navbar.jsp" %>

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
            <%-- Thêm thanh tìm kiếm theo Biển số xe --%>
            <div class="search-box">
                <form action="MainController" method="POST" class="filter-bar">
                    <input type="text" name="searchTruck" class="inp-search" 
                           placeholder="Nhập biển số xe cần tìm..." 
                           value="<%= request.getParameter("searchTruck") != null ? request.getParameter("searchTruck") : ""%>">

                    <input type="submit" name="SearchTripByTruck" value="Tìm xe đi" class="btn-filter">
                </form>
            </div>

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
                            <td><%= count++%></td>
                            <td style="color: #3c8dbc; font-weight: bold;"><%= t[0]%></td>
                            <td class="route-info"><%= t[1]%></td>
                            <td><%= t[2]%></td>
                            <td><%= t[3]%></td>
                            <td><%= t[4]%></td>
                            <td><%= t[5]%></td>
                            <td><%= t[6]%></td>
                            <td>
                                <%-- SỬA: Form xử lý hàng dùng name định danh --%>
                                <form action="MainController" method="POST" style="display: inline;">
                                    <input type="hidden" name="tripID" value="<%= t[0]%>">
                                    <input type="submit" name="ListHang" value="List Hàng" class="btn-action btn-blue">
                                    <input type="submit" name="EditTrip" value="Sửa" class="btn-action btn-blue">
                                    <input type="submit" name="TransferGoods" value="Chuyển Hàng" class="btn-action btn-cyan">
                                </form>
                            </td>
                        </tr>
                        <%      }
                        } else { %>
                        <tr><td colspan="9" style="padding: 20px; color: #888; text-align: center;">Không có dữ liệu chuyến xe.</td></tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>