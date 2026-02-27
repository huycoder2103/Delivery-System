package dto;

import java.io.Serializable;

public class UserDTO implements Serializable {

    private String userID;
    private String fullName;
    private String roleID;
    private String password;
    private String phone;
    private String email;
    private boolean status;

    private int orderCount;
    private double revenue;

    public UserDTO() {
    }

    // ── Constructor đầy đủ (ĐÃ FIX: tham số đổi tên từ pasasword → password) ──
    public UserDTO(String userID, String fullName, String roleID, String password,
            String phone, String email, boolean status) {
        this.userID = userID;
        this.fullName = fullName;
        this.roleID = roleID;
        this.password = password;   // ← BUG CŨ: gán this.password = password (field) chứ không gán tham số
        this.phone = phone;
        this.email = email;
        this.status = status;
    }

    // Constructor cho báo cáo nhân viên
    public UserDTO(String userID, String fullName, int orderCount, double revenue) {
        this.userID = userID;
        this.fullName = fullName;
        this.orderCount = orderCount;
        this.revenue = revenue;
    }

    // Getters & Setters
    public String getUserID() {
        return userID;
    }

    public void setUserID(String v) {
        this.userID = v;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String v) {
        this.fullName = v;
    }

    public String getRoleID() {
        return roleID;
    }

    public void setRoleID(String v) {
        this.roleID = v;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String v) {
        this.password = v;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String v) {
        this.phone = v;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String v) {
        this.email = v;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean v) {
        this.status = v;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int v) {
        this.orderCount = v;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double v) {
        this.revenue = v;
    }
}
