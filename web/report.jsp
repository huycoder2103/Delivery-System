<%-- 
    Document   : report
    Created on : Feb 24, 2026, 11:54:14 PM
    Author     : HuyNHSE190240
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Báo cáo & Giao ca</title>
        <link rel="stylesheet" href="css/home.css">
        <link rel="stylesheet" href="css/report.css"> 
    </head>
    <body>
        <%@include file="includes/navbar.jsp" %>

        <div class="list-container">
            <div class="page-title">
                <h1>TỔNG KẾT CA LÀM VIỆC</h1>
                <div class="underline"></div>
            </div>

            <div class="report-grid">
                <div class="report-card">
                    <h3>📊 Hiệu suất đơn hàng</h3>
                    <div class="stat-row">
                        <span>Tổng số đơn nhận:</span>
                        <span class="stat-value">${TOTAL_ORDERS}</span>
                    </div>
                    <div class="stat-row">
                        <span>Số đơn đã chuyển:</span>
                        <span class="stat-value text-green">${SHIPPED_ORDERS}</span>
                    </div>
                    <div class="stat-row">
                        <span>Số đơn đã hủy:</span>
                        <span class="stat-value text-red">${CANCELLED_ORDERS}</span>
                    </div>
                </div>

                <div class="report-card">
                    <h3>💰 Tài chính ca làm</h3>
                    <div class="stat-row">
                        <span>Tổng tiền cước nhận:</span>
                        <span class="stat-value">${TOTAL_CASH} VNĐ</span>
                    </div>
                    <div class="stat-row">
                        <span>Tiền đã nộp về kho:</span>
                        <span class="stat-value">${SUBMITTED_CASH} VNĐ</span>
                    </div>
                    <div class="stat-row total-revenue">
                        <strong>DOANH THU THỰC TẾ:</strong>
                        <strong>${ACTUAL_REVENUE} VNĐ</strong>
                    </div>
                </div>
            </div>

            <div class="report-card" style="margin-top: 20px;">
                <h3>🔑 Chức năng Giao ca</h3>
                <form action="MainController" method="POST">
                    <input type="hidden" name="totalOrders" value="${TOTAL_ORDERS}">
                    <input type="hidden" name="actualRevenue" value="${ACTUAL_REVENUE}">

                    <label>Ghi chú bàn giao cho ca sau:</label>
                    <textarea name="shiftNote" class="shift-note-area" placeholder="Ví dụ: Tình trạng tiền lẻ, các đơn hàng cần lưu ý..."></textarea>

                    <div class="btn-container">
                        <input type="submit" name="SubmitShiftReport" value="Xác nhận & Chốt ca" class="btn-cyan">
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
