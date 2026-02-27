<%-- 
    Document   : admin
    Created on : Feb 24, 2026, 5:51:10 PM
    Author     : HuyNHSE190240
--%>

<%@page import="dto.UserDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Nhân Sự - Admin</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        List<UserDTO> list = (List<UserDTO>) request.getAttribute("USER_LIST");
        String errMsg = (String) request.getAttribute("ERROR_MESSAGE");
    %>

    <% if (errMsg != null) { %>
    <div style="background:#f8d7da;color:#721c24;padding:10px 20px;text-align:center;">
        <%= errMsg %>
    </div>
    <% } %>

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
                            <%-- Nút Bật/Tắt trạng thái --%>
                            <form action="AdminController" method="POST" style="display:inline;">
                                <input type="hidden" name="userID" value="<%= user.getUserID() %>">
                                <input type="submit" name="ToggleUser"
                                       value="<%= user.isStatus() ? "Khóa" : "Mở khóa" %>"
                                       class="btn-action <%= user.isStatus() ? "btn-orange" : "btn-green" %>">
                            </form>
                            <%-- Nút Xóa (vô hiệu hóa) --%>
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

    <%-- Modal Thêm Nhân Viên --%>
    <div id="addModal" class="modal">
        <div class="modal-content">
            <h3>➕ THÊM NHÂN VIÊN MỚI</h3>
            <form action="MainController" method="POST">
                <div class="group">
                    <label>Mã Tài Khoản <span style="color:red">*</span></label>
                    <input type="text" name="newUserID" class="inp" required placeholder="VD: NV05">
                </div>
                <div class="group">
                    <label>Họ Tên <span style="color:red">*</span></label>
                    <input type="text" name="newFullName" class="inp" required>
                </div>
                <div class="group">
                    <label>Mật Khẩu <span style="color:red">*</span></label>
                    <input type="password" name="newPassword" class="inp" required>
                </div>
                <div class="group">
                    <label>Số Điện Thoại</label>
                    <input type="tel" name="newPhone" class="inp" placeholder="SDT">
                </div>
                <div class="group">
                    <label>Email</label>
                    <input type="email" name="newEmail" class="inp">
                </div>
                <div class="modal-footer">
                    <input type="submit" name="SaveUser" value="💾 Lưu Nhân Viên" class="btn-cyan">
                    <button type="button" onclick="hideAddModal()" class="btn-back">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() { document.getElementById('addModal').style.display = 'flex'; }
        function hideAddModal() { document.getElementById('addModal').style.display = 'none'; }
        window.onclick = function(e) { if (e.target.className === 'modal') hideAddModal(); }
    </script>
</body>
</html>
