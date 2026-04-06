package controller;

import dao.ShiftDAO;
import dto.ShiftDTO;
import dto.UserDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ShiftController", urlPatterns = {"/ShiftController"})
public class ShiftController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("LOGIN_USER");
        ShiftDAO dao = new ShiftDAO();

        try {
            if ("start".equals(action)) {
                // Chỉ cho phép bắt đầu nếu chưa có ca nào ACTIVE
                ShiftDTO checkShift = dao.getActiveShift(user.getUserID());
                if (checkShift == null) {
                    dao.startShift(user.getUserID());
                }
            } else if ("end".equals(action)) {
                ShiftDTO currentShift = (ShiftDTO) session.getAttribute("CURRENT_SHIFT");
                // Kiểm tra ID ca trong session và ID nhân viên phải khớp
                if (currentShift != null && currentShift.getStaffID().equals(user.getUserID())) {
                    dao.endShift(currentShift.getShiftID());
                }
            }
            // Cập nhật lại Session (Nếu kết thúc ca thì updatedShift sẽ là null)
            ShiftDTO updatedShift = dao.getActiveShift(user.getUserID());
            session.setAttribute("CURRENT_SHIFT", updatedShift);
            
        } catch (Exception e) {
            log("Error ShiftController: " + e.toString());
        } finally {
            response.sendRedirect("MainController?GoHome=true");
        }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException { processRequest(req, res); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException { processRequest(req, res); }
}
