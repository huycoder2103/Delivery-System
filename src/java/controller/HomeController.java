/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
            // Tải bản tin hệ thống từ database
            List<String[]> newsList = getAnnouncements();
            request.setAttribute("NEWS_LIST", newsList);

            // Điều hướng trang
            if (request.getParameter("ViewGoods") != null) {
                url = "goods.jsp";
            } else if (request.getParameter("ViewReports") != null) {
                url = "ReportController";
            } else if (request.getParameter("ViewOrderReport") != null) {
                url = "ReportController";
            }
            // GoHome → mặc định home.jsp với news

        } catch (Exception e) {
            log("Error at HomeController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    /** Lấy danh sách thông báo đang hoạt động từ DB */
    private List<String[]> getAnnouncements() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT TOP 5 a.title, a.content, u.fullName, "
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
