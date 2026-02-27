package controller;

import dao.OrderDAO;
import dao.StationDAO;
import dao.TripDAO;
import dao.UserDAO;
import dto.OrderDTO;
import dto.StationDTO;
import dto.UserDTO;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utils.DBUtils;

@WebServlet(name = "GoodsController", urlPatterns = {"/GoodsController"})
public class GoodsController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String url = "list_order.jsp";
        OrderDAO orderDAO = new OrderDAO();

        try {
            // ════════════════════════════════════════════════════════════
            // A. DANH SÁCH & LỌC ĐƠN HÀNG
            // ════════════════════════════════════════════════════════════

            if (request.getParameter("ViewOrderList") != null) {
                loadOrderList(request, null, null, null);
                url = "list_order.jsp";

            } else if (request.getParameter("FilterOrder") != null) {
                String stationF = request.getParameter("stationFilter");
                String dateF    = request.getParameter("dateFilter");
                String statusF  = request.getParameter("statusFilter");
                loadOrderList(request, stationF, dateF, statusF);
                url = "list_order.jsp";

            } else if (request.getParameter("SearchOrderByPhone") != null) {
                String phone = request.getParameter("searchPhone");
                List<OrderDTO> list = orderDAO.searchByPhone(phone != null ? phone : "");
                request.setAttribute("ORDER_LIST", list);
                request.setAttribute("TOTAL_COUNT", list.size());
                loadStations(request);
                url = "list_order.jsp";

            // ════════════════════════════════════════════════════════════
            // B. TẠO ĐƠN HÀNG MỚI
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("CreateOrder") != null) {
                loadStations(request);
                loadStaff(request);
                url = "create_order.jsp";

            // ════════════════════════════════════════════════════════════
            // C. SỬA ĐƠN HÀNG - Load form
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("EditOrder") != null) {
                String orderID = request.getParameter("orderID");
                OrderDTO order = orderDAO.getOrderByID(orderID);
                if (order == null) {
                    request.setAttribute("ERROR_MESSAGE", "Không tìm thấy đơn hàng: " + orderID);
                    loadOrderList(request, null, null, null);
                    url = "list_order.jsp";
                } else {
                    request.setAttribute("EDIT_ORDER", order);
                    loadStations(request);
                    loadStaff(request);
                    url = "edit_order.jsp";
                }

            // ════════════════════════════════════════════════════════════
            // D. LƯU SỬA ĐƠN HÀNG
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("UpdateOrder") != null) {
                String orderID       = request.getParameter("orderID");
                String itemName      = request.getParameter("itemName");
                String sendStation   = request.getParameter("sendStation");
                String receiveStation = request.getParameter("receiveStation");
                String senderName    = request.getParameter("senderName");
                String senderPhone   = request.getParameter("senderPhone");
                String receiverName  = request.getParameter("receiverName");
                String receiverPhone = request.getParameter("receiverPhone");
                String note          = request.getParameter("note");
                String ct            = request.getParameter("ct");
                String staffInput    = request.getParameter("staffInput");

                String paidStr = request.getParameter("paidAmount");
                double amount = 0;
                if (paidStr != null && !paidStr.trim().isEmpty()) {
                    try { amount = Double.parseDouble(paidStr.trim()); } catch (Exception ignored) {}
                }

                if (itemName == null || itemName.trim().isEmpty()) {
                    OrderDTO order = orderDAO.getOrderByID(orderID);
                    request.setAttribute("EDIT_ORDER", order);
                    loadStations(request);
                    loadStaff(request);
                    request.setAttribute("ERROR_MESSAGE", "Tên hàng gửi không được để trống!");
                    url = "edit_order.jsp";
                } else {
                    OrderDTO order = new OrderDTO(orderID, itemName.trim(), amount,
                        senderName, senderPhone, sendStation,
                        receiverName, receiverPhone, receiveStation,
                        staffInput, null, null, ct, null, note);
                    boolean ok = orderDAO.updateOrder(order);
                    if (ok) {
                        request.setAttribute("SUCCESS_MESSAGE", "Cập nhật đơn hàng thành công!");
                    } else {
                        request.setAttribute("ERROR_MESSAGE", "Cập nhật đơn hàng thất bại!");
                    }
                    loadOrderList(request, null, null, null);
                    url = "list_order.jsp";
                }

            // ════════════════════════════════════════════════════════════
            // E. XÓA MỀM ĐƠN HÀNG (đưa vào thùng rác)
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("DeleteOrder") != null) {
                String orderID = request.getParameter("orderID");
                orderDAO.softDelete(orderID);
                loadOrderList(request, null, null, null);
                url = "list_order.jsp";

            // ════════════════════════════════════════════════════════════
            // F. THÙNG RÁC ĐƠN HÀNG
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("ViewTrashOrder") != null) {
                request.setAttribute("TRASH_LIST", orderDAO.getDeletedOrders());
                url = "trash_order.jsp";

            } else if (request.getParameter("RestoreOrder") != null) {
                String orderID = request.getParameter("orderID");
                orderDAO.restore(orderID);
                request.setAttribute("TRASH_LIST", orderDAO.getDeletedOrders());
                request.setAttribute("SUCCESS_MESSAGE", "Đã khôi phục đơn hàng: " + orderID);
                url = "trash_order.jsp";

            } else if (request.getParameter("PermanentDeleteOrder") != null) {
                String orderID = request.getParameter("orderID");
                orderDAO.permanentDelete(orderID);
                request.setAttribute("TRASH_LIST", orderDAO.getDeletedOrders());
                request.setAttribute("SUCCESS_MESSAGE", "Đã xóa vĩnh viễn: " + orderID);
                url = "trash_order.jsp";

            // ════════════════════════════════════════════════════════════
            // G. CHUYỂN HÀNG - Từ ds nhận hàng: chọn chuyến xe khớp trạm gửi
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("ShipOrder") != null) {
                String orderID = request.getParameter("orderID");
                OrderDTO order = orderDAO.getOrderByID(orderID);
                request.setAttribute("ORDER_FOR_SHIP", order);
                if (order != null) {
                    List<String[]> trips = getTripsByDeparture(order.getSendStation());
                    request.setAttribute("MATCHING_TRIPS", trips);
                }
                url = "ship_order.jsp";

            // ════════════════════════════════════════════════════════════
            // H. GÁN ĐƠN HÀNG LÊN CHUYẾN XE
            //    (từ ship_order.jsp hoặc assign_goods.jsp)
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("AssignOrderToTrip") != null) {
                String orderID = request.getParameter("orderID");
                String tripID  = request.getParameter("tripID");
                String source  = request.getParameter("source"); // "ship" | "trip"

                orderDAO.assignToTrip(orderID, tripID);

                if ("trip".equals(source)) {
                    // Từ trang assign_goods (ds chuyến xe) → reload pending orders
                    String[] info = getTripInfo(tripID);
                    String dep = info != null ? info[2] : "";
                    request.setAttribute("TRIP_ID",        tripID);
                    request.setAttribute("TRIP_ROUTE",     info != null ? info[1] : "");
                    request.setAttribute("TRIP_DEPARTURE", dep);
                    request.setAttribute("PENDING_ORDERS", orderDAO.getPendingOrdersByStation(dep));
                    request.setAttribute("SUCCESS_MESSAGE", "Đã gán đơn " + orderID + " lên chuyến " + tripID);
                    url = "assign_goods.jsp";
                } else {
                    // Từ ship_order.jsp → về ds nhận hàng
                    request.setAttribute("SUCCESS_MESSAGE", "Đã chuyển hàng thành công!");
                    loadOrderList(request, null, null, null);
                    url = "list_order.jsp";
                }

            // ════════════════════════════════════════════════════════════
            // I. TỪ DS CHUYẾN XE: bấm "Chuyển Hàng" → hiện đơn chờ khớp trạm
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("TransferGoods") != null) {
                String tripID = request.getParameter("tripID");
                String[] info = getTripInfo(tripID);
                String dep = info != null ? info[2] : "";
                request.setAttribute("TRIP_ID",        tripID);
                request.setAttribute("TRIP_ROUTE",     info != null ? info[1] : "");
                request.setAttribute("TRIP_DEPARTURE", dep);
                request.setAttribute("PENDING_ORDERS", orderDAO.getPendingOrdersByStation(dep));
                url = "assign_goods.jsp";

            // ════════════════════════════════════════════════════════════
            // J. LIST HÀNG TRÊN CHUYẾN XE
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("ListHang") != null) {
                String tripID = request.getParameter("tripID");
                String[] info = getTripInfo(tripID);
                List<OrderDTO> orders = orderDAO.getOrdersByTrip(tripID);
                request.setAttribute("TRIP_ID",    tripID);
                request.setAttribute("TRIP_ROUTE", info != null ? info[1] : "");
                request.setAttribute("ORDER_LIST",  orders);
                url = "list_goods_on_trip.jsp";

            // ════════════════════════════════════════════════════════════
            // K. DANH SÁCH CHUYẾN XE ĐI
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("ViewTripList") != null) {
                loadTripList(request, null);
                url = "list_trip.jsp";

            } else if (request.getParameter("SearchTripByTruck") != null) {
                String truck = request.getParameter("searchTruck");
                loadTripList(request, truck);
                url = "list_trip.jsp";

            } else if (request.getParameter("AddTrip") != null) {
                loadTrucksAndStations(request);
                url = "create_trip.jsp";

            // ════════════════════════════════════════════════════════════
            // L. DANH SÁCH XE ĐẾN / CHUYẾN ĐẾN
            // ════════════════════════════════════════════════════════════

            } else if (request.getParameter("ViewArrivalTripList") != null) {
                loadArrivalList(request, null);
                url = "list_arrival_trip.jsp";

            } else if (request.getParameter("SearchArrivalByTruck") != null) {
                String truck = request.getParameter("searchArrivalTruck");
                loadArrivalList(request, truck);
                url = "list_arrival_trip.jsp";

            } else if (request.getParameter("AddArrivalTrip") != null) {
                loadTrucksAndStations(request);
                url = "create_arrival_trip.jsp";

            } else if (request.getParameter("ReceiveTrip") != null) {
                String tripID = request.getParameter("tripID");
                updateTripStatus(tripID, "Đã đến");
                loadArrivalList(request, null);
                url = "list_arrival_trip.jsp";

            // ── Default ──────────────────────────────────────────────────
            } else {
                loadOrderList(request, null, null, null);
            }

        } catch (Exception e) {
            log("Error GoodsController: " + e.toString());
            e.printStackTrace();
            request.setAttribute("ERROR_MESSAGE", "Lỗi hệ thống: " + e.getMessage());
            try { loadOrderList(request, null, null, null); } catch (Exception ignored) {}
            url = "list_order.jsp";
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // PRIVATE HELPERS
    // ═══════════════════════════════════════════════════════════════════════

    private void loadOrderList(HttpServletRequest req,
                                String stationF, String dateF, String statusF) throws Exception {
        OrderDAO dao = new OrderDAO();
        List<OrderDTO> list;
        if ((stationF != null && !stationF.isEmpty())
                || (dateF != null && !dateF.isEmpty())
                || (statusF != null && !statusF.isEmpty())) {
            list = dao.getFilteredOrders(stationF, dateF, statusF);
        } else {
            list = dao.getAllOrders();
        }
        req.setAttribute("ORDER_LIST",  list);
        req.setAttribute("TOTAL_COUNT", list.size());
        loadStations(req);
    }

    private void loadStations(HttpServletRequest req) throws Exception {
        req.setAttribute("STATION_LIST", new StationDAO().getAllStations());
    }

    private void loadStaff(HttpServletRequest req) throws Exception {
        req.setAttribute("STAFF_LIST", new UserDAO().getAllUsers());
    }

    private void loadTrucksAndStations(HttpServletRequest req) throws Exception {
        loadStations(req);
        req.setAttribute("TRUCK_LIST", getTrucks());
    }

    /** Lấy chuyến xe theo trạm xuất phát (cho tính năng Ship Order) */
    private List<String[]> getTripsByDeparture(String departure) throws Exception {
        String sql = "SELECT tripID,(departure+N' → '+destination) AS route,"
                   + "departure,destination,truckID,driverName,departureTime,status "
                   + "FROM tblTrips WHERE departure=? ORDER BY createdAt DESC";
        List<String[]> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, departure != null ? departure : "");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(new String[]{
                    rs.getString("tripID"),
                    rs.getString("route"),
                    rs.getString("departure"),
                    rs.getString("destination"),
                    rs.getString("truckID"),
                    rs.getString("driverName"),
                    rs.getString("departureTime"),
                    rs.getString("status")
                });
            }
        }
        return list;
    }

    /** Lấy thông tin chuyến xe: [0]=tripID, [1]=route, [2]=departure, [3]=destination */
    private String[] getTripInfo(String tripID) throws Exception {
        String sql = "SELECT tripID,(departure+N' → '+destination) AS route,departure,destination "
                   + "FROM tblTrips WHERE tripID=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tripID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new String[]{
                    rs.getString("tripID"), rs.getString("route"),
                    rs.getString("departure"), rs.getString("destination")
                };
            }
        }
        return null;
    }

    private void loadTripList(HttpServletRequest req, String truckFilter) throws Exception {
        String sql = "SELECT tripID,(departure+N' → '+destination) AS route,"
                   + "departure,destination,truckID,driverName,departureTime,status,"
                   + "staffCreated,notes FROM tblTrips "
                   + (truckFilter != null && !truckFilter.isEmpty() ? "WHERE truckID LIKE ? " : "")
                   + "ORDER BY createdAt DESC";
        List<String[]> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (truckFilter != null && !truckFilter.isEmpty()) ps.setString(1, "%" + truckFilter + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(new String[]{
                    rs.getString("tripID"),        rs.getString("route"),
                    rs.getString("departure"),     rs.getString("destination"),
                    rs.getString("truckID"),       rs.getString("driverName"),
                    rs.getString("departureTime"), rs.getString("status"),
                    rs.getString("staffCreated"),  rs.getString("notes")
                });
            }
        }
        req.setAttribute("TRIP_LIST", list);
    }

    private void loadArrivalList(HttpServletRequest req, String truckFilter) throws Exception {
        loadTripList(req, truckFilter); // same data, different display
    }

    private void updateTripStatus(String tripID, String status) throws Exception {
        String sql = "UPDATE tblTrips SET status=? WHERE tripID=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status); ps.setString(2, tripID);
            ps.executeUpdate();
        }
    }

    private List<String[]> getTrucks() throws Exception {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT truckID,truckType,capacity FROM tblTrucks WHERE status=1";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(new String[]{
                rs.getString("truckID"), rs.getString("truckType"), rs.getString("capacity")
            });
        }
        return list;
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
    @Override public String getServletInfo() { return "GoodsController"; }
}