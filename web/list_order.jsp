<%@page import="dto.UserDTO"%>
<%@page import="dto.StationDTO"%>
<%@page import="dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Đơn Hàng - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
    <style>
        .action-btns-grid { display: flex; flex-direction: column; gap: 4px; }
        .btn-action-text { 
            display: flex; align-items: center; justify-content: center; gap: 5px;
            padding: 6px 10px; border-radius: 6px; border: none; cursor: pointer;
            font-size: 0.75rem; font-weight: 700; color: white; width: 100%; transition: all 0.2s;
        }
        .btn-s-ship   { background: #1a73e8; }
        .btn-s-edit   { background: #fbbc04; color: #3c4043; }
        .btn-s-delete { background: #ea4335; }
        .btn-action-text:hover { transform: scale(1.02); filter: brightness(1.1); }
        .btn-disabled { background: #eee !important; color: #aaa !important; cursor: not-allowed !important; }
        .station-label { font-weight: 700; color: #2c3e50; }
    </style>
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <%
        UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
        String currentUserID = (loginUser != null) ? loginUser.getUserID() : "";
        String currentUserRole = (String) session.getAttribute("ROLE");

        List<OrderDTO> list = (List<OrderDTO>) request.getAttribute("ORDER_LIST");
        List<StationDTO> stationList = (List<StationDTO>) request.getAttribute("STATION_LIST");
        String success = (String) request.getAttribute("SUCCESS_MESSAGE");
        String error   = (String) request.getAttribute("ERROR_MESSAGE");
        String searchPhone = (String) request.getParameter("searchPhone");
        if (searchPhone == null) searchPhone = "";
    %>

    <div style="max-width: 1750px; margin: 20px auto; padding: 0 20px;">
        
        <div class="modern-page-header">
            <h3>📦 Quản Lý Đơn Hàng</h3>
            <div style="font-weight: 700; opacity: 0.9;">Tổng: <%= list != null ? list.size() : 0 %> đơn</div>
        </div>

        <% if (success != null) { %> <div class="alert-success">✅ <%= success %></div> <% } %>
        <% if (error != null) { %> <div class="alert-error">❌ <%= error %></div> <% } %>

        <div class="modern-card">
            <form action="MainController" method="POST" style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 15px;">
                <select name="stationFilter" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                    <option value="">-- Lọc Trạm --</option>
                    <% if (stationList != null) for (StationDTO s : stationList) { %>
                    <option value="<%= s.getStationName() %>"><%= s.getStationName() %></option>
                    <% } %>
                </select>
                <input type="date" name="dateFilter" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                <select name="statusFilter" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                    <option value="">-- Trạng Thái --</option>
                    <option value="chua-chuyen">Chưa chuyển</option>
                    <option value="da-chuyen">Đã chuyển</option>
                </select>
                <input type="submit" name="FilterOrder" value="🔍 Lọc Dữ Liệu" class="btn-modern btn-primary-modern">
                <input type="submit" name="CreateOrder" value="➕ Nhập Hàng Gửi" class="btn-modern btn-success-modern">
                <input type="submit" name="ViewTrashOrder" value="🗑 Thùng rác" class="btn-modern btn-secondary-modern">
            </form>

            <form action="MainController" method="POST" style="display: flex; gap: 10px; align-items: center;">
                <input type="text" name="searchPhone" placeholder="Tìm theo SĐT người gửi/nhận..." 
                       value="<%= searchPhone %>" style="width: 300px; padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                <input type="submit" name="SearchOrderByPhone" value="🔎 Tìm Kiếm" class="btn-modern btn-primary-modern">
                <input type="submit" name="ViewOrderList" value="🔄 Làm mới" class="btn-modern btn-secondary-modern">
            </form>
        </div>

        <div class="modern-card" style="padding: 0; overflow-x: auto;">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Tên Hàng</th>
                        <th>Trạm Gửi</th>
                        <th>Trạm Nhận</th>
                        <th>Người Gửi</th>
                        <th>SĐT Gửi</th>
                        <th>Người Nhận</th>
                        <th>SĐT Nhận</th>
                        <th>NV Nhập</th>
                        <th>Phí TR</th>
                        <th>Phí CT</th>
                        <th>Ghi chú</th>
                        <th>Ngày Nhận</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (list != null && !list.isEmpty()) { 
                        for (OrderDTO o : list) { 
                            // KIỂM TRA QUYỀN SỬA: Admin (AD) hoặc Chính chủ (staffInput == currentUserID)
                            boolean canEdit = "AD".equals(currentUserRole) || o.getStaffInput().equals(currentUserID);
                    %>
                        <tr>
                            <td><strong style="color: #1a73e8;"><%= o.getOrderID() %></strong></td>
                            <td style="font-weight: 600;"><%= o.getItemName() %></td>
                            <td class="station-label"><%= o.getSendStation() %></td>
                            <td class="station-label"><%= o.getReceiveStation() %></td>
                            <td><%= o.getSenderName() %></td>
                            <td style="font-weight: 600;"><%= o.getSenderPhone() %></td>
                            <td><%= o.getReceiverName() %></td>
                            <td style="font-weight: 600;"><%= o.getReceiverPhone() %></td>
                            <td style="color: #5f6368; font-weight: 700;"><%= o.getStaffInput() %></td>
                            
                            <td>
                                <% if (o.getTr() != null && !o.getTr().isEmpty()) { %>
                                    <span class="badge badge-success"><%= o.getTr() %>k</span>
                                <% } else { %> <span style="color:#ccc">—</span> <% } %>
                            </td>
                            <td>
                                <% if (o.getCt() != null && !o.getCt().isEmpty()) { %>
                                    <span class="badge badge-danger"><%= o.getCt() %>k</span>
                                <% } else { %> <span style="color:#ccc">—</span> <% } %>
                            </td>
                            
                            <td style="max-width:150px; font-size: 0.8rem; color: #666; font-style: italic;"><%= o.getNote() != null ? o.getNote() : "" %></td>
                            <td style="font-size: 0.8rem;"><%= o.getReceiveDate() %></td>
                            <td>
                                <% if (o.getTripID() == null || o.getTripID().isEmpty()) { %>
                                    <span class="badge badge-warning">Chưa chuyển</span>
                                <% } else { %>
                                    <span class="badge badge-info">Đã chuyển</span>
                                    <br><small style="color:#1a73e8; font-weight:700;"><%= o.getTripID() %></small>
                                <% } %>
                            </td>
                            <td style="min-width: 110px;">
                                <div class="action-btns-grid">
                                    <form action="MainController" method="POST">
                                        <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                                        
                                        <% if (o.getTripID() == null || o.getTripID().isEmpty()) { %>
                                            <button type="submit" name="ShipOrder" class="btn-action-text btn-s-ship">🚚 Chuyển</button>
                                        <% } %>
                                        
                                        <% if (canEdit) { %>
                                            <button type="submit" name="EditOrder" class="btn-action-text btn-s-edit">✏️ Sửa đơn</button>
                                        <% } else { %>
                                            <button type="button" class="btn-action-text btn-disabled" title="Bạn không có quyền sửa đơn này">🔒 Sửa đơn</button>
                                        <% } %>

                                        <button type="submit" name="DeleteOrder" class="btn-action-text btn-s-delete"
                                                onclick="return confirm('Đưa đơn này vào thùng rác?')">🗑️ Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } } else { %>
                        <tr>
                            <td colspan="15" style="padding: 50px; color: #999;">📭 Không tìm thấy đơn hàng nào phù hợp!</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
