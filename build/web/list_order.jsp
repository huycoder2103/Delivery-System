<%-- 
    Document   : list_order
    Created on : Feb 15, 2026, 7:59:39 PM
    Author     : HuyNHSE190240
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Nhận Hàng</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/list_order.css">
</head>
<body>

<%@include file="includes/navbar.jsp" %>

<div class="list-container">

    <!-- FILTER BAR -->
    <form action="MainController" method="POST" class="filter-bar">
        <select name="stationFilter">
            <option value="">-- Tất Cả Trạm Nhận --</option>
        </select>

        <input type="date" name="dateFilter"
               value="<%= request.getParameter("dateFilter") != null ? request.getParameter("dateFilter") : "" %>">

        <select name="statusFilter">
            <option value="0">Chưa Chuyển</option>
            <option value="1">Đã Chuyển</option>
        </select>

        <input type="submit" name="FilterOrder" value="Lọc" class="btn-filter">
        <input type="submit" name="CreateOrder" value="Nhập Hàng Gửi" class="btn-cyan">
    </form>

    <!-- SEARCH -->
    <form action="MainController" method="POST" class="filter-bar search-box">
        <input type="text" name="searchPhone"
               placeholder="Nhập SĐT người gửi hoặc nhận..."
               value="<%= request.getParameter("searchPhone") != null ? request.getParameter("searchPhone") : "" %>">

        <input type="submit" name="SearchOrderByPhone" value="Tìm kiếm" class="btn-filter">
    </form>

    <h3>
        DANH SÁCH NHẬN HÀNG
        (<%= request.getAttribute("TOTAL_COUNT") != null ? request.getAttribute("TOTAL_COUNT") : "0" %>)
    </h3>

    <div class="table-responsive">
        <table>
            <thead>
            <tr>
                <th><input type="checkbox"></th>
                <th>Mã</th>
                <th>Tên Hàng - Số Tiền</th>
                <th>Gửi</th>
                <th>SĐT</th>
                <th>Trạm Gửi</th>
                <th>Nhận</th>
                <th>SĐT</th>
                <th>Trạm Nhận</th>
                <th>NV Nhập</th>
                <th>NV Nhận</th>
                <th>TR</th>
                <th>CT</th>
                <th>Ngày Nhận</th>
                <th>Handling</th>
            </tr>
            </thead>

            <tbody>
            <c:choose>
                <c:when test="${not empty requestScope.ORDER_LIST}">
                    <c:forEach var="o" items="${requestScope.ORDER_LIST}">
                        <tr>
                            <td><input type="checkbox"></td>

                            <td class="order-id">
                                <a href="#">${o.orderID}</a>
                            </td>

                            <td>
                                <strong>${o.itemName}</strong><br>
                                <small>${o.amount}</small>
                            </td>

                            <td>${o.senderName}</td>
                            <td>${o.senderPhone}</td>
                            <td>${o.sendStation}</td>

                            <td>${o.receiverName}</td>
                            <td>${o.receiverPhone}</td>
                            <td>${o.receiveStation}</td>

                            <td>${o.staffInput}</td>
                            <td>${o.staffReceive}</td>

                            <td>${o.tr}</td>
                            <td>${o.ct}</td>

                            <td>${o.receiveDate}</td>

                            <td>
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="orderID" value="${o.orderID}">

                                    <input type="submit" name="ShipOrder"
                                           value="Chuyển Hàng"
                                           class="btn-action btn-ship">

                                    <input type="submit" name="EditOrder"
                                           value="Sửa"
                                           class="btn-action btn-edit">

                                    <input type="submit" name="DeleteOrder"
                                           value="Delete"
                                           class="btn-action btn-delete">
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="15" style="text-align:center;padding:30px;color:#888;">
                            Không có dữ liệu hiển thị (No data available)
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>