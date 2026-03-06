<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            <form action="GoodsController" method="POST" class="filter-bar">
                <input type="date" name="tripDate">
                <select name="destStation">
                    <option value="">-- Tất Cả Các Trạm Đến --</option>
                </select>
                <input type="submit" name="ViewTripList" value="Xem" class="btn-filter">
                <input type="submit" name="AddTrip" value="+ Thêm Chuyến Xe Đi" class="btn-cyan">
            </form>

            <!-- Tìm kiếm theo Biển số xe -->
            <div class="search-box">
                <form action="GoodsController" method="POST" class="filter-bar">
                    <input type="text" name="searchTruck" class="inp-search"
                           placeholder="Tìm theo biển số xe (VD: 51A-12345)..."
                           value="<%= request.getParameter("searchTruck") != null ? request.getParameter("searchTruck") : "" %>">
                    <input type="submit" name="SearchTripByTruck" value="🔍 Tìm xe đi" class="btn-filter">
                </form>
            </div>

            <%
                String sucMsg = (String) request.getAttribute("SUCCESS_MESSAGE");
                String errMsg = (String) request.getAttribute("ERROR_MESSAGE");
            %>
            <% if (sucMsg != null) { %>
            <div style="background:#d4edda;color:#155724;padding:9px 14px;border-radius:4px;margin:10px 0;font-weight:600;">✅ <%= sucMsg %></div>
            <% } %>
            <% if (errMsg != null) { %>
            <div style="background:#f8d7da;color:#721c24;padding:9px 14px;border-radius:4px;margin:10px 0;font-weight:600;">❌ <%= errMsg %></div>
            <% } %>

            <h3>DANH SÁCH CHUYẾN XE ĐI</h3>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Mã Chuyến</th>
                            <th style="text-align:left">Lộ Trình</th>
                            <th>Trạm Đi</th>
                            <th>Trạm Đến</th>
                            <th>Biển Số Xe</th>
                            <th>Tài Xế</th>
                            <th>NV Tạo</th>
                            <th>Giờ Xuất Phát</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<String[]> tripList = (List<String[]>) request.getAttribute("TRIP_LIST");
                            if (tripList != null && !tripList.isEmpty()) {
                                int count = 1;
                                for (String[] t : tripList) {
                                    // t[0]=tripID, [1]=route, [2]=dep, [3]=dest,
                                    // [4]=licensePlate, [5]=driver, [6]=depTime, [7]=status, [8]=staffCreated, [9]=createdAt
                        %>
                        <tr>
                            <td><%= count++ %></td>
                            <td style="color:#3c8dbc;font-weight:bold;"><%= t[0] %></td>
                            <td class="route-info"><%= t[1] %></td>
                            <td><%= t[2] %></td>
                            <td><%= t[3] %></td>
                            <td><strong><%= t[4] %></strong></td>
                            <td><%= t[5] %></td>
                            <td><%= t[8] %></td>
                            <td><%= t[6] %></td>
                            <td>
                                <form action="GoodsController" method="POST" style="display:inline;">
                                    <input type="hidden" name="tripID" value="<%= t[0] %>">
                                    <input type="submit" name="ListGoods" value="📋 List Hàng"
                                           class="btn-action btn-cyan" style="margin:2px;">
                                </form>
                            </td>
                        </tr>
                        <% }
                        } else { %>
                        <tr>
                            <td colspan="10" style="padding:20px;color:#888;text-align:center;">
                                Không có dữ liệu chuyến xe.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div style="margin-top:16px;">
                <form action="GoodsController" method="POST" style="display:inline;">
                    <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-back"
                           style="padding:9px 20px;">
                </form>
            </div>
        </div>
    </body>
</html>
