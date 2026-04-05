package dto;

import java.io.Serializable;

public class FeedbackDTO implements Serializable {
    private int feedbackID;
    private String userID;
    private String fullName; // Để hiển thị tên người gửi
    private String content;
    private String createdAt;

    public FeedbackDTO() {}

    public FeedbackDTO(int feedbackID, String userID, String fullName, String content, String createdAt) {
        this.feedbackID = feedbackID;
        this.userID = userID;
        this.fullName = fullName;
        this.content = content;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getFeedbackID() { return feedbackID; }
    public void setFeedbackID(int feedbackID) { this.feedbackID = feedbackID; }

    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
