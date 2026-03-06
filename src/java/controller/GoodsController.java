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

    private OrderDAO orderDAO = new OrderDAO();
    private StationDAO stationDAO = new StationDAO();
    private TripDAO tripDAO = new TripDAO();
    private TruckDAO truckDAO = new TruckDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String url = "list_order.jsp";

        try {

            // ════════════════════════════════════════════════════════════
            // A. DANH SÁCH ĐƠN HÀNG
            // ════════════════════════════════════════════════════════════
            if (request.getParameter("ViewOrderList") != null) {
                handleListOrder(request);
                url = "list_order.jsp";

                // ════════════════════════════════════════════════════════════
                // B. LỌC ĐƠN HÀNG
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("FilterOrder") != null) {
                handleFilterOrder(request);
                url = "list_order.jsp";

                // ════════════════════════════════════════════════════════════
                // C. TÌM ĐƠN HÀNG THEO PHONE
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("SearchOrderByPhone") != null) {
                handleSearchByPhone(request);
                url = "list_order.jsp";

                // ════════════════════════════════════════════════════════════
                // D. TẠO ĐƠN HÀNG (LOAD FORM)
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("CreateOrder") != null) {
                loadStations(request);
                url = "create_order.jsp";

                // ════════════════════════════════════════════════════════════
                // E. SỬA ĐƠN HÀNG (LOAD FORM)
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("EditOrder") != null) {
                handleEditOrder(request);
                url = "edit_order.jsp";

                // ════════════════════════════════════════════════════════════
                // F. LƯU SỬA ĐƠN HÀNG
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("UpdateOrder") != null) {
                handleUpdateOrder(request);
                handleListOrder(request);
                url = "list_order.jsp";

                // ════════════════════════════════════════════════════════════
                // G. XÓA MỀM ĐƠN HÀNG
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("DeleteOrder") != null) {
                handleDeleteOrder(request);
                handleListOrder(request);
                url = "list_order.jsp";

                // ════════════════════════════════════════════════════════════
                // G2. THÙNG RÁC
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("ViewTrashOrder") != null) {
                handleViewTrash(request);
                url = "trash_order.jsp";

                // ════════════════════════════════════════════════════════════
                // G3. KHÔI PHỤC ĐƠN HÀNG
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("RestoreOrder") != null) {
                String orderID = request.getParameter("orderID");
                orderDAO.restore(orderID);
                request.setAttribute("SUCCESS_MESSAGE", "Đã khôi phục đơn hàng: " + orderID);
                handleViewTrash(request);
                url = "trash_order.jsp";

                // ════════════════════════════════════════════════════════════
                // G4. XÓA VĨNH VIỄN
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("PermanentDeleteOrder") != null) {
                String orderID = request.getParameter("orderID");
                orderDAO.permanentDelete(orderID);
                request.setAttribute("SUCCESS_MESSAGE", "Đã xóa vĩnh viễn đơn hàng: " + orderID);
                handleViewTrash(request);
                url = "trash_order.jsp";

                // ════════════════════════════════════════════════════════════
                // H. CHUYỂN HÀNG (SHIP) — load danh sách chuyến phù hợp
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("ShipOrder") != null) {
                handleShipOrder(request);
                url = "ship_order.jsp";

                // ════════════════════════════════════════════════════════════
                // I. GÁN ĐƠN LÊN CHUYẾN XE
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("AssignOrderToTrip") != null) {
                handleAssignTrip(request);
                // Sau khi gán, nếu đến từ ship_order thì quay lại list
                handleListOrder(request);
                url = "list_order.jsp";

                // ════════════════════════════════════════════════════════════
                // J. DANH SÁCH CHUYẾN XE ĐI
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("ViewTripList") != null) {
                handleListTrip(request);
                url = "list_trip.jsp";

                // ════════════════════════════════════════════════════════════
                // J2. DANH SÁCH CHUYẾN XE ĐẾN
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("ViewArrivalTripList") != null) {
                handleListArrivalTrip(request);
                url = "list_arrival_trip.jsp";

                // ════════════════════════════════════════════════════════════
                // K. TÌM CHUYẾN XE ĐI THEO BIỂN SỐ XE
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("SearchTripByTruck") != null) {
                handleSearchTripByPlate(request, "depart");
                url = "list_trip.jsp";

                // ════════════════════════════════════════════════════════════
                // K2. TÌM CHUYẾN XE ĐẾN THEO BIỂN SỐ XE
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("SearchArrivalByTruck") != null) {
                handleSearchTripByPlate(request, "arrive");
                url = "list_arrival_trip.jsp";

                // ════════════════════════════════════════════════════════════
                // L. TẠO CHUYẾN XE ĐI
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("AddTrip") != null) {
                loadTrucksAndStations(request);
                url = "create_trip.jsp";

                // ════════════════════════════════════════════════════════════
                // L2. TẠO CHUYẾN XE ĐẾN
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("AddArrivalTrip") != null) {
                loadTrucksAndStations(request);
                url = "create_arrival_trip.jsp";

                // ════════════════════════════════════════════════════════════
                // M. LIST HÀNG TRÊN CHUYẾN
                // ════════════════════════════════════════════════════════════
            } else if (request.getParameter("ListGoods") != null) {
                handleListGoodsOnTrip(request);
                url = "list_goods_on_trip.jsp";

                // ════════════════════════════════════════════════════════════
                // DEFAULT
                // ════════════════════════════════════════════════════════════
            } else {
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
        String sendStation = request.getParameter("sendStation");
        String receiveStation = request.getParameter("receiveStation");
        String senderName = request.getParameter("senderName");
        String senderPhone = request.getParameter("senderPhone");
        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String note = request.getParameter("note");

        // Xử lý TR (đã thanh toán)
        String trValue = "";
        String paidStr = request.getParameter("paidAmount");
        if (paidStr != null && !paidStr.trim().isEmpty()) {
            try {
                double paid = Double.parseDouble(paidStr.trim());
                if (paid > 0) {
                    trValue = String.format("%.0f", paid);
                }
            } catch (NumberFormatException ignored) {
            }
        }

        // Xử lý CT (chưa thanh toán)
        String ctValue = "";
        String remainStr = request.getParameter("remainAmount");
        if (remainStr != null && !remainStr.trim().isEmpty()) {
            try {
                double remain = Double.parseDouble(remainStr.trim());
                if (remain > 0) {
                    ctValue = String.format("%.0f", remain);
                }
            } catch (NumberFormatException ignored) {
            }
        }

        // Tổng tiền
        double totalAmount = 0;
        try {
            if (!trValue.isEmpty()) {
                totalAmount += Double.parseDouble(trValue);
            }
        } catch (NumberFormatException ignored) {
        }
        try {
            if (!ctValue.isEmpty()) {
                totalAmount += Double.parseDouble(ctValue);
            }
        } catch (NumberFormatException ignored) {
        }

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

        // Lấy danh sách chuyến xe đi có departure = sendStation của đơn hàng
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
        String tripID = request.getParameter("tripID");
        orderDAO.assignToTrip(orderID, tripID);
        request.setAttribute("SUCCESS_MESSAGE", "Đã gán đơn " + orderID + " lên chuyến " + tripID + "!");
    }

    // ================================================================
    // CHUYẾN XE
    // ================================================================
    private void handleListTrip(HttpServletRequest request) throws Exception {
        List<TripDTO> list = tripDAO.getTripsByType("depart");
        List<String[]> rows = buildTripRows(list);
        request.setAttribute("TRIP_LIST", rows);
    }

    private void handleListArrivalTrip(HttpServletRequest request) throws Exception {
        List<TripDTO> list = tripDAO.getTripsByType("arrive");
        List<String[]> rows = buildTripRows(list);
        request.setAttribute("ARRIVAL_LIST", rows);
    }

    /**
     * Tìm chuyến xe theo biển số xe (licensePlate của truck) hoặc truckID
     *
     * @param tripType "depart" hoặc "arrive"
     */
    private void handleSearchTripByPlate(HttpServletRequest request, String tripType) throws Exception {
        String keyword = request.getParameter("searchTruck");
        if (keyword == null) {
            keyword = request.getParameter("searchArrivalTruck");
        }
        if (keyword == null) {
            keyword = "";
        }

        List<TripDTO> allTrips = tripDAO.getTripsByType(tripType);
        List<String[]> rows = new ArrayList<>();

        // Lấy map truckID → licensePlate để so sánh
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
            t.getTripID(), // [0] mã chuyến
            t.getDeparture() + " → " + t.getDestination(), // [1] lộ trình
            t.getDeparture(), // [2] trạm đi
            t.getDestination(), // [3] trạm đến
            plate, // [4] biển số xe
            t.getDriverName() != null ? t.getDriverName() : "-", // [5] tài xế
            t.getDepartureTime() != null ? t.getDepartureTime() : "-", // [6] giờ đi
            t.getStatus() != null ? t.getStatus() : "-", // [7] trạng thái
            t.getStaffCreated() != null ? t.getStaffCreated() : "-", // [8] NV tạo
            t.getCreatedAt() != null ? t.getCreatedAt() : "-" // [9] thời gian tạo
        };
    }

    private void loadStations(HttpServletRequest request) throws Exception {
        request.setAttribute("STATION_LIST", stationDAO.getAllStations());
    }

    private void loadTrucksAndStations(HttpServletRequest request) throws Exception {
        request.setAttribute("TRUCK_LIST", truckDAO.getAllTrucks());
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
