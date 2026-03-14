<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

    <c:if test="${not empty requestScope.SUCCESS_MESSAGE}">
        <div class="alert-success">✅ ${requestScope.SUCCESS_MESSAGE}</div>
    </c:if>
    <c:if test="${not empty requestScope.ERROR_MESSAGE}">
        <div class="alert-error">❌ ${requestScope.ERROR_MESSAGE}</div>
    </c:if>

    <!-- BỘ LỌC -->
    <div class="filter-section">
        <div class="filter-label">🔍 Lọc &amp; Tìm kiếm chuyến xe đến</div>

        <!-- Hàng 1: Ngày + Trạm -->
        <form action="GoodsController" method="POST" class="filter-row">
            <input type="date" name="arrivalDate"
                   value="${param.arrivalDate}"
                   title="Lọc theo ngày">
            <select name="departureStation">
                <option value="">-- Tất Cả Trạm Xuất Phát --</option>
                <c:forEach var="s" items="${requestScope.STATION_LIST}">
                    <option value="${s.stationName}"
                        <c:if test="${param.departureStation eq s.stationName}">selected</c:if>>
                        ${s.stationName}
                    </option>
                </c:forEach>
            </select>
            <select name="arrivalStation">
                <option value="">-- Tất Cả Trạm Đến --</option>
                <c:forEach var="s" items="${requestScope.STATION_LIST}">
                    <option value="${s.stationName}"
                        <c:if test="${param.arrivalStation eq s.stationName}">selected</c:if>>
                        ${s.stationName}
                    </option>
                </c:forEach>
            </select>
            <input type="submit" name="ViewArrivalTripList" value="🔍 Lọc" class="btn-filter">
            <input type="submit" name="AddArrivalTrip" value="+ Thêm Chuyến Xe Đến" class="btn-cyan btn-add">
        </form>

        <!-- Hàng 2: Tìm theo biển số xe -->
        <form action="GoodsController" method="POST" class="filter-row">
            <input type="text" name="searchArrivalTruck" class="inp-search"
                   placeholder="🔎 Tìm theo biển số xe (VD: 51A-12345)..."
                   value="${param.searchArrivalTruck}"
                   style="min-width:280px;">
            <input type="submit" name="SearchArrivalByTruck" value="Tìm xe đến" class="btn-filter">
        </form>
    </div>

    <!-- TIÊU ĐỀ BẢNG -->
    <div class="page-header">
        <h3>🏁 DANH SÁCH CHUYẾN XE ĐẾN</h3>
        <span class="count-pill">
            <c:choose>
                <c:when test="${not empty requestScope.ARRIVAL_LIST}">
                    ${fn:length(requestScope.ARRIVAL_LIST)} chuyến
                </c:when>
                <c:otherwise>0 chuyến</c:otherwise>
            </c:choose>
        </span>
    </div>

    <!-- BẢNG DỮ LIỆU -->
    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>No.</th>
                    <th>Mã Chuyến</th>
                    <th style="text-align:left">Lộ Trình</th>
                    <th>Trạm Xuất Phát</th>
                    <th>Trạm Đến</th>
                    <th>Biển Số Xe</th>
                    <th>Tài Xế</th>
                    <th>NV Tạo</th>
                    <th>Ngày Tạo</th>
                    <th>Giờ Xuất Phát</th>
                    <th>Trạng Thái</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty requestScope.ARRIVAL_LIST}">
                        <c:forEach var="t" items="${requestScope.ARRIVAL_LIST}" varStatus="st">
                            <%-- t[0]=tripID, [1]=route, [2]=dep, [3]=dest,
                                 [4]=licensePlate, [5]=driver, [6]=depTime,
                                 [7]=status, [8]=staffCreated, [9]=createdAt --%>
                            <tr>
                                <td>${st.count}</td>
                                <td class="trip-id">${t[0]}</td>
                                <td class="trip-info">${t[1]}</td>
                                <td>${t[2]}</td>
                                <td>${t[3]}</td>
                                <td><strong>${t[4]}</strong></td>
                                <td>${t[5]}</td>
                                <td>${t[8]}</td>
                                <td style="font-size:.78rem;color:#888;">${t[9]}</td>
                                <td>${t[6]}</td>
                                <td>
                                    <span class="badge-status
                                        <c:choose>
                                            <c:when test="${t[7] eq 'Đang đến'}">badge-arriving</c:when>
                                            <c:when test="${t[7] eq 'Đã đến'}">badge-arrived</c:when>
                                            <c:otherwise>badge-other</c:otherwise>
                                        </c:choose>">
                                        ${t[7]}
                                    </span>
                                </td>
                                <td>
                                    <form action="GoodsController" method="POST">
                                        <input type="hidden" name="tripID" value="${t[0]}">
                                        <button type="submit" name="ListGoods" class="btn-list">📋 List Hàng</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="12">
                                <div class="no-data">
                                    <div class="icon">🏁</div>
                                    <p>Không có dữ liệu chuyến xe đến.</p>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <div style="margin-top:16px;">
        <form action="GoodsController" method="POST" style="display:inline;">
            <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Hàng"
                   class="btn-back" style="padding:9px 20px;">
        </form>
    </div>
</div>

</body>
</html>
