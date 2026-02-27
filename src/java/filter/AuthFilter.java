//package filter;
//
//import java.io.IOException;
//import javax.servlet.*;
//import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.*;
//
///**
// * AuthFilter - Bảo vệ toàn bộ trang JSP & Controller. Người chưa đăng nhập sẽ
// * bị redirect về login.jsp.
// */
//@WebFilter(filterName = "AuthFilter", urlPatterns = {"*.jsp", "/MainController",
//    "/AdminController", "/GoodsController", "/HomeController",
//    "/ReportController", "/SaveOrderController", "/SaveTripController",
//    "/SaveArrivalController", "/CreateUserController"})
//public class AuthFilter implements Filter {
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//        HttpSession session = req.getSession(false);
//
//        String uri = req.getRequestURI();
//        String contextPath = req.getContextPath();
//
//        // ── Các URL được phép truy cập khi chưa đăng nhập ────────────────
//        boolean isLoginPage = uri.equals(contextPath + "/login.jsp");
//        boolean isLoginAction = "Login".equals(req.getParameter("Login"));
//        boolean isStaticResource = uri.contains("/css/") || uri.contains("/js/")
//                || uri.contains("/images/");
//        boolean isLogoutAction = "Logout".equals(req.getParameter("Logout"));
//        boolean isRootMainCtrl = uri.endsWith("/MainController")
//                && req.getParameterMap().isEmpty();
//
//        boolean loggedIn = (session != null && session.getAttribute("LOGIN_USER") != null);
//
//        if (loggedIn || isLoginPage || isLoginAction || isStaticResource || isLogoutAction || isRootMainCtrl) {
//            chain.doFilter(request, response);
//        } else {
//            // Chưa đăng nhập → về trang login
//            res.sendRedirect(contextPath + "/login.jsp");
//        }
//    }
//
//    @Override
//    public void init(FilterConfig fc) {
//    }
//
//    @Override
//    public void destroy() {
//    }
//}
