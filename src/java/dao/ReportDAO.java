package dao;

import dto.ReportSummaryDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class ReportDAO {

    /**
     * Lấy thống kê theo ca cho nhân viên.
     */
    public ReportSummaryDTO getSummaryByShift(int shiftID) throws SQLException {
        ReportSummaryDTO dto = new ReportSummaryDTO();
        String sql = "SELECT " +
                     "COUNT(*) AS total, " +
                     "SUM(CASE WHEN shipStatus = 'Đã Chuyển' THEN 1 ELSE 0 END) AS delivered, " +
                     "SUM(CASE WHEN shipStatus = 'Chưa Chuyển' AND tripID IS NOT NULL THEN 1 ELSE 0 END) AS delivering, " +
                     "SUM(CASE WHEN shipStatus = 'Chưa Chuyển' AND tripID IS NULL THEN 1 ELSE 0 END) AS pending, " +
                     "SUM(CASE WHEN shipStatus = 'Đã Chuyển' THEN amount ELSE 0 END) AS revenue " +
                     "FROM tblOrders WHERE shiftID = ? AND isDeleted = 0";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shiftID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto.setTotalOrders(rs.getInt("total"));
                    dto.setDeliveredOrders(rs.getInt("delivered"));
                    dto.setDeliveringOrders(rs.getInt("delivering"));
                    dto.setPendingOrders(rs.getInt("pending"));
                    dto.setTotalRevenue(rs.getDouble("revenue"));
                }
            }
        }
        // Đếm số chuyến xe trong ca
        String sqlTrip = "SELECT COUNT(*) FROM tblTrips WHERE shiftID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlTrip)) {
            ps.setInt(1, shiftID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) dto.setTotalTrips(rs.getInt(1));
            }
        }
        return dto;
    }

    /**
     * Admin: Lấy tổng doanh thu theo ngày bất kỳ.
     */
    public double getRevenueByDate(String date) throws SQLException {
        String sql = "SELECT SUM(amount) FROM tblOrders WHERE DATE(createdAt) = ? AND isDeleted = 0 AND shipStatus = 'Đã Chuyển'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        }
        return 0;
    }

    /**
     * Admin: Đếm số đơn hàng theo ngày bất kỳ.
     */
    public int getOrdersCountByDate(String date) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tblOrders WHERE DATE(createdAt) = ? AND isDeleted = 0";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Admin: Lấy tổng doanh thu hôm nay.
     */
    public double getRevenueToday() throws SQLException {
        String sql = "SELECT SUM(amount) FROM tblOrders WHERE DATE(createdAt) = CURDATE() AND isDeleted = 0 AND shipStatus = 'Đã Chuyển'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }

    /**
     * Admin: Đếm số nhân viên đang trong ca (ACTIVE).
     */
    public int getActiveStaffCount() throws SQLException {
        String sql = "SELECT COUNT(DISTINCT staffID) FROM tblWorkShifts WHERE status = 'ACTIVE'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    /**
     * Lấy lịch sử ca làm việc của nhân viên.
     */
    public List<dto.ShiftDTO> getShiftHistory(String staffID) throws SQLException {
        List<dto.ShiftDTO> list = new ArrayList<>();
        // Lấy tất cả các ca (cả ACTIVE và CLOSED) để nhân viên thấy ca hiện tại của mình luôn
        String sql = "SELECT shiftID, staffID, " +
                     "DATE_FORMAT(startTime, '%d/%m/%Y %H:%i') as startStr, " +
                     "DATE_FORMAT(endTime, '%d/%m/%Y %H:%i') as endStr, status " +
                     "FROM tblWorkShifts WHERE staffID = ? ORDER BY startTime DESC LIMIT 20";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new dto.ShiftDTO(
                        rs.getInt("shiftID"), 
                        rs.getString("staffID"),
                        rs.getString("startStr"), 
                        rs.getString("endStr"), 
                        rs.getString("status")
                    ));
                }
            }
        }
        return list;
    }

    /**
     * Admin: Doanh thu hệ thống theo tháng này.
     */
    public double getRevenueThisMonth() throws SQLException {
        String sql = "SELECT SUM(amount) FROM tblOrders WHERE MONTH(createdAt) = MONTH(CURDATE()) " +
                     "AND YEAR(createdAt) = YEAR(CURDATE()) AND isDeleted = 0 AND shipStatus = 'Đã Chuyển'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }

    /**
     * Admin: Lấy bảng hiệu suất nhân viên theo ngày bất kỳ.
     */
    public List<dto.ReportSummaryDTO> getStaffPerformance(String date) throws SQLException {
        List<dto.ReportSummaryDTO> list = new ArrayList<>();
        // Logic: Ưu tiên lấy những ai ĐANG TRONG CA (status = 'ACTIVE') hoặc CÓ ĐƠN HÀNG trong ngày được chọn
        String sql = "SELECT u.userID, u.fullName, " +
                     "COUNT(o.orderID) as total, " +
                     "SUM(CASE WHEN o.shipStatus = 'Đã Chuyển' THEN o.amount ELSE 0 END) as revenue, " +
                     "MAX(CASE WHEN s.status = 'ACTIVE' THEN 1 ELSE 0 END) as isInShift " +
                     "FROM tblUsers u " +
                     "LEFT JOIN tblWorkShifts s ON u.userID = s.staffID AND s.status = 'ACTIVE' " +
                     "LEFT JOIN tblOrders o ON u.userID = o.staffInput AND DATE(o.createdAt) = ? AND o.isDeleted = 0 " +
                     "WHERE u.roleID = 'US' " +
                     "GROUP BY u.userID, u.fullName";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    dto.ReportSummaryDTO d = new dto.ReportSummaryDTO();
                    d.setStaffID(rs.getString("userID"));
                    d.setStaffName(rs.getString("fullName"));
                    d.setPendingOrders(rs.getInt("isInShift")); 
                    d.setTotalOrders(rs.getInt("total"));
                    d.setTotalRevenue(rs.getDouble("revenue"));
                    list.add(d);
                }
            }
        }
        return list;
    }

    /**
     * Admin: Lấy dữ liệu biểu đồ doanh thu 7 ngày gần nhất.
     */
    public ReportSummaryDTO getWeeklyRevenueChart() throws SQLException {
        ReportSummaryDTO dto = new ReportSummaryDTO();
        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();
        // Sửa lỗi ONLY_FULL_GROUP_BY: Group by chính cái label hoặc dùng DATE(createdAt) đồng nhất
        String sql = "SELECT DATE_FORMAT(createdAt, '%d/%m') as dateLabel, SUM(amount) as dailyRevenue, DATE(createdAt) as orderDate " +
                     "FROM tblOrders WHERE createdAt >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                     "AND isDeleted = 0 AND shipStatus = 'Đã Chuyển' " +
                     "GROUP BY orderDate, dateLabel ORDER BY orderDate ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                labels.add(rs.getString("dateLabel"));
                values.add(rs.getDouble("dailyRevenue"));
            }
        }
        dto.setChartLabels(labels);
        dto.setChartValues(values);
        return dto;
    }
}
