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
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "GoodsController", urlPatterns = {"/GoodsController"})
public class GoodsController extends HttpServlet {

    private OrderDAO   orderDAO   = new OrderDAO();
    private StationDAO stationDAO = new StationDAO();
    private TripDAO    tripDAO    = new TripDAO();
    private TruckDAO   truckDAO   = new TruckDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String url = "list_order.jsp";

        try {
            if (request.getParameter("ViewOrderList") != null) {
                handleListOrder(request);
                url = "list_order.jsp";

            } else if (request.getParameter("FilterOrder") != null) {
                handleFilterOrder(request);
                url = "list_order.jsp";

            } else if (request.getParameter("SearchOrderByPhone") != null) {
                handleSearchByPhone(request);
                url = "list_order.jsp";

            } else if (request.getParameter("CreateOrder") != null) {
                loadStations(request);
                url = "create_order.jsp";

            } else if (request.getParameter("EditOrder") != null) {
                handleEditOrder(request);
                url = "edit_order.jsp";

            } else if (request.getParameter("UpdateOrder") != null) {
                handleUpdateOrder(request);
                handleListOrder(request);
                url = "list_order.jsp";

            } else if (request.getParameter("DeleteOrder") != null) {
                handleDeleteOrder(request);
                handleListOrder(request);
                url = "list_order.jsp";

            } else if (request.getParameter("ViewTrashOrder") != null) {
                handleViewTrash(request);
                url = "trash_order.jsp";

            } else if (request.getParameter("RestoreOrder") != null) {
                String orderID = request.getParameter("orderID");
                orderDAO.restore(orderID);
                request.setAttribute("SUCCESS_MESSAGE", "Đã khôi phục đơn hàng: " + orderID);
                handleViewTrash(request);
                url = "trash_order.jsp";

            } else if (request.getParameter("PermanentDeleteOrder") != null) {
                String orderID = request.getParameter("orderID");
                orderDAO.permanentDelete(orderID);
                request.setAttribute("SUCCESS_MESSAGE", "Đã xóa vĩnh viễn đơn hàng: " + orderID);
                handleViewTrash(request);
                url = "trash_order.jsp";

            } else if (request.getParameter("ShipOrder") != null) {
                handleShipOrder(request);
                url = "ship_order.jsp";

            } else if (request.getParameter("AssignOrderToTrip") != null) {
                handleAssignTrip(request);
                String source = request.getParameter("source");
                if ("trip".equals(source)) {
                    handlePrepareAssignGoods(request);
                    url = "assign_goods.jsp";
                } else {
                    handleListOrder(request);
                    url = "list_order.jsp";
                }

            } else if (request.getParameter("PrepareAssignGoods") != null) {
                handlePrepareAssignGoods(request);
                url = "assign_goods.jsp";

            } else if (request.getParameter("ViewTripList") != null) {
                handleListTrip(request);
                loadStations(request);   // ← Cần cho dropdown lọc trạm
                url = "list_trip.jsp";

            } else if (request.getParameter("FilterTrip") != null) {
                handleFilterTrip(request);
                loadStations(request);
                url = "list_trip.jsp";

            } else if (request.getParameter("ViewArrivalTripList") != null) {
                handleListArrivalTrip(request);
                loadStations(request);   // ← Cần cho dropdown lọc trạm
                url = "list_arrival_trip.jsp";

            } else if (request.getParameter("FilterArrival") != null) {
                handleFilterArrival(request);
                loadStations(request);
                url = "list_arrival_trip.jsp";

            } else if (request.getParameter("SearchTripByTruck") != null) {
                handleSearchTripByPlate(request, "depart");
                loadStations(request);
                url = "list_trip.jsp";

            } else if (request.getParameter("SearchArrivalByTruck") != null) {
                handleSearchTripByPlate(request, "arrive");
                loadStations(request);
                url = "list_arrival_trip.jsp";

            } else if (request.getParameter("AddTrip") != null) {
                loadTrucksAndStations(request);
                url = "create_trip.jsp";

            } else if (request.getParameter("AddArrivalTrip") != null) {
                loadTrucksAndStations(request);
                url = "create_arrival_trip.jsp";

            } else if (request.getParameter("ArrivedTrip") != null) {
                String tripID = request.getParameter("tripID");
                tripDAO.updateTripStatus(tripID, "Đã đến");
                request.setAttribute("SUCCESS_MESSAGE", "Đã xác nhận chuyến xe " + tripID + " đã cập bến!");
                handleListArrivalTrip(request);
                loadStations(request);
                url = "list_arrival_trip.jsp";

            } else if (request.getParameter("ListGoods") != null) {
                handleListGoodsOnTrip(request);
                url = "list_goods_on_trip.jsp";

            } else {
                handleListOrder(request);
                url = "list_order.jsp";
            }

        } catch (Exception e) {
            log("Error GoodsController: " + e.toString());
            e.printStackTrace();
            request.setAttribute("ERROR_MESSAGE", "Lỗi hệ thống: " + e.getMessage());
            try { handleListOrder(request); } catch (Exception ignored) {}
            url = "list_order.jsp";
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // ================================================================
    // ĐƠN HÀNG
    // ================================================================
    private void handleListOrder(HttpServletRequest request) throws Exception {
        List<OrderDTO> list = orderDAO.getAllOrders();
        List<StationDTO> stations = stationDAO.getAllStations();
        request.setAttribute("ORDER_LIST", list);
        request.setAttribute("STATION_LIST", stations);
        request.setAttribute("TOTAL_COUNT", list.size());
    }

    private void handleFilterOrder(HttpServletRequest request) throws Exception {
        String sendStation = request.getParameter("sendStationFilter");
        String receiveStation = request.getParameter("receiveStationFilter");
        String date    = request.getParameter("dateFilter");
        String status  = request.getParameter("statusFilter");
        List<OrderDTO> list = orderDAO.getFilteredOrders(sendStation, receiveStation, date, status);
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
        String orderID       = request.getParameter("orderID");
        String itemName      = request.getParameter("itemName");
        String sendStation   = request.getParameter("sendStation");
        String receiveStation = request.getParameter("receiveStation");
        String senderName    = request.getParameter("senderName");
        String senderPhone   = request.getParameter("senderPhone");
        String receiverName  = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String note          = request.getParameter("note");

        String trValue = "";
        String paidStr = request.getParameter("paidAmount");
        if (paidStr != null && !paidStr.trim().isEmpty()) {
            try {
                double paid = Double.parseDouble(paidStr.trim());
                if (paid > 0) trValue = String.format("%.0f", paid);
            } catch (NumberFormatException ignored) {}
        }

        String ctValue = "";
        String remainStr = request.getParameter("remainAmount");
        if (remainStr != null && !remainStr.trim().isEmpty()) {
            try {
                double remain = Double.parseDouble(remainStr.trim());
                if (remain > 0) ctValue = String.format("%.0f", remain);
            } catch (NumberFormatException ignored) {}
        }

        double totalAmount = 0;
        try { if (!trValue.isEmpty()) totalAmount += Double.parseDouble(trValue); } catch (NumberFormatException ignored) {}
        try { if (!ctValue.isEmpty()) totalAmount += Double.parseDouble(ctValue); } catch (NumberFormatException ignored) {}

        OrderDTO order = orderDAO.getOrderByID(orderID);
        if (order != null) {
            order.setItemName(itemName);
            order.setSendStation(sendStation);
            order.setReceiveStation(receiveStation);
            order.setSenderName(senderName);
            order.setSenderPhone(senderPhone);
            order.setReceiverName(receiverName);
            order.setReceiverPhone(receiverPhone);
            order.setTr(trValue);
            order.setCt(ctValue);
            order.setAmount(totalAmount);
            order.setNote(note);
            orderDAO.updateOrder(order);
            request.setAttribute("SUCCESS_MESSAGE", "Cập nhật đơn hàng thành công!");
        }
    }

    private void handleDeleteOrder(HttpServletRequest request) throws Exception {
        String orderID = request.getParameter("orderID");
        orderDAO.softDelete(orderID);
        request.setAttribute("SUCCESS_MESSAGE", "Đã chuyển đơn hàng vào thùng rác!");
    }

    private void handleViewTrash(HttpServletRequest request) throws Exception {
        List<OrderDTO> trash = orderDAO.getTrashOrders();
        request.setAttribute("TRASH_LIST", trash);
    }

    private void handleShipOrder(HttpServletRequest request) throws Exception {
        String orderID = request.getParameter("orderID");
        OrderDTO order = orderDAO.getOrderByID(orderID);
        request.setAttribute("ORDER_FOR_SHIP", order);

        if (order != null && order.getSendStation() != null) {
            List<TripDTO> trips = tripDAO.getTripsByType("depart");
            List<String[]> matchingTrips = new ArrayList<>();
            for (TripDTO t : trips) {
                if (order.getSendStation().equals(t.getDeparture())) {
                    matchingTrips.add(new String[]{
                        t.getTripID(),
                        t.getDeparture() + " → " + t.getDestination(),
                        t.getDeparture(),
                        t.getDestination(),
                        t.getTruckID(),
                        t.getDriverName(),
                        t.getDepartureTime(),
                        t.getStatus()
                    });
                }
            }
            request.setAttribute("MATCHING_TRIPS", matchingTrips);
        }
    }

    private void handleAssignTrip(HttpServletRequest request) throws Exception {
        String orderID = request.getParameter("orderID");
        String tripID  = request.getParameter("tripID");
        orderDAO.assignToTrip(orderID, tripID);
        request.setAttribute("SUCCESS_MESSAGE", "Đã gán đơn " + orderID + " lên chuyến " + tripID + "!");
    }

    // ================================================================
    // CHUYẾN XE
    // ================================================================
    private void handleListTrip(HttpServletRequest request) throws Exception {
        List<TripDTO> list = tripDAO.getAllTrips(); // Lấy tất cả chuyến xe
        List<String[]> rows = buildTripRows(list);
        request.setAttribute("TRIP_LIST", rows);
    }

    private void handleListArrivalTrip(HttpServletRequest request) throws Exception {
        List<TripDTO> list = tripDAO.getAllTrips(); // Đổ cùng dữ liệu tất cả chuyến xe
        List<String[]> rows = buildTripRows(list);
        request.setAttribute("ARRIVAL_LIST", rows);
    }

    private void handleFilterTrip(HttpServletRequest request) throws Exception {
        String departure = request.getParameter("departureFilter");
        String destination = request.getParameter("destinationFilter");
        String date    = request.getParameter("dateFilter");
        List<TripDTO> list = tripDAO.getFilteredTrips(departure, destination, date, "all");
        request.setAttribute("TRIP_LIST", buildTripRows(list));
    }

    private void handleFilterArrival(HttpServletRequest request) throws Exception {
        String departure = request.getParameter("departureFilter");
        String destination = request.getParameter("destinationFilter");
        String date    = request.getParameter("dateFilter");
        List<TripDTO> list = tripDAO.getFilteredTrips(departure, destination, date, "all");
        request.setAttribute("ARRIVAL_LIST", buildTripRows(list));
    }

    private void handleSearchTripByPlate(HttpServletRequest request, String tripType) throws Exception {
        String keyword = request.getParameter("searchTruck");
        if (keyword == null) keyword = request.getParameter("searchArrivalTruck");
        if (keyword == null) keyword = "";

        List<TripDTO> allTrips = tripDAO.getTripsByType(tripType);
        List<String[]> rows = new ArrayList<>();

        List<TruckDTO> trucks = truckDAO.getAllTrucks();
        java.util.Map<String, String> plateMap = new java.util.HashMap<>();
        for (TruckDTO t : trucks) {
            plateMap.put(t.getTruckID(), t.getLicensePlate() != null ? t.getLicensePlate() : t.getTruckID());
        }

        String kw = keyword.trim().toLowerCase();
        for (TripDTO t : allTrips) {
            String plate = plateMap.getOrDefault(t.getTruckID(), t.getTruckID());
            if (kw.isEmpty()
                    || plate.toLowerCase().contains(kw)
                    || t.getTruckID().toLowerCase().contains(kw)) {
                rows.add(buildTripRow(t, plate));
            }
        }

        if ("depart".equals(tripType)) {
            request.setAttribute("TRIP_LIST", rows);
        } else {
            request.setAttribute("ARRIVAL_LIST", rows);
        }
    }

    private void handleListGoodsOnTrip(HttpServletRequest request) throws Exception {
        String tripID = request.getParameter("tripID");
        List<OrderDTO> orders = orderDAO.getOrdersByTrip(tripID);
        TripDTO trip = tripDAO.getTripByID(tripID);
        request.setAttribute("ORDER_LIST", orders);
        request.setAttribute("TRIP_ID", tripID);
        if (trip != null) {
            request.setAttribute("TRIP_ROUTE", trip.getDeparture() + " → " + trip.getDestination());
        }
    }

    // ================================================================
    // HELPERS
    // ================================================================
    private List<String[]> buildTripRows(List<TripDTO> list) throws Exception {
        List<TruckDTO> trucks = truckDAO.getAllTrucks();
        java.util.Map<String, String> plateMap = new java.util.HashMap<>();
        for (TruckDTO t : trucks) {
            plateMap.put(t.getTruckID(), t.getLicensePlate() != null ? t.getLicensePlate() : t.getTruckID());
        }
        List<String[]> rows = new ArrayList<>();
        for (TripDTO t : list) {
            String plate = plateMap.getOrDefault(t.getTruckID(), t.getTruckID());
            rows.add(buildTripRow(t, plate));
        }
        return rows;
    }

    private String[] buildTripRow(TripDTO t, String plate) {
        return new String[]{
            t.getTripID(),                                          // [0] mã chuyến
            t.getDeparture() + " → " + t.getDestination(),         // [1] lộ trình
            t.getDeparture(),                                       // [2] trạm đi
            t.getDestination(),                                     // [3] trạm đến
            plate,                                                  // [4] biển số xe
            t.getDriverName()   != null ? t.getDriverName()   : "-", // [5] tài xế
            t.getDepartureTime() != null ? t.getDepartureTime() : "-", // [6] giờ đi
            t.getStatus()       != null ? t.getStatus()       : "-", // [7] trạng thái
            t.getStaffCreated() != null ? t.getStaffCreated() : "-", // [8] NV tạo
            t.getCreatedAt()    != null ? t.getCreatedAt()    : "-"  // [9] thời gian tạo
        };
    }

    private void handlePrepareAssignGoods(HttpServletRequest request) throws Exception {
        String tripID = request.getParameter("tripID");
        TripDTO trip = tripDAO.getTripByID(tripID);
        if (trip != null) {
            request.setAttribute("TRIP_ID", tripID);
            request.setAttribute("TRIP_ROUTE", trip.getDeparture() + " → " + trip.getDestination());
            request.setAttribute("TRIP_DEPARTURE", trip.getDeparture());
            
            // Tìm các đơn hàng Chưa Chuyển và có cùng trạm gửi với trạm đi của xe
            List<OrderDTO> allOrders = orderDAO.getAllOrders();
            List<OrderDTO> pending = new ArrayList<>();
            for (OrderDTO o : allOrders) {
                if ((o.getTripID() == null || o.getTripID().isEmpty()) 
                        && trip.getDeparture().equals(o.getSendStation())) {
                    pending.add(o);
                }
            }
            request.setAttribute("PENDING_ORDERS", pending);
        }
    }

    private void loadStations(HttpServletRequest request) throws Exception {
        request.setAttribute("STATION_LIST", stationDAO.getAllStations());
    }

    private void loadTrucksAndStations(HttpServletRequest request) throws Exception {
        request.setAttribute("TRUCK_LIST",   truckDAO.getAllTrucks());
        request.setAttribute("STATION_LIST", stationDAO.getAllStations());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
}