<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tính năng & Hướng dẫn - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
    <link rel="stylesheet" href="css/about.css">
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <div class="home-container">
        <div class="welcome-box">
            <h1>TÍNH NĂNG HỆ THỐNG</h1>
            <p>Khám phá các công cụ quản lý vận chuyển chuyên nghiệp tại Delivery System</p>
        </div>

        <div class="about-container">
            
            <!-- Phần 1: Các Modul chính -->
            <div class="feature-section">
                <h2 class="section-title">Các Phân Hệ Chính</h2>
                <div class="feature-grid">
                    <div class="feature-item">
                        <i>📦</i>
                        <h4>Quản lý Đơn hàng</h4>
                        <p>Nhập mới đơn hàng, theo dõi trạng thái từ "Chưa chuyển" đến "Đã lên xe". Hỗ trợ tìm kiếm nhanh theo SĐT và lọc theo Trạm.</p>
                    </div>
                    <div class="feature-item">
                        <i>🚛</i>
                        <h4>Điều phối Chuyến xe</h4>
                        <p>Tạo lộ trình cho xe đi/đến. Hệ thống tự động gợi ý các đơn hàng phù hợp với trạm đi của xe để gán hàng nhanh chóng.</p>
                    </div>
                    <div class="feature-item">
                        <i>📊</i>
                        <h4>Báo cáo & Thống kê</h4>
                        <p>Theo dõi doanh thu thực tế, số lượng đơn nhập trong ngày và bảng xếp hạng hiệu suất làm việc của từng nhân viên.</p>
                    </div>
                </div>
            </div>

            <!-- Phần 2: Quy trình vận hành -->
            <div class="feature-section">
                <h2 class="section-title">Quy trình Vận hành Chuẩn</h2>
                <div class="workflow-box">
                    <div class="step-list">
                        <div class="step-item">
                            <div class="step-number">1</div>
                            <div class="step-content">
                                <h5>Nhận hàng & Tạo đơn</h5>
                                <p>Vào <strong>Quản lý hàng hóa</strong> -> <strong>Nhập hàng gửi</strong>. Điền thông tin khách hàng và cước phí.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-number">2</div>
                            <div class="step-content">
                                <h5>Tạo Chuyến xe</h5>
                                <p>Khi có xe xuất phát, vào <strong>Chuyến xe đi</strong> -> <strong>Thêm chuyến mới</strong>. Chọn xe, trạm đi và trạm đến.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-number">3</div>
                            <div class="step-content">
                                <h5>Gán hàng lên xe</h5>
                                <p>Tại danh sách Chuyến xe, nhấn <strong>📦 Thêm hàng</strong>. Hệ thống sẽ lọc ra các đơn hàng chờ đi từ trạm đó để bạn tích chọn gán lên xe.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-number">4</div>
                            <div class="step-content">
                                <h5>Xác nhận xe đến</h5>
                                <p>Khi xe về tới trạm đích, vào <strong>Chuyến xe đến</strong>, tìm mã chuyến và nhấn <strong>🏁 Đã đến</strong> để kết thúc hành trình.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Phần 3: Tính năng bảo mật -->
            <div class="feature-section">
                <h2 class="section-title">Công nghệ & Bảo mật</h2>
                <div class="feature-grid">
                    <div class="feature-item">
                        <i>⚡</i>
                        <h4>Kết nối siêu tốc</h4>
                        <p>Sử dụng công nghệ <strong>HikariCP</strong> giúp truy xuất dữ liệu cực nhanh, không giật lag ngay cả khi xử lý hàng ngàn đơn hàng.</p>
                    </div>
                    <div class="feature-item">
                        <i>🔒</i>
                        <h4>Phân quyền chặt chẽ</h4>
                        <p>Mỗi đơn hàng được gắn mã NV Nhập. Chỉ người tạo đơn hoặc Admin mới có quyền chỉnh sửa, đảm bảo tính minh bạch.</p>
                    </div>
                    <div class="feature-item">
                        <i>🗑️</i>
                        <h4>Thùng rác an toàn</h4>
                        <p>Đơn hàng xóa đi sẽ vào Thùng rác. Bạn có thể Khôi phục lại nếu lỡ tay xóa nhầm, hoặc xóa vĩnh viễn để làm sạch dữ liệu.</p>
                    </div>
                </div>
            </div>

            <div style="text-align: center; margin-top: 50px;">
                <form action="MainController" method="POST">
                    <input type="submit" name="GoHome" value="Bắt đầu làm việc ngay" class="btn-modern btn-primary-modern" style="padding: 15px 40px; font-size: 1.1rem; border-radius: 50px;">
                </form>
            </div>
        </div>
    </div>
</body>
</html>
