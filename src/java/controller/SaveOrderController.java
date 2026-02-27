package controller;

import dao.OrderDAO;
import dto.OrderDTO;
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

@WebServlet(name = "SaveOrderController", urlPatterns = {"/SaveOrderController"})
public class SaveOrderController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Sau khi lưu → quay về danh sách đơn hàng
        String url = "GoodsController?ViewOrderList=true";

        try {
            String itemName       = request.getParameter("itemName");
            String sendStation    = request.getParameter("sendStation");
            String receiveStation = request.getParameter("receiveStation");
            String senderName     = request.getParameter("senderName");
            String senderPhone    = request.getParameter("senderPhone");
            String receiverName   = request.getParameter("receiverName");
            String receiverPhone  = request.getParameter("receiverPhone");
            String note           = request.getParameter("note");

            // Parse tiền cước (tránh crash khi ô trống)
            double paid = 0;
            try {
                String paidStr = request.getParameter("paidAmount");
                if (paidStr != null && !paidStr.isEmpty()) paid = Double.parseDouble(paidStr);
            } catch (NumberFormatException ignored) {}

            // Validate bắt buộc
            if (itemName == null || itemName.trim().isEmpty()) {
                request.setAttribute("ERROR_MESSAGE", "Tên hàng gửi không được để trống!");
                url = "GoodsController?CreateOrder=true";
                request.getRequestDispatcher(url).forward(request, response);
                return;
            }

            // Lấy nhân viên đang đăng nhập
            HttpSession session = request.getSession(false);
            String staffID = "NV01"; // fallback
            if (session != null && session.getAttribute("LOGIN_USER") != null) {
                staffID = ((UserDTO) session.getAttribute("LOGIN_USER")).getUserID();
            }

            // Tạo mã đơn hàng: DH + 6 chữ số ngẫu nhiên
            String orderID  = "DH" + String.format("%05d", System.currentTimeMillis() % 100000L);
            String dateStr  = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());

            OrderDTO order = new OrderDTO(
                orderID, itemName.trim(), paid,
                senderName, senderPhone, sendStation,
                receiverName, receiverPhone, receiveStation,
                staffID, null, "Chưa Chuyển", note, dateStr
            );

            OrderDAO dao = new OrderDAO();
            if (!dao.insertOrder(order)) {
                request.setAttribute("ERROR_MESSAGE", "Lưu đơn hàng thất bại! Vui lòng thử lại.");
                url = "GoodsController?CreateOrder=true";
            }

        } catch (Exception e) {
            log("Error at SaveOrderController: " + e.toString());
            request.setAttribute("ERROR_MESSAGE", "Lỗi hệ thống: " + e.getMessage());
            url = "GoodsController?CreateOrder=true";
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
}
