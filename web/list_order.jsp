<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.StationDTO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Nhận Hàng</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/list_order.css">
    <style>
        .action-bar { display:flex; gap:8px; flex-wrap:wrap; align-items:center; margin-bottom:8px; }
        .action-bar select, .action-bar input[type="date"], .action-bar input[type="text"] {
            padding:7px 10px; border:1px solid #ccc; border-radius:4px; font-size:0.85rem;
        }
        .btn-filter {
            background:#3498db; color:#fff; border:none; padding:7px 16px;
            border-radius:4px; cursor:pointer; font-weight:600; font-size:0.84rem;
        }
        .btn-filter:hover { background:#2980b9; }
        .btn-add { background:#27ae60; color:#fff; border:none; padding:7px 16px;
            border-radius:4px; cursor:pointer; font-weight:600; font-size:0.84rem; }
        .btn-add:hover { background:#1e8449; }
        .btn-trash { background:#636e72; color:#fff; border:none; padding:7px 14px;
            border-radius:4px; cursor:pointer; font-weight:600; font-size:0.84rem; }
        .btn-trash:hover { background:#2d3436; }

        .btn-ship   { background:#3498db !important; color:#fff !important; }
        .btn-edit   { background:#f39c12 !important; color:#fff !important; }
        .btn-delete { background:#e74c3c !important; color:#fff !important; }
        .btn-ship:hover   { background:#2980b9 !important; }
        .btn-edit:hover   { background:#d68910 !important; }
        .btn-delete:hover { background:#c0392b !important; }

        .page-title-row {
            display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;
        }
        .page-title-row h3 { margin:0; font-size:1rem; }
    </style>
</head>
<body>
<%@include file="includes/navbar.jsp" %>

<%
    List<StationDTO> stationList = (List<StationDTO>) request.getAttribute("STATION_LIST");
    String selStation = request.getParameter("stationFilter") != null ? request.getParameter("stationFilter") : "";
    String selDate    = request.getParameter("dateFilter")    != null ? request.getParameter("dateFilter")    : "";
    String selStatus  = request.getParameter("statusFilter")  != null ? request.getParameter("statusFilter")  : "";
    String searchPhone = request.getParameter("searchPhone")  != null ? request.getParameter("searchPhone")   : "";
    String sucMsg = (String) request.getAttribute("SUCCESS_MESSAGE");
    String errMsg = (String) request.getAttribute("ERROR_MESSAGE");
%>

<div class="list-container">

    <% if (sucMsg != null) { %>
    <div style="background:#d4edda;color:#155724;padding:9px 14px;border-radius:4px;margin-bottom:10px;font-weight:600;">
        ✅ <%= sucMsg %>
    </div>
    <% } %>
    <% if (errMsg != null) { %>
    <div style="background:#f8d7da;color:#721c24;padding:9px 14px;border-radius:4px;margin-bottom:10px;font-weight:600;">
        ❌ <%= errMsg %>
    </div>
    <% } %>

    <!-- BỘ LỌC CHÍNH -->
    <form action="GoodsController" method="POST" class="action-bar">
        <select name="stationFilter">
            <option value="">-- Tất Cả Trạm Nhận --</option>
            <%
                if (stationList != null) for (StationDTO s : stationList) {
                    boolean sel = s.getStationName().equals(selStation);
            %>
            <option value="<%= s.getStationName() %>" <%= sel ? "selected" : "" %>>
                <%= s.getStationName() %>
            </option>
            <% } %>
        </select>

        <input type="date" name="dateFilter" value="<%= selDate %>" title="Lọc theo ngày nhận">

        <select name="statusFilter">
            <option value="" <%= "".equals(selStatus) ? "selected" : "" %>>-- Tất Cả Trạng Thái --</option>
            <option value="Chưa Chuyển" <%= "Chưa Chuyển".equals(selStatus) ? "selected" : "" %>>Chưa Chuyển</option>
            <option value="Đã Chuyển"   <%= "Đã Chuyển".equals(selStatus)   ? "selected" : "" %>>Đã Chuyển</option>
            <option value="Đã Nhận"     <%= "Đã Nhận".equals(selStatus)     ? "selected" : "" %>>Đã Nhận</option>
        </select>

        <input type="submit" name="FilterOrder" value="🔍 Lọc" class="btn-filter">
        <input type="submit" name="CreateOrder"  value="+ Nhập Hàng Mới" class="btn-add">
        <input type="submit" name="ViewTrashOrder" value="🗑 Thùng Rác" class="btn-trash">
    </form>

    <!-- TÌM THEO SĐT -->
    <form action="GoodsController" method="POST" class="action-bar" style="margin-bottom:12px;">
        <input type="text" name="searchPhone" placeholder="Tìm theo SĐT người gửi / nhận..."
               value="<%= searchPhone %>" style="width:280px;">
        <input type="submit" name="SearchOrderByPhone" value="Tìm kiếm" class="btn-filter">
    </form>

    <div class="page-title-row">
        <h3>DANH SÁCH NHẬN HÀNG
            (<%= request.getAttribute("TOTAL_COUNT") != null ? request.getAttribute("TOTAL_COUNT") : "0" %>)
        </h3>
    </div>

    <div class="table-responsive">
        <table>
            <thead>
                <tr>
                    <th>Mã Đơn</th>
                    <th>Tên Hàng</th>
                    <th>Người Gửi</th>
                    <th>SĐT</th>
                    <th>Trạm Gửi</th>
                    <th>Người Nhận</th>
                    <th>SĐT</th>
                    <th>Trạm Nhận</th>
                    <th>NV Nhập</th>
                    <th>TR</th>
                    <th>CT</th>
                    <th>Ghi Chú</th>
                    <th>Ngày Nhận</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty requestScope.ORDER_LIST}">
                    <c:forEach var="o" items="${requestScope.ORDER_LIST}">
                        <tr>
                            <td><strong style="color:#2980b9">${o.orderID}</strong></td>
                            <td><strong>${o.itemName}</strong></td>
                            <td>${o.senderName}</td>
                            <td>${o.senderPhone}</td>
                            <td>${o.sendStation}</td>
                            <td>${o.receiverName}</td>
                            <td>${o.receiverPhone}</td>
                            <td>${o.receiveStation}</td>
                            <td>${o.staffInput}</td>
                            <td>
                                <span style="font-size:0.75rem;font-weight:700;padding:2px 7px;border-radius:8px;
                                    background:${o.tr == 'Đã Nhận' ? '#d6eaf8' : o.tr == 'Đã Chuyển' ? '#d5f5e3' : '#fdebd0'};
                                    color:${o.tr == 'Đã Nhận' ? '#1a5276' : o.tr == 'Đã Chuyển' ? '#1e8449' : '#a04000'}">
                                    ${o.tr}
                                </span>
                            </td>
                            <td style="max-width:100px;font-size:0.78rem">${o.ct}</td>
                            <td style="max-width:120px;word-wrap:break-word;font-size:0.78rem">${o.note}</td>
                            <td style="font-size:0.8rem">${o.receiveDate}</td>
                            <td>
                                <form action="GoodsController" method="POST">
                                    <input type="hidden" name="orderID" value="${o.orderID}">
                                    <input type="submit" name="ShipOrder" value="Chuyển Hàng"
                                           class="btn-action btn-ship" style="margin-bottom:3px;display:block;">
                                    <input type="submit" name="EditOrder" value="✏ Sửa"
                                           class="btn-action btn-edit" style="margin-bottom:3px;display:block;">
                                    <input type="submit" name="DeleteOrder" value="🗑 Xóa"
                                           class="btn-action btn-delete"
                                           onclick="return confirm('Xóa đơn ${o.orderID}?')">
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="14" style="text-align:center;padding:30px;color:#888;">
                            Không có dữ liệu hiển thị
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
