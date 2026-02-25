/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.StationDAO;
import dto.StationDTO;
import dao.TruckDAO;
import dto.TruckDTO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "GoodsController", urlPatterns = {"/GoodsController"})
public class GoodsController extends HttpServlet {

    private static final String ORDER_LIST_PAGE = "list_order.jsp";
    private static final String CREATE_ORDER_PAGE = "create_order.jsp";
    private static final String TRIP_LIST_PAGE = "list_trip.jsp";
    private static final String TRIP_CREATE_PAGE = "create_trip.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String url = ORDER_LIST_PAGE;
        try {
            // 1. Xử lý khi nhấn nút "NHẬN HÀNG" (CreateOrder)
            if (request.getParameter("CreateOrder") != null) {
                StationDAO dao = new StationDAO();
                List<StationDTO> list = dao.getAllStations();
                request.setAttribute("STATION_LIST", list);
                url = CREATE_ORDER_PAGE;
            } 
            // 2. Xử lý khi nhấn nút "THÊM CHUYẾN XE" (AddTrip)
            else if (request.getParameter("AddTrip") != null) {
                StationDAO sDao = new StationDAO();
                TruckDAO tDao = new TruckDAO();
                request.setAttribute("STATION_LIST", sDao.getAllStations());
                request.setAttribute("TRUCK_LIST", tDao.getAvailableTrucks());
                url = TRIP_CREATE_PAGE;
            }
            // 3. Các hành động khác (Xem danh sách, tìm kiếm...)
            else if (request.getParameter("ViewOrderList") != null) {
                url = ORDER_LIST_PAGE;
            }
            else if (request.getParameter("ViewTripList") != null) {
                url = TRIP_LIST_PAGE;
            }

        } catch (Exception e) {
            log("Error at GoodsController: " + e.toString());
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
