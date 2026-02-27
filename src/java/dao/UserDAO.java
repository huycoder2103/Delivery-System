package dao;

import dto.UserDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class UserDAO {

    // ── Đăng nhập ─────────────────────────────────────────────────────────
    public UserDTO checkLogin(String userID, String password) {
        String sql = "SELECT fullName,roleID,phone,email,status FROM tblUsers "
                   + "WHERE userID=? AND password=? AND status=1";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userID);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new UserDTO(userID, rs.getString("fullName"),
                            rs.getString("roleID"), "",
                            rs.getString("phone"), rs.getString("email"),
                            rs.getBoolean("status"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // ── Lấy tất cả nhân viên ─────────────────────────────────────────────
    public List<UserDTO> getAllUsers() throws Exception {
        List<UserDTO> list = new ArrayList<>();
        String sql = "SELECT userID,fullName,roleID,password,phone,email,status "
                   + "FROM tblUsers ORDER BY roleID,fullName";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new UserDTO(
                    rs.getString("userID"), rs.getString("fullName"),
                    rs.getString("roleID"), rs.getString("password"),
                    rs.getString("phone"),  rs.getString("email"),
                    rs.getBoolean("status")
                ));
            }
        }
        return list;
    }

    // ── Thêm nhân viên mới ───────────────────────────────────────────────
    public boolean insertUser(UserDTO user) throws Exception {
        String sql = "INSERT INTO tblUsers(userID,fullName,roleID,password,phone,email,status) "
                   + "VALUES(?,?,?,?,?,?,?)";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getUserID());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getRoleID());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getEmail());
            ps.setBoolean(7, user.isStatus());
            return ps.executeUpdate() > 0;
        }
    }

    // ── Đổi mật khẩu ─────────────────────────────────────────────────────
    public boolean changePassword(String userID, String newPassword) throws Exception {
        String sql = "UPDATE tblUsers SET password=? WHERE userID=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, userID);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Bật / Tắt trạng thái nhân viên ───────────────────────────────────
    public boolean toggleUserStatus(String userID) throws Exception {
        String sql = "UPDATE tblUsers SET status=CASE WHEN status=1 THEN 0 ELSE 1 END WHERE userID=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userID);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * XÓA NHÂN VIÊN KHỎI DATABASE (hard delete).
     * Yêu cầu mới: Xóa hoàn toàn, không chỉ set status=0.
     * Lưu ý: Nếu nhân viên có FK references (tblOrders, tblTrips), cần set NULL trước.
     */
    public boolean deleteUser(String userID) throws Exception {
        try (Connection c = DBUtils.getConnection()) {
            c.setAutoCommit(false);
            try {
                // 1. Set staffInput/staffReceive = NULL trong tblOrders (tránh FK violation)
                try (PreparedStatement ps = c.prepareStatement(
                        "UPDATE tblOrders SET staffInput=NULL WHERE staffInput=?")) {
                    ps.setString(1, userID); ps.executeUpdate();
                }
                try (PreparedStatement ps = c.prepareStatement(
                        "UPDATE tblOrders SET staffReceive=NULL WHERE staffReceive=?")) {
                    ps.setString(1, userID); ps.executeUpdate();
                }
                // 2. Set staffCreated = NULL trong tblTrips
                try (PreparedStatement ps = c.prepareStatement(
                        "UPDATE tblTrips SET staffCreated=NULL WHERE staffCreated=?")) {
                    ps.setString(1, userID); ps.executeUpdate();
                }
                // 3. Set createdBy = NULL trong tblAnnouncements
                try (PreparedStatement ps = c.prepareStatement(
                        "UPDATE tblAnnouncements SET createdBy=NULL WHERE createdBy=?")) {
                    ps.setString(1, userID); ps.executeUpdate();
                }
                // 4. Xóa nhân viên
                try (PreparedStatement ps = c.prepareStatement(
                        "DELETE FROM tblUsers WHERE userID=?")) {
                    ps.setString(1, userID); ps.executeUpdate();
                }
                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback();
                throw e;
            }
        }
    }

    // ── Cập nhật thông tin nhân viên ──────────────────────────────────────
    public boolean updateUser(UserDTO user) throws Exception {
        String sql = "UPDATE tblUsers SET fullName=?,phone=?,email=?,roleID=? WHERE userID=?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRoleID());
            ps.setString(5, user.getUserID());
            return ps.executeUpdate() > 0;
        }
    }
}