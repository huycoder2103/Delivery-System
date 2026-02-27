/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author jayke
 */
// File: src/java/dto/OrderDTO.java

import java.io.Serializable;

public class OrderDTO implements Serializable {

    private String orderID;
    private String itemName;
    private double amount;
    private String senderName;
    private String senderPhone;
    private String sendStation;
    private String receiverName;
    private String receiverPhone;
    private String receiveStation;
    private String staffInput;
    private String staffReceive;
    private String tr;        // Tiền đã thanh toán
    private String ct;        // Tiền chưa thanh toán
    private String receiveDate;
    private String note;      // Ghi chú

    public OrderDTO() {
    }

    public OrderDTO(String orderID, String itemName, double amount,
            String senderName, String senderPhone, String sendStation,
            String receiverName, String receiverPhone, String receiveStation,
            String staffInput, String staffReceive,
            String tr, String ct, String receiveDate) {
        this.orderID = orderID;
        this.itemName = itemName;
        this.amount = amount;
        this.senderName = senderName;
        this.senderPhone = senderPhone;
        this.sendStation = sendStation;
        this.receiverName = receiverName;
        this.receiverPhone = receiverPhone;
        this.receiveStation = receiveStation;
        this.staffInput = staffInput;
        this.staffReceive = staffReceive;
        this.tr = tr;
        this.ct = ct;
        this.receiveDate = receiveDate;
    }

    // Constructor đầy đủ có note
    public OrderDTO(String orderID, String itemName, double amount,
            String senderName, String senderPhone, String sendStation,
            String receiverName, String receiverPhone, String receiveStation,
            String staffInput, String staffReceive,
            String tr, String ct, String receiveDate, String note) {
        this(orderID, itemName, amount, senderName, senderPhone, sendStation,
                receiverName, receiverPhone, receiveStation,
                staffInput, staffReceive, tr, ct, receiveDate);
        this.note = note;
    }

    // Getters & Setters
    public String getOrderID() {
        return orderID;
    }

    public void setOrderID(String orderID) {
        this.orderID = orderID;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getSenderPhone() {
        return senderPhone;
    }

    public void setSenderPhone(String senderPhone) {
        this.senderPhone = senderPhone;
    }

    public String getSendStation() {
        return sendStation;
    }

    public void setSendStation(String sendStation) {
        this.sendStation = sendStation;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public String getReceiveStation() {
        return receiveStation;
    }

    public void setReceiveStation(String receiveStation) {
        this.receiveStation = receiveStation;
    }

    public String getStaffInput() {
        return staffInput;
    }

    public void setStaffInput(String staffInput) {
        this.staffInput = staffInput;
    }

    public String getStaffReceive() {
        return staffReceive;
    }

    public void setStaffReceive(String staffReceive) {
        this.staffReceive = staffReceive;
    }

    public String getTr() {
        return tr;
    }

    public void setTr(String tr) {
        this.tr = tr;
    }

    public String getCt() {
        return ct;
    }

    public void setCt(String ct) {
        this.ct = ct;
    }

    public String getReceiveDate() {
        return receiveDate;
    }

    public void setReceiveDate(String receiveDate) {
        this.receiveDate = receiveDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
