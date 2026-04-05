package filter;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

/**
 * AuthFilter - Kiểm tra đăng nhập và bảo vệ CSRF.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final SecureRandom secureRandom = new SecureRandom();
    private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder();

    // Hàm sinh Token ngẫu nhiên
    private String generateToken() {
        byte[] randomBytes = new byte[24];
        secureRandom.nextBytes(randomBytes);
        return base64Encoder.encodeToString(randomBytes);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(true);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String method = req.getMethod();

        // 1. Lấy Token hiện tại từ session (để kiểm tra POST)
        String sessionToken = (String) session.getAttribute("CSRF_TOKEN");

        // 2. Tài nguyên tĩnh: cho qua
        if (uri.contains("/css/") || uri.contains("/js/")
                || uri.contains("/images/") || uri.contains("/fonts/")
                || uri.endsWith(".ico") || uri.endsWith(".png")
                || uri.endsWith(".jpg") || uri.endsWith(".gif")) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Kiểm tra CSRF cho các yêu cầu POST
        if ("POST".equalsIgnoreCase(method)) {
            // Chỉ coi là request đăng nhập nếu là POST tới MainController/LoginController với param Login
            boolean isLoginAction = (uri.contains("MainController") && req.getParameter("Login") != null)
                    || (uri.contains("LoginController"));

            if (!isLoginAction) {
                String requestToken = req.getParameter("csrfToken");
                // Nếu session chưa có token (có thể do session timeout), hoặc không khớp
                if (sessionToken == null || requestToken == null || !sessionToken.equals(requestToken)) {
                    System.out.println("CSRF REJECTED: SessionToken=" + sessionToken + ", RequestToken=" + requestToken);
                    res.sendError(HttpServletResponse.SC_FORBIDDEN, "Lỗi bảo mật: CSRF Token không hợp lệ hoặc phiên làm việc đã hết hạn!");
                    return;
                }
            }
        }

        // 4. Đảm bảo luôn có Token trong session cho các form tiếp theo
        if (sessionToken == null) {
            sessionToken = generateToken();
            session.setAttribute("CSRF_TOKEN", sessionToken);
        }

        // 5. Các trang công khai: login.jsp, error.jsp và hành động đăng nhập
        boolean isPublicPage = uri.endsWith("login.jsp") || uri.endsWith("/login.jsp") || uri.endsWith("error.jsp");
        boolean isLoginRequest = "POST".equalsIgnoreCase(method) && 
                ((uri.contains("MainController") && req.getParameter("Login") != null) || uri.contains("LoginController"));

        if (isPublicPage || isLoginRequest) {
            chain.doFilter(request, response);
            return;
        }

        // 5. Kiểm tra đăng nhập
        boolean loggedIn = (session.getAttribute("LOGIN_USER") != null);
        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(contextPath + "/login.jsp");
        }
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}