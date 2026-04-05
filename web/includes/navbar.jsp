<%-- 
    navbar.jsp - Thanh điều hướng hiện đại (Sửa: Click để mở Dropdown)
--%>
<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="includes/navbar.css">

<%
    UserDTO navUser = (UserDTO) session.getAttribute("LOGIN_USER");
    String navRole = (String) session.getAttribute("ROLE");
    
    String fullName = (navUser != null) ? navUser.getFullName() : "Người dùng";
    String email = (navUser != null && navUser.getEmail() != null && !navUser.getEmail().isEmpty()) 
                   ? navUser.getEmail() : "Chưa cập nhật email";
    String initial = (!fullName.isEmpty()) ? fullName.substring(0, 1).toUpperCase() : "U";
%>

<nav class="navbar">
    <!-- Logo & Brand -->
    <a href="MainController?GoHome=true" class="nav-brand">
        <span class="brand-logo">🚚</span>
        <span class="company-name">Delivery System</span>
    </a>

    <!-- Menu Links -->
    <ul class="nav-links">
        <li><a href="MainController?GoHome=true">Trang chủ</a></li>
        <li><a href="MainController?ViewGoods=true">Hàng hóa</a></li>
        <li><a href="MainController?ViewReports=true">Báo cáo</a></li>
        <% if ("AD".equals(navRole)) { %>
            <li><a href="MainController?AdminPanel=true" style="color: #1a73e8; font-weight: 800;">Quản trị</a></li>
        <% } %>
        <li><a href="about.jsp">Hướng dẫn</a></li>
    </ul>

    <!-- User Profile Dropdown -->
    <div class="nav-user-zone" id="userZone">
        <div class="user-trigger" onclick="toggleUserDropdown(event)">
            <div class="user-avatar-small"><%= initial %></div>
            <span class="user-trigger-name"><%= fullName %></span>
            <span class="arrow-icon">▼</span>
        </div>

        <!-- Cửa sổ sổ xuống (Dropdown) -->
        <div class="dropdown-menu" id="userDropdown">
            <div class="dropdown-header">
                <span class="d-name text-bold"><%= fullName %></span>
                <span class="d-email"><%= email %></span>
                <span class="d-role"><%= navRole != null ? navRole : "ST" %></span>
            </div>
            <div class="dropdown-body">
                <form action="MainController" method="POST" style="margin: 0;">
                    <button type="submit" name="Logout" class="dropdown-item btn-logout-link">
                        <span>🚪</span> Đăng xuất hệ thống
                    </button>
                </form>
            </div>
        </div>
    </div>
</nav>

<script>
    function toggleUserDropdown(event) {
        // Ngăn chặn sự kiện click lan ra ngoài
        event.stopPropagation();
        const dropdown = document.getElementById('userDropdown');
        dropdown.classList.toggle('show');
    }

    // Đóng dropdown khi click ra ngoài vùng menu
    window.onclick = function(event) {
        const dropdown = document.getElementById('userDropdown');
        const trigger = document.getElementById('userZone');
        if (dropdown && !trigger.contains(event.target)) {
            dropdown.classList.remove('show');
        }
    }
</script>
