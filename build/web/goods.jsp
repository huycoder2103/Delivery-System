<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Hàng Hóa - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/goods.css">
    <link rel="stylesheet" href="css/common_styles.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <div class="goods-container">
        <div class="page-header">
            <h2>BỘ PHẬN HÀNG HÓA</h2>
            <p style="opacity: 0.9; margin-top: 10px;">Quản lý đơn hàng, điều phối vận chuyển và lộ trình</p>
        </div>

        <div class="goods-grid">
            <!-- 1. Tạo Đơn Hàng -->
            <form action="MainController" method="POST" class="goods-card" onclick="this.submit();">
                <input type="hidden" name="CreateOrder" value="true">
                <div class="card-icon">✍️</div>
                <h3>Nhập Hàng Gửi</h3>
                <p>Tạo mới đơn hàng khi khách đến gửi hàng tại trạm.</p>
                <button type="button" class="btn-access">Bắt đầu</button>
            </form>

            <!-- 2. Danh Sách Đơn Hàng -->
            <form action="MainController" method="POST" class="goods-card" onclick="this.submit();">
                <input type="hidden" name="ViewOrderList" value="true">
                <div class="card-icon">📋</div>
                <h3>Danh Sách Đơn</h3>
                <p>Xem, sửa, xóa và quản lý trạng thái các đơn hàng hiện có.</p>
                <button type="button" class="btn-access">Xem ngay</button>
            </form>

            <!-- 3. Chuyến Xe Đi -->
            <form action="MainController" method="POST" class="goods-card" onclick="this.submit();">
                <input type="hidden" name="ViewTripList" value="true">
                <div class="card-icon">🚛</div>
                <h3>Chuyến Xe Đi</h3>
                <p>Quản lý các chuyến xe xuất phát từ trạm hiện tại.</p>
                <button type="button" class="btn-access">Quản lý</button>
            </form>

            <!-- 4. Chuyến Xe Đến -->
            <form action="MainController" method="POST" class="goods-card" onclick="this.submit();">
                <input type="hidden" name="ViewArrivalTripList" value="true">
                <div class="card-icon">🏁</div>
                <h3>Chuyến Xe Đến</h3>
                <p>Theo dõi và xác nhận các chuyến xe đang về trạm.</p>
                <button type="button" class="btn-access">Theo dõi</button>
            </form>
        </div>

        <div class="back-btn-container">
            <form action="MainController" method="POST">
                <input type="submit" name="GoHome" value="⬅ Quay lại Trang Chủ" class="btn-back">
            </form>
        </div>
    </div>
</body>
</html>
