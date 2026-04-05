package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String url = LOGIN_PAGE;
        try {

            // ── 1. Login / Logout ──────────────────────────────────────────
            if (request.getParameter("Login") != null) {
                url = "LoginController";

            } else if (request.getParameter("Logout") != null) {
                HttpSession session = request.getSession(false);
                if (session != null) session.invalidate();
                url = LOGIN_PAGE;

            // ── 2. Home & Báo cáo ────────────────────────────────────────
            } else if (request.getParameter("GoHome") != null) {
                url = "HomeController";

            } else if (request.getParameter("ViewReports") != null
                    || request.getParameter("ViewOrderReport") != null) {
                url = "ReportController";

            } else if (request.getParameter("SubmitShiftReport") != null) {
                url = "ReportController";

            // ── 3. Quản trị ──────────────────────────────────────────────
            } else if (request.getParameter("AdminPanel") != null) {
                HttpSession session = request.getSession(false);
                String role = (session != null) ? (String) session.getAttribute("ROLE") : null;
                if ("AD".equals(role)) {
                    url = "AdminController";
                } else {
                    request.setAttribute("ERROR_MESSAGE", "Bạn không có quyền truy cập chức năng này!");
                    url = "HomeController";
                }

            // ── 4. Hàng hóa (trang menu) ─────────────────────────────────
            } else if (request.getParameter("ViewGoods") != null) {
                url = "goods.jsp";

            // ── 5. Tất cả action của GoodsController ─────────────────────
            } else if (request.getParameter("ViewOrderList") != null
                    || request.getParameter("CreateOrder") != null
                    || request.getParameter("FilterOrder") != null
                    || request.getParameter("FilterTrip") != null
                    || request.getParameter("FilterArrival") != null
                    || request.getParameter("SearchOrderByPhone") != null
                    || request.getParameter("EditOrder") != null
                    || request.getParameter("UpdateOrder") != null
                    || request.getParameter("DeleteOrder") != null
                    || request.getParameter("ViewTrashOrder") != null
                    || request.getParameter("RestoreOrder") != null
                    || request.getParameter("PermanentDeleteOrder") != null
                    || request.getParameter("ShipOrder") != null
                    || request.getParameter("AssignOrderToTrip") != null
                    || request.getParameter("ViewTripList") != null
                    || request.getParameter("ViewArrivalTripList") != null
                    || request.getParameter("AddTrip") != null
                    || request.getParameter("AddArrivalTrip") != null
                    || request.getParameter("SearchTripByTruck") != null
                    || request.getParameter("SearchArrivalByTruck") != null
                    || request.getParameter("ListGoods") != null
                    || request.getParameter("PrepareAssignGoods") != null
                    || request.getParameter("ArrivedTrip") != null
                    || request.getParameter("TransferGoods") != null
                    || request.getParameter("EditTrip") != null) {
                url = "GoodsController";

            // ── 6. Save controllers ───────────────────────────────────────
            } else if (request.getParameter("SaveOrder") != null) {
                url = "SaveOrderController";

            } else if (request.getParameter("SaveNewTrip") != null) {
                url = "SaveTripController";

            } else if (request.getParameter("SaveArrivalTrip") != null) {
                url = "SaveArrivalController";

            } else if (request.getParameter("SaveUser") != null) {
                url = "CreateUserController";

            // ── 7. Mặc định ──────────────────────────────────────────────
            } else {
                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("LOGIN_USER") != null) {
                    url = "HomeController";
                } else {
                    url = LOGIN_PAGE;
                }
            }

        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
            url = ERROR_PAGE;
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() { return "MainController"; }
}