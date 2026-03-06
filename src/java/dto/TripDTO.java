package dto;

import java.io.Serializable;

public class TripDTO implements Serializable {

    private String tripID;
    private String truckID;
    private String departure;
    private String destination;
    private String departureTime;
    private String driverName;
    private String assistantName;
    private String status;       // "Đang đi" | "Đã đến" | "Đang đến"
    private String tripType;     // "depart" | "arrive"
    private String staffCreated;
    private String notes;
    private String createdAt;

    public TripDTO() {
    }

    public TripDTO(String tripID, String truckID, String departure, String destination,
            String departureTime, String driverName, String assistantName,
            String status, String tripType, String staffCreated, String notes) {
        this.tripID = tripID;
        this.truckID = truckID;
        this.departure = departure;
        this.destination = destination;
        this.departureTime = departureTime;
        this.driverName = driverName;
        this.assistantName = assistantName;
        this.status = status;
        this.tripType = tripType;
        this.staffCreated = staffCreated;
        this.notes = notes;
    }

    public String getTripID() {
        return tripID;
    }

    public void setTripID(String v) {
        this.tripID = v;
    }

    public String getTruckID() {
        return truckID;
    }

    public void setTruckID(String v) {
        this.truckID = v;
    }

    public String getDeparture() {
        return departure;
    }

    public void setDeparture(String v) {
        this.departure = v;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String v) {
        this.destination = v;
    }

    public String getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(String v) {
        this.departureTime = v;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String v) {
        this.driverName = v;
    }

    public String getAssistantName() {
        return assistantName;
    }

    public void setAssistantName(String v) {
        this.assistantName = v;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String v) {
        this.status = v;
    }

    public String getTripType() {
        return tripType;
    }

    public void setTripType(String v) {
        this.tripType = v;
    }

    public String getStaffCreated() {
        return staffCreated;
    }

    public void setStaffCreated(String v) {
        this.staffCreated = v;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String v) {
        this.notes = v;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String v) {
        this.createdAt = v;
    }
}
