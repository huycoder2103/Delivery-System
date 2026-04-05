package utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * DBUtils - Sử dụng HikariCP để quản lý Connection Pool.
 * Giúp ứng dụng kết nối tới MySQL Cloud nhanh hơn và không bị treo khi có nhiều người dùng.
 */
public class DBUtils {

    private static HikariDataSource dataSource;

    static {
        Properties props = new Properties();
        try (InputStream is = DBUtils.class.getResourceAsStream("db.properties")) {
            if (is == null) {
                throw new RuntimeException("Không tìm thấy tệp db.properties!");
            }
            props.load(is);

            // 1. Cấu hình thông số kết nối từ tệp properties
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.username"));
            config.setPassword(props.getProperty("db.password"));
            config.setDriverClassName(props.getProperty("db.driver"));

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
