package dao;

import dto.OrderDTO;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private static final String SELECT_COLS =
        "SELECT orderID, itemName, amount, senderName, senderPhone, sendStation, " +
        "receiverName, receiverPhone, receiveStation, staffInput, staffReceive, " +
        "tr, ct, receiveDate, tripID, note, shipStatus ";

    // ── Map ResultSet → OrderDTO ─────────────────────────────────────────
    private OrderDTO mapRow(ResultSet rs) throws SQLException {
        OrderDTO o = new OrderDTO();
        o.setOrderID(rs.getString("orderID"));
        o.setItemName(rs.getString("itemName"));
        o.setAmount(rs.getDouble("amount"));
        o.setSenderName(rs.getString("senderName"));
        o.setSenderPhone(rs.getString("senderPhone"));
        o.setSendStation(rs.getString("sendStation"));
        o.setReceiverName(rs.getString("receiverName"));
        o.setReceiverPhone(rs.getString("receiverPhone"));
        o.setReceiveStation(rs.getString("receiveStation"));
        o.setStaffInput(rs.getString("staffInput"));
        o.setStaffReceive(rs.getString("staffReceive"));
        o.setTr(rs.getString("tr"));
        o.setCt(rs.getString("ct"));
        o.setReceiveDate(rs.getString("receiveDate"));
        o.setTripID(rs.getString("tripID"));
        o.setNote(rs.getString("note"));
        String ss = rs.getString("shipStatus");
        o.setShipStatus(ss != null ? ss : "Chưa Chuyển");
        return o;
    }

    // ════════════════════════════════════════════════════════════════════
    // ĐỌC
    // ════════════════════════════════════════════════════════════════════

    public List<OrderDTO> getAllOrders() throws Exception {
        String sql = SELECT_COLS + "FROM tblOrders WHERE isDeleted = 0 ORDER BY createdAt DESC";
        return queryList(sql, new ArrayList<>());
    }

    /**
     * Lọc đơn — mọi tham số null/rỗng đều bị bỏ qua
     */
    public List<OrderDTO> getFilteredOrders(String stationFilter,
                                             String dateFilter,
                                             String shipStatusFilter) throws Exception {
        StringBuilder sql = new StringBuilder(
            SELECT_COLS + "FROM tblOrders WHERE isDeleted = 0 ");
        List<Object> params = new ArrayList<>();

        if (stationFilter != null && !stationFilter.trim().isEmpty()) {
            sql.append("AND receiveStation = ? ");
            params.add(stationFilter.trim());
        }
        if (dateFilter != null && !dateFilter.trim().isEmpty()) {
            sql.append("AND CAST(createdAt AS DATE) = ? ");
            params.add(dateFilter.trim());
        }
        if (shipStatusFilter != null && !shipStatusFilter.trim().isEmpty()) {
            sql.append("AND shipStatus = ? ");
            params.add(shipStatusFilter.trim());
        }
        sql.append("ORDER BY createdAt DESC");
        return queryList(sql.toString(), params);
    }

    public OrderDTO getOrderByID(String orderID) throws Exception {
        String sql = SELECT_COLS + "FROM tblOrders WHERE orderID = ? AND isDeleted = 0";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public List<OrderDTO> searchByPhone(String phone) throws Exception {
        String sql = SELECT_COLS +
            "FROM tblOrders WHERE isDeleted = 0 " +
            "AND (senderPhone LIKE ? OR receiverPhone LIKE ?) ORDER BY createdAt DESC";
        List<Object> params = new ArrayList<>();
        params.add("%" + phone + "%");
        params.add("%" + phone + "%");
        return queryList(sql, params);
    }

    public List<OrderDTO> getOrdersByTrip(String tripID) throws Exception {
        String sql =
            "SELECT o.orderID, o.itemName, o.amount, o.senderName, o.senderPhone, " +
            "o.sendStation, o.receiverName, o.receiverPhone, o.receiveStation, " +
            "o.staffInput, o.staffReceive, o.tr, o.ct, o.receiveDate, " +
            "o.tripID, o.note, o.shipStatus " +
            "FROM tblOrders o " +
            "INNER JOIN tblOrderTrip ot ON o.orderID = ot.orderID " +
            "WHERE ot.tripID = ? AND o.isDeleted = 0";
        List<Object> params = new ArrayList<>();
        params.add(tripID);
        return queryList(sql, params);
    }

    // ════════════════════════════════════════════════════════════════════
    // THÊM
    // ════════════════════════════════════════════════════════════════════

    /** shipStatus luôn = "Chưa Chuyển" khi tạo mới */
    public boolean insertOrder(OrderDTO o) throws Exception {
        String sql =
            "INSERT INTO tblOrders " +
            "(orderID, itemName, amount, senderName, senderPhone, sendStation, " +
            "receiverName, receiverPhone, receiveStation, staffInput, tr, ct, " +
            "receiveDate, note, shipStatus) " +
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,  o.getOrderID());
            ps.setString(2,  o.getItemName());
            ps.setDouble(3,  o.getAmount());
            ps.setString(4,  o.getSenderName());
            ps.setString(5,  o.getSenderPhone());
            ps.setString(6,  o.getSendStation());
            ps.setString(7,  o.getReceiverName());
            ps.setString(8,  o.getReceiverPhone());
            ps.setString(9,  o.getReceiveStation());
            ps.setString(10, o.getStaffInput());
            ps.setString(11, o.getTr());
            ps.setString(12, o.getCt());
            ps.setString(13, o.getReceiveDate());
            ps.setString(14, o.getNote());
            ps.setString(15, "Chưa Chuyển");
            return ps.executeUpdate() > 0;
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // CẬP NHẬT
    // ════════════════════════════════════════════════════════════════════

    /** Cập nhật thông tin đơn — không đổi shipStatus và tr */
    public boolean updateOrder(OrderDTO o) throws Exception {
        String sql =
            "UPDATE tblOrders SET " +
            "itemName = ?, amount = ?, senderName = ?, senderPhone = ?, sendStation = ?, " +
            "receiverName = ?, receiverPhone = ?, receiveStation = ?, ct = ?, note = ? " +
            "WHERE orderID = ? AND isDeleted = 0";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,  o.getItemName());
            ps.setDouble(2,  o.getAmount());
            ps.setString(3,  o.getSenderName());
            ps.setString(4,  o.getSenderPhone());
            ps.setString(5,  o.getSendStation());
            ps.setString(6,  o.getReceiverName());
            ps.setString(7,  o.getReceiverPhone());
            ps.setString(8,  o.getReceiveStation());
            ps.setString(9,  o.getCt());
            ps.setString(10, o.getNote());
            ps.setString(11, o.getOrderID());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Đổi shipStatus → "Đã Chuyển"
     * Gọi khi bấm nút Chuyển Hàng trong list_order.jsp
     */
    public boolean markAsShipped(String orderID) throws Exception {
        String sql = "UPDATE tblOrders SET shipStatus = N'Đã Chuyển' " +
                     "WHERE orderID = ? AND isDeleted = 0";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Gán đơn vào chuyến xe, đồng thời đổi shipStatus = "Đã Chuyển"
     */
    public boolean assignToTrip(String orderID, String tripID) throws Exception {
        try (Connection c = DBUtils.getConnection()) {
            c.setAutoCommit(false);
            try {
                // Kiểm tra đã gán chưa
                try (PreparedStatement ps = c.prepareStatement(
                        "SELECT COUNT(*) FROM tblOrderTrip WHERE orderID = ? AND tripID = ?")) {
                    ps.setString(1, orderID);
                    ps.setString(2, tripID);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            c.commit();
                            return true;
                        }
                    }
                }
                // Insert liên kết
                try (PreparedStatement ps = c.prepareStatement(
                        "INSERT INTO tblOrderTrip(orderID, tripID) VALUES(?, ?)")) {
                    ps.setString(1, orderID);
                    ps.setString(2, tripID);
                    ps.executeUpdate();
                }
                // Update tripID + shipStatus
                try (PreparedStatement ps = c.prepareStatement(
                        "UPDATE tblOrders SET tripID = ?, shipStatus = N'Đã Chuyển' " +
                        "WHERE orderID = ?")) {
                    ps.setString(1, tripID);
                    ps.setString(2, orderID);
                    ps.executeUpdate();
                }
                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback();
                throw e;
            }
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // XÓA
    // ════════════════════════════════════════════════════════════════════

    public boolean softDelete(String orderID) throws Exception {
        String sql = "UPDATE tblOrders SET isDeleted = 1 WHERE orderID = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean restore(String orderID) throws Exception {
        String sql = "UPDATE tblOrders SET isDeleted = 0 WHERE orderID = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // PRIVATE
    // ════════════════════════════════════════════════════════════════════

    private List<OrderDTO> queryList(String sql, List<Object> params) throws Exception {
        List<OrderDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }
}