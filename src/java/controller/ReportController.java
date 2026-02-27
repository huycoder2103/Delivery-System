/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jayke
 */
import dao.OrderDAO;
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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            HttpSession session = request.getSession(false);
            String role = (session != null) ? (String) session.getAttribute("ROLE") : "US";
            UserDTO loginUser = (session != null) ? (UserDTO) session.getAttribute("LOGIN_USER") : null;

            if ("AD".equals(role)) {
                // ── Admin: xem toàn hệ thống ──────────────────────────────
                loadAdminStats(request);
                loadStaffStats(request);
            } else {
                // ── Nhân viên: xem ca của mình ────────────────────────────
                String staffID = (loginUser != null) ? loginUser.getUserID() : "NV01";
                loadStaffShift(request, staffID);
            }
        } catch (Exception e) {
            log("Error at ReportController: " + e.toString());
        } finally {
            request.getRequestDispatcher("report.jsp").forward(request, response);
        }
    }

    /** Thống kê tổng quát cho Admin */
    private void loadAdminStats(HttpServletRequest request) {
        String sql = "SELECT "
                   + "  COUNT(*) AS totalOrders, "
                   + "  SUM(CASE WHEN tr=N'Đã Nhận' THEN 1 ELSE 0 END) AS completedOrders, "
                   + "  SUM(CASE WHEN tr=N'Chưa Chuyển' THEN 1 ELSE 0 END) AS pendingOrders, "
                   + "  ISNULL(SUM(amount),0) AS totalRevenue, "
                   + "  SUM(CASE WHEN CAST(createdAt AS DATE)=CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) AS todayOrders, "
                   + "  ISNULL(SUM(CASE WHEN CAST(createdAt AS DATE)=CAST(GETDATE() AS DATE) THEN amount ELSE 0 END),0) AS todayRevenue "
                   + "FROM tblOrders WHERE isDeleted=0";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                request.setAttribute("TOTAL_ORDERS",     rs.getInt("totalOrders"));
                request.setAttribute("COMPLETED_ORDERS", rs.getInt("completedOrders"));
                request.setAttribute("PENDING_ORDERS",   rs.getInt("pendingOrders"));
                request.setAttribute("TOTAL_REVENUE",    formatMoney(rs.getDouble("totalRevenue")));
                request.setAttribute("TODAY_ORDERS",     rs.getInt("todayOrders"));
                request.setAttribute("TODAY_REVENUE",    formatMoney(rs.getDouble("todayRevenue")));
            }
        } catch (Exception e) { /* silent */ }
    }

    /** Thống kê hiệu suất từng nhân viên cho Admin */
    private void loadStaffStats(HttpServletRequest request) {
        String sql = "SELECT u.userID, u.fullName, "
                   + "  COUNT(o.orderID) AS orderCount, "
                   + "  ISNULL(SUM(o.amount),0) AS revenue "
                   + "FROM tblUsers u "
                   + "LEFT JOIN tblOrders o ON u.userID=o.staffInput AND o.isDeleted=0 "
                   + "WHERE u.roleID='US' "
                   + "GROUP BY u.userID, u.fullName "
                   + "ORDER BY revenue DESC";
        List<UserDTO> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UserDTO u = new UserDTO(
                    rs.getString("userID"),
                    rs.getString("fullName"),
                    rs.getInt("orderCount"),
                    rs.getDouble("revenue")
                );
                list.add(u);
            }
        } catch (Exception e) { /* silent */ }
        request.setAttribute("STAFF_LIST", list);
    }

    /** Thống kê ca làm việc của nhân viên (tính theo ngày hôm nay) */
    private void loadStaffShift(HttpServletRequest request, String staffID) {
        String sql = "SELECT COUNT(*) AS totalOrders, ISNULL(SUM(amount),0) AS totalCash "
                   + "FROM tblOrders WHERE staffInput=? AND isDeleted=0 "
                   + "AND CAST(createdAt AS DATE)=CAST(GETDATE() AS DATE)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("TOTAL_ORDERS", rs.getInt("totalOrders"));
                    request.setAttribute("TOTAL_CASH",   formatMoney(rs.getDouble("totalCash")));
                }
            }
        } catch (Exception e) { /* silent */ }
        request.setAttribute("CANCELLED_ORDERS", 0);
    }

    /** Format số tiền có dấu phân cách hàng nghìn */
    private String formatMoney(double amount) {
        return String.format("%,.0f", amount);
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
