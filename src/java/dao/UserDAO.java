/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author HuyNHSE190240
 */
import dto.UserDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class UserDAO {

    // Kiểm tra đăng nhập
    public UserDTO checkLogin(String userID, String password) throws SQLException {
        UserDTO user = null;
        String sql = "SELECT fullName, roleID, phone, email, status FROM tblUsers WHERE userID = ? AND password = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ptm = conn.prepareStatement(sql)) {
            ptm.setString(1, userID);
            ptm.setString(2, password);
            try ( ResultSet rs = ptm.executeQuery()) {
                if (rs.next()) {
                    user = new UserDTO(userID, rs.getString("fullName"), rs.getString("roleID"),
                            "", rs.getString("phone"), rs.getString("email"), rs.getBoolean("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Thêm người dùng mới (Dùng try-with-resources)
    public boolean insertUser(UserDTO user) throws SQLException {
        String sql = "INSERT INTO tblUsers(userID, fullName, roleID, password, phone, email, status) VALUES(?,?,?,?,?,?,?)";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ptm = conn.prepareStatement(sql)) {
            ptm.setString(1, user.getUserID());
            ptm.setString(2, user.getFullName());
            ptm.setString(3, user.getRoleID());
            ptm.setString(4, user.getPassword());
            ptm.setString(5, user.getPhone());
            ptm.setString(6, user.getEmail());
            ptm.setBoolean(7, user.isStatus());
            return ptm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hàm lấy danh sách tất cả nhân viên
    public List<UserDTO> getAllUsers() throws SQLException, ClassNotFoundException {
        List<UserDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = utils.DBUtils.getConnection();
            if (conn != null) {
                // Câu lệnh SQL truy vấn đầy đủ thông tin nhân viên
                String sql = "SELECT userID, fullName, roleID, password, phone, email, status FROM tblUsers";
                ptm = conn.prepareStatement(sql);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String userID = rs.getString("userID");
                    String fullName = rs.getString("fullName");
                    String roleID = rs.getString("roleID");
                    String password = rs.getString("password");
                    String phone = rs.getString("phone");
                    String email = rs.getString("email");
                    boolean status = rs.getBoolean("status");
                    list.add(new UserDTO(userID, fullName, roleID, password, phone, email, status));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return list;
    }
}
