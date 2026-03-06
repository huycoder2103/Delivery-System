<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Nhận Hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
</head>
<body>

<%-- Toast thông báo từ session --%>
<c:if test="${not empty sessionScope.successMsg}">
    <div id="toastSuccess" class="toast-container">
        <div class="alert alert-success alert-dismissible shadow" role="alert" style="min-width:280px">
            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </div>
    <c:remove var="successMsg" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.errorMsg}">
    <div id="toastError" class="toast-container">
        <div class="alert alert-danger alert-dismissible shadow" role="alert" style="min-width:280px">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </div>
    <c:remove var="errorMsg" scope="session"/>
</c:if>

<div class="loading-overlay" id="loadingOverlay">
    <div class="loading-box">
        <div class="spinner-border text-primary mb-2"></div>
        <div class="text-muted small">Đang xử lý...</div>
    </div>
</div>

<div class="container-fluid px-4 py-3">

    <%-- Header --%>
    <div class="page-header">
        <div>
            <h4><i class="fas fa-boxes me-2"></i>Danh Sách Nhận Hàng</h4>
            <small class="opacity-75">Quản lý đơn hàng và trạng thái chuyển</small>
        </div>
        <a href="GoodsController?action=addOrder" class="btn btn-light fw-bold btn-sm">
            <i class="fas fa-plus me-1"></i>Thêm Đơn Hàng
        </a>
    </div>

    <%-- Bộ lọc --%>
    <div class="filter-card">
        <form method="get" action="GoodsController" class="row g-2 align-items-end">
            <input type="hidden" name="action" value="listOrder">

            <div class="col-md-3">
                <label class="form-label fw-semibold small mb-1">Trạm nhận</label>
                <select name="stationFilter" class="form-select form-select-sm">
                    <option value="">-- Tất cả trạm --</option>
                    <c:forEach var="st" items="${stationList}">
                        <option value="${st.stationName}"
                            <c:if test="${stationFilter == st.stationName}">selected</c:if>>
                            ${st.stationName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold small mb-1">Ngày nhận</label>
                <input type="date" name="dateFilter" class="form-control form-control-sm"
                       value="${dateFilter}">
            </div>

            <div class="col-md-3">
                <label class="form-label fw-semibold small mb-1">Trạng thái chuyển</label>
                <select name="shipStatusFilter" class="form-select form-select-sm">
                    <option value="">-- Tất cả --</option>
                    <option value="Chưa Chuyển" <c:if test="${shipStatusFilter == 'Chưa Chuyển'}">selected</c:if>>
                        ⏳ Chưa Chuyển
                    </option>
                    <option value="Đã Chuyển" <c:if test="${shipStatusFilter == 'Đã Chuyển'}">selected</c:if>>
                        ✓ Đã Chuyển
                    </option>
                </select>
            </div>

            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary btn-sm flex-fill">
                    <i class="fas fa-search me-1"></i>Lọc
                </button>
                <a href="GoodsController?action=listOrder" class="btn btn-outline-secondary btn-sm flex-fill">
                    <i class="fas fa-redo me-1"></i>Xóa lọc
                </a>
            </div>
        </form>
    </div>

    <%-- Thống kê nhanh --%>
    <div class="row g-3 mb-3">
        <div class="col-md-3 col-6">
            <div class="bg-white rounded-3 p-3 shadow-sm text-center">
                <div class="text-primary fw-bold fs-4">${orderList.size()}</div>
                <div class="text-muted small">Tổng đơn hiển thị</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="bg-white rounded-3 p-3 shadow-sm text-center">
                <div class="text-warning fw-bold fs-4">
                    <c:set var="cntChua" value="0"/>
                    <c:forEach var="o" items="${orderList}">
                        <c:if test="${o.shipStatus != 'Đã Chuyển'}">
                            <c:set var="cntChua" value="${cntChua + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${cntChua}
                </div>
                <div class="text-muted small">Chưa Chuyển</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="bg-white rounded-3 p-3 shadow-sm text-center">
                <div class="text-success fw-bold fs-4">
                    <c:set var="cntDa" value="0"/>
                    <c:forEach var="o" items="${orderList}">
                        <c:if test="${o.shipStatus == 'Đã Chuyển'}">
                            <c:set var="cntDa" value="${cntDa + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${cntDa}
                </div>
                <div class="text-muted small">Đã Chuyển</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="bg-white rounded-3 p-3 shadow-sm text-center">
                <div class="text-danger fw-bold fs-4">
                    <c:set var="cntCT" value="0"/>
                    <c:forEach var="o" items="${orderList}">
                        <c:if test="${not empty o.ct and o.ct != '0'}">
                            <c:set var="cntCT" value="${cntCT + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${cntCT}
                </div>
                <div class="text-muted small">Chưa Thanh Toán</div>
            </div>
        </div>
    </div>

    <%-- Bảng dữ liệu --%>
    <div class="table-card">
        <div class="table-responsive">
            <table class="table table-hover mb-0" id="orderTable">
                <thead>
                    <tr>
                        <th style="width:40px">STT</th>
                        <th style="width:100px">Mã ĐH</th>
                        <th>Hàng Hóa</th>
                        <th>Người Gửi</th>
                        <th>Người Nhận</th>
                        <th style="width:110px">Trạm Nhận</th>
                        <th style="width:90px" title="Tiền đã thanh toán — Trả rồi">TR</th>
                        <th style="width:90px" title="Tiền chưa thanh toán — Chưa trả">CT</th>
                        <th style="width:130px">Ghi Chú</th>
                        <th style="width:130px">Trạng Thái Chuyển</th>
                        <th style="width:130px">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty orderList}">
                            <tr>
                                <td colspan="11" class="text-center text-muted py-5">
                                    <i class="fas fa-inbox fa-2x mb-2 d-block opacity-50"></i>
                                    Không có đơn hàng nào
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="o" items="${orderList}" varStatus="idx">
                                <tr id="row-${o.orderID}">

                                    <%-- STT --%>
                                    <td class="text-center text-muted">${idx.count}</td>

                                    <%-- Mã đơn --%>
                                    <td class="text-center">
                                        <strong class="text-primary">${o.orderID}</strong>
                                    </td>

                                    <%-- Hàng hóa --%>
                                    <td>${o.itemName}</td>

                                    <%-- Người gửi --%>
                                    <td>
                                        <div class="fw-semibold">${o.senderName}</div>
                                        <small class="text-muted">${o.senderPhone}</small>
                                    </td>

                                    <%-- Người nhận --%>
                                    <td>
                                        <div class="fw-semibold">${o.receiverName}</div>
                                        <small class="text-muted">${o.receiverPhone}</small>
                                    </td>

                                    <%-- Trạm nhận --%>
                                    <td class="text-center">
                                        <small>${o.receiveStation}</small>
                                    </td>

                                    <%-- TR: Tiền đã thanh toán --%>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty o.tr and o.tr != '0'}">
                                                <span class="badge-tr">${o.tr}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <%-- CT: Tiền chưa thanh toán --%>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty o.ct and o.ct != '0'}">
                                                <span class="badge-ct">${o.ct}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <%-- Ghi chú --%>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty o.note}">
                                                <span class="text-secondary" title="${o.note}">
                                                    <c:out value="${o.note}"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <%-- ═══════════════════════════════════════
                                         TRẠNG THÁI CHUYỂN HÀNG (CỘT MỚI)
                                    ═══════════════════════════════════════ --%>
                                    <td class="text-center" id="status-${o.orderID}">
                                        <c:choose>
                                            <c:when test="${o.shipStatus == 'Đã Chuyển'}">
                                                <span class="badge-da-chuyen">
                                                    <i class="fas fa-check me-1"></i>Đã Chuyển
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-chua-chuyen">
                                                    <i class="fas fa-clock me-1"></i>Chưa Chuyển
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <%-- Thao tác --%>
                                    <td>
                                        <div class="action-btns">
                                            <%-- Nút Chuyển Hàng: chỉ hiện khi Chưa Chuyển --%>
                                            <c:if test="${o.shipStatus != 'Đã Chuyển'}">
                                                <button class="btn-chuyen"
                                                        id="btnChuyen-${o.orderID}"
                                                        onclick="xacNhanChuyen('${o.orderID}')">
                                                    <i class="fas fa-truck me-1"></i>Chuyển
                                                </button>
                                            </c:if>

                                            <%-- Nút Sửa --%>
                                            <a href="GoodsController?action=editOrder&orderID=${o.orderID}"
                                               class="btn btn-warning btn-sm py-1">
                                                <i class="fas fa-edit"></i>
                                            </a>

                                            <%-- Nút Xóa --%>
                                            <a href="GoodsController?action=deleteOrder&orderID=${o.orderID}"
                                               class="btn btn-danger btn-sm py-1"
                                               onclick="return confirm('Xóa đơn ${o.orderID}?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <div class="text-muted small mt-2 px-1">
        Hiển thị <strong>${orderList.size()}</strong> đơn hàng
    </div>

</div>

<%-- ═══════════════════════════════════════════════════════════
     MODAL XÁC NHẬN CHUYỂN HÀNG
═══════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="modalChuyen" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white border-0 rounded-top">
                <h5 class="modal-title fs-6">
                    <i class="fas fa-truck me-2"></i>Xác nhận chuyển hàng
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center py-4">
                <div class="text-muted mb-2">Chuyển đơn hàng</div>
                <div class="fw-bold fs-5 text-primary mb-1" id="lblOrderID"></div>
                <div class="text-muted small">
                    Trạng thái sẽ đổi thành<br>
                    <span class="badge-da-chuyen mt-1 d-inline-block">
                        <i class="fas fa-check me-1"></i>Đã Chuyển
                    </span>
                </div>
            </div>
            <div class="modal-footer border-0 justify-content-center gap-2 pb-4">
                <button type="button" class="btn btn-outline-secondary btn-sm px-4"
                        data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary btn-sm px-4"
                        id="btnXacNhan">
                    <i class="fas fa-check me-1"></i>Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let _orderID = '';

    // Hiện modal xác nhận
    function xacNhanChuyen(orderID) {
        _orderID = orderID;
        document.getElementById('lblOrderID').textContent = orderID;
        new bootstrap.Modal(document.getElementById('modalChuyen')).show();
    }

    // Bấm Xác nhận trong modal
    document.getElementById('btnXacNhan').addEventListener('click', function () {
        if (!_orderID) return;

        const btn = this;
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang xử lý...';

        // Hiện loading overlay
        document.getElementById('loadingOverlay').classList.add('active');

        // Gọi AJAX
        fetch('GoodsController', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: new URLSearchParams({
                action: 'updateShipStatus',
                orderID: _orderID
            })
        })
        .then(res => res.json())
        .then(data => {
            // Ẩn modal
            bootstrap.Modal.getInstance(document.getElementById('modalChuyen')).hide();
            document.getElementById('loadingOverlay').classList.remove('active');

            if (data.success) {
                capNhatGiaoDienUI(_orderID);
                hienToast('✅ Đã chuyển đơn hàng ' + _orderID, 'success');
            } else {
                hienToast('❌ ' + (data.message || 'Có lỗi xảy ra'), 'danger');
            }
        })
        .catch(() => {
            // Fallback: redirect nếu AJAX lỗi
            document.getElementById('loadingOverlay').classList.remove('active');
            window.location.href = 'GoodsController?action=updateShipStatus&orderID=' + _orderID;
        })
        .finally(() => {
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-check me-1"></i>Xác nhận';
            _orderID = '';
        });
    });

    // Cập nhật UI ngay sau khi thành công (không reload trang)
    function capNhatGiaoDienUI(orderID) {
        // Đổi badge trạng thái
        const tdStatus = document.getElementById('status-' + orderID);
        if (tdStatus) {
            tdStatus.innerHTML =
                '<span class="badge-da-chuyen">'
                + '<i class="fas fa-check me-1"></i>Đã Chuyển'
                + '</span>';
        }
        // Ẩn nút "Chuyển"
        const btnChuyen = document.getElementById('btnChuyen-' + orderID);
        if (btnChuyen) btnChuyen.remove();
    }

    // Hiện toast thông báo
    function hienToast(msg, type) {
        const div = document.createElement('div');
        div.className = 'toast-container';
        div.innerHTML =
            '<div class="alert alert-' + type + ' alert-dismissible shadow mb-0" style="min-width:260px">'
            + msg
            + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>'
            + '</div>';
        document.body.appendChild(div);
        setTimeout(() => div.remove(), 4000);
    }

    // Tự ẩn toast từ server sau 3 giây
    setTimeout(() => {
        ['toastSuccess', 'toastError'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.style.transition = 'opacity .5s',
                     el.style.opacity = '0',
                     setTimeout(() => el.remove(), 500);
        });
    }, 3000);
</script>

</body>
</html>
