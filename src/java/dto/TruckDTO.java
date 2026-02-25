/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author HuyNHSE190240
 */

public class TruckDTO {
    private String truckID;
    private String truckType;
    private boolean status;

    public TruckDTO() {
    }

    public TruckDTO(String truckID, String truckType, boolean status) {
        this.truckID = truckID;
        this.truckType = truckType;
        this.status = status;
    }

    public String getTruckID() {
        return truckID;
    }

    public void setTruckID(String truckID) {
        this.truckID = truckID;
    }

    public String getTruckType() {
        return truckType;
    }

    public void setTruckType(String truckType) {
        this.truckType = truckType;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
