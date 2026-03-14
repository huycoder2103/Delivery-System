package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBUtils {

    // --- CẤU HÌNH KẾT NỐI ---
//    private static final String DB_HOST = "localhost";
////    private static final String DB_HOST = "db";
//    private static final String DB_PORT = "1433";
//    private static final String DB_NAME = "DeliverySystemDB";
//    private static final String USER_NAME = "sa";
//    private static final String PASSWORD = "YourStrongPassword123";
//
//    
//    private static final String DB_URL =
//        "jdbc:sqlserver://" + DB_HOST + ":" + DB_PORT
//        + ";databaseName=" + DB_NAME
//        + ";encrypt=true;trustServerCertificate=true;";
//
//    public static Connection getConnection() throws ClassNotFoundException, SQLException {
//        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
//        return DriverManager.getConnection(DB_URL, USER_NAME, PASSWORD);
//    }
    
    // Thay thông tin Aiven của bạn vào đây
    private static final String DB_HOST = "delivery-db-mysql-jayker03212k5-ee32.f.aivencloud.com";
    private static final String DB_PORT = "19281";
    private static final String DB_NAME = "defaultdb";
    private static final String USER_NAME = "avnadmin";
    private static final String PASSWORD = "AVNS_txLmskApkmP4v1bHS0y";

    // URL kết nối MySQL có bật SSL
    private static final String DB_URL =
        "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME + "?useSSL=true";

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        // Đổi driver sang MySQL
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, USER_NAME, PASSWORD);
    }
}
