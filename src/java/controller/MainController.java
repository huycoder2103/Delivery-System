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
 * @author ADMIN
 */
@WebServlet(name = "MainController",
        urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    // --- CÁC ĐÍCH ĐẾN TĨNH (JSP) ---
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String HOME_PAGE = "home.jsp";
    private static final String GOODS_PAGE = "goods.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    // --- CÁC BỘ ĐIỀU PHỐI (CONTROLLERS) ---
    private static final String LOGIN_CONTROLLER = "LoginController";
    private static final String LOGOUT_CONTROLLER = "LogoutController";
    private static final String HOME_CONTROLLER = "HomeController";
    private static final String GOODS_CONTROLLER = "GoodsController";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Đảm bảo đọc tiếng Việt từ Form

        String url = LOGIN_PAGE;

        try {

            // --- 1. NHÓM HỆ THỐNG & TÀI KHOẢN ---
            if (request.getParameter("Login") != null) {
                url = LOGIN_CONTROLLER;
            } else if (request.getParameter("Logout") != null) {
                url = LOGIN_PAGE;
            } else if (request.getParameter("ChangePassword") != null) {
                url = "ChangePasswordController";
            } // --- 2. NHÓM ĐIỀU HƯỚNG TRANG CHÍNH (HOME & TIÊU ĐIỂM) ---
            else if (request.getParameter("GoHome") != null) {
                url = HOME_PAGE;
            } else if (request.getParameter("ViewGoods") != null) {
                url = GOODS_PAGE;
            } else if (request.getParameter("AdminPanel") != null || request.getParameter("ViewReports") != null) {
                url = HOME_CONTROLLER;
            } // --- 3. NHÓM NGHIỆP VỤ HÀNG HÓA (FORWARD SANG GOODSCONTROLLER) ---
            else if (request.getParameter("CreateOrder") != null
                    || request.getParameter("ViewOrderList") != null
                    || request.getParameter("ViewTripList") != null
                    || request.getParameter("ViewArrivalTripList") != null
                    || request.getParameter("AddArrivalTrip") != null
                    || request.getParameter("AddTrip") != null
                    || request.getParameter("ViewOrderReport") != null) {
                url = GOODS_CONTROLLER;
            } // --- 4. NHÓM XỬ LÝ TRONG BẢNG (LIST HÀNG, NHẬN XE, SỬA...) ---
            else if (request.getParameter("ListHang") != null
                    || request.getParameter("ReceiveTrip") != null
                    || request.getParameter("ShipOrder") != null
                    || request.getParameter("EditOrder") != null
                    || request.getParameter("TransferGoods") != null
                    || request.getParameter("EditTrip") != null) {
                url = GOODS_CONTROLLER;
            } // --- 5. NHÓM LƯU DỮ LIỆU (SAVE ACTIONS) ---
            else if (request.getParameter("SaveOrder") != null) {
                url = "SaveOrderController";
            } else if (request.getParameter("SaveNewTrip") != null) {
                url = "SaveTripController";
            } else if (request.getParameter("SaveArrivalTrip") != null) {
                url = "SaveArrivalController";
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
