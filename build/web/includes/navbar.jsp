<%-- 
    Document   : navbar
    Created on : Feb 24, 2026, 6:17:37 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>navbar</title>
        <link rel="stylesheet" href="includes/navbar.css">
    </head>
    <body>
        <%
            String fullName = (String) session.getAttribute("FULLNAME");
            if (fullName == null)
                fullName = "Nhân Viên";
        %>

        <div class="navbar">
            <div class="company-name">
                <form action="MainController" method="POST" style="display: inline;">
                    <input type="submit" name="GoHome" value="CÔNG TY" 
                           style="background: none; border: none; color: white; font: inherit; cursor: pointer; padding: 0;">
                </form>
            </div>

            <div class="user-menu" onclick="toggleDropdown()">
                <span class="user-name">👤 <%= fullName%> ▼</span>
                <div id="userDropdown" class="dropdown-content">
                    <div class="user-header">
                        <p><strong><%= fullName%></strong></p>
                        <small><%= session.getAttribute("EMAIL") != null ? session.getAttribute("EMAIL") : ""%></small>
                    </div>
                    <div class="user-footer">
                        <form action="MainController" method="POST">
                            <input type="submit" name="Logout" value="Đăng Xuất" class="btn-logout">
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function toggleDropdown() {
                var d = document.getElementById("userDropdown");
                d.style.display = (d.style.display === "block") ? "none" : "block";
            }

            // Thêm: Đóng dropdown khi nhấn ra ngoài để giao diện mượt hơn
            window.onclick = function (event) {
                if (!event.target.matches('.user-name')) {
                    var dropdowns = document.getElementsByClassName("dropdown-content");
                    for (var i = 0; i < dropdowns.length; i++) {
                        var openDropdown = dropdowns[i];
                        if (openDropdown.style.display === "block") {
                            openDropdown.style.display = "none";
                        }
                    }
                }
            }

            // Hàm tự động giãn rộng ô input theo nội dung
            function autoExpandInput() {
                const searchInputs = document.querySelectorAll('.inp-search');

                searchInputs.forEach(input => {
                    input.addEventListener('input', function () {
                        // Tính toán độ dài: mỗi ký tự tầm 8-10px, tối thiểu 150px
                        let newWidth = Math.max(150, (this.value.length * 9) + 24);
                        this.style.width = newWidth + 'px';
                    });
                });
            }

            // Chạy hàm khi trang web tải xong
            document.addEventListener('DOMContentLoaded', autoExpandInput);
            
        </script>

    </body>
</html>
