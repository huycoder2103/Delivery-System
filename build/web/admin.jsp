<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Admin</title>
        <link rel="stylesheet" href="css/home.css">
        <link rel="stylesheet" href="css/admin.css">

    <body>
        <%@include file="includes/navbar.jsp" %>

        <!-- --- ADMIN DASHBOARD --- -->
        <div class="admin-container" style="margin-bottom: 20px; background: #fdfdfd;">
            <div class="admin-header">
                <h2>BẢNG ĐIỀU KHIỂN HỆ THỐNG</h2>
            </div>
            <div class="kpi-row">
                <div class="kpi-mini blue" style="background: #e7f3ff; border: 1px solid #b3d7ff;">
                    <div class="v" style="color: #007bff;">
                        <fmt:formatNumber value="${requestScope.REVENUE_TODAY}" type="number" maxFractionDigits="0" groupingUsed="true"/> K
                    </div>
                    <div class="l">Doanh thu hôm nay</div>
                </div>
                <div class="kpi-mini green" style="background: #e6fffa; border: 1px solid #b2f5ea;">
                    <div class="v" style="color: #38b2ac;">${requestScope.ACTIVE_STAFF}</div>
                    <div class="l">Nhân viên đang trong ca làm</div>
                </div>
                <div class="kpi-mini" style="flex: 2; background: white; padding: 10px;">
                    <canvas id="revenueChart" style="max-height: 120px; width: 100%;"></canvas>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const ctx = document.getElementById('revenueChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: [
                            <c:forEach var="label" items="${CHART_DATA.chartLabels}" varStatus="loop">
                                '${label}'${!loop.last ? ',' : ''}
                            </c:forEach>
                        ],
                        datasets: [{
                            label: 'Doanh thu 7 ngày gần nhất',
                            data: [
                                <c:forEach var="val" items="${CHART_DATA.chartValues}" varStatus="loop">
                                    ${val}${!loop.last ? ',' : ''}
                                </c:forEach>
                            ],
                            borderColor: '#007bff',
                            backgroundColor: 'rgba(0, 123, 255, 0.1)',
                            fill: true,
                            tension: 0.3
                        }]
                    },
                    options: {
                        plugins: { legend: { display: false } },
                        scales: { y: { beginAtZero: true } }
                    }
                });
            });
        </script>
        <!-- ----------------------- -->

        <c:if test="${not empty requestScope.ERROR_MESSAGE}">
            <div style="background:#f8d7da;color:#721c24;padding:10px 20px;text-align:center;font-weight:bold;">
                ❌ ${requestScope.ERROR_MESSAGE}
            </div>
        </c:if>
        <c:if test="${not empty requestScope.SUCCESS_MESSAGE}">
            <div style="background:#d4edda;color:#155724;padding:10px 20px;text-align:center;font-weight:bold;">
                ✅ ${requestScope.SUCCESS_MESSAGE}
            </div>
        </c:if>

        <!-- ═══════════════════════════════════════════════════════
             PHẦN 1: QUẢN LÝ NHÂN VIÊN
        ═══════════════════════════════════════════════════════ -->
        <div class="admin-container">
            <div class="admin-header">
                <h2>QUẢN LÝ NHÂN VIÊN</h2>
                <button class="btn-cyan" onclick="showAddModal()">+ Thêm Nhân Viên Mới</button>
            </div>

            <%-- KPI mini cards --%>
            <div class="kpi-row">
                <div class="kpi-mini">
                    <div class="v" id="kpiTotal">${fn:length(requestScope.USER_LIST)}</div>
                    <div class="l">Tổng nhân viên</div>
                </div>
                <div class="kpi-mini green">
                    <div class="v" id="kpiActive">
                        <c:set var="activeCount" value="0"/>
                        <c:forEach var="u" items="${requestScope.USER_LIST}">
                            <c:if test="${u.status}">
                                <c:set var="activeCount" value="${activeCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${activeCount}
                    </div>
                    <div class="l">Đang hoạt động</div>
                </div>
                <div class="kpi-mini red">
                    <div class="v">${fn:length(requestScope.USER_LIST) - activeCount}</div>
                    <div class="l">Tạm khóa</div>
                </div>
            </div>

            <%-- SEARCH BAR --%>
            <div class="search-bar">
                <input type="text" id="staffSearch"
                       placeholder="🔍 Tìm theo tên hoặc SĐT..."
                       oninput="filterStaff(this.value)">
                <button class="btn-search" onclick="filterStaff(document.getElementById('staffSearch').value)">Tìm kiếm</button>
                <button class="btn-clear" onclick="clearSearch()">✕ Xóa</button>
                <span class="result-count" id="resultCount"></span>
            </div>

            <div class="table-responsive">
                <table id="staffTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Mã NV</th>
                            <th>Họ Tên</th>
                            <th>SĐT</th>
                            <th>Trạng Thái Ca</th>
                            <th>Quyền</th>
                            <th>Tài Khoản</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody id="staffBody">
                        <c:choose>
                            <c:when test="${not empty requestScope.USER_LIST}">
                                <c:forEach var="user" items="${requestScope.USER_LIST}" varStatus="st">
                                    <%-- Tìm trạng thái ca của user này từ list performance --%>
                                    <c:set var="isInShift" value="false"/>
                                    <c:forEach var="perf" items="${requestScope.STAFF_PERFORMANCE}">
                                        <c:if test="${perf.staffID eq user.userID and perf.pendingOrders == 1}">
                                            <c:set var="isInShift" value="true"/>
                                        </c:if>
                                    </c:forEach>

                                    <tr class="staff-row"
                                        data-name="${fn:toLowerCase(user.fullName)}"
                                        data-phone="${user.phone != null ? user.phone : ''}">
                                        <td>${st.count}</td>
                                        <td><strong>${user.userID}</strong></td>
                                        <td class="col-name">${user.fullName}</td>
                                        <td class="col-phone">${not empty user.phone ? user.phone : '-'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${isInShift}">
                                                    <span class="badge bg-success" style="font-size: 0.75rem;">🟢 Đang làm việc</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-light text-muted" style="font-size: 0.75rem; border: 1px solid #ddd;">⚪ Đang nghỉ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge-${'AD' eq user.roleID ? 'admin' : 'user'}">
                                                ${'AD' eq user.roleID ? 'Admin' : 'Nhân Viên'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="${user.status ? 'status-active' : 'status-inactive'}">
                                                ${user.status ? '✅ Mở' : '⛔ Khóa'}
                                            </span>
                                        </td>
                                        <td>
                                            <%-- Bật/Tắt --%>
                                            <form action="AdminController" method="POST" style="display:inline;">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                <input type="hidden" name="userID" value="${user.userID}">
                                                <input type="submit" name="ToggleUser"
                                                       value="${user.status ? 'Khóa' : 'Mở khóa'}"
                                                       class="btn-action ${user.status ? 'btn-orange' : 'btn-green'}">
                                            </form>
                                            <%-- Đổi mật khẩu --%>
                                            <button class="btn-action btn-blue"
                                                    onclick="showChangePassModal('${user.userID}', '${user.fullName}')">
                                                Đổi MK
                                            </button>
                                            <%-- Xóa (không xóa admin) --%>
                                            <c:if test="${user.userID ne 'admin'}">
                                                <form action="AdminController" method="POST" style="display:inline;"
                                                      onsubmit="return confirm('Xác nhận xóa nhân viên này?');">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                    <input type="hidden" name="userID" value="${user.userID}">
                                                    <input type="submit" name="DeleteUser" value="Xóa" class="btn-action btn-red">
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" style="text-align:center;padding:20px;color:#888;">
                                        Chưa có nhân viên nào.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <div id="noResult">
                    <div style="font-size:2rem;">🔍</div>
                    <p>Không tìm thấy nhân viên phù hợp.</p>
                </div>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════════════════
             PHẦN 2: QUẢN LÝ BẢNG TIN HỆ THỐNG
        ═══════════════════════════════════════════════════════ -->
        <div class="admin-container" style="margin-top:30px;">
            <div class="admin-header">
                <h2>📢 BẢNG TIN HỆ THỐNG</h2>
                <button class="btn-cyan" onclick="showAnnModal()">+ Thêm Bảng Tin Mới</button>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Tiêu Đề</th>
                            <th>Nội Dung</th>
                            <th>Người Đăng</th>
                            <th>Ngày Đăng</th>
                            <th>Trạng Thái</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.ANN_LIST}">
                                <c:forEach var="ann" items="${requestScope.ANN_LIST}" varStatus="st">
                                    <%-- ann[0]=id, [1]=title, [2]=content, [3]=fullName, [4]=createdDate, [5]=isActive --%>
                                    <tr>
                                        <td>${st.count}</td>
                                        <td><strong>${ann[1]}</strong></td>
                                        <td style="max-width:300px;word-wrap:break-word;text-align:left;">${ann[2]}</td>
                                        <td>${ann[3]}</td>
                                        <td>${ann[4]}</td>
                                        <td>
                                            <span class="${'1' eq ann[5] ? 'status-active' : 'status-inactive'}">
                                                ${'1' eq ann[5] ? '✅ Hiển thị' : '⛔ Ẩn'}
                                            </span>
                                        </td>
                                        <td>
                                            <form action="AdminController" method="POST" style="display:inline;"
                                                  onsubmit="return confirm('Xác nhận xóa bảng tin này?');">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                <input type="hidden" name="annID" value="${ann[0]}">
                                                <input type="submit" name="DeleteAnnouncement"
                                                       value="Xóa" class="btn-action btn-red">
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" style="text-align:center;padding:20px;color:#888;">
                                        Chưa có bảng tin nào.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════════════════
             MODAL: THÊM NHÂN VIÊN
        ═══════════════════════════════════════════════════════ -->
        <div id="addModal" class="modal">
            <div class="modal-content">
                <h3>➕ THÊM NHÂN VIÊN MỚI</h3>
                <form action="MainController" method="POST" onsubmit="return validateAddForm()">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                    <div class="group">
                        <label>Mã Tài Khoản <span style="color:red">*</span></label>
                        <input type="text" name="newUserID" id="newUserID" class="inp" required placeholder="VD: NV05">
                    </div>
                    <div class="group">
                        <label>Họ Tên <span style="color:red">*</span></label>
                        <input type="text" name="newFullName" class="inp" required placeholder="Nguyễn Văn A">
                    </div>
                    <div class="group">
                        <label>Mật Khẩu <span style="color:red">*</span></label>
                        <input type="password" name="newPassword" id="newPassword" class="inp" required placeholder="Nhập mật khẩu">
                    </div>
                    <div class="group">
                        <label>Xác Nhận Mật Khẩu <span style="color:red">*</span></label>
                        <input type="password" name="newConfirmPassword" id="newConfirmPassword" class="inp" required placeholder="Nhập lại mật khẩu">
                        <small id="addPassErr" style="color:red;display:none;">Mật khẩu không khớp!</small>
                    </div>
                    <div class="group">
                        <label>Số Điện Thoại</label>
                        <input type="tel" name="newPhone" class="inp" placeholder="0901234567">
                    </div>
                    <div class="group">
                        <label>Email</label>
                        <input type="email" name="newEmail" class="inp" placeholder="abc@company.vn">
                    </div>
                    <div class="modal-footer">
                        <input type="submit" name="SaveUser" value="💾 Lưu Nhân Viên" class="btn-cyan">
                        <button type="button" onclick="hideAddModal()" class="btn-back">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════════════════
             MODAL: ĐỔI MẬT KHẨU
        ═══════════════════════════════════════════════════════ -->
        <div id="changePassModal" class="modal">
            <div class="modal-content">
                <h3>🔑 ĐỔI MẬT KHẨU</h3>
                <p id="cpUserLabel" style="color:#555;margin-bottom:15px;"></p>
                <form action="AdminController" method="POST" onsubmit="return validateChangePassForm()">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                    <input type="hidden" name="cpUserID" id="cpUserID">
                    <div class="group">
                        <label>Mật Khẩu Mới <span style="color:red">*</span></label>
                        <input type="password" name="cpNewPassword" id="cpNewPassword" class="inp" required placeholder="Nhập mật khẩu mới">
                    </div>
                    <div class="group">
                        <label>Xác Nhận Mật Khẩu Mới <span style="color:red">*</span></label>
                        <input type="password" name="cpConfirmPassword" id="cpConfirmPassword" class="inp" required placeholder="Nhập lại mật khẩu mới">
                        <small id="cpPassErr" style="color:red;display:none;">Mật khẩu không khớp!</small>
                    </div>
                    <div class="modal-footer">
                        <input type="submit" name="ChangePassword" value="✅ Xác Nhận Đổi" class="btn-cyan">
                        <button type="button" onclick="hideChangePassModal()" class="btn-back">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════════════════
             MODAL: THÊM BẢNG TIN
        ═══════════════════════════════════════════════════════ -->
        <div id="annModal" class="modal">
            <div class="modal-content">
                <h3>📢 THÊM BẢNG TIN MỚI</h3>
                <form action="AdminController" method="POST">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                    <div class="group">
                        <label>Tiêu Đề <span style="color:red">*</span></label>
                        <input type="text" name="annTitle" class="inp" required placeholder="VD: Thông báo nghỉ lễ...">
                    </div>
                    <div class="group">
                        <label>Nội Dung <span style="color:red">*</span></label>
                        <textarea name="annContent" class="inp" required rows="5"
                                  style="resize:vertical;padding:10px;"
                                  placeholder="Nhập nội dung thông báo..."></textarea>
                    </div>
                    <div class="modal-footer">
                        <input type="submit" name="SaveAnnouncement" value="📤 Đăng Bảng Tin" class="btn-cyan">
                        <button type="button" onclick="hideAnnModal()" class="btn-back">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // ── Search nhân viên theo tên hoặc SĐT ─────────────────────
            function filterStaff(keyword) {
                const kw = keyword.trim().toLowerCase();
                const rows = document.querySelectorAll('#staffBody .staff-row');
                let visibleCount = 0;

                rows.forEach(row => {
                    const name = row.getAttribute('data-name') || '';
                    const phone = row.getAttribute('data-phone') || '';
                    const match = !kw || name.includes(kw) || phone.includes(kw);
                    row.style.display = match ? '' : 'none';
                    if (match) {
                        visibleCount++;
                        // Highlight tên & số điện thoại
                        if (kw) {
                            highlightCell(row.querySelector('.col-name'), keyword);
                            highlightCell(row.querySelector('.col-phone'), keyword);
                        } else {
                            clearHighlight(row.querySelector('.col-name'));
                            clearHighlight(row.querySelector('.col-phone'));
                        }
                    }
                });

                const total = rows.length;
                const countEl = document.getElementById('resultCount');
                const noResultEl = document.getElementById('noResult');

                if (kw) {
                    countEl.textContent = `Tìm thấy ${visibleCount} / ${total} nhân viên`;
                    noResultEl.style.display = visibleCount === 0 ? 'block' : 'none';
                } else {
                    countEl.textContent = '';
                    noResultEl.style.display = 'none';
                }
            }

            function highlightCell(cell, keyword) {
                if (!cell) return;
                const text = cell.textContent;
                if (!keyword) {
                    cell.innerHTML = text;
                    return;
                }
                
                const regex = new RegExp('(' + escapeRegex(keyword) + ')', 'gi');
                const parts = text.split(regex);
                
                cell.innerHTML = ''; // Xóa nội dung cũ
                parts.forEach(part => {
                    if (part.toLowerCase() === keyword.toLowerCase()) {
                        const span = document.createElement('span');
                        span.className = 'highlight';
                        span.textContent = part;
                        cell.appendChild(span);
                    } else {
                        cell.appendChild(document.createTextNode(part));
                    }
                });
            }

            function clearHighlight(cell) {
                if (!cell)
                    return;
                cell.innerHTML = cell.textContent;
            }

            function escapeRegex(string) {
                // Liệt kê rõ các ký tự cần escape để tránh gây nhầm lẫn cho parser của JSP
                return string.replace(/[.*+?^$}{()|[\]\\]/g, function (match) {
                    return '\\' + match;
                });
            }

            function clearSearch() {
                document.getElementById('staffSearch').value = '';
                filterStaff('');
            }

            // ── Modal nhân viên ────────────────────────────────────────
            function showAddModal() {
                document.getElementById('addModal').style.display = 'flex';
            }
            function hideAddModal() {
                document.getElementById('addModal').style.display = 'none';
            }

            function validateAddForm() {
                const p1 = document.getElementById('newPassword').value;
                const p2 = document.getElementById('newConfirmPassword').value;
                const err = document.getElementById('addPassErr');
                if (p1 !== p2) {
                    err.style.display = 'block';
                    return false;
                }
                err.style.display = 'none';
                return true;
            }

            // ── Modal đổi mật khẩu ─────────────────────────────────────
            function showChangePassModal(userID, fullName) {
                document.getElementById('cpUserID').value = userID;
                document.getElementById('cpUserLabel').textContent = 'Nhân viên: ' + fullName + ' (' + userID + ')';
                document.getElementById('cpNewPassword').value = '';
                document.getElementById('cpConfirmPassword').value = '';
                document.getElementById('cpPassErr').style.display = 'none';
                document.getElementById('changePassModal').style.display = 'flex';
            }
            function hideChangePassModal() {
                document.getElementById('changePassModal').style.display = 'none';
            }

            function validateChangePassForm() {
                const p1 = document.getElementById('cpNewPassword').value;
                const p2 = document.getElementById('cpConfirmPassword').value;
                const err = document.getElementById('cpPassErr');
                if (p1 !== p2) {
                    err.style.display = 'block';
                    return false;
                }
                err.style.display = 'none';
                return true;
            }

            // ── Modal bảng tin ─────────────────────────────────────────
            function showAnnModal() {
                document.getElementById('annModal').style.display = 'flex';
            }
            function hideAnnModal() {
                document.getElementById('annModal').style.display = 'none';
            }

            // Đóng modal khi click ra ngoài
            window.onclick = function (e) {
                if (e.target.className === 'modal') {
                    hideAddModal();
                    hideAnnModal();
                    hideChangePassModal();
                }
            };

            // Enter để tìm kiếm
            document.getElementById('staffSearch').addEventListener('keydown', function (e) {
                if (e.key === 'Enter')
                    filterStaff(this.value);
            });
        </script>
        <%@include file="includes/footer.jsp" %>
</body>
</html>
