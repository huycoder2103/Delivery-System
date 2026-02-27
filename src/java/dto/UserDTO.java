/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author HuyNHSE190240
 */
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

    public UserDTO(String userID, String fullName, String roleID, String pasasword, String phone, String email, boolean status) {
        this.userID = userID;
        this.fullName = fullName;
        this.roleID = roleID;
        this.password = password;
        this.phone = phone;
        this.email = email;
        this.status = status;
    }
    
    public UserDTO(String userID, String fullName, int orderCount, double revenue) {
        this.userID = userID;
        this.fullName = fullName;
        this.orderCount = orderCount;
        this.revenue = revenue;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }

    
    
    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRoleID() {
        return roleID;
    }

    public void setRoleID(String roleID) {
        this.roleID = roleID;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
