/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String url = LOGIN_PAGE;

        try {
            // 1. Nhóm Login/Logout
            if (request.getParameter("Login") != null) {
                url = "LoginController";
            } else if (request.getParameter("Logout") != null) {
                url = LOGIN_PAGE;
            } 
            
            // 2. Nhóm Home & Admin
            else if (request.getParameter("GoHome") != null || request.getParameter("ViewReports") != null) {
                url = "HomeController";
            } else if (request.getParameter("AdminPanel") != null) {
                HttpSession session = request.getSession(false);
                String role = (session != null) ? (String) session.getAttribute("ROLE") : null;
                if ("AD".equals(role)) {
                    url = "AdminController";
                } else {
                    request.setAttribute("ERROR_MESSAGE", "Bạn không có quyền truy cập khu vực Quản trị!");
                    url = "home.jsp";
                }
            } 
            
            // 3. Nhóm GoodsController (Sử dụng toán tử || để gộp các hành động cùng đích đến)
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
                url = "GoodsController";
            } 
            
            // 4. Các Controller xử lý Save dữ liệu & Trang tĩnh
            else if (request.getParameter("ViewGoods") != null) {
                url = "goods.jsp";
            } else if (request.getParameter("SaveOrder") != null) {
                url = "SaveOrderController";
            } else if (request.getParameter("SaveNewTrip") != null) {
                url = "SaveTripController";
            } else if (request.getParameter("SaveArrivalTrip") != null) {
                url = "SaveArrivalController";
            } else if (request.getParameter("SaveUser") != null) {
                url = "CreateUserController";
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
