/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author jayke
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import utils.DBUtils;

public class TripDAO {
    public boolean insertTrip(String truckID, String dep, String des, String time) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO tblTrips(truckID, departure, destination, departureTime, status) VALUES(?,?,?,?,?)";
        String updateTruck = "UPDATE tblTrucks SET status = 0 WHERE truckID = ?"; // Xe đang đi (status=0)
        
        try (Connection conn = DBUtils.getConnection()) {
            conn.setAutoCommit(false); // Dùng Transaction
            try (PreparedStatement ptm1 = conn.prepareStatement(sql);
                 PreparedStatement ptm2 = conn.prepareStatement(updateTruck)) {
                ptm1.setString(1, truckID);
                ptm1.setString(2, dep);
                ptm1.setString(3, des);
                ptm1.setString(4, time);
                ptm1.setString(5, "Đang đi");
                
                ptm2.setString(1, truckID);
                
                boolean check = ptm1.executeUpdate() > 0 && ptm2.executeUpdate() > 0;
                conn.commit();
                return check;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }
}
