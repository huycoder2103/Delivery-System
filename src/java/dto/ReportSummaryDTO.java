package dto;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public class ReportSummaryDTO implements Serializable {
    // Thống kê đơn hàng
    private int totalOrders;
    private int deliveredOrders;
    private int deliveringOrders;
    private int pendingOrders;
    private double totalRevenue;
    private int totalTrips;

    private String staffID;
    private String staffName;

    // Dữ liệu cho biểu đồ (Admin)
    private List<String> chartLabels;
    private List<Double> chartValues;

    public ReportSummaryDTO() {}

    // Getters and Setters
    public String getStaffID() { return staffID; }
    public void setStaffID(String staffID) { this.staffID = staffID; }
    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }
    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
    public int getDeliveredOrders() { return deliveredOrders; }
    public void setDeliveredOrders(int deliveredOrders) { this.deliveredOrders = deliveredOrders; }
    public int getDeliveringOrders() { return deliveringOrders; }
    public void setDeliveringOrders(int deliveringOrders) { this.deliveringOrders = deliveringOrders; }
    public int getPendingOrders() { return pendingOrders; }
    public void setPendingOrders(int pendingOrders) { this.pendingOrders = pendingOrders; }
    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
    public int getTotalTrips() { return totalTrips; }
    public void setTotalTrips(int totalTrips) { this.totalTrips = totalTrips; }
    public List<String> getChartLabels() { return chartLabels; }
    public void setChartLabels(List<String> chartLabels) { this.chartLabels = chartLabels; }
    public List<Double> getChartValues() { return chartValues; }
    public void setChartValues(List<Double> chartValues) { this.chartValues = chartValues; }
}
