<%@page import="dto.StationDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Chuyến Xe Đến - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
    <link rel="stylesheet" href="css/list_trip.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        List<StationDTO> stationList = (List<StationDTO>) request.getAttribute("STATION_LIST");
        String search = (String) request.getParameter("searchArrivalTruck");
        if (search == null) search = "";
        
        String success = (String) request.getAttribute("SUCCESS_MESSAGE");
        String error   = (String) request.getAttribute("ERROR_MESSAGE");
    %>

    <div style="max-width: 1600px; margin: 20px auto; padding: 0 20px;">
        
        <div class="modern-page-header header-arrival">
            <h3>🚛 DANH SÁCH CHUYẾN XE ĐẾN</h3>
            <span style="font-weight: 700; opacity: 0.9;">Tổng: ${ARRIVAL_LIST != null ? ARRIVAL_LIST.size() : 0} chuyến</span>
        </div>

        <% if (success != null) { %> <div class="alert-success">✅ <%= success %></div> <% } %>
        <% if (error != null) { %> <div class="alert-error">❌ <%= error %></div> <% } %>

        <div class="modern-card">
            <div style="display: flex; flex-direction: column; gap: 15px;">
                <form action="GoodsController" method="POST" style="display:flex; gap:10px; flex-wrap: wrap; align-items: center;">
                    <select name="stationFilter" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                        <option value="">-- Lọc Trạm Gửi --</option>
                        <% if (stationList != null) for (StationDTO s : stationList) { %>
                        <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                        <% } %>
                    </select>
                    <input type="date" name="dateFilter" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                    <input type="submit" name="FilterArrival" value="🔍 Lọc Dữ Liệu" class="btn-modern btn-primary-modern">
                    <input type="submit" name="AddArrivalTrip" value="➕ Thêm Chuyến Đến Mới" class="btn-modern btn-success-modern">
                </form>
                
                <form action="GoodsController" method="POST" style="display:flex; gap:10px; align-items: center;">
                    <input type="text" name="searchArrivalTruck" placeholder="Nhập biển số xe cần tìm..." 
                           value="<%= search %>" style="min-width:280px; padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                    <input type="submit" name="SearchArrivalByTruck" value="🔎 Tìm Xe" class="btn-modern btn-primary-modern">
                    <input type="submit" name="ViewArrivalTripList" value="🔄 Làm mới" class="btn-modern btn-secondary-modern">
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
                    <c:if test="${not empty ARRIVAL_LIST}">
                        <c:forEach var="t" items="${ARRIVAL_LIST}">
                            <tr>
                                <td><strong class="trip-id-arrival">${t[0]}</strong></td>
                                <td class="td-departure">${t[2]}</td>
                                <td class="td-destination">${t[3]}</td>
                                <td class="td-truck">${t[4]}</td>
                                <td class="td-time">${t[6]}</td>
                                <td>${t[5]}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t[7] == 'Đã đến'}">
                                            <span class="badge-status-m badge-arrived">🏁 Đã cập bến</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status-m badge-arriving">${t[7]}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${t[8]}</td>
                                <td class="td-created-at">${t[9]}</td>
                                <td style="min-width: 130px;">
                                    <div class="action-btns-grid">
                                        <c:if test="${t[7] != 'Đã đến'}">
                                            <form action="GoodsController" method="POST">
                                                <input type="hidden" name="tripID" value="${t[0]}">
                                                <button type="submit" name="ArrivedTrip" class="btn-action-trip btn-done-trip"
                                                        onclick="return confirm('Xác nhận chuyến xe ${t[0]} đã về tới trạm?')">🏁 Đã đến</button>
                                            </form>
                                            
                                            <form action="MainController" method="POST">
                                                <input type="hidden" name="tripID" value="${t[0]}">
                                                <button type="submit" name="PrepareAssignGoods" class="btn-action-trip btn-assign-goods">📦 Thêm hàng</button>
                                            </form>
                                        </c:if>
                                        
                                        <form action="MainController" method="POST">
                                            <input type="hidden" name="tripID" value="${t[0]}">
                                            <button type="submit" name="ListGoods" class="btn-action-trip">📋 Xem hàng hóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty ARRIVAL_LIST}">
                        <tr>
                            <td colspan="9" style="padding: 50px; color: #999;">📭 Chưa có chuyến xe nào đang đến.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 20px;">
            <form action="GoodsController" method="POST">
                <input type="submit" name="ViewOrderList" value="⬅ Quay lại DS Đơn Hàng" class="btn-modern btn-secondary-modern">
            </form>
        </div>
    </div>
</body>
</html>
