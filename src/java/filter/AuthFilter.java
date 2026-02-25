///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package filter;
//
///**
// *
// * @author HuyNHSE190240
// */
//import java.io.IOException;
//import javax.servlet.Filter;
//import javax.servlet.FilterChain;
//import javax.servlet.FilterConfig;
//import javax.servlet.ServletException;
//import javax.servlet.ServletRequest;
//import javax.servlet.ServletResponse;
//import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//@WebFilter(filterName = "AuthFilter", urlPatterns = {"*.jsp", "/MainController"})
//public class AuthFilter implements Filter {
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//        HttpSession session = req.getSession(false);
//
//        String loginURI = req.getContextPath() + "/login.jsp";
//        String mainController = req.getContextPath() + "/MainController";
//        
//        // Kiểm tra xem người dùng đã đăng nhập chưa thông qua attribute "FULLNAME"
//        boolean loggedIn = (session != null && session.getAttribute("FULLNAME") != null);
//        boolean loginRequest = req.getRequestURI().equals(loginURI);
//        boolean loginAction = "Login".equals(req.getParameter("Login"));
//
//        if (loggedIn || loginRequest || loginAction) {
//            chain.doFilter(request, response); // Cho phép đi tiếp
//        } else {
//            res.sendRedirect(loginURI); // Bắt buộc quay lại trang login
//        }
//    }
//
//    @Override public void init(FilterConfig filterConfig) {}
//    @Override public void destroy() {}
//}