/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.TripDAO;
import dto.UserDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * SaveArrivalController - Lưu thông tin chuyến xe đến.
 * Thực chất là tạo một chuyến xe mới với hướng đi ngược lại,
 * hoặc cập nhật chuyến xe đã tạo sang trạng thái "Đã đến".
 *
 * Hiện tại: Tạo chuyến xe mới từ form create_arrival_trip.jsp
 * (Tương tự SaveTrip nhưng dành cho hướng xe về trạm)
 */
@WebServlet(name = "SaveArrivalController", urlPatterns = {"/SaveArrivalController"})
public class SaveArrivalController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String url = "GoodsController?ViewArrivalTripList=true";

        try {
            String truckID   = request.getParameter("truckID");
            String dep       = request.getParameter("departure");
            String des       = request.getParameter("destination");
            String time      = request.getParameter("departureTime");
            String driver    = request.getParameter("driver");
            String assistant = request.getParameter("assistant");
            String notes     = request.getParameter("note");

            // Lấy staff ID từ session
            HttpSession session = request.getSession(false);
            String staffID = "NV01";
            if (session != null && session.getAttribute("LOGIN_USER") != null) {
                staffID = ((UserDTO) session.getAttribute("LOGIN_USER")).getUserID();
            }

            if (truckID != null && !truckID.isEmpty()) {
                TripDAO dao = new TripDAO();
                dao.insertTrip(truckID, dep, des, time, driver, assistant, staffID, notes);
            }

        } catch (Exception e) {
            log("Error at SaveArrivalController: " + e.toString());
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
