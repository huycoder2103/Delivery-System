package filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

/**
 * AuthFilter - Kiểm tra đăng nhập trước khi truy cập các trang bảo vệ.
 *
 * BUG CŨ: Filter chặn cả POST login vì chỉ check URI, không check parameter.
 * FIX: Whitelist rõ ràng các request được phép mà không cần đăng nhập.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri         = req.getRequestURI();
        String contextPath = req.getContextPath();

        // ── 1. Tài nguyên tĩnh: luôn cho qua ────────────────────────────
        if (uri.contains("/css/") || uri.contains("/js/")
                || uri.contains("/images/") || uri.contains("/fonts/")
                || uri.endsWith(".ico") || uri.endsWith(".png")
                || uri.endsWith(".jpg") || uri.endsWith(".gif")) {
            chain.doFilter(request, response);
            return;
        }

        // ── 2. Trang đăng nhập (login.jsp) → cho qua ─────────────────────
        if (uri.endsWith("login.jsp") || uri.endsWith("/login.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // ── 3. Trang lỗi → cho qua ───────────────────────────────────────
        if (uri.endsWith("error.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // ── 4. MainController với action Login → ĐÂY LÀ FIX CHÍNH ───────
        //    Khi user POST form đăng nhập, request đi tới MainController
        //    với parameter "Login". Filter cũ chặn vì chỉ check URI.
        if (uri.contains("MainController")) {
            String loginParam = req.getParameter("Login");
            if (loginParam != null) {
                // Đây là action đăng nhập → cho qua để MainController xử lý
                chain.doFilter(request, response);
                return;
            }
        }

        // ── 5. Kiểm tra session ───────────────────────────────────────────
        boolean loggedIn = (session != null && session.getAttribute("LOGIN_USER") != null);

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập → redirect về trang login
            res.sendRedirect(contextPath + "/login.jsp");
        }
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}