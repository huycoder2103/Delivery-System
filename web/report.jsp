<%@page import="dto.ShiftDTO"%>
<%@page import="dto.ReportSummaryDTO"%>
<%@page import="java.util.List"%>
<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Hệ Thống - Delivery System</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/common_styles.css">
    <style>
        body { background-color: #f4f7f6; }
        .report-card { border: none; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); transition: 0.3s; }
        .report-card:hover { transform: translateY(-5px); }
        .nav-link { color: #495057; font-weight: 600; border: none !important; padding: 12px 25px; }
        .nav-link.active { color: #0d6efd !important; border-bottom: 3px solid #0d6efd !important; background: none !important; }
        .stat-value { font-size: 1.8rem; font-weight: 700; color: #333; }
        .stat-label { font-size: 0.9rem; color: #6c757d; text-transform: uppercase; letter-spacing: 1px; }
        .staff-link { color: #212529; text-decoration: none; transition: 0.2s; }
        .staff-link:hover { color: #0d6efd; text-decoration: underline; }
    </style>
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-dark">📊 BÁO CÁO & THỐNG KÊ</h2>
            <a href="MainController?GoHome=true" class="btn btn-outline-secondary btn-sm">← Quay lại</a>
        </div>

        <c:choose>
            <%-- ========================== GIAO DIỆN ADMIN ========================== --%>
            <c:when test="${sessionScope.ROLE eq 'AD'}">
                <!-- Bộ lọc ngày -->
                <div class="card report-card mb-4 p-3 shadow-sm border-0 bg-white">
                    <form action="ReportController" method="GET" class="row align-items-end g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-bold text-secondary small">CHỌN NGÀY XEM BÁO CÁO</label>
                            <input type="date" name="reportDate" class="form-control border-primary" value="${REPORT_DATE}">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100 fw-bold">🔍 XEM BÁO CÁO</button>
                        </div>
                        <div class="col-md-6 text-end">
                            <span class="badge bg-light text-dark border p-2">📅 Đang xem dữ liệu ngày: <strong>${REPORT_DATE}</strong></span>
                        </div>
                    </form>
                </div>

                <!-- KPI Admin -->
                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="card report-card p-3 text-center border-start border-primary border-4 shadow-sm">
                            <div class="stat-label">Doanh thu (${REPORT_DATE})</div>
                            <div class="stat-value text-primary"><fmt:formatNumber value="${REVENUE_DATE_VAL}" type="number" groupingUsed="true"/> K</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card report-card p-3 text-center border-start border-info border-4 shadow-sm">
                            <div class="stat-label">Số đơn (${REPORT_DATE})</div>
                            <div class="stat-value text-info">${ORDERS_DATE_VAL}</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card report-card p-3 text-center border-start border-success border-4 shadow-sm">
                            <div class="stat-label">Doanh thu tháng này</div>
                            <div class="stat-value text-success"><fmt:formatNumber value="${REVENUE_MONTH_VAL}" type="number" groupingUsed="true"/> K</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card report-card p-3 text-center border-start border-warning border-4 shadow-sm">
                            <div class="stat-label">NV đang làm việc</div>
                            <div class="stat-value text-warning">${ACTIVE_STAFF_COUNT}</div>
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <!-- Biểu đồ doanh thu -->
                    <div class="col-md-8">
                        <div class="card report-card p-4 h-100">
                            <h5 class="fw-bold mb-3">Tăng trưởng doanh thu (7 ngày)</h5>
                            <canvas id="adminRevenueChart" style="max-height: 300px;"></canvas>
                        </div>
                    </div>
                    <!-- Hiệu suất nhân viên -->
                    <div class="col-md-4">
                        <div class="card report-card p-4 h-100">
                            <h5 class="fw-bold mb-3">Hiệu suất hôm nay</h5>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr><th>Nhân viên</th><th class="text-end">Đơn</th><th class="text-end">Tiền</th></tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${STAFF_PERFORMANCE}">
                                            <tr class="${SELECTED_STAFF_ID eq p.staffID ? 'table-primary' : ''}">
                                                <td>
                                                    <a href="ReportController?targetStaffID=${p.staffID}" class="staff-link fw-bold">
                                                        ${p.staffName}
                                                    </a>
                                                    <small class="d-block ${p.pendingOrders == 1 ? 'text-success' : 'text-muted'}">
                                                        ${p.pendingOrders == 1 ? '● Đang làm' : '○ Nghỉ'}
                                                    </small>
                                                </td>
                                                <td class="text-end">${p.totalOrders}</td>
                                                <td class="text-end text-success fw-bold"><fmt:formatNumber value="${p.totalRevenue}" type="number" groupingUsed="true"/> K</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <p class="small text-muted mt-2"><i>* Nhấn vào tên nhân viên để xem chi tiết ca làm.</i></p>
                        </div>
                    </div>
                </div>

                <%-- Chi tiết lịch sử ca khi Admin chọn NV --%>
                <c:if test="${not empty SELECTED_STAFF_ID}">
                    <div class="card report-card p-4 mt-4 bg-white border-top border-primary border-5 shadow">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold text-primary mb-0">📜 LỊCH SỬ LÀM VIỆC: ${SELECTED_STAFF_ID}</h5>
                            <a href="ReportController" class="btn btn-sm btn-close"></a>
                        </div>
                        <%@include file="includes/shift_history_table.jsp" %>
                    </div>
                </c:if>
            </c:when>

            <%-- ========================== GIAO DIỆN NHÂN VIÊN ========================== --%>
            <c:otherwise>
                <ul class="nav nav-tabs mb-4" id="staffReportTab" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link ${empty VIEW_SHIFT_ID ? 'active' : ''}" id="current-tab" data-bs-toggle="tab" data-bs-target="#current" type="button">Ca Hiện Tại</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link ${not empty VIEW_SHIFT_ID ? 'active' : ''}" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button">Lịch Sử Ca</button>
                    </li>
                </ul>

                <div class="tab-content" id="staffReportTabContent">
                    <!-- Tab: Ca Hiện Tại -->
                    <div class="tab-pane fade ${empty VIEW_SHIFT_ID ? 'show active' : ''}" id="current" role="tabpanel">
                        <c:choose>
                            <c:when test="${not empty sessionScope.CURRENT_SHIFT}">
                                <div class="alert alert-info d-flex justify-content-between align-items-center">
                                    <span>🟢 Bạn đang trong ca làm việc số <strong>#${sessionScope.CURRENT_SHIFT.shiftID}</strong> (Bắt đầu: ${sessionScope.CURRENT_SHIFT.startTime})</span>
                                    <a href="MainController?EndShift=true&action=end" class="btn btn-danger btn-sm" onclick="return confirm('Xác nhận kết ca?')">Kết thúc ca</a>
                                </div>
                                <div class="row g-4">
                                    <div class="col-md-3">
                                        <div class="card report-card p-4 text-center border-bottom border-success border-3">
                                            <div class="stat-label">Đã giao thành công</div>
                                            <div class="stat-value text-success">${SHIFT_SUMMARY.deliveredOrders}</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card report-card p-4 text-center border-bottom border-primary border-3">
                                            <div class="stat-label">Đang đi giao</div>
                                            <div class="stat-value text-primary">${SHIFT_SUMMARY.deliveringOrders}</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card report-card p-4 text-center border-bottom border-warning border-3">
                                            <div class="stat-label">Chờ xử lý</div>
                                            <div class="stat-value text-warning">${SHIFT_SUMMARY.pendingOrders}</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card report-card p-4 text-center border-bottom border-danger border-3">
                                            <div class="stat-label">Doanh thu tạm tính</div>
                                            <div class="stat-value text-danger"><fmt:formatNumber value="${SHIFT_SUMMARY.totalRevenue}" type="number" groupingUsed="true"/> K</div>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" width="100" class="mb-3 opacity-50">
                                    <h4 class="text-muted">Bạn chưa bắt đầu ca làm việc nào.</h4>
                                    <a href="MainController?StartShift=true&action=start" class="btn btn-primary mt-3 px-4 py-2">Bắt đầu ca ngay</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Tab: Lịch Sử Ca -->
                    <div class="tab-pane fade ${not empty VIEW_SHIFT_ID ? 'show active' : ''}" id="history" role="tabpanel">
                        <div class="card report-card p-4">
                            <h5 class="fw-bold mb-3">20 Ca làm việc gần nhất</h5>
                            <%@include file="includes/shift_history_table.jsp" %>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        <c:if test="${sessionScope.ROLE eq 'AD'}">
        const ctx = document.getElementById('adminRevenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: [<c:forEach var="label" items="${CHART_DATA.chartLabels}" varStatus="loop">'${label}'${!loop.last ? ',' : ''}</c:forEach>],
                datasets: [{
                    label: 'Doanh thu (K)',
                    data: [<c:forEach var="val" items="${CHART_DATA.chartValues}" varStatus="loop">${val}${!loop.last ? ',' : ''}</c:forEach>],
                    borderColor: '#0d6efd', backgroundColor: 'rgba(13, 110, 253, 0.1)', fill: true, tension: 0.4
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { callback: function(value) { return value.toLocaleString('vi-VN') + ' K'; } } } }
            }
        });
        </c:if>
    </script>
    <%@include file="includes/footer.jsp" %>
</body>
</html>
