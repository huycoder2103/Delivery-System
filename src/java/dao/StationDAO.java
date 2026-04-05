/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author HuyNHSE190240
 */

import dto.StationDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class StationDAO {
    // Hàm lấy tất cả các trạm
    public List<StationDTO> getAllStations() throws SQLException, ClassNotFoundException {
        List<StationDTO> list = new ArrayList<>();
        String sql = "SELECT stationID, stationName FROM tblStations";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ptm = conn.prepareStatement(sql);
             ResultSet rs = ptm.executeQuery()) {
            while (rs.next()) {
                int stationID = rs.getInt("stationID");
                String stationName = rs.getString("stationName");
                list.add(new StationDTO(stationID, stationName));
            }
        }
        return list;
    }
}
