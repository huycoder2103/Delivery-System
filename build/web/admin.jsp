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
    
    <% List<UserDTO> list = (List<UserDTO>) request.getAttribute("USER_LIST"); %>

    <div class="admin-container">
        <div class="admin-header">
            <h2>QUẢN LÝ NHÂN VIÊN</h2>
            <button class="btn-cyan" onclick="showAddModal()">+ Thêm Nhân Viên Mới</button>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>Mã NV</th>
                        <th>Họ Tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Quyền</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (list != null) { for (UserDTO user : list) { %>
                    <tr>
                        <td><%= user.getUserID() %></td>
                        <td><%= user.getFullName() %></td>
                        <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                        <td><%= user.getEmail() != null ? user.getEmail() : "-" %></td>
                        <td><%= "AD".equals(user.getRoleID()) ? "Admin" : "Nhân Viên" %></td>
                        <td>
                            <button class="btn-action btn-blue">Sửa</button>
                            <button class="btn-action btn-red">Xóa</button>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <div id="addModal" class="modal">
        <div class="modal-content">
            <h3>THÊM NHÂN VIÊN MỚI</h3>
            <form action="MainController" method="POST">
                <div class="group">
                    <label>Họ Tên</label>
                    <input type="text" name="newFullName" class="inp" required>
                </div>
                <div class="group">
                    <label>Tài Khoản</label>
                    <input type="text" name="newUserID" class="inp" required>
                </div>
                <div class="group">
                    <label>Mật Khẩu</label>
                    <input type="password" name="newPassword" class="inp" required>
                </div>
                <div class="group">
                    <label>Số Điện Thoại</label>
                    <input type="tel" name="newPhone" class="inp">
                </div>
                <div class="group">
                    <label>Gmail</label>
                    <input type="email" name="newEmail" class="inp">
                </div>
                <div class="modal-footer">
                    <input type="submit" name="SaveUser" value="Lưu Nhân Viên" class="btn-cyan">
                    <button type="button" onclick="hideAddModal()" class="btn-back">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() { document.getElementById('addModal').style.display = 'flex'; }
        function hideAddModal() { document.getElementById('addModal').style.display = 'none'; }
        window.onclick = function(e) { if(e.target.className == 'modal') hideAddModal(); }
    </script>
</body>
</html>