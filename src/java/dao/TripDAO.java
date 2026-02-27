package dao;

import java.sql.*;
import utils.DBUtils;

public class TripDAO {

    /**
     * Tạo chuyến xe mới + cập nhật trạng thái xe sang "Đang đi" (status=0)
     * Dùng transaction để đảm bảo tính toàn vẹn dữ liệu.
     */
    public boolean insertTrip(String truckID, String dep, String des,
                              String time, String driverName, String assistant,
                              String staffCreated, String notes)
            throws SQLException, ClassNotFoundException {

        // Tạo mã chuyến tự động: TRIP + timestamp 6 chữ số cuối
        String tripID = "TRIP" + (System.currentTimeMillis() % 1000000L);

        String sqlTrip  = "INSERT INTO tblTrips "
                        + "(tripID, truckID, departure, destination, departureTime, "
                        + " driverName, assistantName, status, staffCreated, notes) "
                        + "VALUES (?,?,?,?,?,?,?,?,?,?)";
        String sqlTruck = "UPDATE tblTrucks SET status = 0 WHERE truckID = ?";

        try (Connection conn = DBUtils.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(sqlTrip);
                 PreparedStatement ps2 = conn.prepareStatement(sqlTruck)) {

                ps1.setString(1, tripID);
                ps1.setString(2, truckID);
                ps1.setString(3, dep);
                ps1.setString(4, des);
                ps1.setString(5, time);
                ps1.setString(6, driverName);
                ps1.setString(7, assistant);
                ps1.setString(8, "Đang đi");
                ps1.setString(9, staffCreated);
                ps1.setString(10, notes);

                ps2.setString(1, truckID);

                boolean ok = ps1.executeUpdate() > 0 && ps2.executeUpdate() > 0;
                conn.commit();
                return ok;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    /** Phiên bản đơn giản (tương thích SaveTripController cũ) */
    public boolean insertTrip(String truckID, String dep, String des, String time)
            throws SQLException, ClassNotFoundException {
        return insertTrip(truckID, dep, des, time, null, null, null, null);
    }

    /**
     * Cập nhật trạng thái chuyến xe.
     * Nếu trạng thái mới là "Đã đến" → trả xe về rảnh (status=1).
     */
    public boolean updateTripStatus(String tripID, String status)
            throws SQLException, ClassNotFoundException {

        String sqlTrip  = "UPDATE tblTrips SET status = ? WHERE tripID = ?";
        String sqlTruck = "UPDATE tblTrucks SET status = 1 "
                        + "WHERE truckID = (SELECT truckID FROM tblTrips WHERE tripID = ?)";

        try (Connection conn = DBUtils.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(sqlTrip)) {
                ps1.setString(1, status);
                ps1.setString(2, tripID);
                ps1.executeUpdate();

                if ("Đã đến".equals(status)) {
                    try (PreparedStatement ps2 = conn.prepareStatement(sqlTruck)) {
                        ps2.setString(1, tripID);
                        ps2.executeUpdate();
                    }
                }
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }
}
