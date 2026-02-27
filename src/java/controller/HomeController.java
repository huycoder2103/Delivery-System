package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import utils.DBUtils;

@WebServlet(name = "HomeController", urlPatterns = {"/HomeController"})
public class HomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String url = "home.jsp";
        try {
            // Tải bản tin hệ thống (bao gồm id để nút xóa hoạt động)
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
     * Lấy danh sách thông báo đang hoạt động.
     * FIX: Thêm a.id vào SELECT để nút xóa trong home.jsp hoạt động.
     * Trả về: [0]=id, [1]=title, [2]=content, [3]=fullName, [4]=createdDate
     */
    private List<String[]> getAnnouncements() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT TOP 5 a.id, a.title, a.content, u.fullName, "
                   + "CONVERT(NVARCHAR, a.createdAt, 103) AS createdDate "
                   + "FROM tblAnnouncements a "
                   + "LEFT JOIN tblUsers u ON a.createdBy = u.userID "
                   + "WHERE a.isActive = 1 "
                   + "ORDER BY a.createdAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("id"),           // [0] dùng cho nút xóa
                    rs.getString("title"),        // [1]
                    rs.getString("content"),      // [2]
                    rs.getString("fullName") != null ? rs.getString("fullName") : "Admin", // [3]
                    rs.getString("createdDate")   // [4]
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