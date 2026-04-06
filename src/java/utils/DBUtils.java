package utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;
// import java.io.InputStream;
// import java.util.Properties;

/**
 * DBUtils - Sử dụng HikariCP để quản lý Connection Pool.
 * Đã cập nhật để sử dụng Biến môi trường (Environment Variables) cho Deploy.
 */
public class DBUtils {

    private static HikariDataSource dataSource;

    static {
        try {
            /* --- BẢN CŨ: ĐỌC TỪ FILE PROPERTIES (ĐÃ COMMENT) ---
            Properties props = new Properties();
            try (InputStream is = DBUtils.class.getResourceAsStream("db.properties")) {
                if (is == null) {
                    throw new RuntimeException("Không tìm thấy tệp db.properties!");
                }
                props.load(is);
                HikariConfig config = new HikariConfig();
                config.setJdbcUrl(props.getProperty("db.url"));
                config.setUsername(props.getProperty("db.username"));
                config.setPassword(props.getProperty("db.password"));
                config.setDriverClassName(props.getProperty("db.driver"));
            }
            --------------------------------------------------- */

            // BẢN MỚI: ĐỌC TỪ BIẾN MÔI TRƯỜNG
            HikariConfig config = new HikariConfig();
            
            String dbUrl = System.getenv("DB_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPassword = System.getenv("DB_PASSWORD");
            String dbDriver = System.getenv("DB_DRIVER"); 

            if (dbUrl == null || dbUser == null || dbPassword == null) {
                throw new RuntimeException("LỖI: Thiếu biến môi trường cấu hình Database (DB_URL, DB_USER, DB_PASSWORD)!");
            }

            config.setJdbcUrl(dbUrl);
            config.setUsername(dbUser);
            config.setPassword(dbPassword);
            config.setDriverClassName(dbDriver != null ? dbDriver : "com.mysql.cj.jdbc.Driver");

            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000);
            config.setConnectionTimeout(20000);
            config.setMaxLifetime(1800000);

            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("LỖI: Không thể khởi tạo Hikari Connection Pool với Biến môi trường!");
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource chưa được khởi tạo thành công.");
        }
        return dataSource.getConnection();
    }

    public static void closePool() {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}