package dao;

import dto.ShiftDTO;
import java.sql.*;
import utils.DBUtils;

public class ShiftDAO {

    /**
     * Lấy ca đang hoạt động của nhân viên.
     */
    public ShiftDTO getActiveShift(String staffID) throws SQLException {
        String sql = "SELECT shiftID, staffID, startTime, endTime, status FROM tblWorkShifts WHERE staffID = ? AND status = 'ACTIVE' LIMIT 1";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ShiftDTO(
                            rs.getInt("shiftID"),
                            rs.getString("staffID"),
                            rs.getString("startTime"),
                            rs.getString("endTime"),
                            rs.getString("status")
                    );
                }
            }
        }
        return null;
    }

    /**
     * Bắt đầu ca mới.
     */
    public boolean startShift(String staffID) throws SQLException {
        String sql = "INSERT INTO tblWorkShifts(staffID, startTime, status) VALUES(?, NOW(), 'ACTIVE')";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, staffID);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Kết thúc ca.
     */
    public boolean endShift(int shiftID) throws SQLException {
        String sql = "UPDATE tblWorkShifts SET endTime = NOW(), status = 'CLOSED' WHERE shiftID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shiftID);
            return ps.executeUpdate() > 0;
        }
    }
}
