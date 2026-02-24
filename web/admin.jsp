<%-- 
    Document   : admin
    Created on : Feb 24, 2026, 5:51:10 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Nhân Sự - Admin</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <%
        // Kiểm tra phân quyền
        String role = (String) session.getAttribute("ROLE");
        if (role == null || !role.equals("AD")) {
            request.setAttribute("ERROR_MESSAGE", "Bạn không có quyền truy cập vào khu vực này!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String fullName = (String) session.getAttribute("FULLNAME");
        if (fullName == null) fullName = "Admin";
    %>

    <div class="navbar">
        <div class="company-name">HỆ THỐNG GIAO HÀNG</div>
        <div class="user-menu">
            <span class="user-name">👤 <%= fullName %> (Admin)</span>
        </div>
    </div>

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
                        <th>Tài Khoản</th>
                        <th>Quyền</th>
                        <th>Trạng Thái</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Dữ liệu giả lập hiển thị --%>
                    <tr>
                        <td>NV001</td>
                        <td>Nguyễn Hoàng Huy</td>
                        <td>admin</td>
                        <td>Admin</td>
                        <td><span class="status-active">Đang làm việc</span></td>
                        <td>
                            <button class="btn-action btn-blue">Đổi MK</button>
                            <button class="btn-action btn-red">Xóa</button>
                        </td>
                    </tr>
                    <tr>
                        <td>NV002</td>
                        <td>Trần Văn B</td>
                        <td>staff01</td>
                        <td>Nhân Viên</td>
                        <td><span class="status-active">Đang làm việc</span></td>
                        <td>
                            <button class="btn-action btn-blue">Đổi MK</button>
                            <button class="btn-action btn-red">Xóa</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <form action="MainController" method="POST">
                <input type="submit" name="GoHome" value="⬅ Quay lại Trang chủ" class="btn-back-home">
            </form>
        </div>
    </div>

    <%-- Modal thêm nhân viên (Ẩn mặc định) --%>
    <div id="addModal" class="modal">
        <div class="modal-content">
            <h3>Thêm Nhân Viên Mới</h3>
            <form action="MainController" method="POST">
                <div class="group">
                    <label>Họ Tên</label>
                    <input type="text" name="newFullName" class="inp" required>
                </div>
                <div class="group">
                    <label>Tên Đăng Nhập</label>
                    <input type="text" name="newUserID" class="inp" required>
                </div>
                <div class="group">
                    <label>Mật Khẩu</label>
                    <input type="password" name="newPassword" class="inp" required>
                </div>
                <div class="modal-footer">
                    <input type="submit" name="SaveUser" value="Lưu Nhân Viên" class="btn-cyan">
                    <button type="button" class="btn-back" onclick="hideAddModal()">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() { document.getElementById('addModal').style.display = 'flex'; }
        function hideAddModal() { document.getElementById('addModal').style.display = 'none'; }
    </script>
</body>
</html>
