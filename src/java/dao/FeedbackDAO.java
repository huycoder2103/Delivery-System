package dao;

import dto.FeedbackDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class FeedbackDAO {
    
    public boolean insertFeedback(String userID, String content) throws Exception {
        String sql = "INSERT INTO tblFeedbacks(userID, content) VALUES(?, ?)";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userID);
            ps.setString(2, content);
            return ps.executeUpdate() > 0;
        }
    }

    public List<FeedbackDTO> getRecentFeedbacks() throws Exception {
        List<FeedbackDTO> list = new ArrayList<>();
        String sql = "SELECT f.feedbackID, f.userID, u.fullName, f.content, " +
                     "DATE_FORMAT(f.createdAt, '%d/%m/%Y %H:%i') as createdAt " +
                     "FROM tblFeedbacks f JOIN tblUsers u ON f.userID = u.userID " +
                     "ORDER BY f.createdAt DESC LIMIT 15";
        try (Connection c = DBUtils.getConnection(); 
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new FeedbackDTO(
                    rs.getInt("feedbackID"),
                    rs.getString("userID"),
                    rs.getString("fullName"),
                    rs.getString("content"),
                    rs.getString("createdAt")
                ));
            }
        }
        return list;
    }

    public boolean deleteFeedback(int feedbackID) throws Exception {
        String sql = "DELETE FROM tblFeedbacks WHERE feedbackID = ?";
        try (Connection c = DBUtils.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, feedbackID);
            return ps.executeUpdate() > 0;
        }
    }
}
