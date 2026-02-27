<%-- 
    Document   : create_order
    Created on : Feb 15, 2026, 6:17:46 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nhập Hàng Gửi</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/create_order.css">
</head>
<body>
     <%@include file="includes/navbar.jsp" %>

    <div class="order-container">
        <div class="order-header">
            <h2>NHẬP HÀNG GỬI</h2>
        </div>

        <form action="MainController" method="POST">
            <div class="order-toolbar">
                <span ">Thông tin hàng gửi</span>
                
                <%-- SỬA TẠI ĐÂY: name="SaveOrder" để điều hướng trong Controller --%>
                <input type="submit" name="SaveOrder" value="Lưu đơn hàng" class="btn-save">
            </div>

            <div class="form-body">
                <div class="form-group">
                    <label>Tên Hàng Gửi</label>
                    <input type="text" name="itemName" placeholder="Nhập Tên Hàng Gửi..." required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Trạm Gửi</label>
                        <select name="sendStation">
                            <option value="An Sương">An Sương</option>
                            <option value="Tây Ninh">Tây Ninh</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Trạm Nhận</label>
                        <select name="receiveStation">
                            <option value="">-- Chọn Trạm Nhận --</option>
                            <option value="Châu Đốc">Châu Đốc</option>
                            <option value="Long Xuyên">Long Xuyên</option>
                            <option value="Long Xuyên">Kiên Giang</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Người Gửi</label>
                        <input type="text" name="senderName" placeholder="Nhập vào tên người gửi...">
                    </div>
                    <div class="form-group">
                        <label>SĐT</label>
                        <input type="text" name="senderPhone" placeholder="Nhập vào số điện thoại người gửi...">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Người Nhận</label>
                        <input type="text" name="receiverName" placeholder="Nhập vào tên người nhận...">
                    </div>
                    <div class="form-group">
                        <label>SĐT</label>
                        <input type="text" name="receiverPhone" placeholder="Nhập vào số điện thoại người nhận...">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Thanh Toán</label>
                        <div class="input-addon">
                            <input type="number" name="paidAmount" placeholder="Số tiền phí khách thanh toán...">
                            <span>.000Đ</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Chưa Thanh Toán</label>
                        <div class="input-addon">
                            <input type="number" name="remainAmount" placeholder="Nhập vào phí khách chưa thanh toán...">
                            <span>.000Đ</span>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Ghi Chú (Nhân Viên Nhận)</label>
                    <textarea name="note" rows="3" placeholder="Nhập ghi chú..."></textarea>
                </div>
            </div>
        </form>
    </div>

    <div style="margin: 20px;">
        <%-- THÊM NÚT QUAY LẠI: name="ViewGoods" để Controller dẫn về trang bộ phận hàng --%>
        <form action="MainController" method="POST">
            <input type="submit" name="ViewGoods" value="⬅ Quay lại" class="btn-back" 
                   style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;">
        </form>
    </div>
</body>
</html>