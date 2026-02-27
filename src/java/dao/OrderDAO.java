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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class OrderDAO {

    // 1. Lấy toàn bộ danh sách đơn hàng
    public List<OrderDTO> getAllOrders() throws SQLException, ClassNotFoundException {
        List<OrderDTO> list = new ArrayList<>();
        String sql = "SELECT orderID, itemName, amount, senderName, senderPhone, sendStation, "
                   + "receiverName, receiverPhone, receiveStation, staffInput, staffReceive, "
                   + "tr, ct, receiveDate FROM tblOrders";
        
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ptm = conn.prepareStatement(sql); 
             ResultSet rs = ptm.executeQuery()) {
            while (rs.next()) {
                list.add(new OrderDTO(
                    rs.getString("orderID"), rs.getString("itemName"), rs.getDouble("amount"),
                    rs.getString("senderName"), rs.getString("senderPhone"), rs.getString("sendStation"),
                    rs.getString("receiverName"), rs.getString("receiverPhone"), rs.getString("receiveStation"),
                    rs.getString("staffInput"), rs.getString("staffReceive"),
                    rs.getString("tr"), rs.getString("ct"), rs.getString("receiveDate")
                ));
            }
        }
        return list;
    }

    // 2. Tìm kiếm đơn hàng theo số điện thoại (Hỗ trợ chức năng Search của bạn)
    public List<OrderDTO> searchOrderByPhone(String phone) throws SQLException, ClassNotFoundException {
        List<OrderDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblOrders WHERE senderPhone LIKE ? OR receiverPhone LIKE ?";
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ptm = conn.prepareStatement(sql)) {
            ptm.setString(1, "%" + phone + "%");
            ptm.setString(2, "%" + phone + "%");
            try (ResultSet rs = ptm.executeQuery()) {
                while (rs.next()) {
                    list.add(new OrderDTO(
                        rs.getString("orderID"), rs.getString("itemName"), rs.getDouble("amount"),
                        rs.getString("senderName"), rs.getString("senderPhone"), rs.getString("sendStation"),
                        rs.getString("receiverName"), rs.getString("receiverPhone"), rs.getString("receiveStation"),
                        rs.getString("staffInput"), rs.getString("staffReceive"),
                        rs.getString("tr"), rs.getString("ct"), rs.getString("receiveDate")
                    ));
                }
            }
        }
        return list;
    }

    // 3. Xóa đơn hàng (Hỗ trợ nút Delete)
    public boolean deleteOrder(String orderID) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM tblOrders WHERE orderID = ?";
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ptm = conn.prepareStatement(sql)) {
            ptm.setString(1, orderID);
            return ptm.executeUpdate() > 0;
        }
    }
    
    // 4. Lưu đơn hàng mới (Hỗ trợ SaveOrderController)
    public boolean insertOrder(OrderDTO order) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO tblOrders(orderID, itemName, amount, senderName, senderPhone, sendStation, receiverName, receiverPhone, receiveStation, staffInput, tr, ct, receiveDate) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ptm = conn.prepareStatement(sql)) {
            ptm.setString(1, order.getOrderID());
            ptm.setString(2, order.getItemName());
            ptm.setDouble(3, order.getAmount());
            ptm.setString(4, order.getSenderName());
            ptm.setString(5, order.getSenderPhone());
            ptm.setString(6, order.getSendStation());
            ptm.setString(7, order.getReceiverName());
            ptm.setString(8, order.getReceiverPhone());
            ptm.setString(9, order.getReceiveStation());
            ptm.setString(10, order.getStaffInput());
            ptm.setString(11, order.getTr());
            ptm.setString(12, order.getCt());
            ptm.setString(13, order.getReceiveDate());
            return ptm.executeUpdate() > 0;
        }
    }
}