package dto;

import java.io.Serializable;

/**
 * ShiftDTO - Chứa thông tin ca làm việc của nhân viên.
 */
public class ShiftDTO implements Serializable {
    private int shiftID;
    private String staffID;
    private String startTime;
    private String endTime;
    private String status;

    public ShiftDTO() {
    }

    public ShiftDTO(int shiftID, String staffID, String startTime, String endTime, String status) {
        this.shiftID = shiftID;
        this.staffID = staffID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
    }

    public int getShiftID() {
        return shiftID;
    }

    public void setShiftID(int shiftID) {
        this.shiftID = shiftID;
    }

    public String getStaffID() {
        return staffID;
    }

    public void setStaffID(String staffID) {
        this.staffID = staffID;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
