package dao;

import dto.OrderDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class OrderDAO {

    // ── Helper: Map một ResultSet row → OrderDTO ─────────────────────────
    private OrderDTO mapRow(ResultSet rs) throws SQLException {
        OrderDTO o = new OrderDTO(
            rs.getString("orderID"),
            rs.getString("itemName"),
            rs.getDouble("amount"),
            rs.getString("senderName"),
            rs.getString("senderPhone"),
            rs.getString("sendStation"),
            rs.getString("receiverName"),
            rs.getString("receiverPhone"),
            rs.getString("receiveStation"),
            rs.getString("staffInput"),
            rs.getString("staffReceive"),
            rs.getString("tr"),
            rs.getString("ct"),
            rs.getString("receiveDate")
        );
        try { o.setNote(rs.getString("note")); } catch (Exception ignored) {}
        try { o.setTripID(rs.getString("tripID")); } catch (Exception ignored) {}
        return o;
    }

    // ══════════════════════════════════════════════════════════════════════
    // ĐỌC DỮ LIỆU
    // ══════════════════════════════════════════════════════════════════════

    /** Lấy tất cả đơn hàng chưa xóa */
    public List<OrderDTO> getAllOrders() throws Exception {
        String sql = "SELECT orderID,itemName,amount,senderName,senderPhone,sendStation,"
                   + "receiverName,receiverPhone,receiveStation,staffInput,staffReceive,"
                   + "tr,ct,receiveDate,tripID,note FROM tblOrders WHERE isDeleted=0 ORDER BY createdAt DESC";
        return queryList(sql);
    }

    /** Lọc đơn hàng theo trạm nhận, ngày, trạng thái */
    public List<OrderDTO> getFilteredOrders(String stationFilter, String dateFilter, String statusFilter)
            throws Exception {
        StringBuilder sql = new StringBuilder(
            "SELECT orderID,itemName,amount,senderName,senderPhone,sendStation,"
          + "receiverName,receiverPhone,receiveStation,staffInput,staffReceive,"
          + "tr,ct,receiveDate,tripID,note FROM tblOrders WHERE isDeleted=0 ");
        List<Object> params = new ArrayList<>();

        if (stationFilter != null && !stationFilter.trim().isEmpty()) {
            sql.append("AND receiveStation=? ");
            params.add(stationFilter.trim());
        }
        if (dateFilter != null && !dateFilter.trim().isEmpty()) {
            sql.append("AND CAST(createdAt AS DATE)=? ");
            params.add(dateFilter.trim());
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append("AND tr=? ");
            params.add(statusFilter.trim());
        }
        sql.append("ORDER BY createdAt DESC");
        return queryListWithParams(sql.toString(), params);
    }

    /** Tìm đơn theo SĐT người gửi hoặc nhận */
    public List<OrderDTO> searchByPhone(String phone) throws Exception {
        String sql = "SELECT orderID,itemName,amount,senderName,senderPhone,sendStation,"
                   + "receiverName,receiverPhone,receiveStation,staffInput,staffReceive,"
                   + "tr,ct,receiveDate,tripID,note FROM tblOrders WHERE isDeleted=0 "
                   + "AND (senderPhone LIKE ? OR receiverPhone LIKE ?) ORDER BY createdAt DESC";
        List<Object> params = new ArrayList<>();
        params.add("%" + phone + "%");
        params.add("%" + phone + "%");
        return queryListWithParams(sql, params);
    }

    /** Lấy đơn theo ID */
    public OrderDTO getOrderByID(String orderID) throws Exception {
        String sql = "SELECT orderID,itemName,amount,senderName,senderPhone,sendStation,"
                   + "receiverName,receiverPhone,receiveStation,staffInput,staffReceive,"
                   + "tr,ct,receiveDate,tripID,note FROM tblOrders WHERE orderID=? AND isDeleted=0";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Lấy danh sách đơn hàng đã xóa (thùng rác) */
    public List<OrderDTO> getDeletedOrders() throws Exception {
        String sql = "SELECT orderID,itemName,amount,senderName,senderPhone,sendStation,"
                   + "receiverName,receiverPhone,receiveStation,staffInput,staffReceive,"
                   + "tr,ct,receiveDate,tripID,note FROM tblOrders WHERE isDeleted=1 ORDER BY createdAt DESC";
        return queryList(sql);
    }

    /** Lấy đơn hàng chưa chuyển theo trạm gửi (để gán lên xe) */
    public List<OrderDTO> getPendingOrdersByStation(String station) throws Exception {
        String sql = "SELECT orderID,itemName,amount,senderName,senderPhone,sendStation,"
                   + "receiverName,receiverPhone,receiveStation,staffInput,staffReceive,"
                   + "tr,ct,receiveDate,tripID,note FROM tblOrders "
                   + "WHERE isDeleted=0 AND tr=N'Chưa Chuyển' AND sendStation=? ORDER BY createdAt ASC";
        List<Object> params = new ArrayList<>();
        params.add(station != null ? station : "");
        return queryListWithParams(sql, params);
    }

    /** Lấy danh sách đơn đã được gán lên một chuyến xe */
    public List<OrderDTO> getOrdersByTrip(String tripID) throws Exception {
        String sql = "SELECT o.orderID,o.itemName,o.amount,o.senderName,o.senderPhone,o.sendStation,"
                   + "o.receiverName,o.receiverPhone,o.receiveStation,o.staffInput,o.staffReceive,"
                   + "o.tr,o.ct,o.receiveDate,o.tripID,o.note FROM tblOrders o "
                   + "INNER JOIN tblOrderTrip ot ON o.orderID=ot.orderID "
                   + "WHERE ot.tripID=? AND o.isDeleted=0";
        List<Object> params = new ArrayList<>();
        params.add(tripID);
        return queryListWithParams(sql, params);
    }

    // ══════════════════════════════════════════════════════════════════════
    // GHI DỮ LIỆU
    // ══════════════════════════════════════════════════════════════════════

    /** Thêm đơn hàng mới */
    public boolean insertOrder(OrderDTO o) throws Exception {
        String sql = "INSERT INTO tblOrders"
                   + "(orderID,itemName,amount,senderName,senderPhone,sendStation,"
                   + "receiverName,receiverPhone,receiveStation,staffInput,tr,ct,receiveDate,note)"
                   + " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
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
            ps.setString(11, o.getTr() != null ? o.getTr() : "Chưa Chuyển");
            ps.setString(12, o.getCt());
            ps.setString(13, o.getReceiveDate());
            ps.setString(14, o.getNote());
            return ps.executeUpdate() > 0;
        }
    }

    /** Cập nhật đơn hàng */
    public boolean updateOrder(OrderDTO o) throws Exception {
        String sql = "UPDATE tblOrders SET itemName=?,amount=?,senderName=?,senderPhone=?,"
                   + "sendStation=?,receiverName=?,receiverPhone=?,receiveStation=?,"
                   + "staffInput=?,ct=?,note=? WHERE orderID=? AND isDeleted=0";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,  o.getItemName());
            ps.setDouble(2,  o.getAmount());
            ps.setString(3,  o.getSenderName());
            ps.setString(4,  o.getSenderPhone());
            ps.setString(5,  o.getSendStation());
            ps.setString(6,  o.getReceiverName());
            ps.setString(7,  o.getReceiverPhone());
            ps.setString(8,  o.getReceiveStation());
            ps.setString(9,  o.getStaffInput());
            ps.setString(10, o.getCt());
            ps.setString(11, o.getNote());
            ps.setString(12, o.getOrderID());
            return ps.executeUpdate() > 0;
        }
    }

    /** Cập nhật trạng thái đơn hàng */
    public boolean updateStatus(String orderID, String status) throws Exception {
        String sql = "UPDATE tblOrders SET tr=? WHERE orderID=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    /** Gán đơn hàng vào chuyến xe */
    public boolean assignToTrip(String orderID, String tripID) throws Exception {
        try (Connection c = DBUtils.getConnection()) {
            c.setAutoCommit(false);
            try {
                // Kiểm tra đã gán chưa
                String chk = "SELECT COUNT(*) FROM tblOrderTrip WHERE orderID=? AND tripID=?";
                try (PreparedStatement ps = c.prepareStatement(chk)) {
                    ps.setString(1, orderID); ps.setString(2, tripID);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            c.commit();
                            return true; // đã gán rồi
                        }
                    }
                }
                // Insert liên kết
                String ins = "INSERT INTO tblOrderTrip(orderID,tripID) VALUES(?,?)";
                try (PreparedStatement ps = c.prepareStatement(ins)) {
                    ps.setString(1, orderID); ps.setString(2, tripID);
                    ps.executeUpdate();
                }
                // Cập nhật tripID và trạng thái
                String upd = "UPDATE tblOrders SET tripID=?,tr=N'Đã Chuyển' WHERE orderID=?";
                try (PreparedStatement ps = c.prepareStatement(upd)) {
                    ps.setString(1, tripID); ps.setString(2, orderID);
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

    // ══════════════════════════════════════════════════════════════════════
    // XÓA
    // ══════════════════════════════════════════════════════════════════════

    /** Xóa mềm (đưa vào thùng rác) */
    public boolean softDelete(String orderID) throws Exception {
        String sql = "UPDATE tblOrders SET isDeleted=1 WHERE orderID=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    /** Khôi phục từ thùng rác */
    public boolean restore(String orderID) throws Exception {
        String sql = "UPDATE tblOrders SET isDeleted=0 WHERE orderID=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    /** Xóa vĩnh viễn khỏi DB */
    public boolean permanentDelete(String orderID) throws Exception {
        try (Connection c = DBUtils.getConnection()) {
            c.setAutoCommit(false);
            try {
                // Xóa liên kết tblOrderTrip trước (tránh FK violation)
                try (PreparedStatement ps = c.prepareStatement("DELETE FROM tblOrderTrip WHERE orderID=?")) {
                    ps.setString(1, orderID); ps.executeUpdate();
                }
                // Xóa đơn hàng
                try (PreparedStatement ps = c.prepareStatement("DELETE FROM tblOrders WHERE orderID=?")) {
                    ps.setString(1, orderID); ps.executeUpdate();
                }
                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback();
                throw e;
            }
        }
    }

    // ══════════════════════════════════════════════════════════════════════
    // PRIVATE HELPERS
    // ══════════════════════════════════════════════════════════════════════

    private List<OrderDTO> queryList(String sql) throws Exception {
        List<OrderDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private List<OrderDTO> queryListWithParams(String sql, List<Object> params) throws Exception {
        List<OrderDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }
}