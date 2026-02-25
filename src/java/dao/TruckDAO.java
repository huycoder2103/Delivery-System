/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author HuyNHSE190240
 */

import dto.TruckDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class TruckDAO {
    // Hàm lấy danh sách xe đang rảnh (status = 1)
    public List<TruckDTO> getAvailableTrucks() throws SQLException, ClassNotFoundException {
        List<TruckDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT truckID, truckType, status FROM tblTrucks WHERE status = 1";
                ptm = conn.prepareStatement(sql);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String truckID = rs.getString("truckID");
                    String truckType = rs.getString("truckType");
                    boolean status = rs.getBoolean("status");
                    list.add(new TruckDTO(truckID, truckType, status));
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
