<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.UserDTO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Hệ thống Quản lý Vận tải</title>
    <link rel="stylesheet" href="css/home.css">
    
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        String msg  = (String) request.getAttribute("ERROR_MESSAGE");
        String role = (String) session.getAttribute("ROLE");
        boolean isAdmin = "AD".equals(role);
        if (msg != null) {
    %>
    <div style="color:white;background-color:red;padding:10px;text-align:center;font-weight:bold;">
        <%= msg %>
    </div>
    <% } %>

    <div class="main-container">
        <div class="page-title">
            <h1>TRANG CHỦ</h1>
            <div class="underline"></div>
        </div>

        <div class="dashboard-grid">
            <%-- CARD 1: HÀNG HÓA --%>
            <form action="MainController" method="POST" class="card-item bg-green">
                <input type="submit" name="ViewGoods" value="" class="card-overlay">
                <div class="card-content">
                    <div class="card-top">
                        <span class="number">01</span>
                        <span class="icon">📦</span>
                    </div>
                    <h3>HÀNG HÓA</h3>
                    <p>Quản lý nhận hàng & vận chuyển</p>
                </div>
                <div class="card-link">Truy cập hệ thống ➜</div>
            </form>

            <%-- CARD 2: QUẢN TRỊ --%>
            <form action="MainController" method="POST" class="card-item bg-blue">
                <input type="submit" name="AdminPanel" value="" class="card-overlay">
                <div class="card-content">
                    <div class="card-top">
                        <span class="number">02</span>
                        <span class="icon">⚙️</span>
                    </div>
                    <h3>QUẢN TRỊ</h3>
                    <p>Quản lý nhân sự & phân quyền</p>
                </div>
                <div class="card-link">Truy cập hệ thống ➜</div>
            </form>

            <%-- CARD 3: BÁO CÁO --%>
            <form action="MainController" method="POST" class="card-item bg-yellow">
                <input type="submit" name="ViewReports" value="" class="card-overlay">
                <div class="card-content">
                    <div class="card-top">
                        <span class="number">03</span>
                        <span class="icon">📊</span>
                    </div>
                    <h3>BÁO CÁO</h3>
                    <p>Thống kê sản lượng & doanh thu</p>
                </div>
                <div class="card-link">Truy cập hệ thống ➜</div>
            </form>
        </div>

        <!-- BẢN TIN HỆ THỐNG -->
        <div class="news-section">
            <div class="news-header">📢 BẢN TIN HỆ THỐNG</div>
            <div class="news-container">
                <%
                    // news[0]=id, [1]=title, [2]=content, [3]=fullName, [4]=createdDate
                    List<String[]> newsList = (List<String[]>) request.getAttribute("NEWS_LIST");
                    if (newsList != null && !newsList.isEmpty()) {
                        for (String[] news : newsList) {
                %>
                <div class="news-entry">
                    <% if (isAdmin) { %>
                    <form action="AdminController" method="POST" style="display:inline;"
                          onsubmit="return confirm('Xác nhận xóa bảng tin này?');">
                        <input type="hidden" name="annID" value="<%= news[0] %>">
                        <input type="hidden" name="referer" value="home">
                        <input type="submit" name="DeleteAnnouncement"
                               value="✕ Xóa" class="btn-delete-news">
                    </form>
                    <% } %>
                    <h4><%= news[1] %></h4>
                    <p><%= news[2] %></p>
                    <small>Người đăng: <%= news[3] %> — <%= news[4] %></small>
                </div>
                <%
                        }
                    } else {
                %>
                <p class="no-data">Hiện chưa có thông báo mới từ ban quản lý.</p>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
