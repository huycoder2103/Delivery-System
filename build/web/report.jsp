<%@page import="java.util.List"%>
<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo & Giao ca - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/report.css">
    
</head>
<body>
<%@include file="includes/navbar.jsp" %>

<%
    String role = (String) session.getAttribute("ROLE");
    if (role == null) role = "US";
    boolean isAdmin = "AD".equals(role);

    String selectedDate = (String) request.getAttribute("SELECTED_DATE");
    if (selectedDate == null) selectedDate = java.time.LocalDate.now().toString();

    String todayStr = java.time.LocalDate.now().toString();
    boolean isToday = todayStr.equals(selectedDate);

    // Format dd/MM/yyyy
    String displayDate = selectedDate;
    try {
        java.time.LocalDate ld = java.time.LocalDate.parse(selectedDate);
        displayDate = String.format("%02d/%02d/%d", ld.getDayOfMonth(), ld.getMonthValue(), ld.getYear());
    } catch (Exception ignored) {}

    List<String[]> dailyHistory = (List<String[]>) request.getAttribute("DAILY_HISTORY");
    double maxRev = 1;
    if (dailyHistory != null) {
        for (String[] r : dailyHistory) {
            try { double v = Double.parseDouble(r[3].replace(",","")); if (v > maxRev) maxRev = v; } catch (Exception ignored) {}
        }
    }
%>

<div class="list-container">
    <div class="page-title">
        <h1><%= isAdmin ? "BÁO CÁO TỔNG QUÁT" : "TỔNG KẾT CA LÀM VIỆC" %></h1>
        <div class="underline"></div>
    </div>

    <% if (isAdmin) { %>
    <%-- ════════════ ADMIN TABS ════════════ --%>
    <div class="report-tabs">
        <button class="tab-btn active" onclick="switchTab('day',     this)">📅 Theo Ngày</button>
        <button class="tab-btn"        onclick="switchTab('month',   this)">📆 Tháng Này</button>
        <button class="tab-btn"        onclick="switchTab('total',   this)">📊 Tổng Hệ Thống</button>
        <!--<button class="tab-btn"        onclick="switchTab('history', this)">🗓 Lịch Sử 30 Ngày</button>-->
    </div>

    <%-- ── TAB: THEO NGÀY ── --%>
    <div id="tab-day" class="tab-pane active">
        <form action="ReportController" method="POST" class="date-picker-bar">
            <label>📅 Chọn ngày:</label>
            <input type="date" name="selectedDate" value="<%= selectedDate %>" max="<%= todayStr %>">
            <button type="submit" class="btn-view-date">Xem báo cáo</button>
            <button type="button" class="btn-today"
                    onclick="document.querySelector('[name=selectedDate]').value='<%= todayStr %>';this.closest('form').submit()">
                Hôm nay
            </button>
            <span class="selected-date-badge">
                Đang xem: <strong><%= displayDate %></strong><%= isToday ? " (Hôm nay)" : "" %>
            </span>
        </form>

        <div class="kpi-grid-4">
            <div class="kpi-card green">
                <div class="kpi-lbl">Tổng đơn ngày này</div>
                <div class="kpi-val green">${DAY_ORDERS != null ? DAY_ORDERS : 0}</div>
            </div>
            <div class="kpi-card orange">
                <div class="kpi-lbl">Doanh thu</div>
                <div class="kpi-val orange">${DAY_REVENUE != null ? DAY_REVENUE : 0}k</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-lbl">Đã chuyển</div>
                <div class="kpi-val text-green">${DAY_COMPLETED != null ? DAY_COMPLETED : 0}</div>
            </div>
            <div class="kpi-card red">
                <div class="kpi-lbl">Chưa chuyển</div>
                <div class="kpi-val red">${DAY_PENDING != null ? DAY_PENDING : 0}</div>
            </div>
        </div>

        <%-- Hiệu suất nhân viên ngày chọn --%>
        <div class="report-card">
            <h3>👥 Hiệu suất nhân viên — <%= displayDate %></h3>
            <table class="staff-table">
                <thead><tr><th>Hạng</th><th>Mã NV</th><th>Họ Tên</th><th style="text-align:center">Số đơn</th><th style="text-align:right">Doanh thu (VNĐ)</th></tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty STAFF_LIST}">
                            <c:forEach var="s" items="${STAFF_LIST}" varStatus="st">
                                <tr>
                                    <td style="text-align:center;font-size:1rem;">
                                        <c:choose>
                                            <c:when test="${st.index==0}">🥇</c:when>
                                            <c:when test="${st.index==1}">🥈</c:when>
                                            <c:when test="${st.index==2}">🥉</c:when>
                                            <c:otherwise><span style="color:#ccc">${st.count}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${s.userID}</td>
                                    <td><strong>${s.fullName}</strong></td>
                                    <td style="text-align:center;font-weight:700;color:#2980b9">${s.orderCount}</td>
                                    <td style="text-align:right;color:#27ae60;font-weight:700;">
                                        <fmt:formatNumber value="${s.revenue}" type="number" groupingUsed="true"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise><tr><td colspan="5" class="no-data-row">Không có dữ liệu ngày này.</td></tr></c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- Danh sách đơn hàng ngày chọn --%>
        <div class="report-card">
            <h3>📋 Chi tiết đơn hàng — <%= displayDate %>
                <span style="float:right;font-size:.8rem;color:#888;font-weight:400;">${DAY_ORDERS != null ? DAY_ORDERS : 0} đơn</span>
            </h3>
            <div class="day-orders-wrap">
                <table class="day-table">
                    <thead>
                        <tr>
                            <th>#</th><th>Mã Đơn</th><th>Tên Hàng</th>
                            <th>Người Gửi / SĐT</th><th>Trạm Gửi</th>
                            <th>Người Nhận / SĐT</th><th>Trạm Nhận</th>
                            <th>NV</th><th>TR</th><th>CT</th>
                            <th>Cước</th><th>Trạng Thái</th><th>Giờ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty DAY_ORDERS_LIST}">
                                <c:forEach var="o" items="${DAY_ORDERS_LIST}" varStatus="st">
                                    <tr>
                                        <td style="color:#ccc">${st.count}</td>
                                        <td style="color:#1a73e8;font-weight:700;white-space:nowrap">${o[0]}</td>
                                        <td style="font-weight:600;text-align:left;white-space:nowrap">${o[1]}</td>
                                        <td style="text-align:left">${o[3]}<br><small style="color:#aaa">${o[4]}</small></td>
                                        <td>${o[5]}</td>
                                        <td style="text-align:left">${o[6]}<br><small style="color:#aaa">${o[7]}</small></td>
                                        <td>${o[8]}</td>
                                        <td>${o[9]}</td>
                                        <td><c:if test="${o[10] ne '-' and not empty o[10]}"><span class="bs bs-tr">${o[10]}K</span></c:if></td>
                                        <td><c:if test="${o[11] ne '-' and not empty o[11]}"><span class="bs bs-ct">${o[11]}K</span></c:if></td>
                                        <td style="color:#27ae60;font-weight:700;white-space:nowrap">${o[2]}đ</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o[12] eq 'Đã Chuyển'}"><span class="bs bs-ship">✅ Đã Chuyển</span></c:when>
                                                <c:otherwise><span class="bs bs-wait">⏳ Chưa</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="color:#888;font-size:.77rem">${o[14]}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="13" class="no-data-row">
                                    <div style="font-size:2rem;margin-bottom:6px">📭</div>
                                    Không có đơn hàng nào trong ngày này.
                                </td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%-- ── TAB: THÁNG NÀY ── --%>
    <div id="tab-month" class="tab-pane">
        <div class="kpi-grid-3">
            <div class="kpi-card green">
                <div class="kpi-lbl">Đơn tháng ${CURRENT_MONTH}</div>
                <div class="kpi-val green">${MONTH_ORDERS != null ? MONTH_ORDERS : 0}</div>
            </div>
            <div class="kpi-card orange">
                <div class="kpi-lbl">Doanh thu tháng</div>
                <div class="kpi-val orange">${MONTH_REVENUE != null ? MONTH_REVENUE : 0}k</div>
            </div>
            <div class="kpi-card red">
                <div class="kpi-lbl">Chờ xử lý</div>
                <div class="kpi-val red">${MONTH_PENDING != null ? MONTH_PENDING : 0}</div>
            </div>
        </div>
        <div class="report-card">
            <h3>📆 Chi tiết tháng ${CURRENT_MONTH}</h3>
            <div class="stat-row"><span>Tổng đơn nhận:</span><span class="stat-value text-blue">${MONTH_ORDERS != null ? MONTH_ORDERS : 0}</span></div>
            <div class="stat-row"><span>Đã chuyển:</span><span class="stat-value text-green">${MONTH_COMPLETED != null ? MONTH_COMPLETED : 0}</span></div>
            <div class="stat-row"><span>Chờ xử lý:</span><span class="stat-value text-red">${MONTH_PENDING != null ? MONTH_PENDING : 0}</span></div>
            <div class="stat-row"><span>Tổng doanh thu:</span><span class="stat-value text-green">${MONTH_REVENUE != null ? MONTH_REVENUE : 0} k</span></div>
        </div>
    </div>

    <%-- ── TAB: TỔNG HỆ THỐNG ── --%>
    <div id="tab-total" class="tab-pane">
        <div class="kpi-grid-3">
            <div class="kpi-card"><div class="kpi-lbl">Tổng đơn</div><div class="kpi-val">${TOTAL_ORDERS != null ? TOTAL_ORDERS : 0}</div></div>
            <div class="kpi-card green"><div class="kpi-lbl">Tổng doanh thu</div><div class="kpi-val green">${TOTAL_REVENUE != null ? TOTAL_REVENUE : 0}k</div></div>
            <div class="kpi-card red"><div class="kpi-lbl">Tổng chờ xử lý</div><div class="kpi-val red">${PENDING_ORDERS != null ? PENDING_ORDERS : 0}</div></div>
        </div>
        <div class="report-card">
            <h3>📊 Tổng quan toàn hệ thống</h3>
            <div class="stat-row"><span>Tổng đơn hàng:</span><span class="stat-value">${TOTAL_ORDERS != null ? TOTAL_ORDERS : 0}</span></div>
            <div class="stat-row"><span>Đã chuyển thành công:</span><span class="stat-value text-green">${COMPLETED_ORDERS != null ? COMPLETED_ORDERS : 0}</span></div>
            <div class="stat-row"><span>Đang chờ xử lý:</span><span class="stat-value text-red">${PENDING_ORDERS != null ? PENDING_ORDERS : 0}</span></div>
            <div class="stat-row"><span>Đơn hàng hôm nay:</span><span class="stat-value text-blue">${TODAY_ORDERS != null ? TODAY_ORDERS : 0}</span></div>
            <div class="stat-row"><span>Doanh thu hôm nay:</span><span class="stat-value text-orange">${TODAY_REVENUE != null ? TODAY_REVENUE : 0} k</span></div>
            <div class="stat-row"><span>Tổng doanh thu toàn bộ:</span><span class="stat-value text-green">${TOTAL_REVENUE != null ? TOTAL_REVENUE : 0} k</span></div>
        </div>
    </div>

    <%-- ── TAB: LỊCH SỬ 30 NGÀY ── --%>
<!--    <div id="tab-history" class="tab-pane">
        <div class="report-card">
            <h3>🗓 Lịch sử doanh thu 30 ngày gần nhất
                <span style="float:right;font-size:.76rem;color:#888;font-weight:400;">
                    💡 Nhấn vào dòng bất kỳ để xem chi tiết đơn hàng ngày đó
                </span>
            </h3>
            <div style="overflow-x:auto;">
                <table class="history-table">
                    <thead>
                        <tr>
                            <th>#</th><th>Ngày</th>
                            <th style="text-align:center">Số Đơn</th>
                            <th>Doanh Thu</th>
                            <th>Biểu Đồ</th>
                            <th style="text-align:center">Đã Chuyển</th>
                            <th>Xem Chi Tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (dailyHistory != null && !dailyHistory.isEmpty()) {
                                int idx = 1;
                                for (String[] row : dailyHistory) {
                                    boolean isTodayRow = todayStr.equals(row[1]);
                                    boolean isSelRow   = selectedDate.equals(row[1]);
                                    double  rev = 0;
                                    try { rev = Double.parseDouble(row[3].replace(",","")); } catch (Exception ig) {}
                                    int pct = (int)(rev / maxRev * 100);
                                    String rc = isSelRow ? "row-selected" : (isTodayRow ? "row-today" : "");
                        %>
                        <tr class="<%= rc %>" onclick="goToDay('<%= row[1] %>')">
                            <td style="color:#ccc"><%= idx++ %></td>
                            <td>
                                <strong><%= row[0] %></strong>
                                <% if (isTodayRow) { %><span class="tag-today">Hôm nay</span><% } %>
                                <% if (isSelRow && !isTodayRow) { %><span class="tag-sel">Đang xem</span><% } %>
                            </td>
                            <td class="cnt-cell"><%= row[2] %></td>
                            <td class="rev-cell"><%= row[3] %>đ</td>
                            <td>
                                <div class="bar-wrap"><div class="bar-fill" style="width:<%= pct %>%"></div></div>
                                <small style="color:#aaa;margin-left:6px"><%= pct %>%</small>
                            </td>
                            <td style="text-align:center;color:#27ae60;font-weight:700"><%= row.length > 4 ? row[4] : "-" %></td>
                            <td>
                                <button class="btn-detail"
                                        onclick="event.stopPropagation();goToDay('<%= row[1] %>')">
                                    📋 Xem
                                </button>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="7" class="no-data-row">Chưa có dữ liệu.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>-->

    <% } else { %>
    <%-- ════════════ NHÂN VIÊN TABS ════════════ --%>
    <div class="report-tabs">
        <button class="tab-btn active" onclick="switchTab('day',     this)">📅 Theo Ngày</button>
        <button class="tab-btn"        onclick="switchTab('month',   this)">📆 Tháng Này</button>
        <button class="tab-btn"        onclick="switchTab('history', this)">🗓 Lịch Sử</button>
    </div>

    <%-- ── TAB: THEO NGÀY (nhân viên) ── --%>
    <div id="tab-day" class="tab-pane active">
        <form action="ReportController" method="POST" class="date-picker-bar">
            <label>📅 Chọn ngày:</label>
            <input type="date" name="selectedDate" value="<%= selectedDate %>" max="<%= todayStr %>">
            <button type="submit" class="btn-view-date">Xem báo cáo</button>
            <button type="button" class="btn-today"
                    onclick="document.querySelector('[name=selectedDate]').value='<%= todayStr %>';this.closest('form').submit()">
                Hôm nay
            </button>
            <span class="selected-date-badge">
                Đang xem: <strong><%= displayDate %></strong><%= isToday ? " (Hôm nay)" : "" %>
            </span>
        </form>

        <div class="kpi-grid-2">
            <div class="kpi-card green">
                <div class="kpi-lbl">Đơn nhận ngày này</div>
                <div class="kpi-val green">${DAY_ORDERS != null ? DAY_ORDERS : 0}</div>
            </div>
            <div class="kpi-card orange">
                <div class="kpi-lbl">Tiền thu ngày này</div>
                <div class="kpi-val orange">${DAY_REVENUE != null ? DAY_REVENUE : 0}k</div>
            </div>
        </div>

        <div class="report-card">
            <h3>📋 Đơn hàng của tôi — <%= displayDate %>
                <span style="float:right;font-size:.8rem;color:#888;font-weight:400">${DAY_ORDERS != null ? DAY_ORDERS : 0} đơn</span>
            </h3>
            <div class="day-orders-wrap">
                <table class="day-table">
                    <thead>
                        <tr>
                            <th>#</th><th>Mã Đơn</th><th>Tên Hàng</th>
                            <th>Người Gửi / SĐT</th><th>Trạm Gửi</th>
                            <th>Người Nhận / SĐT</th><th>Trạm Nhận</th>
                            <th>TR</th><th>CT</th>
                            <th>Trạng Thái</th><th>Giờ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty DAY_ORDERS_LIST}">
                                <c:forEach var="o" items="${DAY_ORDERS_LIST}" varStatus="st">
                                    <tr>
                                        <td style="color:#ccc">${st.count}</td>
                                        <td style="color:#1a73e8;font-weight:700;white-space:nowrap">${o[0]}</td>
                                        <td style="font-weight:600;text-align:left;white-space:nowrap">${o[1]}</td>
                                        <td style="text-align:left">${o[3]}<br><small style="color:#aaa">${o[4]}</small></td>
                                        <td>${o[5]}</td>
                                        <td style="text-align:left">${o[6]}<br><small style="color:#aaa">${o[7]}</small></td>
                                        <td>${o[8]}</td>
                                        <td><c:if test="${o[10] ne '-' and not empty o[10]}"><span class="bs bs-tr">${o[10]}K</span></c:if></td>
                                        <td><c:if test="${o[11] ne '-' and not empty o[11]}"><span class="bs bs-ct">${o[11]}K</span></c:if></td>
                                        
                                        <td>
                                            <c:choose>
                                                <c:when test="${o[12] eq 'Đã Chuyển'}"><span class="bs bs-ship">✅ Đã Chuyển</span></c:when>
                                                <c:otherwise><span class="bs bs-wait">⏳ Chưa</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="color:#888;font-size:.77rem">${o[14]}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="12" class="no-data-row">
                                    <div style="font-size:2rem;margin-bottom:6px">📭</div>
                                    Không có đơn hàng nào trong ngày này.
                                </td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <% if (isToday) { %>
        <div class="report-card">
            <h3>🔑 Giao ca hôm nay</h3>
            <form action="MainController" method="POST">
                <input type="hidden" name="totalOrders" value="${TOTAL_ORDERS}">
                <label style="font-weight:600;color:#555">Ghi chú bàn giao cho ca sau:</label>
                <textarea name="shiftNote" class="shift-area"
                          placeholder="VD: Còn 3 đơn chưa chuyển, xe 50A-502.93 đang trên đường..."></textarea>
                <div style="margin-top:12px;text-align:right">
                    <input type="submit" name="SubmitShiftReport" value="✅ Xác nhận & Chốt ca" class="btn-cyan">
                </div>
            </form>
        </div>
        <% } %>
    </div>

    <%-- ── TAB: THÁNG NÀY (nhân viên) ── --%>
    <div id="tab-month" class="tab-pane">
        <div class="kpi-grid-2">
            <div class="kpi-card green"><div class="kpi-lbl">Đơn tháng ${CURRENT_MONTH}</div><div class="kpi-val green">${MONTH_ORDERS != null ? MONTH_ORDERS : 0}</div></div>
            <div class="kpi-card orange"><div class="kpi-lbl">Doanh thu tháng</div><div class="kpi-val orange">${MONTH_REVENUE != null ? MONTH_REVENUE : 0}k</div></div>
        </div>
        <div class="report-card">
            <h3>📆 Kết quả tháng ${CURRENT_MONTH}</h3>
            <div class="stat-row"><span>Tổng đơn tháng này:</span><span class="stat-value text-blue">${MONTH_ORDERS != null ? MONTH_ORDERS : 0}</span></div>
            <div class="stat-row"><span>Tổng tiền thu:</span><span class="stat-value text-green">${MONTH_REVENUE != null ? MONTH_REVENUE : 0} k</span></div>
        </div>
    </div>

    <%-- ── TAB: LỊCH SỬ (nhân viên) ── --%>
    <div id="tab-history" class="tab-pane">
        <div class="report-card">
            <h3>🗓 Lịch sử làm việc của tôi
                <span style="float:right;font-size:.76rem;color:#888;font-weight:400">💡 Nhấn dòng để xem chi tiết</span>
            </h3>
            <div style="overflow-x:auto;">
                <table class="history-table">
                    <thead>
                        <tr><th>#</th><th>Ngày</th><th style="text-align:center">Số Đơn</th><th>Doanh Thu</th><th>Biểu Đồ</th><th>Xem</th></tr>
                    </thead>
                    <tbody>
                        <%
                            if (dailyHistory != null && !dailyHistory.isEmpty()) {
                                int idx2 = 1;
                                for (String[] row : dailyHistory) {
                                    boolean isTR = todayStr.equals(row[1]);
                                    boolean isSR = selectedDate.equals(row[1]);
                                    double rv2 = 0;
                                    try { rv2 = Double.parseDouble(row[3].replace(",","")); } catch (Exception ig){}
                                    int pct2 = (int)(rv2 / maxRev * 100);
                                    String rc2 = isSR ? "row-selected" : (isTR ? "row-today" : "");
                        %>
                        <tr class="<%= rc2 %>" onclick="goToDay('<%= row[1] %>')">
                            <td style="color:#ccc"><%= idx2++ %></td>
                            <td>
                                <strong><%= row[0] %></strong>
                                <% if (isTR) { %><span class="tag-today">Hôm nay</span><% } %>
                                <% if (isSR && !isTR) { %><span class="tag-sel">Đang xem</span><% } %>
                            </td>
                            <td class="cnt-cell"><%= row[2] %></td>
                            <td class="rev-cell"><%= row[3] %>đ</td>
                            <td>
                                <div class="bar-wrap"><div class="bar-fill" style="width:<%= pct2 %>%"></div></div>
                            </td>
                            <td>
                                <button class="btn-detail" onclick="event.stopPropagation();goToDay('<%= row[1] %>')">📋 Xem</button>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="no-data-row">Chưa có dữ liệu.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% } %>

    <div style="text-align:center;margin-top:20px;">
        <form action="MainController" method="POST">
            <input type="submit" name="GoHome" value="⬅ Quay lại Trang chủ" class="btn-back" style="padding:10px 30px;border-radius:20px;">
        </form>
    </div>
</div>

<script>
    function switchTab(id, btn) {
        document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + id).classList.add('active');
        btn.classList.add('active');
    }

    // Chuyển sang tab "Theo Ngày" và load ngày được chọn
    function goToDay(dateStr) {
        const f = document.createElement('form');
        f.method = 'POST'; f.action = 'ReportController';
        const i = document.createElement('input');
        i.type = 'hidden'; i.name = 'selectedDate'; i.value = dateStr;
        f.appendChild(i); document.body.appendChild(f); f.submit();
    }
</script>
</body>
</html>
