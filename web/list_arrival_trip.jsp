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
            <form action="GoodsController" method="POST" class="filter-bar">
                <input type="date" name="arrivalDate"
                       value="<%= request.getParameter("arrivalDate") != null ? request.getParameter("arrivalDate") : "" %>">
                <select name="departureStation">
                    <option value="">-- Tất Cả Các Trạm Đến --</option>
                </select>
                <input type="submit" name="ViewArrivalTripList" value="Xem" class="btn-filter">
                <input type="submit" name="AddArrivalTrip" value="+ Thêm Chuyến Xe Đến" class="btn-cyan">
            </form>

            <!-- Tìm kiếm theo Biển số xe -->
            <div class="search-box">
                <form action="GoodsController" method="POST" class="filter-bar">
                    <input type="text" name="searchArrivalTruck" class="inp-search"
                           placeholder="Tìm theo biển số xe (VD: 51A-12345)..."
                           value="<%= request.getParameter("searchArrivalTruck") != null ? request.getParameter("searchArrivalTruck") : "" %>">
                    <input type="submit" name="SearchArrivalByTruck" value="🔍 Tìm xe đến" class="btn-filter">
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

            <h3>DANH SÁCH CHUYẾN XE ĐẾN</h3>

            <table>
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Mã Chuyến</th>
                        <th style="text-align:left">Lộ Trình</th>
                        <th>Biển Số Xe</th>
                        <th>Tài Xế</th>
                        <th>Giờ Xuất Phát</th>
                        <th>Trạng Thái</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<String[]> arrivalList = (List<String[]>) request.getAttribute("ARRIVAL_LIST");
                        if (arrivalList != null && !arrivalList.isEmpty()) {
                            int count = 1;
                            for (String[] t : arrivalList) {
                                // t[0]=tripID, [1]=route, [2]=dep, [3]=dest,
                                // [4]=licensePlate, [5]=driver, [6]=depTime, [7]=status, [8]=staffCreated, [9]=createdAt
                    %>
                    <tr>
                        <td><%= count++ %></td>
                        <td style="color:#3c8dbc;font-weight:bold;"><%= t[0] %></td>
                        <td class="trip-info"><%= t[1] %></td>
                        <td><strong><%= t[4] %></strong></td>
                        <td><%= t[5] %></td>
                        <td><%= t[6] %></td>
                        <td>
                            <span style="padding:3px 9px;border-radius:9px;font-size:.78rem;font-weight:700;
                                background:<%= "Đang đến".equals(t[7]) ? "#fdebd0" : "#d4efdf" %>;
                                color:<%= "Đang đến".equals(t[7]) ? "#a04000" : "#1e8449" %>">
                                <%= t[7] %>
                            </span>
                        </td>
                        <td>
                            <form action="GoodsController" method="POST" style="display:inline;">
                                <input type="hidden" name="tripID" value="<%= t[0] %>">
                                <input type="submit" name="ListGoods" value="📋 List Hàng"
                                       class="btn-action btn-list" style="margin:2px;">
                            </form>
                        </td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="8" style="padding:20px;color:#888;text-align:center;">
                            Không có dữ liệu chuyến xe đến.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div style="margin-top:16px;">
                <form action="GoodsController" method="POST" style="display:inline;">
                    <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng" class="btn-back"
                           style="padding:9px 20px;">
                </form>
            </div>
        </div>
    </body>
</html>
