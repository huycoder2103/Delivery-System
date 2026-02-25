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
 * @author HuyNHSE190240
 */
@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    private static final String SUCCESS = "home.jsp";
    private static final String ERROR = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Đảm bảo không lỗi font

        String url = ERROR;

        try {
            String userID = request.getParameter("userID");
            String password = request.getParameter("password");
            HttpSession session = request.getSession();

            // 1. KIỂM TRA TÀI KHOẢN ADMIN
            if ("admin".equals(userID) && "1".equals(password)) {
                session.setAttribute("FULLNAME", "Nguyễn Hoàng Huy (Admin)");
                session.setAttribute("ROLE", "AD"); // AD đại diện cho Admin
                session.setAttribute("EMAIL", "huy@delivery.com");
                url = SUCCESS;
            } // 2. KIỂM TRA TÀI KHOẢN NHÂN VIÊN (MỚI THÊM)
            else if ("us".equals(userID) && "1".equals(password)) {
                session.setAttribute("FULLNAME", "Nhân Viên Chính Thức");
                session.setAttribute("ROLE", "US"); // US đại diện cho User/Nhân viên
                session.setAttribute("EMAIL", "staff@delivery.com");
                url = SUCCESS;
            } // 3. SAI TÀI KHOẢN HOẶC MẬT KHẨU
            else {
                request.setAttribute("ERROR_MESSAGE", "Tài khoản hoặc mật khẩu không chính xác!");
                url = ERROR;
            }
        } catch (Exception e) {
            log("Error at LoginController: " + e.toString());
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
