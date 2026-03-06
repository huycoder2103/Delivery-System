package dao;

import dto.TripDTO;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {

    private static final String SELECT_COLS =
        "SELECT tripID, truckID, departure, destination, departureTime, " +
        "driverName, assistantName, status, tripType, staffCreated, notes, " +
        "CONVERT(NVARCHAR(20), createdAt, 120) AS createdAt ";

    private TripDTO mapRow(ResultSet rs) throws SQLException {
        TripDTO t = new TripDTO(
            rs.getString("tripID"),
            rs.getString("truckID"),
            rs.getString("departure"),
            rs.getString("destination"),
            rs.getString("departureTime"),
            rs.getString("driverName"),
            rs.getString("assistantName"),
            rs.getString("status"),
            rs.getString("tripType"),
            rs.getString("staffCreated"),
            rs.getString("notes")
        );
        try { t.setCreatedAt(rs.getString("createdAt")); } catch (Exception ignored) {}
        return t;
    }

    /**
     * Lấy danh sách chuyến xe theo loại.
     * @param tripType "depart" = chuyến xe đi | "arrive" = chuyến xe đến
     */
    public List<TripDTO> getTripsByType(String tripType) throws Exception {
        String sql = SELECT_COLS + "FROM tblTrips WHERE tripType = ? ORDER BY createdAt DESC";
        List<TripDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tripType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    /** Lấy tất cả chuyến xe */
    public List<TripDTO> getAllTrips() throws Exception {
        String sql = SELECT_COLS + "FROM tblTrips ORDER BY createdAt DESC";
        List<TripDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Lấy chuyến xe theo ID */
    public TripDTO getTripByID(String tripID) throws Exception {
        String sql = SELECT_COLS + "FROM tblTrips WHERE tripID = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tripID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    /** Lấy chuyến xe đang chạy */
    public List<TripDTO> getActiveTrips() throws Exception {
        String sql = SELECT_COLS +
            "FROM tblTrips WHERE status IN (N'Đang đi', N'Đang đến') ORDER BY createdAt DESC";
        List<TripDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Thêm chuyến xe mới */
    public boolean insertTrip(TripDTO t) throws Exception {
        String sql = "INSERT INTO tblTrips " +
                     "(tripID, truckID, departure, destination, departureTime, " +
                     "driverName, assistantName, status, tripType, staffCreated, notes) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,  t.getTripID());
            ps.setString(2,  t.getTruckID());
            ps.setString(3,  t.getDeparture());
            ps.setString(4,  t.getDestination());
            ps.setString(5,  t.getDepartureTime());
            ps.setString(6,  t.getDriverName());
            ps.setString(7,  t.getAssistantName());
            ps.setString(8,  t.getStatus());
            ps.setString(9,  t.getTripType());
            ps.setString(10, t.getStaffCreated());
            ps.setString(11, t.getNotes());
            return ps.executeUpdate() > 0;
        }
    }

    /** Cập nhật trạng thái chuyến xe */
    public boolean updateTripStatus(String tripID, String status) throws Exception {
        String sql = "UPDATE tblTrips SET status = ? WHERE tripID = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, tripID);
            return ps.executeUpdate() > 0;
        }
    }

    /** Xóa chuyến xe */
    public boolean deleteTrip(String tripID) throws Exception {
        String sql = "DELETE FROM tblTrips WHERE tripID = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tripID);
            return ps.executeUpdate() > 0;
        }
    }
}