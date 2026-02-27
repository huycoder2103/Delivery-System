package controller;

import dao.UserDAO;
import dto.UserDTO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CreateUserController", urlPatterns = {"/CreateUserController"})
public class CreateUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // Forward về AdminController để load lại danh sách và hiển thị admin.jsp
        String url = "AdminController";
        try {
            String userID    = request.getParameter("newUserID");
            String fullName  = request.getParameter("newFullName");
            String password  = request.getParameter("newPassword");
            String confirm   = request.getParameter("newConfirmPassword");
            String phone     = request.getParameter("newPhone");
            String email     = request.getParameter("newEmail");

            // Validate
            if (userID == null || userID.trim().isEmpty()) {
                request.setAttribute("ERROR_MESSAGE", "Mã tài khoản không được để trống!");
            } else if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("ERROR_MESSAGE", "Họ tên không được để trống!");
            } else if (password == null || password.trim().isEmpty()) {
                request.setAttribute("ERROR_MESSAGE", "Mật khẩu không được để trống!");
            } else if (!password.equals(confirm)) {
                request.setAttribute("ERROR_MESSAGE", "Xác nhận mật khẩu không khớp!");
            } else {
                UserDAO dao = new UserDAO();
                UserDTO user = new UserDTO(
                    userID.trim(), fullName.trim(), "US",
                    password.trim(), phone, email, true
                );
                boolean ok = dao.insertUser(user);
                if (!ok) {
                    request.setAttribute("ERROR_MESSAGE",
                        "Lưu nhân viên thất bại! Mã tài khoản có thể đã tồn tại.");
                } else {
                    request.setAttribute("SUCCESS_MESSAGE",
                        "Thêm nhân viên " + fullName.trim() + " thành công!");
                }
            }
        } catch (Exception e) {
            log("Error at CreateUserController: " + e.toString());
            request.setAttribute("ERROR_MESSAGE", "Lỗi hệ thống: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    public String getServletInfo() { return "CreateUserController"; }
}