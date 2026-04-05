<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cẩm Nang Toàn Tập - ntXuanSystem</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
    <link rel="stylesheet" href="css/about.css">
    <style>
        /* Bổ sung một số style cho icon nút */
        .btn-ref { display: inline-block; padding: 2px 8px; border-radius: 4px; font-weight: bold; font-size: 0.8rem; color: white; margin: 0 2px; }
        .bg-blue { background: #1a73e8; }
        .bg-green { background: #34a853; }
        .bg-yellow { background: #fbbc04; color: #333 !important; }
        .bg-red { background: #ea4335; }
        .bg-gray { background: #5f6368; }
    </style>
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <div class="about-container">
        <div class="about-header">
            <h1>📘 TỪ ĐIỂN CHỨC NĂNG HỆ THỐNG</h1>
            <p>Hướng dẫn chi tiết ý nghĩa và cách dùng của mọi nút bấm trên giao diện</p>
        </div>

        <!-- 1. ĐIỀU HƯỚNG CHUNG (NAVBAR & HOME) -->
        <div class="guide-section">
            <h2>🏠 Điều Hướng & Trang Chủ</h2>
            <div class="feature-grid">
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>🧭 Các nút trên Thanh công cụ (Navbar)</h4>
                    <div class="card-hint">Hiện diện ở tất cả các trang</div>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">👤 Avatar/Tên người dùng <span>+</span></div>
                                <div class="sub-feature-content">
                                    Nhấn để mở menu cá nhân. Chứa thông tin Email và vai trò (AD/ST).
                                </div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">🚪 Nút "Đăng xuất" <span>+</span></div>
                                <div class="sub-feature-content">
                                    Kết thúc phiên làm việc an toàn, xóa bộ nhớ tạm (Cache) để bảo vệ dữ liệu trạm.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. QUẢN LÝ HÀNG HÓA -->
        <div class="guide-section">
            <h2>📦 Nghiệp Vụ Hàng Hóa & Đơn Hàng</h2>
            <div class="feature-grid">
                <!-- TRANG DANH SÁCH ĐƠN -->
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>📑 Trang Danh Sách Đơn Hàng</h4>
                    <div class="card-hint">Nơi làm việc nhiều nhất của nhân viên</div>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-blue">🔍 Lọc Dữ Liệu</span> <span>+</span></div>
                                <div class="sub-feature-content">
                                    Tìm đơn hàng theo tổ hợp: Trạm Gửi + Trạm Nhận + Ngày + Trạng thái.
                                </div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-green">➕ Nhập Hàng Gửi</span> <span>+</span></div>
                                <div class="sub-feature-content">
                                    Mở trang tạo đơn mới khi có khách tới gửi hàng.
                                </div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-gray">🗑 Thùng rác</span> <span>+</span></div>
                                <div class="sub-feature-content">
                                    Xem lại các đơn đã xóa. Bạn có thể khôi phục từ đây.
                                </div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-blue">🚚 Chuyển</span> (Trong bảng) <span>+</span></div>
                                <div class="sub-feature-content">
                                    Gán đơn hàng hiện tại lên một chuyến xe tải đang chuẩn bị đi.
                                </div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-yellow">✏️ Sửa</span> (Trong bảng) <span>+</span></div>
                                <div class="sub-feature-content">
                                    Mở trang chỉnh sửa thông tin hàng, SĐT khách hoặc tiền cước.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TRANG THÙNG RÁC -->
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>♻️ Trang Thùng Rác</h4>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-green">🔄 Khôi phục</span> <span>+</span></div>
                                <div class="sub-feature-content">Đưa đơn hàng trở lại danh sách quản lý chính.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-red">❌ Xóa vĩnh viễn</span> <span>+</span></div>
                                <div class="sub-feature-content">Xóa sạch dữ liệu khỏi hệ thống, không thể lấy lại.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. QUẢN LÝ CHUYẾN XE -->
        <div class="guide-section">
            <h2>🚛 Nghiệp Vụ Chuyến Xe (Logistics)</h2>
            <div class="feature-grid">
                <!-- CHUYẾN XE ĐI -->
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>📤 Trang Chuyến Xe Đi (Departure)</h4>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-green">➕ Thêm Chuyến Mới</span> <span>+</span></div>
                                <div class="sub-feature-content">Đăng ký một chuyến xe tải mới xuất phát từ trạm.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📋 Hàng trên xe <span>+</span></div>
                                <div class="sub-feature-content">Xem danh sách các mã đơn hàng đang nằm trên xe này.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📦 Thêm hàng <span>+</span></div>
                                <div class="sub-feature-content">Mở danh sách hàng chưa chuyển để chất thêm lên xe.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CHUYẾN XE ĐẾN -->
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>📥 Trang Chuyến Xe Đến (Arrival)</h4>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-green">🏁 Đã đến</span> <span>+</span></div>
                                <div class="sub-feature-content">
                                    <b>Nút quan trọng nhất:</b> Xác nhận xe đã về tới trạm vật lý. Hệ thống sẽ tự cập nhật trạng thái "Đã về trạm" cho tất cả đơn hàng trên xe này.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. BÁO CÁO -->
        <div class="guide-section">
            <h2>📊 Trang Báo Cáo & Thống Kê</h2>
            <div class="feature-grid">
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>📈 Các công cụ phân tích dữ liệu</h4>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📑 Các Tab: Doanh Thu / Nhân Viên / Theo Ngày <span>+</span></div>
                                <div class="sub-feature-content">Nhấn để chuyển đổi các góc nhìn báo cáo khác nhau.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-blue">💾 Chốt Bàn Giao Ca</span> <span>+</span></div>
                                <div class="sub-feature-content">Ghi lại tổng kết doanh thu và ghi chú cho nhân viên ca sau.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 5. QUẢN TRỊ ADMIN (CHỈ ADMIN THẤY) -->
        <c:set var="userRole" value="${sessionScope.ROLE}" />
        <c:if test="${userRole eq 'AD'}">
            <div class="admin-only-section">
                <div class="admin-badge-top">QUYỀN QUẢN TRỊ VIÊN</div>
                <h2>🛡️ Bảng Điều Khiển Quản Trị (Admin Panel)</h2>
                <div class="feature-grid">
                    <div class="feature-card" onclick="toggleCard(this)">
                        <h4>⚙️ Các nút quản trị cốt lõi</h4>
                        <div class="feature-details">
                            <div class="sub-feature-container">
                                <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                    <div class="sub-feature-header"><span class="btn-ref bg-green">➕ Thêm Nhân Viên</span> <span>+</span></div>
                                    <div class="sub-feature-content">Tạo tài khoản mới cho nhân viên mới vào làm.</div>
                                </div>
                                <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                    <div class="sub-feature-header"><span class="btn-ref bg-yellow">🔐 Đổi MK</span> <span>+</span></div>
                                    <div class="sub-feature-content">Cấp lại mật khẩu nhanh khi nhân viên quên (Mã hóa SHA-256).</div>
                                </div>
                                <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                    <div class="sub-feature-header"><span class="btn-ref bg-blue">Khóa / Mở Khóa</span> <span>+</span></div>
                                    <div class="sub-feature-content">Tạm dừng quyền truy cập của nhân viên vi phạm hoặc nghỉ phép.</div>
                                </div>
                                <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                    <div class="sub-feature-header"><span class="btn-ref bg-red">Xóa</span> (Nhân viên) <span>+</span></div>
                                    <div class="sub-feature-content">Xóa vĩnh viễn tài khoản (Không thể xóa chính tài khoản admin).</div>
                                </div>
                                <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                    <div class="sub-feature-header">📝 Lưu bảng tin <span>+</span></div>
                                    <div class="sub-feature-content">Đăng thông báo quan trọng lên trang chủ của toàn hệ thống.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- NÚT QUAY LẠI TRANG CHỦ -->
        <div style="text-align: center; margin-top: 40px;">
            <form action="MainController" method="POST">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="submit" name="GoHome" value="⬅ Quay lại Trang chủ" class="btn-home">
            </form>
        </div>

        <!-- FEEDBACK -->
        <div class="feedback-section">
            <h2>💬 Góp Ý Hệ Thống</h2>
            <form action="MainController" method="POST" class="feedback-form">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <textarea name="feedbackContent" rows="3" placeholder="Góp ý về các chức năng tại đây..." required></textarea>
                <div style="text-align: right;">
                    <button type="submit" name="SaveFeedback" class="btn-modern btn-primary-modern">🚀 Gửi</button>
                </div>
            </form>
            <div class="feedback-list">
                <c:forEach var="fb" items="${requestScope.FEEDBACK_LIST}">
                    <div class="feedback-item">
                        <div class="feedback-meta">
                            <span class="fb-user">👤 ${fb.fullName}</span>
                            <div class="fb-actions">
                                <span class="fb-date">${fb.createdAt}</span>
                                <c:if test="${(sessionScope.LOGIN_USER.userID eq fb.userID) or (sessionScope.ROLE eq 'AD')}">
                                    <form action="MainController" method="POST" style="display:inline;">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                        <input type="hidden" name="feedbackID" value="${fb.feedbackID}">
                                        <button type="submit" name="DeleteFeedback" class="btn-delete-fb">Xóa</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                        <div class="fb-content">${fb.content}</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <script>
        function toggleCard(card) {
            // Chỉ toggle card cha nếu không phải đang click vào các mục con
            if (event.target.closest('.sub-feature-item')) return;
            
            const allCards = document.querySelectorAll('.feature-card');
            allCards.forEach(c => {
                if (c !== card) c.classList.remove('active');
            });
            card.classList.toggle('active');
        }

        function toggleSubFeature(event, item) {
            event.stopPropagation(); // Chống nổi bọt sự kiện lên card cha
            
            const container = item.closest('.sub-feature-container');
            const allItems = container.querySelectorAll('.sub-feature-item');
            
            // 1. Reset tất cả các mục khác trong cùng container
            allItems.forEach(otherItem => {
                if (otherItem !== item) {
                    otherItem.classList.remove('open');
                    const otherIcon = otherItem.querySelector('.sub-feature-header span:last-child');
                    if (otherIcon) otherIcon.textContent = '+';
                }
            });

            // 2. Toggle mục hiện tại
            item.classList.toggle('open');
            
            // 3. Cập nhật icon của mục hiện tại
            const icon = item.querySelector('.sub-feature-header span:last-child');
            if (icon) {
                icon.textContent = item.classList.contains('open') ? '-' : '+';
            }
        }
    </script>
    <%@include file="includes/footer.jsp" %>
</body>
</html>
