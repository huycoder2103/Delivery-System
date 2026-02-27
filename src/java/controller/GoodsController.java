/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import dao.StationDAO;
import dao.TripDAO;
import dao.TruckDAO;
import dto.OrderDTO;
import dto.StationDTO;
import dto.TruckDTO;
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

@WebServlet(name = "GoodsController", urlPatterns = {"/GoodsController"})
public class GoodsController extends HttpServlet {

    private static final String ORDER_LIST_PAGE   = "list_order.jsp";
    private static final String CREATE_ORDER_PAGE = "create_order.jsp";
    private static final String TRIP_LIST_PAGE    = "list_trip.jsp";
    private static final String TRIP_CREATE_PAGE  = "create_trip.jsp";
    private static final String ARRIVAL_LIST_PAGE = "list_arrival_trip.jsp";
    private static final String ARRIVAL_CREATE    = "create_arrival_trip.jsp";
    private static final String ERROR_PAGE        = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String url = ORDER_LIST_PAGE;
        try {
            // ── Tạo đơn hàng mới ──────────────────────────────────────────
            if (request.getParameter("CreateOrder") != null
                    || request.getParameter("FilterOrder") != null) {
                url = CREATE_ORDER_PAGE;

            // ── Danh sách đơn hàng ────────────────────────────────────────
            } else if (request.getParameter("ViewOrderList") != null) {
                loadOrderList(request);
                url = ORDER_LIST_PAGE;

            // ── Tìm đơn theo số điện thoại ────────────────────────────────
            } else if (request.getParameter("SearchOrderByPhone") != null) {
                String phone = request.getParameter("searchPhone");
                OrderDAO dao = new OrderDAO();
                List<OrderDTO> list = dao.searchOrderByPhone(phone);
                request.setAttribute("ORDER_LIST", list);
                request.setAttribute("TOTAL_COUNT", list.size());
                url = ORDER_LIST_PAGE;

            // ── Xóa đơn hàng ──────────────────────────────────────────────
            } else if (request.getParameter("DeleteOrder") != null) {
                String orderID = request.getParameter("orderID");
                new OrderDAO().deleteOrder(orderID);
                loadOrderList(request);
                url = ORDER_LIST_PAGE;

            // ── Sửa đơn hàng (load dữ liệu lên form) ─────────────────────
            } else if (request.getParameter("EditOrder") != null) {
                String orderID = request.getParameter("orderID");
                OrderDAO dao = new OrderDAO();
                OrderDTO order = dao.getOrderByID(orderID);
                request.setAttribute("EDIT_ORDER", order);
                url = CREATE_ORDER_PAGE;   // Dùng lại trang nhập, detect bằng EDIT_ORDER

            // ── Tạo chuyến xe mới ─────────────────────────────────────────
            } else if (request.getParameter("AddTrip") != null) {
                // Nạp danh sách xe rảnh & trạm
                loadTrucksAndStations(request);
                url = TRIP_CREATE_PAGE;

            // ── Danh sách chuyến xe đi ────────────────────────────────────
            } else if (request.getParameter("ViewTripList") != null) {
                loadTripList(request);
                url = TRIP_LIST_PAGE;

            // ── Tìm chuyến xe theo biển số ────────────────────────────────
            } else if (request.getParameter("SearchTripByTruck") != null) {
                String truck = request.getParameter("searchTruck");
                loadTripList(request, truck, null);
                url = TRIP_LIST_PAGE;

            // ── Danh sách chuyến xe đến ───────────────────────────────────
            } else if (request.getParameter("ViewArrivalTripList") != null) {
                loadArrivalList(request);
                url = ARRIVAL_LIST_PAGE;

            // ── Tìm chuyến xe đến theo biển số ───────────────────────────
            } else if (request.getParameter("SearchArrivalByTruck") != null) {
                String truck = request.getParameter("searchArrivalTruck");
                loadArrivalList(request, truck);
                url = ARRIVAL_LIST_PAGE;

            // ── Thêm chuyến xe đến (form) ─────────────────────────────────
            } else if (request.getParameter("AddArrivalTrip") != null) {
                loadTrucksAndStations(request);
                url = ARRIVAL_CREATE;

            // ── Chuyển hàng lên chuyến xe ────────────────────────────────
            } else if (request.getParameter("ShipOrder") != null) {
                String orderID = request.getParameter("orderID");
                new OrderDAO().updateOrderStatus(orderID, "Đã Chuyển");
                loadOrderList(request);
                url = ORDER_LIST_PAGE;

            // ── Nhận xe về trạm ───────────────────────────────────────────
            } else if (request.getParameter("ReceiveTrip") != null) {
                String tripID = request.getParameter("tripID");
                new TripDAO().updateTripStatus(tripID, "Đã đến");
                loadArrivalList(request);
                url = ARRIVAL_LIST_PAGE;

            // ── Sửa chuyến xe ─────────────────────────────────────────────
            } else if (request.getParameter("EditTrip") != null) {
                String tripID = request.getParameter("tripID");
                // Tải dữ liệu chuyến xe lên form (để trống chưa làm sửa phức tạp)
                loadTrucksAndStations(request);
                url = TRIP_CREATE_PAGE;

            // ── Mặc định: vào goods.jsp ──────────────────────────────────
            } else if (request.getParameter("ListHang") != null) {
                // Chức năng List Hàng theo chuyến (có thể mở rộng sau)
                String tripID = request.getParameter("tripID");
                List<OrderDTO> orders = new OrderDAO().getOrdersByTrip(tripID);
                request.setAttribute("ORDER_LIST", orders);
                request.setAttribute("TOTAL_COUNT", orders.size());
                url = ORDER_LIST_PAGE;

            } else {
                loadOrderList(request);
            }

        } catch (Exception e) {
            log("Error at GoodsController: " + e.toString());
            request.setAttribute("ERROR_MESSAGE", "Lỗi hệ thống: " + e.getMessage());
            url = ERROR_PAGE;
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────

    /** Tải danh sách đơn hàng đầy đủ vào request */
    private void loadOrderList(HttpServletRequest request) throws Exception {
        loadOrderList(request, null, null, null);
    }

    private void loadOrderList(HttpServletRequest request,
                               String stationFilter,
                               String dateFilter,
                               String statusFilter) throws Exception {
        OrderDAO dao = new OrderDAO();
        List<OrderDTO> list = dao.getAllOrders();
        request.setAttribute("ORDER_LIST", list);
        request.setAttribute("TOTAL_COUNT", list.size());
    }

    /** Tải danh sách chuyến xe đi */
    private void loadTripList(HttpServletRequest request) throws Exception {
        loadTripList(request, null, null);
    }

    private void loadTripList(HttpServletRequest request, String truckFilter, String stationFilter)
            throws Exception {
        String sql;
        List<Object> params = new ArrayList<>();

        if (truckFilter != null && !truckFilter.isEmpty()) {
            sql = "SELECT tripID, (departure+N' → '+destination) AS route, departure, destination, "
                + "truckID, staffCreated, CONVERT(NVARCHAR,createdAt,120) AS createdAt FROM tblTrips "
                + "WHERE truckID LIKE ? ORDER BY createdAt DESC";
            params.add("%" + truckFilter + "%");
        } else {
            sql = "SELECT tripID, (departure+N' → '+destination) AS route, departure, destination, "
                + "truckID, staffCreated, CONVERT(NVARCHAR,createdAt,120) AS createdAt FROM tblTrips "
                + "ORDER BY createdAt DESC";
        }

        List<String[]> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        rs.getString("tripID"),
                        rs.getString("route"),
                        rs.getString("departure"),
                        rs.getString("destination"),
                        rs.getString("truckID"),
                        rs.getString("staffCreated"),
                        rs.getString("createdAt")
                    });
                }
            }
        }
        request.setAttribute("TRIP_LIST", list);
    }

    /** Tải danh sách chuyến xe đến (xe đang đi = status=0) */
    private void loadArrivalList(HttpServletRequest request) throws Exception {
        loadArrivalList(request, null);
    }

    private void loadArrivalList(HttpServletRequest request, String truckFilter) throws Exception {
        String sql;
        if (truckFilter != null && !truckFilter.isEmpty()) {
            sql = "SELECT tripID, departure, destination, (departure+N'→'+destination) AS route, "
                + "truckID, staffCreated, CONVERT(NVARCHAR,createdAt,120) AS createdAt, departureTime, status "
                + "FROM tblTrips WHERE truckID LIKE ? ORDER BY createdAt DESC";
        } else {
            sql = "SELECT tripID, departure, destination, (departure+N'→'+destination) AS route, "
                + "truckID, staffCreated, CONVERT(NVARCHAR,createdAt,120) AS createdAt, departureTime, status "
                + "FROM tblTrips ORDER BY createdAt DESC";
        }

        List<String[]> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (truckFilter != null && !truckFilter.isEmpty())
                ps.setString(1, "%" + truckFilter + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        rs.getString("tripID"),
                        rs.getString("departure"),
                        rs.getString("destination"),
                        rs.getString("route"),
                        rs.getString("truckID"),
                        rs.getString("staffCreated"),
                        rs.getString("createdAt"),
                        rs.getString("departureTime"),
                        rs.getString("status"),
                        rs.getString("status")   // index 9 = status dùng để render nút
                    });
                }
            }
        }
        request.setAttribute("ARRIVAL_LIST", list);
    }

    /** Nạp danh sách xe rảnh & các trạm vào request */
    private void loadTrucksAndStations(HttpServletRequest request) throws Exception {
        request.setAttribute("TRUCK_LIST",   new TruckDAO().getAvailableTrucks());
        request.setAttribute("STATION_LIST", new StationDAO().getAllStations());
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
