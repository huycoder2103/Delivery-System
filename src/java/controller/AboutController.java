package controller;

import dao.FeedbackDAO;
import dto.FeedbackDTO;
import dto.UserDTO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "AboutController", urlPatterns = {"/AboutController"})
public class AboutController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        FeedbackDAO dao = new FeedbackDAO();
        try {
            HttpSession session = request.getSession(false);
            UserDTO user = (session != null) ? (UserDTO) session.getAttribute("LOGIN_USER") : null;

            // 1. Xử lý Gửi Feedback
            if (request.getParameter("SaveFeedback") != null && user != null) {
                String content = request.getParameter("feedbackContent");
                if (content != null && !content.trim().isEmpty()) {
                    dao.insertFeedback(user.getUserID(), content.trim());
                    request.setAttribute("SUCCESS_MESSAGE", "Cảm ơn bạn đã gửi phản hồi!");
                }
            }

            // 2. Xử lý Xóa Feedback
            if (request.getParameter("DeleteFeedback") != null && user != null) {
                String fbIDStr = request.getParameter("feedbackID");
                if (fbIDStr != null) {
                    dao.deleteFeedback(Integer.parseInt(fbIDStr));
                    request.setAttribute("SUCCESS_MESSAGE", "Đã xóa phản hồi thành công.");
                }
            }

            // 3. Lấy danh sách Feedback để hiển thị
            List<FeedbackDTO> feedbackList = dao.getRecentFeedbacks();
            request.setAttribute("FEEDBACK_LIST", feedbackList);

        } catch (Exception e) {
            log("Error at AboutController: " + e.toString());
        } finally {
            request.getRequestDispatcher("about.jsp").forward(request, response);
        }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
}
