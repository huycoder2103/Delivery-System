<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lỗi Hệ Thống</title>
    <link rel="stylesheet" href="css/home.css">
    <style>
        .error-box {
            max-width: 500px; margin: 80px auto; text-align: center;
            background: white; padding: 40px; border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .error-icon { font-size: 4rem; margin-bottom: 20px; }
        .error-box h2 { color: #e74c3c; }
        .error-msg { color: #666; margin: 15px 0; font-size: 0.9rem; }
    </style>
</head>
<body>
    <%@include file="includes/navbar.jsp" %>
    <div class="error-box">
        <div class="error-icon">⚠️</div>
        <h2>Đã xảy ra lỗi!</h2>
        <p class="error-msg">
            <%= request.getAttribute("ERROR_MESSAGE") != null
                ? request.getAttribute("ERROR_MESSAGE")
                : "Hệ thống gặp sự cố. Vui lòng thử lại sau." %>
        </p>
        <form action="MainController" method="POST">
            <input type="submit" name="GoHome" value="⬅ Quay lại Trang chủ" class="btn-cyan"
                   style="padding: 10px 25px; font-size: 1rem;">
        </form>
    </div>
</body>
</html>
