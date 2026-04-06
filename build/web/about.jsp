<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hướng dẫn chi tiết - Delivery System</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/common_styles.css">
    <link rel="stylesheet" href="css/about.css">
    <style>
        .btn-ref { display: inline-block; padding: 2px 8px; border-radius: 4px; font-weight: bold; font-size: 0.8rem; color: white; margin: 0 2px; }
        .bg-blue { background: #1a73e8; }
        .bg-green { background: #34a853; }
        .bg-yellow { background: #fbbc04; color: #333 !important; }
        .bg-red { background: #ea4335; }
        .bg-gray { background: #5f6368; }
        .currency-note { background: #fff3cd; padding: 10px; border-radius: 8px; border-left: 5px solid #ffc107; margin-bottom: 20px; font-weight: 600; }
    </style>
</head>
<body>
    <%@include file="includes/navbar.jsp" %>

    <div class="about-container">
        <div class="about-header">
            <h1>📘 HƯỚNG DẪN SỬ DỤNG HỆ THỐNG</h1>
            <p>Quy trình quản lý hàng hóa, ca làm việc và hệ thống báo cáo</p>
        </div>

        <div class="currency-note">
            ⚠️ LƯU Ý QUAN TRỌNG: Toàn bộ đơn vị tiền tệ (Cước phí, Doanh thu) trên hệ thống hiện được tính bằng đơn vị "K" (Ví dụ: 50 K = 50,000 VNĐ).
        </div>

        <!-- 1. QUẢN LÝ CA LÀM VIỆC (NEW) -->
        <div class="guide-section">
            <h2 class="text-primary">⏱️ Quản Lý Ca Làm Việc</h2>
            <div class="feature-grid">
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>🚀 Quy trình Bắt đầu & Kết thúc ca</h4>
                    <div class="card-hint">Thực hiện ngay tại Trang Chủ</div>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">🟢 Nút "Bắt đầu ca" <span>+</span></div>
                                <div class="sub-feature-content">
                                    Mỗi nhân viên khi bắt đầu làm việc phải nhấn nút này. Hệ thống sẽ ghi nhận thời gian bắt đầu và tạo một <b>Mã Ca</b> riêng biệt. Mọi đơn hàng bạn nhập trong lúc này sẽ được tính vào doanh thu của ca đó.
                                </div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">🛑 Nút "Kết thúc ca" <span>+</span></div>
                                <div class="sub-feature-content">
                                    Khi hết giờ làm, hãy nhấn nút này để đóng ca. Hệ thống sẽ chốt số liệu doanh thu và số đơn hàng bạn đã xử lý. 
                                </div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📊 Thống kê Real-time <span>+</span></div>
                                <div class="sub-feature-content">
                                    Ngay trên widget ca làm, bạn sẽ thấy các con số: <b>Đã giao</b>, <b>Đang đi</b> và <b>Doanh thu tạm tính</b> được cập nhật tức thì theo từng đơn hàng bạn xử lý.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. HỆ THỐNG BÁO CÁO (NEW) -->
        <div class="guide-section">
            <h2 class="text-success">📊 Báo Cáo & Thống Kê</h2>
            <div class="feature-grid">
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>📈 Công cụ dành cho Nhân Viên</h4>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📑 Tab "Ca Hiện Tại" <span>+</span></div>
                                <div class="sub-feature-content">Xem tổng quan chi tiết các con số vận hành của phiên làm việc đang diễn ra.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📜 Tab "Lịch Sử Ca" <span>+</span></div>
                                <div class="sub-feature-content">Xem lại 20 ca làm việc gần nhất. Nhấn nút <b>"Chi tiết"</b> để xem danh sách từng đơn hàng cụ thể đã làm trong ca đó.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${sessionScope.ROLE eq 'AD'}">
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>🛡️ Công cụ dành cho Quản Trị (Admin)</h4>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">🔍 Bộ lọc ngày <span>+</span></div>
                                <div class="sub-feature-content">Admin có thể chọn bất kỳ ngày nào để xem lại doanh thu, số đơn và hiệu suất của toàn hệ thống trong ngày đó.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">👥 Giám sát nhân viên <span>+</span></div>
                                <div class="sub-feature-content">Bảng <b>Hiệu suất hôm nay</b> cho biết ai đang online (🟢) và ai đang nghỉ (⚪). Nhấn vào tên nhân viên để soi chi tiết lịch sử làm việc của họ.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📈 Biểu đồ Tăng trưởng <span>+</span></div>
                                <div class="sub-feature-content">Theo dõi xu hướng doanh thu trong 7 ngày gần nhất qua biểu đồ đường trực quan.</div>
                            </div>
                        </div>
                    </div>
                </div>
                </c:if>
            </div>
        </div>

        <!-- 3. QUẢN LÝ HÀNG HÓA -->
        <div class="guide-section">
            <h2>📦 Nghiệp Vụ Đơn Hàng & Chuyến Xe</h2>
            <div class="feature-grid">
                <!-- TRANG DANH SÁCH ĐƠN -->
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>📑 Quản lý Đơn Hàng</h4>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-blue">🔍 Lọc Dữ Liệu</span> <span>+</span></div>
                                <div class="sub-feature-content">Tìm đơn theo Trạm Gửi/Nhận, Ngày hoặc Trạng thái đơn.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-green">➕ Nhập Hàng Gửi</span> <span>+</span></div>
                                <div class="sub-feature-content">Tạo mới đơn hàng khi khách tới gửi. Nhớ kiểm tra SĐT người nhận để tránh lỗi giao hàng.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📦 Gán lên xe <span>+</span></div>
                                <div class="sub-feature-content">Trong trang "Chuyến xe đi", dùng nút này để chất hàng hóa lên xe tải.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CHUYẾN XE -->
                <div class="feature-card" onclick="toggleCard(this)">
                    <h4>🚛 Quản lý Chuyến Xe</h4>
                    <div class="feature-details">
                        <div class="sub-feature-container">
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header">📋 Xem hàng hóa <span>+</span></div>
                                <div class="sub-feature-content">Xem danh sách tất cả món hàng thực tế đang có trên xe tải đó.</div>
                            </div>
                            <div class="sub-feature-item" onclick="toggleSubFeature(event, this)">
                                <div class="sub-feature-header"><span class="btn-ref bg-green">🏁 Đã đến</span> <span>+</span></div>
                                <div class="sub-feature-content">Xác nhận xe đã về trạm. Hệ thống sẽ tự động chuyển trạng thái đơn hàng sang "Đã Chuyển" (Đã đến trạm nhận).</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

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
            if (event.target.closest('.sub-feature-item')) return;
            const allCards = document.querySelectorAll('.feature-card');
            allCards.forEach(c => { if (c !== card) c.classList.remove('active'); });
            card.classList.toggle('active');
        }

        function toggleSubFeature(event, item) {
            event.stopPropagation();
            const container = item.closest('.sub-feature-container');
            const allItems = container.querySelectorAll('.sub-feature-item');
            allItems.forEach(otherItem => {
                if (otherItem !== item) {
                    otherItem.classList.remove('open');
                    const otherIcon = otherItem.querySelector('.sub-feature-header span:last-child');
                    if (otherIcon) otherIcon.textContent = '+';
                }
            });
            item.classList.toggle('open');
            const icon = item.querySelector('.sub-feature-header span:last-child');
            if (icon) { icon.textContent = item.classList.contains('open') ? '-' : '+'; }
        }
    </script>
    <%@include file="includes/footer.jsp" %>
</body>
</html>
