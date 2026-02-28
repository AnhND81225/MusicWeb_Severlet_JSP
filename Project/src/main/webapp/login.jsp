<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>🎧 Đăng Nhập - Music App</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/login.css">
</head>
<body>
    <div class="login-card">
        <h2>🎧 Đăng Nhập</h2>

        <form action="MainController" method="post">
            <input type="hidden" name="txtAction" value="login"/>

            <div class="mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <input type="text" name="txtUsername" class="form-control" placeholder="Nhập username..." value="${username}" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <div class="input-group">
                    <input type="password" name="txtPassword" id="password" class="form-control" placeholder="Nhập password..." required>
                    <button type="button" class="btn btn-outline-light" id="togglePassword">👁</button>
                </div>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-danger text-center py-2">${msg}</div>
            </c:if>

            <button type="submit" class="btn-login mt-3">Đăng Nhập</button>

            <div class="links mt-3">
                <a href="forgotPassword.jsp">Quên mật khẩu?</a> |
                <a href="register.jsp">Đăng ký tài khoản</a>
            </div>
        </form>
    </div>

    <script src="JS/login.js"></script> <!-- JS riêng -->
</body>
</html>
