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
import javax.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "MainController",
        urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    private static final String HOME_CONTROLLER = "HomeController";
    private static final String GOODS_CONTROLLER = "GoodsController";
    private static final String LOGIN_CONTROLLER = "LoginController";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String url = LOGIN_PAGE;

        try {
            // --- 1. XỬ LÝ QUYỀN TRUY CẬP QUẢN TRỊ (ADMIN PANEL) ---
            if (request.getParameter("AdminPanel") != null) {
                HttpSession session = request.getSession(false);
                String role = (session != null) ? (String) session.getAttribute("ROLE") : null;

                if ("AD".equals(role)) {
                    url = "admin.jsp"; // Cho phép nếu là Admin
                } else {
                    // Nếu là nhân viên (US) hoặc khách, báo lỗi và giữ ở Home
                    request.setAttribute("ERROR_MESSAGE", "Bạn không có quyền truy cập khu vực Quản trị!");
                    url = "home.jsp";
                }
            } // --- 2. NHÓM ĐIỀU PHỐI VỀ LOGIN CONTROLLER ---
            else if (request.getParameter("Login") != null) {
                url = LOGIN_CONTROLLER;
            } // --- 3. NHÓM ĐIỀU PHỐI VỀ HOME CONTROLLER (TRÙNG ĐÍCH ĐẾN) ---
            else if (request.getParameter("GoHome") != null
                    || request.getParameter("ViewReports") != null) {
                url = HOME_CONTROLLER;
            } // --- 4. NHÓM ĐIỀU PHỐI VỀ GOODS CONTROLLER (TẤT CẢ NGHIỆP VỤ HÀNG HÓA) ---
            else if (request.getParameter("ViewOrderList") != null
                    || request.getParameter("CreateOrder") != null
                    || request.getParameter("SearchOrderByPhone") != null
                    || request.getParameter("SearchTripByTruck") != null
                    || request.getParameter("SearchArrivalByTruck") != null
                    || request.getParameter("ViewTripList") != null
                    || request.getParameter("ViewArrivalTripList") != null
                    || request.getParameter("AddArrivalTrip") != null
                    || request.getParameter("AddTrip") != null
                    || request.getParameter("ViewOrderReport") != null
                    || request.getParameter("ListHang") != null
                    || request.getParameter("ReceiveTrip") != null
                    || request.getParameter("ShipOrder") != null
                    || request.getParameter("EditOrder") != null
                    || request.getParameter("TransferGoods") != null
                    || request.getParameter("EditTrip") != null) {
                url = GOODS_CONTROLLER;
            } // --- 5. CÁC TRANG JSP TĨNH KHÁC ---
            else if (request.getParameter("ViewGoods") != null) {
                url = "goods.jsp";
            } else if (request.getParameter("Logout") != null) {
                url = LOGIN_PAGE;
            } // --- 6. NHÓM LƯU DỮ LIỆU (CÁC CONTROLLER RIÊNG BIỆT) ---
            else if (request.getParameter("SaveOrder") != null) {
                url = "SaveOrderController";
            } else if (request.getParameter("SaveNewTrip") != null) {
                url = "SaveTripController";
            } else if (request.getParameter("SaveArrivalTrip") != null) {
                url = "SaveArrivalController";
            } else if (request.getParameter("SaveUser") != null) {
                url = "admin.jsp";
            }

        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
            url = ERROR_PAGE;
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     *
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException,
            IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     *
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException,
            IOException {
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
