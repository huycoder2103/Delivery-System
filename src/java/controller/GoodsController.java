package controller;

import dao.OrderDAO;
import dao.TruckDAO;
import dao.TripDAO;
import dao.StationDAO;
import dto.OrderDTO;
import dto.TruckDTO;
import dto.TripDTO;
import dto.StationDTO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "GoodsController", urlPatterns = {"/GoodsController"})
public class GoodsController extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private StationDAO stationDAO = new StationDAO();
    private TripDAO tripDAO = new TripDAO();
    private TruckDAO trucDAO = new TruckDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String url = "list_order.jsp";

//        HttpSession session = request.getSession(false);
//
//        if (session == null || session.getAttribute("user") == null) {
//            response.sendRedirect("login.jsp");
//            return;
//        }

        try {

            // ════════════════════════════════════════════════════════════
            // A. DANH SÁCH ĐƠN HÀNG
            // ════════════════════════════════════════════════════════════
            if (request.getParameter("ViewOrderList") != null) {

                handleListOrder(request);
                url = "list_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // B. LỌC ĐƠN HÀNG
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("FilterOrder") != null) {

                handleFilterOrder(request);
                url = "list_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // C. TÌM ĐƠN HÀNG THEO PHONE
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("SearchOrderByPhone") != null) {

                handleSearchByPhone(request);
                url = "list_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // D. TẠO ĐƠN HÀNG (LOAD FORM)
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("CreateOrder") != null) {

                loadStations(request);
                url = "create_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // E. SỬA ĐƠN HÀNG (LOAD FORM)
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("EditOrder") != null) {

                handleEditOrder(request);
                url = "edit_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // F. LƯU SỬA ĐƠN HÀNG
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("UpdateOrder") != null) {

                handleUpdateOrder(request);
                handleListOrder(request);
                url = "list_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // G. XÓA ĐƠN HÀNG
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("DeleteOrder") != null) {

                handleDeleteOrder(request);
                handleListOrder(request);
                url = "list_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // H. CHUYỂN HÀNG (SHIP)
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("ShipOrder") != null) {

                handleShipOrder(request);
                url = "ship_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // I. GÁN ĐƠN LÊN CHUYẾN XE
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("AssignOrderToTrip") != null) {

                handleAssignTrip(request);
                handleListOrder(request);
                url = "list_order.jsp";

            } // ════════════════════════════════════════════════════════════
            // J. DANH SÁCH CHUYẾN XE
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("ViewTripList") != null) {

                handleListTrip(request);
                url = "list_trip.jsp";

            } // ════════════════════════════════════════════════════════════
            // K. TÌM CHUYẾN XE
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("SearchTripByTruck") != null) {

                handleSearchTrip(request);
                url = "list_trip.jsp";

            } // ════════════════════════════════════════════════════════════
            // L. TẠO CHUYẾN XE
            // ════════════════════════════════════════════════════════════
            else if (request.getParameter("AddTrip") != null) {

                loadTrucksAndStations(request);
                url = "create_trip.jsp";

            } // ════════════════════════════════════════════════════════════
            // DEFAULT
            // ════════════════════════════════════════════════════════════
            else {

                handleListOrder(request);
                url = "list_order.jsp";

            }

        } catch (Exception e) {

            log("Error GoodsController: " + e.toString());
            e.printStackTrace();

            request.setAttribute("ERROR_MESSAGE", "Lỗi hệ thống: " + e.getMessage());

            try {
                handleListOrder(request);
            } catch (Exception ignored) {
            }

            url = "list_order.jsp";

        } finally {

            request.getRequestDispatcher(url).forward(request, response);

        }
    }

    // ================================================================
    // METHOD XỬ LÝ LOGIC
    // ================================================================
    private void handleListOrder(HttpServletRequest request) throws Exception {

        List<OrderDTO> list = orderDAO.getAllOrders();
        List<StationDTO> stations = stationDAO.getAllStations();

        request.setAttribute("ORDER_LIST", list);
        request.setAttribute("STATION_LIST", stations);
        request.setAttribute("TOTAL_COUNT", list.size());
    }

    private void handleFilterOrder(HttpServletRequest request) throws Exception {

        String station = request.getParameter("stationFilter");
        String date = request.getParameter("dateFilter");
        String status = request.getParameter("statusFilter");

        List<OrderDTO> list = orderDAO.getFilteredOrders(station, date, status);

        request.setAttribute("ORDER_LIST", list);
        request.setAttribute("TOTAL_COUNT", list.size());

        loadStations(request);
    }

    private void handleSearchByPhone(HttpServletRequest request) throws Exception {

        String phone = request.getParameter("searchPhone");

        List<OrderDTO> list = orderDAO.searchByPhone(phone);

        request.setAttribute("ORDER_LIST", list);
        request.setAttribute("TOTAL_COUNT", list.size());

        loadStations(request);
    }

    private void handleEditOrder(HttpServletRequest request) throws Exception {

        String orderID = request.getParameter("orderID");

        OrderDTO order = orderDAO.getOrderByID(orderID);

        request.setAttribute("EDIT_ORDER", order);

        loadStations(request);
    }

    private void handleUpdateOrder(HttpServletRequest request) throws Exception {

        String orderID = request.getParameter("orderID");
        String itemName = request.getParameter("itemName");

        OrderDTO order = orderDAO.getOrderByID(orderID);

        order.setItemName(itemName);

        orderDAO.updateOrder(order);

        request.setAttribute("SUCCESS_MESSAGE", "Cập nhật thành công!");
    }

    private void handleDeleteOrder(HttpServletRequest request) throws Exception {

        String orderID = request.getParameter("orderID");

        orderDAO.softDelete(orderID);

        request.setAttribute("SUCCESS_MESSAGE", "Đã xóa đơn hàng!");
    }

    private void handleShipOrder(HttpServletRequest request) throws Exception {

        String orderID = request.getParameter("orderID");

        OrderDTO order = orderDAO.getOrderByID(orderID);

        request.setAttribute("ORDER_FOR_SHIP", order);
    }

    private void handleAssignTrip(HttpServletRequest request) throws Exception {

        String orderID = request.getParameter("orderID");
        String tripID = request.getParameter("tripID");

        orderDAO.assignToTrip(orderID, tripID);

        request.setAttribute("SUCCESS_MESSAGE", "Đã gán đơn lên chuyến!");
    }

    private void handleListTrip(HttpServletRequest request) throws Exception {

        List<TripDTO> list = tripDAO.getAllTrips();

        request.setAttribute("TRIP_LIST", list);
    }

    private void handleSearchTrip(HttpServletRequest request) throws Exception {

        String truck = request.getParameter("searchTruck");

        List<TripDTO> list = tripDAO.getTripsByType(truck);

        request.setAttribute("TRIP_LIST", list);
    }

    private void loadStations(HttpServletRequest request) throws Exception {

        List<StationDTO> stations = stationDAO.getAllStations();

        request.setAttribute("STATION_LIST", stations);
    }

    private void loadTrucksAndStations(HttpServletRequest request) throws Exception {

        request.setAttribute("TRUCK_LIST", trucDAO.getAllTrucks());
        request.setAttribute("STATION_LIST", stationDAO.getAllStations());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        processRequest(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        processRequest(req, res);
    }
}
