package dto;

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
    private String tr;           // trạng thái: Chưa Chuyển / Đã Chuyển / Đã Nhận
    private String ct;           // loại hàng / ghi chú loại
    private String receiveDate;
    private String tripID;
    private String note;

    public OrderDTO() {}

    // Constructor đầy đủ (không có note, tripID)
    public OrderDTO(String orderID, String itemName, double amount,
                    String senderName, String senderPhone, String sendStation,
                    String receiverName, String receiverPhone, String receiveStation,
                    String staffInput, String staffReceive,
                    String tr, String ct, String receiveDate) {
        this.orderID        = orderID;
        this.itemName       = itemName;
        this.amount         = amount;
        this.senderName     = senderName;
        this.senderPhone    = senderPhone;
        this.sendStation    = sendStation;
        this.receiverName   = receiverName;
        this.receiverPhone  = receiverPhone;
        this.receiveStation = receiveStation;
        this.staffInput     = staffInput;
        this.staffReceive   = staffReceive;
        this.tr             = tr;
        this.ct             = ct;
        this.receiveDate    = receiveDate;
    }

    // Constructor có note
    public OrderDTO(String orderID, String itemName, double amount,
                    String senderName, String senderPhone, String sendStation,
                    String receiverName, String receiverPhone, String receiveStation,
                    String staffInput, String staffReceive,
                    String tr, String ct, String receiveDate, String note) {
        this(orderID, itemName, amount, senderName, senderPhone, sendStation,
             receiverName, receiverPhone, receiveStation, staffInput, staffReceive,
             tr, ct, receiveDate);
        this.note = note;
    }

    // Getters & Setters
    public String getOrderID()              { return orderID; }
    public void   setOrderID(String v)      { this.orderID = v; }

    public String getItemName()             { return itemName; }
    public void   setItemName(String v)     { this.itemName = v; }

    public double getAmount()               { return amount; }
    public void   setAmount(double v)       { this.amount = v; }

    public String getSenderName()           { return senderName; }
    public void   setSenderName(String v)   { this.senderName = v; }

    public String getSenderPhone()          { return senderPhone; }
    public void   setSenderPhone(String v)  { this.senderPhone = v; }

    public String getSendStation()          { return sendStation; }
    public void   setSendStation(String v)  { this.sendStation = v; }

    public String getReceiverName()         { return receiverName; }
    public void   setReceiverName(String v) { this.receiverName = v; }

    public String getReceiverPhone()         { return receiverPhone; }
    public void   setReceiverPhone(String v) { this.receiverPhone = v; }

    public String getReceiveStation()           { return receiveStation; }
    public void   setReceiveStation(String v)   { this.receiveStation = v; }

    public String getStaffInput()               { return staffInput; }
    public void   setStaffInput(String v)       { this.staffInput = v; }

    public String getStaffReceive()             { return staffReceive; }
    public void   setStaffReceive(String v)     { this.staffReceive = v; }

    public String getTr()                   { return tr; }
    public void   setTr(String v)           { this.tr = v; }

    public String getCt()                   { return ct; }
    public void   setCt(String v)           { this.ct = v; }

    public String getReceiveDate()          { return receiveDate; }
    public void   setReceiveDate(String v)  { this.receiveDate = v; }

    public String getTripID()               { return tripID; }
    public void   setTripID(String v)       { this.tripID = v; }

    public String getNote()                 { return note; }
    public void   setNote(String v)         { this.note = v; }
}