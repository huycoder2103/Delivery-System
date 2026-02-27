/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
        try {
            // ── Nhân viên ────────────────────────────────────────────────
            if (request.getParameter("ToggleUser") != null) {
                String uid = request.getParameter("userID");
                new UserDAO().toggleUserStatus(uid);

            } else if (request.getParameter("DeleteUser") != null) {
                String uid = request.getParameter("userID");
                new UserDAO().deactivateUser(uid);

            // ── Bảng tin: Thêm mới ───────────────────────────────────────
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
                }

            // ── Bảng tin: Xóa ────────────────────────────────────────────
            } else if (request.getParameter("DeleteAnnouncement") != null) {
                String annID = request.getParameter("annID");
                deleteAnnouncement(annID);
            }

            // Luôn load lại danh sách nhân viên + bảng tin
            List<UserDTO> userList = new UserDAO().getAllUsers();
            request.setAttribute("USER_LIST", userList);

            List<String[]> annList = getAllAnnouncements();
            request.setAttribute("ANN_LIST", annList);

        } catch (Exception e) {
            log("Error at AdminController: " + e.toString());
        } finally {
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        }
    }

    // ── Lấy tất cả bảng tin ──────────────────────────────────────────────
    private List<String[]> getAllAnnouncements() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT a.annID, a.title, a.content, u.fullName, "
                   + "CONVERT(NVARCHAR, a.createdAt, 103) AS createdDate, a.isActive "
                   + "FROM tblAnnouncements a "
                   + "LEFT JOIN tblUsers u ON a.createdBy = u.userID "
                   + "ORDER BY a.createdAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("annID"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("fullName") != null ? rs.getString("fullName") : "Admin",
                    rs.getString("createdDate"),
                    rs.getString("isActive")
                });
            }
        } catch (Exception e) {
            log("Error getAllAnnouncements: " + e.toString());
        }
        return list;
    }

    // ── Thêm bảng tin mới ────────────────────────────────────────────────
    private void insertAnnouncement(String title, String content, String staffID) {
        String sql = "INSERT INTO tblAnnouncements (title, content, createdBy, isActive) "
                   + "VALUES (?, ?, ?, 1)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, staffID);
            ps.executeUpdate();
        } catch (Exception e) {
            log("Error insertAnnouncement: " + e.toString());
        }
    }

    // ── Xóa bảng tin ─────────────────────────────────────────────────────
    private void deleteAnnouncement(String annID) {
        String sql = "DELETE FROM tblAnnouncements WHERE annID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, annID);
            ps.executeUpdate();
        } catch (Exception e) {
            log("Error deleteAnnouncement: " + e.toString());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    public String getServletInfo() { return "AdminController"; }
}