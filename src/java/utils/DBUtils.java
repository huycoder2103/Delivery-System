package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBUtils - Tiện ích kết nối cơ sở dữ liệu
 * 
 * ĐỂ THAY ĐỔI CẤU HÌNH KẾT NỐI:
 *   - Chỉnh DB_HOST nếu SQL Server không nằm trên localhost
 *   - Chỉnh USER_NAME / PASSWORD theo tài khoản SQL Server của bạn
 */
public class DBUtils {

    // --- CẤU HÌNH KẾT NỐI ---
    private static final String DB_HOST = "localhost";
    private static final String DB_PORT = "1433";
    private static final String DB_NAME = "DeliverySystemDB";
    private static final String USER_NAME = "sa";
    private static final String PASSWORD = "12345";

    // URL kết nối (encrypt+trustServerCertificate cho SQL Server 2019+)
    private static final String DB_URL =
        "jdbc:sqlserver://" + DB_HOST + ":" + DB_PORT
        + ";databaseName=" + DB_NAME
        + ";encrypt=true;trustServerCertificate=true;";

    /**
     * Lấy kết nối đến database.
     * Ném ClassNotFoundException nếu thiếu driver sqljdbc4.jar
     */
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(DB_URL, USER_NAME, PASSWORD);
    }
}
