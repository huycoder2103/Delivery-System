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

@WebServlet(name = "AdminController", urlPatterns = {"/AdminController"})
public class AdminController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Nếu xóa bảng tin từ home.jsp → redirect về HomeController
        String referer = request.getParameter("referer");
        String forwardTarget = "admin.jsp";
        if ("home".equals(referer)) {
            forwardTarget = "HomeController";
        }

        try {
            UserDAO userDAO = new UserDAO();

            // ── Bật/Tắt trạng thái nhân viên ─────────────────────────
            if (request.getParameter("ToggleUser") != null) {
                String uid = request.getParameter("userID");
                userDAO.toggleUserStatus(uid);

            // ── XÓA NHÂN VIÊN KHỎI DATABASE (hard delete) ────────────
            // Yêu cầu mới: xóa hẳn, không chỉ set status=0
            } else if (request.getParameter("DeleteUser") != null) {
                String uid = request.getParameter("userID");
                if ("admin".equals(uid)) {
                    request.setAttribute("ERROR_MESSAGE", "Không thể xóa tài khoản Admin chính!");
                } else {
                    try {
                        userDAO.deleteUser(uid);
                        request.setAttribute("SUCCESS_MESSAGE", "Đã xóa nhân viên: " + uid);
                    } catch (Exception e) {
                        request.setAttribute("ERROR_MESSAGE", "Xóa thất bại: " + e.getMessage());
                    }
                }

            // ── Đổi mật khẩu ─────────────────────────────────────────
            } else if (request.getParameter("ChangePassword") != null) {
                String uid     = request.getParameter("cpUserID");
                String newPass = request.getParameter("cpNewPassword");
                String confirm = request.getParameter("cpConfirmPassword");

                if (newPass == null || newPass.trim().isEmpty()) {
                    request.setAttribute("ERROR_MESSAGE", "Mật khẩu mới không được để trống!");
                } else if (!newPass.equals(confirm)) {
                    request.setAttribute("ERROR_MESSAGE", "Xác nhận mật khẩu không khớp!");
                } else {
                    boolean ok = userDAO.changePassword(uid, newPass.trim());
                    if (ok) request.setAttribute("SUCCESS_MESSAGE", "Đổi mật khẩu thành công cho: " + uid);
                    else    request.setAttribute("ERROR_MESSAGE",   "Đổi mật khẩu thất bại!");
                }

            // ── Thêm bảng tin ─────────────────────────────────────────
            } else if (request.getParameter("SaveAnnouncement") != null) {
                String title   = request.getParameter("annTitle");
                String content = request.getParameter("annContent");
                HttpSession session = request.getSession(false);
                String staffID = "admin";
                if (session != null && session.getAttribute("LOGIN_USER") != null) {
                    staffID = ((UserDTO) session.getAttribute("LOGIN_USER")).getUserID();
                }
                if (title != null && !title.trim().isEmpty()
                        && content != null && !content.trim().isEmpty()) {
                    insertAnnouncement(title.trim(), content.trim(), staffID);
                    request.setAttribute("SUCCESS_MESSAGE", "Đã đăng bảng tin mới!");
                }

            // ── Xóa bảng tin ─────────────────────────────────────────
            } else if (request.getParameter("DeleteAnnouncement") != null) {
                String annID = request.getParameter("annID");
                deleteAnnouncement(annID);
            }

            // Load lại danh sách nhân viên + bảng tin (chỉ khi forward về admin.jsp)
            if ("admin.jsp".equals(forwardTarget)) {
                request.setAttribute("USER_LIST", userDAO.getAllUsers());
                request.setAttribute("ANN_LIST",  getAllAnnouncements());
            }

        } catch (Exception e) {
            log("Error AdminController: " + e.toString());
            e.printStackTrace();
            request.setAttribute("ERROR_MESSAGE", "Lỗi hệ thống: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(forwardTarget).forward(request, response);
        }
    }

    // ── Lấy tất cả bảng tin (FIX: dùng a.id thay a.annID) ────────────────
    private List<String[]> getAllAnnouncements() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT a.id,a.title,a.content,u.fullName,"
                   + "CONVERT(NVARCHAR,a.createdAt,103) AS createdDate,a.isActive "
                   + "FROM tblAnnouncements a "
                   + "LEFT JOIN tblUsers u ON a.createdBy=u.userID "
                   + "ORDER BY a.createdAt DESC";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(new String[]{
                rs.getString("id"),
                rs.getString("title"),
                rs.getString("content"),
                rs.getString("fullName") != null ? rs.getString("fullName") : "Admin",
                rs.getString("createdDate"),
                rs.getString("isActive")
            });
        } catch (Exception e) { log("getAllAnnouncements error: " + e); }
        return list;
    }

    private void insertAnnouncement(String title, String content, String staffID) {
        String sql = "INSERT INTO tblAnnouncements(title,content,createdBy,isActive) VALUES(?,?,?,1)";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, title); ps.setString(2, content); ps.setString(3, staffID);
            ps.executeUpdate();
        } catch (Exception e) { log("insertAnnouncement error: " + e); }
    }

    // FIX: dùng id thay annID
    private void deleteAnnouncement(String annID) {
        String sql = "DELETE FROM tblAnnouncements WHERE id=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, annID);
            ps.executeUpdate();
        } catch (Exception e) { log("deleteAnnouncement error: " + e); }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
    @Override public String getServletInfo() { return "AdminController"; }
}