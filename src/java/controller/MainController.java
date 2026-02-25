/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import dto.UserDTO;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    
    private final Map<String, String> actionMap = new HashMap<>();

    public MainController() {
        // --- 1. NHÓM ĐIỀU PHỐI VỀ LOGIN/LOGOUT ---
        actionMap.put("Login", "LoginController");
        actionMap.put("Logout", LOGIN_PAGE);
        // --- 2. NHÓM ĐIỀU PHỐI VỀ HOME & REPORTS ---
        actionMap.put("GoHome", "HomeController");
        actionMap.put("ViewReports", "HomeController");
        actionMap.put("AdminPanel", "AdminController");
        // --- 3. NHÓM NGHIỆP VỤ HÀNG HÓA & CHUYẾN XE (GOODS_CONTROLLER) ---
        actionMap.put("ViewOrderList", "GoodsController");
        actionMap.put("CreateOrder", "GoodsController");
        actionMap.put("SearchOrderByPhone", "GoodsController");
        actionMap.put("SearchTripByTruck", "GoodsController");
        actionMap.put("SearchArrivalByTruck", "GoodsController");
        actionMap.put("ViewTripList", "GoodsController");
        actionMap.put("ViewArrivalTripList", "GoodsController");
        actionMap.put("AddArrivalTrip", "GoodsController");
        actionMap.put("AddTrip", "GoodsController");
        actionMap.put("ViewOrderReport", "GoodsController");
        actionMap.put("ListHang", "GoodsController");
        actionMap.put("ReceiveTrip", "GoodsController");
        actionMap.put("ShipOrder", "GoodsController");
        actionMap.put("EditOrder", "GoodsController");
        actionMap.put("TransferGoods", "GoodsController");
        actionMap.put("EditTrip", "GoodsController");
        // --- 4. CÁC TRANG JSP TĨNH & LƯU DỮ LIỆU ---
        actionMap.put("ViewGoods", "goods.jsp");
        actionMap.put("SaveOrder", "SaveOrderController");
        actionMap.put("SaveNewTrip", "SaveTripController");
        actionMap.put("SaveArrivalTrip", "SaveArrivalController");
        actionMap.put("SaveUser", "admin.jsp");
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String url = LOGIN_PAGE; // Mặc định quay về Login nếu không khớp action nào

        try {
            // --- A. XỬ LÝ LƯU NHÂN VIÊN MỚI (VỊ TRÍ THÊM MỚI) ---
            if (request.getParameter("SaveUser") != null) {
                try {
                    String userID = request.getParameter("newUserID");
                    String fullName = request.getParameter("newFullName");
                    String password = request.getParameter("newPassword");
                    String phone = request.getParameter("newPhone");
                    String email = request.getParameter("newEmail");
                    UserDAO dao = new UserDAO();
                    // Tạo đối tượng User với Role mặc định là US (User/Nhân viên)
                    UserDTO user = new UserDTO(userID, fullName, "US", password, phone, email, true);
                    boolean check = dao.insertUser(user);
                    if (check) {
                        url = "AdminController"; // Lưu thành công -> Quay về danh sách để cập nhật
                    } else {
                        request.setAttribute("ERROR_MESSAGE", "Lưu nhân viên thất bại!");
                        url = "AdminController";
                    }
                } catch (Exception e) {
                    log("Error at SaveUser logic: " + e.toString());
                }
            } 
            // --- B. XỬ LÝ QUYỀN TRUY CẬP QUẢN TRỊ ---
            else if (request.getParameter("AdminPanel") != null) {
                HttpSession session = request.getSession(false);
                String role = (session != null) ? (String) session.getAttribute("ROLE") : null;

                if ("AD".equals(role)) {
                    url = "AdminController"; 
                } else {
                    request.setAttribute("ERROR_MESSAGE", "Bạn không có quyền truy cập khu vực Quản trị!");
                    url = "home.jsp";
                }
            } 
            // --- C. TỰ ĐỘNG TRA CỨU CÁC HÀNH ĐỘNG KHÁC TỪ MAP ---
            else {
                for (String action : actionMap.keySet()) {
                    if (request.getParameter(action) != null) {
                        url = actionMap.get(action);
                        break;
                    }
                }
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
            url = ERROR_PAGE;
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
     *
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException,
            IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     *
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException,
            IOException {
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
