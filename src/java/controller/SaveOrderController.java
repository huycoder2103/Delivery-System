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

            // TR = tiền đã thanh toán (để trống nếu không nhập)
            String trValue = "";
            String paidStr = request.getParameter("paidAmount");
            if (paidStr != null && !paidStr.trim().isEmpty()) {
                try {
                    double paid = Double.parseDouble(paidStr.trim());
                    if (paid > 0) trValue = String.format("%.0f", paid);
                } catch (NumberFormatException ignored) {}
            }

            // CT = tiền chưa thanh toán (để trống nếu không nhập)
            String ctValue = "";
            String remainStr = request.getParameter("remainAmount");
            if (remainStr != null && !remainStr.trim().isEmpty()) {
                try {
                    double remain = Double.parseDouble(remainStr.trim());
                    if (remain > 0) ctValue = String.format("%.0f", remain);
                } catch (NumberFormatException ignored) {}
            }

            // amount = tổng paid + remain
            double totalAmount = 0;
            try {
                if (!trValue.isEmpty()) totalAmount += Double.parseDouble(trValue);
                if (!ctValue.isEmpty()) totalAmount += Double.parseDouble(ctValue);
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
            String staffID = "NV01";
            if (session != null && session.getAttribute("LOGIN_USER") != null) {
                staffID = ((UserDTO) session.getAttribute("LOGIN_USER")).getUserID();
            }

            String orderID = "DH" + String.format("%05d", System.currentTimeMillis() % 100000L);
            String dateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());

            OrderDTO order = new OrderDTO(
                orderID,
                itemName.trim(),
                totalAmount,
                senderName,
                senderPhone,
                sendStation,
                receiverName,
                receiverPhone,
                receiveStation,
                staffID,
                null,
                trValue,   // TR = tiền đã thanh toán
                ctValue,   // CT = tiền chưa thanh toán
                dateStr,
                note       // Ghi chú
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