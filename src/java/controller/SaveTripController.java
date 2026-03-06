package controller;

import dao.TripDAO;
import dto.TripDTO;
import dto.UserDTO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "SaveTripController", urlPatterns = {"/SaveTripController"})
public class SaveTripController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String url = "GoodsController?ViewTripList=true";

        try {
            String truckID    = request.getParameter("truckID");
            String dep        = request.getParameter("departure");
            String des        = request.getParameter("destination");
            String time       = request.getParameter("departureTime");
            String driver     = request.getParameter("driver");
            String assistant  = request.getParameter("assistant");
            String notes      = request.getParameter("note");

            // Lấy staffID từ session
            HttpSession session = request.getSession(false);
            String staffID = "NV01"; // fallback
            if (session != null && session.getAttribute("LOGIN_USER") != null) {
                staffID = ((UserDTO) session.getAttribute("LOGIN_USER")).getUserID();
            }

            // Validate bắt buộc
            if (truckID == null || truckID.isEmpty()
                    || dep == null || dep.isEmpty()
                    || des == null || des.isEmpty()
                    || time == null || time.isEmpty()) {
                request.setAttribute("ERROR_MESSAGE", "Vui lòng nhập đầy đủ thông tin chuyến xe!");
                url = "GoodsController?AddTrip=true";

            } else if (dep.equals(des)) {
                request.setAttribute("ERROR_MESSAGE", "Trạm đi và trạm đến không được giống nhau!");
                url = "GoodsController?AddTrip=true";

            } else {
                // Tạo TripDTO — tripType = "depart" (chuyến xe ĐI)
                String tripID = "TRIP" + new SimpleDateFormat("yyMMddHHmmss").format(new Date());

                TripDTO trip = new TripDTO();
                trip.setTripID(tripID);
                trip.setTruckID(truckID);
                trip.setDeparture(dep);
                trip.setDestination(des);
                trip.setDepartureTime(time);
                trip.setDriverName(driver);
                trip.setAssistantName(assistant);
                trip.setNotes(notes);
                trip.setStatus("Đang đi");
                trip.setTripType("depart");
                trip.setStaffCreated(staffID);

                TripDAO dao = new TripDAO();
                boolean ok = dao.insertTrip(trip);

                if (!ok) {
                    request.setAttribute("ERROR_MESSAGE", "Lưu chuyến xe thất bại!");
                    url = "GoodsController?AddTrip=true";
                }
            }

        } catch (Exception e) {
            log("Error at SaveTripController: " + e.toString());
            request.setAttribute("ERROR_MESSAGE", "Lỗi hệ thống: " + e.getMessage());
            url = "GoodsController?AddTrip=true";

        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
}