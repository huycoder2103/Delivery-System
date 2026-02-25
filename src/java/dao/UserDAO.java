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
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Hàm kết nối Database (Thay đổi databaseName cho đúng)
    public Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=DeliverySystemDB";
        return DriverManager.getConnection(url, "sa", "12345");
    }

    public boolean insertUser(UserDTO user) throws SQLException, ClassNotFoundException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = getConnection();
            if (conn != null) {
                String sql = "INSERT INTO tblUsers(userID, fullName, roleID, password, phone, email, status) VALUES(?,?,?,?,?,?,?)";
                ptm = conn.prepareStatement(sql);
                ptm.setString(1, user.getUserID());
                ptm.setString(2, user.getFullName());
                ptm.setString(3, "US"); // Mặc định là nhân viên
                ptm.setString(4, user.getPassword());
                ptm.setString(5, user.getPhone());
                ptm.setString(6, user.getEmail());
                ptm.setBoolean(7, true); // Mặc định đang hoạt động
                check = ptm.executeUpdate() > 0;
            }
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return check;
    }
    // Hàm lấy danh sách tất cả nhân viên
    public List<UserDTO> getAllUsers() throws SQLException, ClassNotFoundException {
    List<UserDTO> list = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ptm = null;
    ResultSet rs = null;
    try {
        conn = getConnection();
        if (conn != null) {
            // Thêm phone và email vào câu lệnh SQL
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
                
                // Khởi tạo UserDTO với đầy đủ tham số để hiển thị lên bảng admin
                list.add(new UserDTO(userID, fullName, roleID, password, phone, email, status));
            }
        }
    } finally {
        if (rs != null) rs.close();
        if (ptm != null) ptm.close();
        if (conn != null) conn.close();
    }
    return list;
}
}