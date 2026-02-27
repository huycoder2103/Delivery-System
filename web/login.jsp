<%-- 
    Document   : login
    Created on : Feb 15, 2026, 4:17:52 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Delivery System</title>
        <link rel="stylesheet" href="css/login.css">
    </head>
    <body>
        <div class="brand">HỆ THỐNG GIAO HÀNG</div>
        <div class="login-box">
            <h2 class="title">ĐĂNG NHẬP</h2>

            <%-- Form gửi trực tiếp về MainController --%>
            <form action="MainController" method="POST">
                <div class="group">
                    <span class="label">User ID</span>
                     <input type="text" name="userID" class="inp" placeholder="Nhập tài khoản" required 
                           value="<%= request.getParameter("userID") != null ? request.getParameter("userID") : ""%>">
                </div>

                <div class="group">
                    <span class="label">Password</span>
                     <input type="password" name="password" class="inp" placeholder="Nhập mật khẩu" required>
                </div>


                <input type="submit" name="Login" value="Đăng nhập" class="btn-main">
            </form>

            <%-- Thông báo lỗi từ Controller --%>
            <%
                String msg = (String) request.getAttribute("ERROR_MESSAGE");
                if (msg != null && !msg.isEmpty()) {
            %>
            <div class="err"><%= msg%></div>
            <% }%>

            <div class="social-grp">
                <button class="btn-sn gg">Google</button>
                <button class="btn-sn fb">Facebook</button>
            </div>

            <div class="footer">
                <a href="javascript:void(0)" onclick="showMsg()" class="link-qmk">Quên mật khẩu?</a>
                <div id="notice" class="notice">
                    Liên hệ Ban Quản Lý để được cấp lại mật khẩu.
                </div>
            </div>
        </div>

        <script>
            function showMsg() {
                var x = document.getElementById("notice");
                x.style.display = (x.style.display === "block") ? "none" : "block";
            }
        </script>
    </body>
</html>