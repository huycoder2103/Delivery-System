/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author HuyNHSE190240
 */
@WebServlet(name = "GoodsController", urlPatterns = {"/GoodsController"})
public class GoodsController extends HttpServlet {

    // --- ĐỊNH NGHĨA CÁC ĐÍCH ĐẾN JSP ---
    private static final String ORDER_LIST_PAGE = "list_order.jsp";
    private static final String CREATE_ORDER_PAGE = "create_order.jsp";
    private static final String TRIP_LIST_PAGE = "list_trip.jsp";
    private static final String TRIP_CREATE_PAGE = "create_trip.jsp";
    private static final String ARRIVAL_TRIP_PAGE = "list_arrival_trip.jsp";
    private static final String ARRIVAL_TRIP_CREATE_PAGE = "create_arrival_trip.jsp";
    private static final String REPORT_PAGE = "order_report.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Mặc định url
        String url = ORDER_LIST_PAGE;

        try {
            // --- 1. NHÓM ĐƠN HÀNG (ORDERS) ---
            if (request.getParameter("ViewOrderList") != null || request.getParameter("FilterOrder") != null) {
                // TODO: List<OrderDTO> list = dao.getAllOrders();
                // request.setAttribute("ORDER_LIST", list);
                url = ORDER_LIST_PAGE;
            } else if (request.getParameter("CreateOrder") != null) {
                url = CREATE_ORDER_PAGE;
            } else if (request.getParameter("ViewOrderReport") != null) {
                url = REPORT_PAGE;
            } 
            // --- 2. NHÓM CHUYẾN XE ĐI (DEPARTURE TRIPS) ---
            else if (request.getParameter("ViewTripList") != null) {
                // TODO: Gọi TripDAO lấy danh sách chuyến xe đi
                url = TRIP_LIST_PAGE;
            } else if (request.getParameter("AddTrip") != null) {
                url = TRIP_CREATE_PAGE;
            } 
            // --- 3. NHÓM CHUYẾN XE ĐẾN (ARRIVAL TRIPS) ---
            else if (request.getParameter("ViewArrivalTripList") != null) {
                // TODO: Gọi TripDAO lấy danh sách chuyến xe đến
                url = ARRIVAL_TRIP_PAGE;
            } else if (request.getParameter("AddArrivalTrip") != null) {
                url = ARRIVAL_TRIP_CREATE_PAGE;
            } 
            // --- 4. NHÓM XỬ LÝ TRONG BẢNG (HANDLING ACTIONS) ---
            else if (request.getParameter("ListHang") != null) {
                String tripID = request.getParameter("tripID");
                // TODO: Lấy danh sách hàng hóa thuộc tripID này
                url = "list_goods_by_trip.jsp"; // Ví dụ trang hiển thị hàng theo xe
            } else if (request.getParameter("ReceiveTrip") != null) {
                String tripID = request.getParameter("tripID");
                // TODO: Thực hiện logic xác nhận nhận xe
                url = "MainController?ViewArrivalTripList=true"; // Quay lại danh sách đến
            } else if (request.getParameter("ShipOrder") != null) {
                String orderID = request.getParameter("orderID");
                // TODO: Thực hiện logic chuyển trạng thái đơn hàng
                url = "MainController?ViewOrderList=true"; // Quay lại danh sách đơn hàng
            } else if (request.getParameter("EditOrder") != null) {
                // TODO: Load dữ liệu đơn hàng cũ và vào trang sửa
                url = "edit_order.jsp";
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
