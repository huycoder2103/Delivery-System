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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "GoodsController", urlPatterns = {"/GoodsController"})
public class GoodsController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            switch (action) {

                // ═══════════════════════════════════════════════════
                // DANH SÁCH ĐƠN HÀNG
                // ═══════════════════════════════════════════════════
                case "ViewOrderList":
                    handleListOrder(request, response);
                    break;

                // ═══════════════════════════════════════════════════
                // THÊM ĐƠN HÀNG
                // ═══════════════════════════════════════════════════
                case "CreateOrder":
                    handleAddOrder(request, response);
                    break;

                // ═══════════════════════════════════════════════════
                // SỬA ĐƠN HÀNG
                // ═══════════════════════════════════════════════════
                case "editOrder":
                    handleEditOrder(request, response);
                    break;

                case "updateOrder":
                    handleUpdateOrder(request, response);
                    break;

                // ═══════════════════════════════════════════════════
                // XÓA ĐƠN HÀNG
                // ═══════════════════════════════════════════════════
                case "deleteOrder":
                    handleDeleteOrder(request, response);
                    break;

                // ═══════════════════════════════════════════════════
                // CẬP NHẬT TRẠNG THÁI CHUYỂN HÀNG ← MỚI
                // ═══════════════════════════════════════════════════
                case "updateShipStatus":
                    handleUpdateShipStatus(request, response);
                    break;

                // ═══════════════════════════════════════════════════
                // CHUYẾN XE ĐI
                // ═══════════════════════════════════════════════════
                case "ViewTripList":
                    handleListTripDepart(request, response);
                    break;

                case "addTripDepart":
                    handleAddTripDepart(request, response);
                    break;

                // ═══════════════════════════════════════════════════
                // CHUYẾN XE ĐẾN
                // ═══════════════════════════════════════════════════
                case "ViewArrivalTripList":
                    handleListTripArrive(request, response);
                    break;

                case "addTripArrive":
                    handleAddTripArrive(request, response);
                    break;

                // ═══════════════════════════════════════════════════
                // GÁN ĐƠN LÊN CHUYẾN XE
                // ═══════════════════════════════════════════════════
                case "assignTrip":
                    handleAssignTrip(request, response);
                    break;

                default:
                    handleListOrder(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "❌ Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // Danh sách đơn hàng — forward list_order.jsp
    // ═══════════════════════════════════════════════════════════════════
    private void handleListOrder(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String stationFilter    = request.getParameter("stationFilter");
        String dateFilter       = request.getParameter("dateFilter");
        String shipStatusFilter = request.getParameter("shipStatusFilter");

        OrderDAO   orderDAO   = new OrderDAO();
        StationDAO stationDAO = new StationDAO();

        List<OrderDTO>   orderList   = orderDAO.getFilteredOrders(stationFilter, dateFilter, shipStatusFilter);
        List<StationDTO> stationList = stationDAO.getAllStations();

        request.setAttribute("orderList",        orderList);
        request.setAttribute("stationList",      stationList);
        request.setAttribute("stationFilter",    stationFilter    != null ? stationFilter    : "");
        request.setAttribute("dateFilter",       dateFilter       != null ? dateFilter       : "");
        request.setAttribute("shipStatusFilter", shipStatusFilter != null ? shipStatusFilter : "");

        request.getRequestDispatcher("list_order.jsp").forward(request, response);
    }

    // ═══════════════════════════════════════════════════════════════════
    // Thêm đơn hàng
    // ═══════════════════════════════════════════════════════════════════
    private void handleAddOrder(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String orderID       = request.getParameter("orderID");
            String itemName      = request.getParameter("itemName");
            String amountStr     = request.getParameter("amount");
            String senderName    = request.getParameter("senderName");
            String senderPhone   = request.getParameter("senderPhone");
            String sendStation   = request.getParameter("sendStation");
            String receiverName  = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String recvStation   = request.getParameter("receiveStation");
            String tr            = request.getParameter("tr");
            String ct            = request.getParameter("ct");
            String note          = request.getParameter("note");

            HttpSession session = request.getSession(false);
            String staffInput   = (String) session.getAttribute("userID");

            if (orderID == null || orderID.trim().isEmpty()) {
                orderID = "DH" + new SimpleDateFormat("yyMMddHHmmss").format(new Date());
            }

            double amount = 0;
            try { amount = Double.parseDouble(amountStr != null ? amountStr.trim() : "0"); }
            catch (NumberFormatException ignored) {}

            String receiveDate = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());

            OrderDTO order = new OrderDTO(
                orderID.trim(), itemName, amount,
                senderName, senderPhone, sendStation,
                receiverName, receiverPhone, recvStation,
                staffInput, null, tr, ct, receiveDate, note
            );
            // shipStatus tự động = "Chưa Chuyển" (set trong DAO khi INSERT)

            OrderDAO orderDAO = new OrderDAO();
            boolean ok = orderDAO.insertOrder(order);

            if (ok) {
                request.getSession().setAttribute("successMsg", "✅ Thêm đơn hàng thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "❌ Thêm đơn hàng thất bại!");
            }
            response.sendRedirect("GoodsController?action=listOrder");

        } else {
            StationDAO stationDAO = new StationDAO();
            request.setAttribute("stationList", stationDAO.getAllStations());
            request.getRequestDispatcher("add_order.jsp").forward(request, response);
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // Load form sửa đơn
    // ═══════════════════════════════════════════════════════════════════
    private void handleEditOrder(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String orderID    = request.getParameter("orderID");
        OrderDAO orderDAO = new OrderDAO();
        OrderDTO order    = orderDAO.getOrderByID(orderID);

        if (order == null) {
            request.getSession().setAttribute("errorMsg", "❌ Không tìm thấy đơn hàng!");
            response.sendRedirect("GoodsController?action=listOrder");
            return;
        }

        StationDAO stationDAO = new StationDAO();
        request.setAttribute("order",       order);
        request.setAttribute("stationList", stationDAO.getAllStations());
        request.getRequestDispatcher("edit_order.jsp").forward(request, response);
    }

    // ═══════════════════════════════════════════════════════════════════
    // Cập nhật đơn hàng
    // ═══════════════════════════════════════════════════════════════════
    private void handleUpdateOrder(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String orderID       = request.getParameter("orderID");
        String itemName      = request.getParameter("itemName");
        String amountStr     = request.getParameter("amount");
        String senderName    = request.getParameter("senderName");
        String senderPhone   = request.getParameter("senderPhone");
        String sendStation   = request.getParameter("sendStation");
        String receiverName  = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String recvStation   = request.getParameter("receiveStation");
        String ct            = request.getParameter("ct");
        String note          = request.getParameter("note");

        double amount = 0;
        try { amount = Double.parseDouble(amountStr != null ? amountStr.trim() : "0"); }
        catch (NumberFormatException ignored) {}

        OrderDAO orderDAO = new OrderDAO();
        OrderDTO existing = orderDAO.getOrderByID(orderID);
        if (existing == null) {
            request.getSession().setAttribute("errorMsg", "❌ Không tìm thấy đơn hàng!");
            response.sendRedirect("GoodsController?action=listOrder");
            return;
        }

        existing.setItemName(itemName);
        existing.setAmount(amount);
        existing.setSenderName(senderName);
        existing.setSenderPhone(senderPhone);
        existing.setSendStation(sendStation);
        existing.setReceiverName(receiverName);
        existing.setReceiverPhone(receiverPhone);
        existing.setReceiveStation(recvStation);
        existing.setCt(ct);
        existing.setNote(note);

        boolean ok = orderDAO.updateOrder(existing);
        request.getSession().setAttribute(
            ok ? "successMsg" : "errorMsg",
            ok ? "✅ Cập nhật đơn hàng thành công!" : "❌ Cập nhật thất bại!"
        );
        response.sendRedirect("GoodsController?action=listOrder");
    }

    // ═══════════════════════════════════════════════════════════════════
    // Xóa mềm đơn hàng
    // ═══════════════════════════════════════════════════════════════════
    private void handleDeleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String orderID    = request.getParameter("orderID");
        OrderDAO orderDAO = new OrderDAO();
        boolean ok        = orderDAO.softDelete(orderID);

        request.getSession().setAttribute(
            ok ? "successMsg" : "errorMsg",
            ok ? "✅ Đã xóa đơn hàng " + orderID : "❌ Xóa thất bại!"
        );
        response.sendRedirect("GoodsController?action=listOrder");
    }

    // ═══════════════════════════════════════════════════════════════════
    // CẬP NHẬT TRẠNG THÁI CHUYỂN HÀNG ← MỚI
    // Khi bấm nút "Chuyển Hàng" trong list_order.jsp
    // shipStatus: "Chưa Chuyển" → "Đã Chuyển"
    // ═══════════════════════════════════════════════════════════════════
    private void handleUpdateShipStatus(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String orderID = request.getParameter("orderID");

        if (orderID == null || orderID.trim().isEmpty()) {
            sendJson(response, false, "Thiếu mã đơn hàng");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        boolean ok = orderDAO.markAsShipped(orderID.trim());

        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
                      || (request.getHeader("Accept") != null
                          && request.getHeader("Accept").contains("application/json"));

        if (isAjax) {
            sendJson(response, ok, ok ? "Đã cập nhật trạng thái" : "Không tìm thấy đơn " + orderID);
        } else {
            request.getSession().setAttribute(
                ok ? "successMsg" : "errorMsg",
                ok ? "✅ Đã chuyển đơn hàng " + orderID : "❌ Không tìm thấy đơn hàng " + orderID
            );
            response.sendRedirect("GoodsController?action=listOrder");
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // Danh sách chuyến xe ĐI
    // ═══════════════════════════════════════════════════════════════════
    private void handleListTripDepart(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        TripDAO    tripDAO    = new TripDAO();
        TruckDAO   truckDAO   = new TruckDAO();
        StationDAO stationDAO = new StationDAO();

        request.setAttribute("tripList",    tripDAO.getTripsByType("depart"));
        request.setAttribute("truckList",   truckDAO.getActiveTrucks());
        request.setAttribute("stationList", stationDAO.getAllStations());
        request.getRequestDispatcher("list_trip_depart.jsp").forward(request, response);
    }

    // ═══════════════════════════════════════════════════════════════════
    // Thêm chuyến xe ĐI
    // ═══════════════════════════════════════════════════════════════════
    private void handleAddTripDepart(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String tripID = "TRIP" + new SimpleDateFormat("yyMMddHHmmss").format(new Date());
        HttpSession session = request.getSession(false);

        TripDTO trip = buildTripDTO(request, tripID, "Đang đi", "depart",
                                    (String) session.getAttribute("userID"));

        TripDAO tripDAO = new TripDAO();
        boolean ok = tripDAO.insertTrip(trip);

        request.getSession().setAttribute(
            ok ? "successMsg" : "errorMsg",
            ok ? "✅ Thêm chuyến xe đi thành công!" : "❌ Thêm chuyến xe thất bại!"
        );
        response.sendRedirect("GoodsController?action=listTripDepart");
    }

    // ═══════════════════════════════════════════════════════════════════
    // Danh sách chuyến xe ĐẾN
    // ═══════════════════════════════════════════════════════════════════
    private void handleListTripArrive(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        TripDAO    tripDAO    = new TripDAO();
        TruckDAO   truckDAO   = new TruckDAO();
        StationDAO stationDAO = new StationDAO();

        request.setAttribute("tripList",    tripDAO.getTripsByType("arrive"));
        request.setAttribute("truckList",   truckDAO.getActiveTrucks());
        request.setAttribute("stationList", stationDAO.getAllStations());
        request.getRequestDispatcher("list_trip_arrive.jsp").forward(request, response);
    }

    // ═══════════════════════════════════════════════════════════════════
    // Thêm chuyến xe ĐẾN
    // ═══════════════════════════════════════════════════════════════════
    private void handleAddTripArrive(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String tripID = "TRIP" + new SimpleDateFormat("yyMMddHHmmss").format(new Date());
        HttpSession session = request.getSession(false);

        TripDTO trip = buildTripDTO(request, tripID, "Đang đến", "arrive",
                                    (String) session.getAttribute("userID"));

        TripDAO tripDAO = new TripDAO();
        boolean ok = tripDAO.insertTrip(trip);

        request.getSession().setAttribute(
            ok ? "successMsg" : "errorMsg",
            ok ? "✅ Thêm chuyến xe đến thành công!" : "❌ Thêm chuyến xe thất bại!"
        );
        response.sendRedirect("GoodsController?action=listTripArrive");
    }

    // ═══════════════════════════════════════════════════════════════════
    // Gán đơn hàng lên chuyến xe → shipStatus = "Đã Chuyển"
    // ═══════════════════════════════════════════════════════════════════
    private void handleAssignTrip(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String orderID = request.getParameter("orderID");
        String tripID  = request.getParameter("tripID");

        if (orderID == null || tripID == null
                || orderID.trim().isEmpty() || tripID.trim().isEmpty()) {
            sendJson(response, false, "Thiếu mã đơn hoặc mã chuyến");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        boolean ok = orderDAO.assignToTrip(orderID.trim(), tripID.trim());

        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
                      || (request.getHeader("Accept") != null
                          && request.getHeader("Accept").contains("application/json"));

        if (isAjax) {
            sendJson(response, ok, ok ? "Gán chuyến thành công" : "Gán chuyến thất bại");
        } else {
            request.getSession().setAttribute(
                ok ? "successMsg" : "errorMsg",
                ok ? "✅ Đã gán đơn " + orderID + " vào chuyến " + tripID
                   : "❌ Gán chuyến thất bại!"
            );
            response.sendRedirect("GoodsController?action=listOrder");
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // HELPER: Build TripDTO từ request params
    // ═══════════════════════════════════════════════════════════════════
    private TripDTO buildTripDTO(HttpServletRequest req, String tripID,
                                  String status, String tripType, String staffCreated) {
        TripDTO t = new TripDTO();
        t.setTripID(tripID);
        t.setTruckID(req.getParameter("truckID"));
        t.setDeparture(req.getParameter("departure"));
        t.setDestination(req.getParameter("destination"));
        t.setDepartureTime(req.getParameter("departureTime"));
        t.setDriverName(req.getParameter("driverName"));
        t.setAssistantName(req.getParameter("assistantName"));
        t.setNotes(req.getParameter("notes"));
        t.setStatus(status);
        t.setTripType(tripType);
        t.setStaffCreated(staffCreated);
        return t;
    }

    // ═══════════════════════════════════════════════════════════════════
    // HELPER: Trả về JSON
    // ═══════════════════════════════════════════════════════════════════
    private void sendJson(HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\""
                + message.replace("\"", "'") + "\"}");
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
}