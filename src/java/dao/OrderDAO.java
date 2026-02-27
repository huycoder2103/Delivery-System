/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author jayke
 */
// File: src/java/dao/OrderDAO.java


import dto.OrderDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class OrderDAO {

    // ── Mapper từ ResultSet → OrderDTO ──────────────────────────────────
    private OrderDTO mapRow(ResultSet rs) throws SQLException {
        return new OrderDTO(
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
    }

    // ── 1. Lấy tất cả đơn hàng (chưa bị xóa) ───────────────────────────
    public List<OrderDTO> getAllOrders() throws SQLException, ClassNotFoundException {
        List<OrderDTO> list = new ArrayList<>();
        String sql = "SELECT orderID, itemName, amount, senderName, senderPhone, sendStation, "
                   + "receiverName, receiverPhone, receiveStation, staffInput, staffReceive, "
                   + "tr, ct, receiveDate FROM tblOrders WHERE isDeleted = 0 ORDER BY createdAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── 2. Lấy đơn hàng theo ID ─────────────────────────────────────────
    public OrderDTO getOrderByID(String orderID) throws SQLException, ClassNotFoundException {
        String sql = "SELECT orderID, itemName, amount, senderName, senderPhone, sendStation, "
                   + "receiverName, receiverPhone, receiveStation, staffInput, staffReceive, "
                   + "tr, ct, receiveDate FROM tblOrders WHERE orderID = ? AND isDeleted = 0";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // ── 3. Tìm kiếm theo SĐT ────────────────────────────────────────────
    public List<OrderDTO> searchOrderByPhone(String phone) throws SQLException, ClassNotFoundException {
        List<OrderDTO> list = new ArrayList<>();
        String sql = "SELECT orderID, itemName, amount, senderName, senderPhone, sendStation, "
                   + "receiverName, receiverPhone, receiveStation, staffInput, staffReceive, "
                   + "tr, ct, receiveDate FROM tblOrders "
                   + "WHERE isDeleted = 0 AND (senderPhone LIKE ? OR receiverPhone LIKE ?) "
                   + "ORDER BY createdAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + phone + "%");
            ps.setString(2, "%" + phone + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ── 4. Lấy đơn theo chuyến xe ───────────────────────────────────────
    public List<OrderDTO> getOrdersByTrip(String tripID) throws SQLException, ClassNotFoundException {
        List<OrderDTO> list = new ArrayList<>();
        String sql = "SELECT o.orderID, o.itemName, o.amount, o.senderName, o.senderPhone, "
                   + "o.sendStation, o.receiverName, o.receiverPhone, o.receiveStation, "
                   + "o.staffInput, o.staffReceive, o.tr, o.ct, o.receiveDate "
                   + "FROM tblOrders o "
                   + "INNER JOIN tblOrderTrip ot ON o.orderID = ot.orderID "
                   + "WHERE ot.tripID = ? AND o.isDeleted = 0";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tripID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ── 5. Lọc đơn hàng theo trạm, ngày, trạng thái ────────────────────
    public List<OrderDTO> filterOrders(String station, String date, String status)
            throws SQLException, ClassNotFoundException {
        List<OrderDTO> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder(
            "SELECT orderID, itemName, amount, senderName, senderPhone, sendStation, "
          + "receiverName, receiverPhone, receiveStation, staffInput, staffReceive, "
          + "tr, ct, receiveDate FROM tblOrders WHERE isDeleted = 0");

        if (station != null && !station.isEmpty()) sb.append(" AND receiveStation = ?");
        if (date != null && !date.isEmpty())       sb.append(" AND CAST(createdAt AS DATE) = ?");
        if (status != null && !status.isEmpty())   sb.append(" AND tr = ?");
        sb.append(" ORDER BY createdAt DESC");

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            int idx = 1;
            if (station != null && !station.isEmpty()) ps.setString(idx++, station);
            if (date != null && !date.isEmpty())       ps.setString(idx++, date);
            if (status != null && !status.isEmpty())   ps.setString(idx++, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ── 6. Thêm đơn hàng mới ────────────────────────────────────────────
    public boolean insertOrder(OrderDTO order) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO tblOrders "
                   + "(orderID, itemName, amount, senderName, senderPhone, sendStation, "
                   + " receiverName, receiverPhone, receiveStation, staffInput, tr, ct, receiveDate) "
                   + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1,  order.getOrderID());
            ps.setString(2,  order.getItemName());
            ps.setDouble(3,  order.getAmount());
            ps.setString(4,  order.getSenderName());
            ps.setString(5,  order.getSenderPhone());
            ps.setString(6,  order.getSendStation());
            ps.setString(7,  order.getReceiverName());
            ps.setString(8,  order.getReceiverPhone());
            ps.setString(9,  order.getReceiveStation());
            ps.setString(10, order.getStaffInput());
            ps.setString(11, order.getTr());
            ps.setString(12, order.getCt());
            ps.setString(13, order.getReceiveDate());
            return ps.executeUpdate() > 0;
        }
    }

    // ── 7. Cập nhật đơn hàng ────────────────────────────────────────────
    public boolean updateOrder(OrderDTO order) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE tblOrders SET itemName=?, amount=?, senderName=?, senderPhone=?, "
                   + "sendStation=?, receiverName=?, receiverPhone=?, receiveStation=?, ct=? "
                   + "WHERE orderID=? AND isDeleted=0";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, order.getItemName());
            ps.setDouble(2, order.getAmount());
            ps.setString(3, order.getSenderName());
            ps.setString(4, order.getSenderPhone());
            ps.setString(5, order.getSendStation());
            ps.setString(6, order.getReceiverName());
            ps.setString(7, order.getReceiverPhone());
            ps.setString(8, order.getReceiveStation());
            ps.setString(9, order.getCt());
            ps.setString(10, order.getOrderID());
            return ps.executeUpdate() > 0;
        }
    }

    // ── 8. Cập nhật trạng thái đơn hàng ─────────────────────────────────
    public boolean updateOrderStatus(String orderID, String status)
            throws SQLException, ClassNotFoundException {
        String sql = "UPDATE tblOrders SET tr = ? WHERE orderID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    // ── 9. Xóa mềm (soft delete) ─────────────────────────────────────────
    public boolean deleteOrder(String orderID) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE tblOrders SET isDeleted = 1 WHERE orderID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    // ── 10. Đếm đơn hàng theo nhân viên (cho báo cáo) ───────────────────
    public int countOrdersByStaff(String staffID) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM tblOrders WHERE staffInput = ? AND isDeleted = 0 "
                   + "AND CAST(createdAt AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // ── 11. Doanh thu của nhân viên hôm nay ─────────────────────────────
    public double revenueByStaff(String staffID) throws SQLException, ClassNotFoundException {
        String sql = "SELECT ISNULL(SUM(amount),0) FROM tblOrders WHERE staffInput = ? "
                   + "AND isDeleted = 0 AND CAST(createdAt AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        }
        return 0.0;
    }
}
