package controller;

import dao.UserDAO;
import dao.ReportDAO;
import dao.ShiftDAO;
import dao.OrderDAO;
import dto.UserDTO;
import dto.ShiftDTO;
import dto.ReportSummaryDTO;
import java.io.IOException;
import java.sql.*;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ReportController", urlPatterns = {"/ReportController"})
public class ReportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String url = "report.jsp";
        try {
            HttpSession session = request.getSession(false);
            UserDTO loginUser = (session != null) ? (UserDTO) session.getAttribute("LOGIN_USER") : null;
            String  role      = (session != null) ? (String)  session.getAttribute("ROLE")       : "US";
            
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            ReportDAO reportDAO = new ReportDAO();
            ShiftDAO  shiftDAO  = new ShiftDAO();
            OrderDAO  orderDAO  = new OrderDAO();

            // 1. Xử lý xem chi tiết ca (viewShiftID)
            String viewShiftID = request.getParameter("viewShiftID");
            if (viewShiftID != null && !viewShiftID.trim().isEmpty()) {
                int sid = Integer.parseInt(viewShiftID);
                request.setAttribute("SHIFT_ORDERS", orderDAO.getOrdersByShiftID(sid));
                request.setAttribute("VIEW_SHIFT_ID", sid);
            }

            // 2. Xác định đối tượng cần lấy lịch sử (targetStaffID)
            String targetStaffID = request.getParameter("targetStaffID");
            if (targetStaffID == null || targetStaffID.trim().isEmpty()) {
                targetStaffID = loginUser.getUserID();
            }

            // 3. Nạp dữ liệu dựa trên vai trò
            if ("AD".equals(role)) {
                // Lấy ngày báo cáo (mặc định là hôm nay)
                String reportDate = request.getParameter("reportDate");
                if (reportDate == null || reportDate.trim().isEmpty()) {
                    reportDate = java.time.LocalDate.now().toString();
                }
                request.setAttribute("REPORT_DATE", reportDate);

                // Thống kê theo ngày chọn lọc
                request.setAttribute("REVENUE_DATE_VAL", reportDAO.getRevenueByDate(reportDate));
                request.setAttribute("ORDERS_DATE_VAL", reportDAO.getOrdersCountByDate(reportDate));
                
                // Các thống kê khác
                request.setAttribute("REVENUE_TODAY_VAL", reportDAO.getRevenueToday());
                request.setAttribute("REVENUE_MONTH_VAL", reportDAO.getRevenueThisMonth());
                request.setAttribute("ACTIVE_STAFF_COUNT", reportDAO.getActiveStaffCount());
                request.setAttribute("STAFF_PERFORMANCE", reportDAO.getStaffPerformance(reportDate));
                request.setAttribute("CHART_DATA", reportDAO.getWeeklyRevenueChart());
                
                // Nếu đang soi 1 nhân viên cụ thể hoặc vừa bấm xem chi tiết ca
                if (request.getParameter("targetStaffID") != null || viewShiftID != null) {
                    request.setAttribute("SELECTED_STAFF_ID", targetStaffID);
                    request.setAttribute("SHIFT_HISTORY", reportDAO.getShiftHistory(targetStaffID));
                }
            } else {
                // Thống kê cho Nhân viên
                ShiftDTO currentShift = shiftDAO.getActiveShift(loginUser.getUserID());
                if (currentShift != null) {
                    request.setAttribute("SHIFT_SUMMARY", reportDAO.getSummaryByShift(currentShift.getShiftID()));
                }
                // Luôn nạp lịch sử của chính mình
                request.setAttribute("SHIFT_HISTORY", reportDAO.getShiftHistory(loginUser.getUserID()));
            }

            // 4. Logic cũ (Doanh thu theo ngày chọn lọc) - Giữ để không lỗi trang
            String selectedDate = request.getParameter("selectedDate");
            if (selectedDate == null || selectedDate.trim().isEmpty()) {
                selectedDate = java.time.LocalDate.now().toString();
            }
            request.setAttribute("SELECTED_DATE", selectedDate);

        } catch (Exception e) {
            log("Error ReportController: " + e.toString());
            request.setAttribute("ERROR_MESSAGE", "Lỗi nạp báo cáo: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException { processRequest(req, res); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException { processRequest(req, res); }
}
