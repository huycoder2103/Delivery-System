package controller;

import dao.UserDAO;
import dto.UserDTO;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utils.DBUtils;

@WebServlet(name = "ReportController", urlPatterns = {"/ReportController"})
public class ReportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            HttpSession session = request.getSession(false);
            String  role      = (session != null) ? (String)  session.getAttribute("ROLE")       : "US";
            UserDTO loginUser = (session != null) ? (UserDTO) session.getAttribute("LOGIN_USER") : null;

            String selectedDate = request.getParameter("selectedDate");
            if (selectedDate == null || selectedDate.trim().isEmpty()) {
                selectedDate = java.time.LocalDate.now().toString();
            }
            request.setAttribute("SELECTED_DATE", selectedDate);
            request.setAttribute("CURRENT_MONTH",
                java.time.LocalDate.now().getMonthValue() + "/" + java.time.LocalDate.now().getYear());

            if ("AD".equals(role)) {
                loadAdminStats(request);
                loadMonthlyAdminStats(request);
                loadDayStats(request, selectedDate);
                loadDailyHistory(request);
                loadOrdersOfDay(request, selectedDate);
                loadStaffStatsByDay(request, selectedDate);
            } else {
                String staffID = (loginUser != null) ? loginUser.getUserID() : "NV01";
                loadStaffShift(request, staffID);
                loadMonthlyStaffStats(request, staffID);
                loadDayStatsForStaff(request, staffID, selectedDate);
                loadDailyHistoryForStaff(request, staffID);
                loadOrdersOfDayForStaff(request, staffID, selectedDate);
            }
        } catch (Exception e) {
            log("Error at ReportController: " + e.toString());
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher("report.jsp").forward(request, response);
        }
    }

    // ── Admin tổng + hôm nay ───────────────────────────────────────
    // MySQL: GETDATE() → NOW(), ISNULL → IFNULL, bỏ N'' prefix,
    //        CAST(x AS DATE) → DATE(x)
    private void loadAdminStats(HttpServletRequest request) {
        String sql =
            "SELECT COUNT(*) AS totalOrders,"
            + " SUM(CASE WHEN shipStatus = 'Đã Chuyển'  THEN 1 ELSE 0 END) AS completedOrders,"
            + " SUM(CASE WHEN shipStatus = 'Chưa Chuyển' THEN 1 ELSE 0 END) AS pendingOrders,"
            + " IFNULL(SUM(amount), 0) AS totalRevenue,"
            + " SUM(CASE WHEN DATE(createdAt) = CURDATE() THEN 1 ELSE 0 END) AS todayOrders,"
            + " IFNULL(SUM(CASE WHEN DATE(createdAt) = CURDATE() THEN amount ELSE 0 END), 0) AS todayRevenue"
            + " FROM tblOrders WHERE isDeleted = 0";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                request.setAttribute("TOTAL_ORDERS",     rs.getInt("totalOrders"));
                request.setAttribute("COMPLETED_ORDERS", rs.getInt("completedOrders"));
                request.setAttribute("PENDING_ORDERS",   rs.getInt("pendingOrders"));
                request.setAttribute("TOTAL_REVENUE",    fmt(rs.getDouble("totalRevenue")));
                request.setAttribute("TODAY_ORDERS",     rs.getInt("todayOrders"));
                request.setAttribute("TODAY_REVENUE",    fmt(rs.getDouble("todayRevenue")));
            }
        } catch (Exception e) { log("loadAdminStats: " + e); }
    }

    // ── Admin tháng hiện tại ───────────────────────────────────────
    // MySQL: MONTH(x) và YEAR(x) vẫn dùng được, GETDATE() → NOW()
    private void loadMonthlyAdminStats(HttpServletRequest request) {
        String sql =
            "SELECT COUNT(*) AS monthOrders,"
            + " SUM(CASE WHEN shipStatus = 'Đã Chuyển'  THEN 1 ELSE 0 END) AS monthCompleted,"
            + " SUM(CASE WHEN shipStatus = 'Chưa Chuyển' THEN 1 ELSE 0 END) AS monthPending,"
            + " IFNULL(SUM(amount), 0) AS monthRevenue"
            + " FROM tblOrders WHERE isDeleted = 0"
            + " AND MONTH(createdAt) = MONTH(NOW()) AND YEAR(createdAt) = YEAR(NOW())";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                request.setAttribute("MONTH_ORDERS",    rs.getInt("monthOrders"));
                request.setAttribute("MONTH_COMPLETED", rs.getInt("monthCompleted"));
                request.setAttribute("MONTH_PENDING",   rs.getInt("monthPending"));
                request.setAttribute("MONTH_REVENUE",   fmt(rs.getDouble("monthRevenue")));
            }
        } catch (Exception e) { log("loadMonthlyAdminStats: " + e); }
    }

    // ── Admin ngày chọn ───────────────────────────────────────────
    // MySQL: DATE(createdAt) thay CAST(createdAt AS DATE)
    private void loadDayStats(HttpServletRequest request, String date) {
        String sql =
            "SELECT COUNT(*) AS dayOrders,"
            + " IFNULL(SUM(amount), 0) AS dayRevenue,"
            + " SUM(CASE WHEN shipStatus = 'Đã Chuyển'  THEN 1 ELSE 0 END) AS dayCompleted,"
            + " SUM(CASE WHEN shipStatus = 'Chưa Chuyển' THEN 1 ELSE 0 END) AS dayPending"
            + " FROM tblOrders WHERE isDeleted = 0 AND DATE(createdAt) = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("DAY_ORDERS",    rs.getInt("dayOrders"));
                    request.setAttribute("DAY_REVENUE",   fmt(rs.getDouble("dayRevenue")));
                    request.setAttribute("DAY_COMPLETED", rs.getInt("dayCompleted"));
                    request.setAttribute("DAY_PENDING",   rs.getInt("dayPending"));
                }
            }
        } catch (Exception e) { log("loadDayStats: " + e); }
    }

    /**
     * Lịch sử 30 ngày — Admin.
     * MySQL: TOP 30 → LIMIT 30, DATE_FORMAT thay CONVERT,
     *        DATE(createdAt) thay CAST(createdAt AS DATE)
     * [0]=dd/MM/yyyy [1]=yyyy-MM-dd [2]=orders [3]=revenue [4]=done
     */
    private void loadDailyHistory(HttpServletRequest request) {
        String sql =
            "SELECT DATE_FORMAT(DATE(createdAt), '%d/%m/%Y') AS d,"
            + " DATE(createdAt) AS rawDate,"
            + " COUNT(*) AS cnt,"
            + " IFNULL(SUM(amount), 0) AS rev,"
            + " SUM(CASE WHEN shipStatus = 'Đã Chuyển' THEN 1 ELSE 0 END) AS done"
            + " FROM tblOrders WHERE isDeleted = 0"
            + " GROUP BY DATE(createdAt)"
            + " ORDER BY DATE(createdAt) DESC"
            + " LIMIT 30";
        List<String[]> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("d"),
                    rs.getString("rawDate"),
                    String.valueOf(rs.getInt("cnt")),
                    fmt(rs.getDouble("rev")),
                    String.valueOf(rs.getInt("done"))
                });
            }
        } catch (Exception e) { log("loadDailyHistory: " + e); }
        request.setAttribute("DAILY_HISTORY", list);
    }

    /**
     * Danh sách đơn ngày chọn — Admin.
     * MySQL: DATE_FORMAT(createdAt, '%H:%i:%s') thay CONVERT(NVARCHAR, createdAt, 108)
     *        DATE(createdAt) thay CAST(createdAt AS DATE)
     */
    private void loadOrdersOfDay(HttpServletRequest request, String date) {
        String sql =
            "SELECT orderID, itemName, amount, senderName, senderPhone,"
            + " sendStation, receiverName, receiverPhone, receiveStation,"
            + " staffInput, tr, ct, shipStatus, note,"
            + " DATE_FORMAT(createdAt, '%H:%i:%s') AS createdTime"
            + " FROM tblOrders WHERE isDeleted = 0 AND DATE(createdAt) = ?"
            + " ORDER BY createdAt DESC";
        List<String[]> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        rs.getString("orderID"),       rs.getString("itemName"),
                        fmt(rs.getDouble("amount")),
                        nvl(rs.getString("senderName")),   nvl(rs.getString("senderPhone")),
                        nvl(rs.getString("sendStation")),
                        nvl(rs.getString("receiverName")), nvl(rs.getString("receiverPhone")),
                        nvl(rs.getString("receiveStation")),
                        nvl(rs.getString("staffInput")),
                        nvl(rs.getString("tr")),           nvl(rs.getString("ct")),
                        nvl(rs.getString("shipStatus")),   nvl(rs.getString("note")),
                        nvl(rs.getString("createdTime"))
                    });
                }
            }
        } catch (Exception e) { log("loadOrdersOfDay: " + e); }
        request.setAttribute("DAY_ORDERS_LIST", list);
    }

    // ── Hiệu suất nhân viên trong ngày chọn ─────────────────────
    // MySQL: DATE(o.createdAt) thay CAST(o.createdAt AS DATE)
    private void loadStaffStatsByDay(HttpServletRequest request, String date) {
        String sql =
            "SELECT u.userID, u.fullName,"
            + " COUNT(o.orderID) AS orderCount,"
            + " IFNULL(SUM(o.amount), 0) AS revenue"
            + " FROM tblUsers u"
            + " LEFT JOIN tblOrders o ON u.userID = o.staffInput AND o.isDeleted = 0"
            + "   AND DATE(o.createdAt) = ?"
            + " WHERE u.roleID = 'US'"
            + " GROUP BY u.userID, u.fullName ORDER BY revenue DESC";
        List<UserDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new UserDTO(rs.getString("userID"), rs.getString("fullName"),
                                         rs.getInt("orderCount"), rs.getDouble("revenue")));
                }
            }
        } catch (Exception e) { log("loadStaffStatsByDay: " + e); }
        request.setAttribute("STAFF_LIST", list);
    }

    // ── Nhân viên hôm nay ────────────────────────────────────────
    // MySQL: CURDATE() thay CAST(GETDATE() AS DATE)
    private void loadStaffShift(HttpServletRequest request, String staffID) {
        String sql =
            "SELECT COUNT(*) AS totalOrders, IFNULL(SUM(amount), 0) AS totalCash"
            + " FROM tblOrders WHERE staffInput = ? AND isDeleted = 0"
            + " AND DATE(createdAt) = CURDATE()";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("TOTAL_ORDERS", rs.getInt("totalOrders"));
                    request.setAttribute("TOTAL_CASH",   fmt(rs.getDouble("totalCash")));
                }
            }
        } catch (Exception e) { log("loadStaffShift: " + e); }
    }

    // ── Nhân viên tháng ─────────────────────────────────────────
    // MySQL: MONTH(NOW()), YEAR(NOW()) thay MONTH(GETDATE()), YEAR(GETDATE())
    private void loadMonthlyStaffStats(HttpServletRequest request, String staffID) {
        String sql =
            "SELECT COUNT(*) AS monthOrders, IFNULL(SUM(amount), 0) AS monthRevenue"
            + " FROM tblOrders WHERE staffInput = ? AND isDeleted = 0"
            + " AND MONTH(createdAt) = MONTH(NOW()) AND YEAR(createdAt) = YEAR(NOW())";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("MONTH_ORDERS",  rs.getInt("monthOrders"));
                    request.setAttribute("MONTH_REVENUE", fmt(rs.getDouble("monthRevenue")));
                }
            }
        } catch (Exception e) { log("loadMonthlyStaffStats: " + e); }
    }

    // ── Nhân viên ngày chọn ─────────────────────────────────────
    private void loadDayStatsForStaff(HttpServletRequest request, String staffID, String date) {
        String sql =
            "SELECT COUNT(*) AS dayOrders, IFNULL(SUM(amount), 0) AS dayRevenue"
            + " FROM tblOrders WHERE staffInput = ? AND isDeleted = 0 AND DATE(createdAt) = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, staffID);
            ps.setString(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("DAY_ORDERS",  rs.getInt("dayOrders"));
                    request.setAttribute("DAY_REVENUE", fmt(rs.getDouble("dayRevenue")));
                }
            }
        } catch (Exception e) { log("loadDayStatsForStaff: " + e); }
    }

    // ── Lịch sử 30 ngày — nhân viên ────────────────────────────
    // MySQL: LIMIT 30 thay TOP 30, DATE_FORMAT thay CONVERT, DATE() thay CAST(.. AS DATE)
    private void loadDailyHistoryForStaff(HttpServletRequest request, String staffID) {
        String sql =
            "SELECT DATE_FORMAT(DATE(createdAt), '%d/%m/%Y') AS d,"
            + " DATE(createdAt) AS rawDate,"
            + " COUNT(*) AS cnt, IFNULL(SUM(amount), 0) AS rev"
            + " FROM tblOrders WHERE staffInput = ? AND isDeleted = 0"
            + " GROUP BY DATE(createdAt)"
            + " ORDER BY DATE(createdAt) DESC"
            + " LIMIT 30";
        List<String[]> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        rs.getString("d"),
                        rs.getString("rawDate"),
                        String.valueOf(rs.getInt("cnt")),
                        fmt(rs.getDouble("rev"))
                    });
                }
            }
        } catch (Exception e) { log("loadDailyHistoryForStaff: " + e); }
        request.setAttribute("DAILY_HISTORY", list);
    }

    // ── Đơn hàng ngày chọn — nhân viên ─────────────────────────
    private void loadOrdersOfDayForStaff(HttpServletRequest request, String staffID, String date) {
        String sql =
            "SELECT orderID, itemName, amount, senderName, senderPhone,"
            + " sendStation, receiverName, receiverPhone, receiveStation,"
            + " staffInput, tr, ct, shipStatus, note,"
            + " DATE_FORMAT(createdAt, '%H:%i:%s') AS createdTime"
            + " FROM tblOrders WHERE staffInput = ? AND isDeleted = 0 AND DATE(createdAt) = ?"
            + " ORDER BY createdAt DESC";
        List<String[]> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, staffID);
            ps.setString(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        rs.getString("orderID"),       rs.getString("itemName"),
                        fmt(rs.getDouble("amount")),
                        nvl(rs.getString("senderName")),   nvl(rs.getString("senderPhone")),
                        nvl(rs.getString("sendStation")),
                        nvl(rs.getString("receiverName")), nvl(rs.getString("receiverPhone")),
                        nvl(rs.getString("receiveStation")),
                        nvl(rs.getString("staffInput")),
                        nvl(rs.getString("tr")),           nvl(rs.getString("ct")),
                        nvl(rs.getString("shipStatus")),   nvl(rs.getString("note")),
                        nvl(rs.getString("createdTime"))
                    });
                }
            }
        } catch (Exception e) { log("loadOrdersOfDayForStaff: " + e); }
        request.setAttribute("DAY_ORDERS_LIST", list);
    }

    private String fmt(double v) { return String.format("%,.0f", v); }
    private String nvl(String s) { return s != null ? s : "-"; }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException { processRequest(req, res); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException { processRequest(req, res); }
    @Override public String getServletInfo() { return "ReportController"; }
}