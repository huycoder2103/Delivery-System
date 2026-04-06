package controller;

import dao.ShiftDAO;
import dao.ReportDAO;
import dto.ShiftDTO;
import dto.ReportSummaryDTO;
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

@WebServlet(name = "HomeController", urlPatterns = {"/HomeController"})
public class HomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        UserDTO loginUser = (session != null) ? (UserDTO) session.getAttribute("LOGIN_USER") : null;

        String url = "home.jsp";
        try {
            if (loginUser != null) {
                // 1. Kiểm tra và cập nhật ca hiện tại vào session
                ShiftDAO shiftDAO = new ShiftDAO();
                ShiftDTO currentShift = shiftDAO.getActiveShift(loginUser.getUserID());
                session.setAttribute("CURRENT_SHIFT", currentShift);

                // 2. Nếu đang trong ca, lấy báo cáo tóm tắt
                if (currentShift != null) {
                    ReportDAO reportDAO = new ReportDAO();
                    ReportSummaryDTO shiftSummary = reportDAO.getSummaryByShift(currentShift.getShiftID());
                    request.setAttribute("SHIFT_SUMMARY", shiftSummary);
                }
            }

            List<String[]> newsList = getAnnouncements();
            request.setAttribute("NEWS_LIST", newsList);

            if (request.getParameter("ViewGoods") != null) {
                url = "goods.jsp";
            } else if (request.getParameter("ViewReports") != null
                    || request.getParameter("ViewOrderReport") != null) {
                url = "ReportController";
            }

        } catch (Exception e) {
            log("Error at HomeController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    /**
     * MySQL: LIMIT thay TOP, DATE_FORMAT thay CONVERT, bỏ N'' prefix,
     * isActive = 1 giữ nguyên (MySQL dùng số 0/1 cho boolean)
     */
    private List<String[]> getAnnouncements() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT a.id, a.title, a.content, u.fullName, "
                + "DATE_FORMAT(a.createdAt, '%d/%m/%Y') AS createdDate "
                + "FROM tblAnnouncements a "
                + "LEFT JOIN tblUsers u ON a.createdBy = u.userID "
                + "WHERE a.isActive = 1 "
                + "ORDER BY a.createdAt DESC "
                + "LIMIT 5";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("fullName") != null ? rs.getString("fullName") : "Admin",
                    rs.getString("createdDate")
                });
            }
        } catch (Exception e) {
            // Không crash trang chủ nếu DB lỗi
        }
        return list;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    public String getServletInfo() { return "HomeController"; }
}