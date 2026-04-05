package utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * DBUtils - Sử dụng HikariCP để quản lý Connection Pool.
 * Giúp ứng dụng kết nối tới MySQL Cloud nhanh hơn và không bị treo khi có nhiều người dùng.
 */
public class DBUtils {

    private static HikariDataSource dataSource;

    static {
        try {
            // 1. Cấu hình thông số kết nối
            HikariConfig config = new HikariConfig();

            // Thông tin Database MySQL trên Aiven Cloud của bạn
            config.setJdbcUrl("jdbc:mysql://delivery-db-mysql-jayker03212k5-ee32.f.aivencloud.com:19281/defaultdb?useSSL=true");
            config.setUsername("avnadmin");
            config.setPassword("AVNS_txLmskApkmP4v1bHS0y");
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            // 2. Cấu hình Pool (Bể chứa kết nối)
            config.setMaximumPoolSize(10);      // Tối đa 10 kết nối đồng thời
            config.setMinimumIdle(2);           // Luôn giữ ít nhất 2 kết nối chờ sẵn
            config.setIdleTimeout(30000);       // 30 giây không dùng thì đóng bớt kết nối
            config.setConnectionTimeout(20000); // Đợi tối đa 20s để lấy kết nối, quá hạn sẽ báo lỗi
            config.setMaxLifetime(1800000);     // Reset kết nối sau mỗi 30 phút để tránh bị "treo" từ phía Cloud

            // 3. Các tùy chỉnh tối ưu riêng cho MySQL
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            // Khởi tạo DataSource
            dataSource = new HikariDataSource(config);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("LỖI: Không thể khởi tạo Hikari Connection Pool!");
        }
    }

    /**
     * Lấy một kết nối từ Pool.
     * Khi dùng xong (gọi conn.close()), kết nối sẽ trả về Pool chứ không bị ngắt hẳn.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource chưa được khởi tạo thành công.");
        }
        return dataSource.getConnection();
    }

    /**
     * Đóng toàn bộ Pool khi dừng ứng dụng (tùy chọn).
     */
    public static void closePool() {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}
