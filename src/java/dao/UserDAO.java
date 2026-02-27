package dao;

import dto.UserDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class UserDAO {

    // ── Kiểm tra đăng nhập ───────────────────────────────────────────────
    public UserDTO checkLogin(String userID, String password) throws SQLException {
        String sql = "SELECT fullName, roleID, phone, email, status "
                   + "FROM tblUsers WHERE userID=? AND password=? AND status=1";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new UserDTO(userID, rs.getString("fullName"),
                            rs.getString("roleID"), "", rs.getString("phone"),
                            rs.getString("email"), rs.getBoolean("status"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // ── Lấy tất cả nhân viên ─────────────────────────────────────────────
    public List<UserDTO> getAllUsers() throws SQLException, ClassNotFoundException {
        List<UserDTO> list = new ArrayList<>();
        String sql = "SELECT userID, fullName, roleID, password, phone, email, status "
                   + "FROM tblUsers ORDER BY roleID, fullName";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
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
    public boolean insertUser(UserDTO user) throws SQLException {
        String sql = "INSERT INTO tblUsers(userID,fullName,roleID,password,phone,email,status) "
                   + "VALUES(?,?,?,?,?,?,?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUserID());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getRoleID());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getEmail());
            ps.setBoolean(7, user.isStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── Bật / tắt trạng thái nhân viên ──────────────────────────────────
    public boolean toggleUserStatus(String userID) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE tblUsers SET status = CASE WHEN status=1 THEN 0 ELSE 1 END "
                   + "WHERE userID=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Vô hiệu hóa nhân viên (tương đương xóa mềm) ─────────────────────
    public boolean deactivateUser(String userID) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE tblUsers SET status=0 WHERE userID=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Cập nhật thông tin nhân viên ─────────────────────────────────────
    public boolean updateUser(UserDTO user) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE tblUsers SET fullName=?, phone=?, email=?, roleID=? WHERE userID=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRoleID());
            ps.setString(5, user.getUserID());
            return ps.executeUpdate() > 0;
        }
    }
}
