/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import dto.OrderDTO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "SaveOrderController", urlPatterns = {"/SaveOrderController"})
public class SaveOrderController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "GoodsController?ViewOrderList=true"; // Lưu xong quay về danh sách
        try {
            // Lấy dữ liệu từ create_order.jsp
            String itemName = request.getParameter("itemName");
            String sendStation = request.getParameter("sendStation");
            String receiveStation = request.getParameter("receiveStation");
            String senderName = request.getParameter("senderName");
            String senderPhone = request.getParameter("senderPhone");
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            double paid = Double.parseDouble(request.getParameter("paidAmount"));
            String note = request.getParameter("note");
            
            // Tự động tạo ID và Ngày (Mã đơn hàng ví dụ: DH + timestamp)
            String orderID = "DH" + System.currentTimeMillis() % 100000;
            String date = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());

            OrderDTO order = new OrderDTO(orderID, itemName, paid, senderName, senderPhone, 
                                          sendStation, receiverName, receiverPhone, receiveStation, 
                                          "NV01", "", "Chưa Chuyển", note, date);
            
            OrderDAO dao = new OrderDAO();
            if(dao.insertOrder(order)) {
                request.setAttribute("MESSAGE", "Đã lưu đơn hàng thành công!");
            }
        } catch (Exception e) {
            log("Error at SaveOrderController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
