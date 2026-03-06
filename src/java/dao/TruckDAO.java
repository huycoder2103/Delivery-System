package dao;

import dto.TruckDTO;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TruckDAO {

    private TruckDTO mapRow(ResultSet rs) throws SQLException {
        return new TruckDTO(
            rs.getString("truckID"),
            rs.getString("truckType"),
            rs.getString("licensePlate"),
            rs.getString("driverName"),
            rs.getString("driverPhone"),
            rs.getBoolean("status"),
            rs.getString("notes")
        );
    }

    /** Lấy tất cả xe đang hoạt động (status = 1 = rảnh) — dùng cho dropdown chọn xe */
    public List<TruckDTO> getActiveTrucks() throws Exception {
        String sql = "SELECT truckID, truckType, licensePlate, driverName, driverPhone, status, notes " +
                     "FROM tblTrucks WHERE status = 1 ORDER BY truckID";
        List<TruckDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Lấy tất cả xe (kể cả đang đi) */
    public  List<TruckDTO> getAllTrucks() throws Exception {
        String sql = "SELECT truckID, truckType, licensePlate, driverName, driverPhone, status, notes " +
                     "FROM tblTrucks ORDER BY truckID";
        List<TruckDTO> list = new ArrayList<>();
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Lấy xe theo ID */
    public TruckDTO getTruckByID(String truckID) throws Exception {
        String sql = "SELECT truckID, truckType, licensePlate, driverName, driverPhone, status, notes " +
                     "FROM tblTrucks WHERE truckID = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, truckID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    /** Thêm xe mới */
    public boolean insertTruck(TruckDTO t) throws Exception {
        String sql = "INSERT INTO tblTrucks(truckID, truckType, licensePlate, driverName, driverPhone, status, notes) " +
                     "VALUES(?,?,?,?,?,?,?)";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,  t.getTruckID());
            ps.setString(2,  t.getTruckType());
            ps.setString(3,  t.getLicensePlate());
            ps.setString(4,  t.getDriverName());
            ps.setString(5,  t.getDriverPhone());
            ps.setBoolean(6, t.isStatus());
            ps.setString(7,  t.getNotes());
            return ps.executeUpdate() > 0;
        }
    }

    /** Cập nhật trạng thái xe: true=rảnh, false=đang đi */
    public boolean updateTruckStatus(String truckID, boolean status) throws Exception {
        String sql = "UPDATE tblTrucks SET status = ? WHERE truckID = ?";
        try (Connection c = DBUtils.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setString(2, truckID);
            return ps.executeUpdate() > 0;
        }
    }
}