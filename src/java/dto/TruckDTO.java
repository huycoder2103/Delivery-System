package dto;

import java.io.Serializable;

public class TruckDTO implements Serializable {

    private String truckID;
    private String licensePlate;
    private String driverName;
    private String driverPhone;
    private boolean status;   // true = rảnh, false = đang đi
    private String notes;

    public TruckDTO() {}

    public TruckDTO(String truckID, String licensePlate,
            String driverName, String driverPhone, boolean status, String notes) {
        this.truckID      = truckID;
        this.licensePlate = licensePlate;
        this.driverName   = driverName;
        this.driverPhone  = driverPhone;
        this.status       = status;
        this.notes        = notes;
    }

    public String getTruckID()            { return truckID; }
    public void   setTruckID(String v)    { this.truckID = v; }

    public String getLicensePlate()           { return licensePlate; }
    public void   setLicensePlate(String v)   { this.licensePlate = v; }

    public String getDriverName()         { return driverName; }
    public void   setDriverName(String v) { this.driverName = v; }

    public String getDriverPhone()        { return driverPhone; }
    public void   setDriverPhone(String v){ this.driverPhone = v; }

    public boolean isStatus()             { return status; }
    public void    setStatus(boolean v)   { this.status = v; }

    public String getNotes()              { return notes; }
    public void   setNotes(String v)      { this.notes = v; }
}