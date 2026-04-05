<%@page import="dto.StationDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Chuyến Xe Đi - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
    <link rel="stylesheet" href="css/list_trip.css">
</head>
<body>
    <%@include file="../includes/navbar.jsp" %>

    <%
        List<StationDTO> stationList = (List<StationDTO>) request.getAttribute("STATION_LIST");
        String search = (String) request.getParameter("searchTruck");
        if (search == null) search = "";
        
        String success = (String) request.getAttribute("SUCCESS_MESSAGE");
        String error   = (String) request.getAttribute("ERROR_MESSAGE");
    %>

    <div style="max-width: 1550px; margin: 20px auto; padding: 0 20px;">
        
        <div class="modern-page-header">
            <div>
                <h3>🚚 DANH SÁCH CHUYẾN XE ĐI</h3>
                <div style="font-size: 0.85rem; opacity: 0.8; margin-top: 4px;">Tổng: ${TRIP_LIST != null ? TRIP_LIST.size() : 0} chuyến</div>
            </div>
            
            <div style="display: flex; gap: 10px;">
                <form action="MainController" method="POST" style="margin:0;">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                    <button type="submit" name="ViewOrderList" class="btn-modern" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                        📦 Quản Lý Đơn Hàng
                    </button>
                </form>
                <form action="MainController" method="POST" style="margin:0;">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                    <button type="submit" name="ViewArrivalTripList" class="btn-modern" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                        📥 Chuyến Xe Đến
                    </button>
                </form>
            </div>
        </div>

        <% if (success != null) { %> <div class="alert-success">✅ <%= success %></div> <% } %>
        <% if (error != null) { %> <div class="alert-error">❌ <%= error %></div> <% } %>

        <div class="modern-card">
            <div style="display: flex; flex-direction: column; gap: 15px;">
                <form action="GoodsController" method="POST" style="display:flex; gap:10px; flex-wrap: wrap; align-items: center;">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                    
                    <select name="departureFilter" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                        <option value="">-- Từ Trạm (Đi) --</option>
                        <% if (stationList != null) for (StationDTO s : stationList) { %>
                        <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                        <% } %>
                    </select>

                    <select name="destinationFilter" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                        <option value="">-- Đến Trạm (Dừng) --</option>
                        <% if (stationList != null) for (StationDTO s : stationList) { %>
                        <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                        <% } %>
                    </select>

                    <input type="date" name="dateFilter" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                    <input type="submit" name="FilterTrip" value="🔍 Lọc Dữ Liệu" class="btn-modern btn-primary-modern">
                    <input type="submit" name="AddTrip" value="➕ Thêm Chuyến Mới" class="btn-modern btn-success-modern">
                </form>
                
                <form action="GoodsController" method="POST" style="display:flex; gap:10px; align-items: center;">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                    <input type="text" name="searchTruck" placeholder="Nhập biển số xe cần tìm..." 
                           value="<%= search %>" style="min-width:280px; padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                    <input type="submit" name="SearchTripByTruck" value="🔎 Tìm Xe" class="btn-modern btn-primary-modern">
                    <input type="submit" name="ViewTripList" value="🔄 Làm mới" class="btn-modern btn-secondary-modern">
                </form>
            </div>
        </div>

        <div class="modern-card" style="padding: 0; overflow: hidden;">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th>Mã Chuyến</th>
                        <th>Trạm Đi</th>
                        <th>Trạm Đến</th>
                        <th>Biển Số Xe</th>
                        <th>Giờ Đi</th>
                        <th>Tài Xế</th>
                        <th>Trạng Thái</th>
                        <th>NV Tạo</th>
                        <th>Thời Gian Tạo</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${not empty TRIP_LIST}">
                        <c:forEach var="t" items="${TRIP_LIST}">
                            <tr>
                                <td><strong style="color: #1a73e8;">${t[0]}</strong></td>
                                <td class="td-departure" style="color: red; font-weight: 500;">${t[2]}</td>
                                <td class="td-destination" style="color: #219150;font-weight: 500;">${t[3]}</td>
                                <td class="td-truck">${t[4]}</td>
                                <td class="td-time">${t[6]}</td>
                                <td>${t[5]}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t[7] == 'Đang đi'}">
                                            <span class="badge-status-m badge-going">🚛 Đang đi</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status-m badge-arrived">🏁 Đã cập bến</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${t[8]}</td>
                                <td class="td-created-at">${t[9]}</td>
                                <td style="min-width: 130px;">
                                    <div class="action-btns-grid">
                                        <c:if test="${t[7] == 'Đang đi'}">
                                            <form action="MainController" method="POST">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                <input type="hidden" name="tripID" value="${t[0]}">
                                                <button type="submit" name="PrepareAssignGoods" class="btn-action-trip btn-assign-goods">📦 Thêm hàng</button>
                                            </form>
                                        </c:if>
                                        <form action="MainController" method="POST">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                            <input type="hidden" name="tripID" value="${t[0]}">
                                            <button type="submit" name="ListGoods" class="btn-action-trip">📋 Xem hàng hóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty TRIP_LIST}">
                        <tr>
                            <td colspan="10" style="padding: 50px; color: #999;">📭 Chưa có chuyến xe nào xuất phát.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 20px;">
            <form action="GoodsController" method="POST">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Đơn Hàng" class="btn-back">
            </form>
        </div>
    </div>
    <%@include file="includes/footer.jsp" %>
</body>
</html>
