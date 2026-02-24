<%-- 
    Document   : list_order
    Created on : Feb 15, 2026, 7:59:39 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh Sách Nhận Hàng</title>
        <link rel="stylesheet" href="css/home.css">
        <link rel="stylesheet" href="css/list_order.css">
    </head>
    <body>
        <%
            String fullName = (String) session.getAttribute("FULLNAME");
            if (fullName == null)
                fullName = "Nhân Viên";
        %>

        <div class="navbar">
            <div class="company-name">CÔNG TY</div>
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
        </script>

        <div class="list-container">
            <%-- Toolbar Lọc và Nhập hàng dùng form gửi name trực tiếp --%>
            <form action="MainController" method="POST" class="filter-bar">
                <select name="stationFilter">
                    <option value="">-- Tất Cả Trạm Nhận --</option>
                </select>
                <input type="date" name="dateFilter" value="<%= request.getParameter("dateFilter") != null ? request.getParameter("dateFilter") : "" %>">
                <select name="statusFilter">
                    <option value="0">Chưa Chuyển</option>
                    <option value="1">Đã Chuyển</option>
                </select>
                
                <%-- SỬA: Dùng name để định danh hành động --%>
                <input type="submit" name="FilterOrder" value="Lọc" class="btn-filter">
                <input type="submit" name="CreateOrder" value="Nhập Hàng Gửi" class="btn-cyan">
            </form>

            <h3 style="margin-bottom: 15px;">
                DANH SÁCH NHẬN HÀNG (<%= request.getAttribute("TOTAL_COUNT") != null ? request.getAttribute("TOTAL_COUNT") : "0"%>)
            </h3>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th><input type="checkbox"></th>
                            <th>Mã</th>
                            <th>Tên Hàng - Số Tiền</th>
                            <th>Người Gửi</th>
                            <th>Người Nhận</th>
                            <th>Trạm Nhận</th>
                            <th>Ngày Nhận</th>
                            <th>Handling</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<String[]> orderList = (List<String[]>) request.getAttribute("ORDER_LIST");
                            if (orderList != null && !orderList.isEmpty()) {
                                for (String[] o : orderList) {
                        %>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><a href="#" class="order-id"><%= o[0]%></a></td>
                            <td>
                                <span class="item-name"><%= o[1]%></span><br>
                                <small><%= o[2]%></small>
                            </td>
                            <td><%= o[3]%><br><small><%= o[4]%></small></td>
                            <td><%= o[6]%><br><small><%= o[7]%></small></td>
                            <td class="station-link"><%= o[8]%></td>
                            <td class="order-id"><%= o[13]%></td>
                            <td>
                                <%-- SỬA: Form cho từng dòng dùng name định danh --%>
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="orderID" value="<%= o[0] %>">
                                    <input type="submit" name="ShipOrder" value="Chuyển Hàng" class="btn-action btn-ship">
                                    <input type="submit" name="EditOrder" value="Sửa" class="btn-action btn-edit">
                                </form>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 30px; color: #888;">
                                Không có dữ liệu hiển thị.
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
        </div>

        
    </body>
</html>