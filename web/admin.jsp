<%@page import="dto.UserDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Admin</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        List<UserDTO> list     = (List<UserDTO>) request.getAttribute("USER_LIST");
        List<String[]> annList = (List<String[]>) request.getAttribute("ANN_LIST");
        String errMsg = (String) request.getAttribute("ERROR_MESSAGE");
        String sucMsg = (String) request.getAttribute("SUCCESS_MESSAGE");
    %>

    <% if (errMsg != null) { %>
    <div style="background:#f8d7da;color:#721c24;padding:10px 20px;text-align:center;font-weight:bold;">
        ❌ <%= errMsg %>
    </div>
    <% } %>
    <% if (sucMsg != null) { %>
    <div style="background:#d4edda;color:#155724;padding:10px 20px;text-align:center;font-weight:bold;">
        ✅ <%= sucMsg %>
    </div>
    <% } %>

    <!-- ═══════════════════════════════════════════════════════
         PHẦN 1: QUẢN LÝ NHÂN VIÊN
    ═══════════════════════════════════════════════════════ -->
    <div class="admin-container">
        <div class="admin-header">
            <h2>QUẢN LÝ NHÂN VIÊN</h2>
            <button class="btn-cyan" onclick="showAddModal()">+ Thêm Nhân Viên Mới</button>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Mã NV</th>
                        <th>Họ Tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Quyền</th>
                        <th>Trạng Thái</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (list != null) {
                            int i = 1;
                            for (UserDTO user : list) {
                    %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong><%= user.getUserID() %></strong></td>
                        <td><%= user.getFullName() %></td>
                        <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                        <td><%= user.getEmail() != null ? user.getEmail() : "-" %></td>
                        <td>
                            <span class="badge-<%= "AD".equals(user.getRoleID()) ? "admin" : "user" %>">
                                <%= "AD".equals(user.getRoleID()) ? "Admin" : "Nhân Viên" %>
                            </span>
                        </td>
                        <td>
                            <span class="<%= user.isStatus() ? "status-active" : "status-inactive" %>">
                                <%= user.isStatus() ? "✅ Hoạt động" : "⛔ Tạm khóa" %>
                            </span>
                        </td>
                        <td>
                            <%-- Bật/Tắt --%>
                            <form action="AdminController" method="POST" style="display:inline;">
                                <input type="hidden" name="userID" value="<%= user.getUserID() %>">
                                <input type="submit" name="ToggleUser"
                                       value="<%= user.isStatus() ? "Khóa" : "Mở khóa" %>"
                                       class="btn-action <%= user.isStatus() ? "btn-orange" : "btn-green" %>">
                            </form>
                            <%-- Đổi mật khẩu --%>
                            <button class="btn-action btn-blue"
                                    onclick="showChangePassModal('<%= user.getUserID() %>', '<%= user.getFullName() %>')">
                                Đổi MK
                            </button>
                            <%-- Xóa (không xóa admin) --%>
                            <% if (!"admin".equals(user.getUserID())) { %>
                            <form action="AdminController" method="POST" style="display:inline;"
                                  onsubmit="return confirm('Xác nhận vô hiệu hóa nhân viên này?');">
                                <input type="hidden" name="userID" value="<%= user.getUserID() %>">
                                <input type="submit" name="DeleteUser" value="Xóa" class="btn-action btn-red">
                            </form>
                            <% } %>
                        </td>
                    </tr>
                    <% }} %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════
         PHẦN 2: QUẢN LÝ BẢNG TIN HỆ THỐNG
    ═══════════════════════════════════════════════════════ -->
    <div class="admin-container" style="margin-top: 30px;">
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
                    <%
                        if (annList != null && !annList.isEmpty()) {
                            int i = 1;
                            for (String[] ann : annList) {
                                // ann[0]=id, [1]=title, [2]=content, [3]=fullName, [4]=createdDate, [5]=isActive
                    %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong><%= ann[1] %></strong></td>
                        <td style="max-width:300px;word-wrap:break-word;text-align:left;">
                            <%= ann[2] %>
                        </td>
                        <td><%= ann[3] %></td>
                        <td><%= ann[4] %></td>
                        <td>
                            <span class="<%= "1".equals(ann[5]) ? "status-active" : "status-inactive" %>">
                                <%= "1".equals(ann[5]) ? "✅ Hiển thị" : "⛔ Ẩn" %>
                            </span>
                        </td>
                        <td>
                            <form action="AdminController" method="POST" style="display:inline;"
                                  onsubmit="return confirm('Xác nhận xóa bảng tin này?');">
                                <input type="hidden" name="annID" value="<%= ann[0] %>">
                                <input type="submit" name="DeleteAnnouncement"
                                       value="Xóa" class="btn-action btn-red">
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" style="text-align:center;padding:20px;color:#888;">
                            Chưa có bảng tin nào.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════
         MODAL: THÊM NHÂN VIÊN (có xác nhận mật khẩu)
    ═══════════════════════════════════════════════════════ -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <h3>➕ THÊM NHÂN VIÊN MỚI</h3>
            <form action="MainController" method="POST" onsubmit="return validateAddForm()">
                <div class="group">
                    <label>Mã Tài Khoản <span style="color:red">*</span></label>
                    <input type="text" name="newUserID" id="newUserID" class="inp" required
                           placeholder="VD: NV05">
                </div>
                <div class="group">
                    <label>Họ Tên <span style="color:red">*</span></label>
                    <input type="text" name="newFullName" class="inp" required
                           placeholder="Nguyễn Văn A">
                </div>
                <div class="group">
                    <label>Mật Khẩu <span style="color:red">*</span></label>
                    <input type="password" name="newPassword" id="newPassword" class="inp" required
                           placeholder="Nhập mật khẩu">
                </div>
                <div class="group">
                    <label>Xác Nhận Mật Khẩu <span style="color:red">*</span></label>
                    <input type="password" name="newConfirmPassword" id="newConfirmPassword" class="inp" required
                           placeholder="Nhập lại mật khẩu">
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
                <input type="hidden" name="cpUserID" id="cpUserID">
                <div class="group">
                    <label>Mật Khẩu Mới <span style="color:red">*</span></label>
                    <input type="password" name="cpNewPassword" id="cpNewPassword" class="inp" required
                           placeholder="Nhập mật khẩu mới">
                </div>
                <div class="group">
                    <label>Xác Nhận Mật Khẩu Mới <span style="color:red">*</span></label>
                    <input type="password" name="cpConfirmPassword" id="cpConfirmPassword" class="inp" required
                           placeholder="Nhập lại mật khẩu mới">
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
                <div class="group">
                    <label>Tiêu Đề <span style="color:red">*</span></label>
                    <input type="text" name="annTitle" class="inp" required
                           placeholder="VD: Thông báo nghỉ lễ...">
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
        // ── Modal nhân viên ──────────────────────────────────────────────
        function showAddModal() { document.getElementById('addModal').style.display = 'flex'; }
        function hideAddModal() { document.getElementById('addModal').style.display = 'none'; }

        function validateAddForm() {
            var p1 = document.getElementById('newPassword').value;
            var p2 = document.getElementById('newConfirmPassword').value;
            var err = document.getElementById('addPassErr');
            if (p1 !== p2) {
                err.style.display = 'block';
                return false;
            }
            err.style.display = 'none';
            return true;
        }

        // ── Modal đổi mật khẩu ───────────────────────────────────────────
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
            var p1 = document.getElementById('cpNewPassword').value;
            var p2 = document.getElementById('cpConfirmPassword').value;
            var err = document.getElementById('cpPassErr');
            if (p1 !== p2) {
                err.style.display = 'block';
                return false;
            }
            err.style.display = 'none';
            return true;
        }

        // ── Modal bảng tin ───────────────────────────────────────────────
        function showAnnModal() { document.getElementById('annModal').style.display = 'flex'; }
        function hideAnnModal() { document.getElementById('annModal').style.display = 'none'; }

        // Đóng modal khi click ra ngoài
        window.onclick = function(e) {
            if (e.target.className === 'modal') {
                hideAddModal();
                hideAnnModal();
                hideChangePassModal();
            }
        }
    </script>
</body>
</html>
