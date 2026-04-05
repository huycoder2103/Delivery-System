<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lỗi Hệ Thống</title>
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/error.css">
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
            <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
            <input type="submit" name="GoHome" value="⬅ Quay lại Trang chủ" class="btn-home">
        </form>
    </div>
    <%@include file="includes/footer.jsp" %>
</body>
</html>
