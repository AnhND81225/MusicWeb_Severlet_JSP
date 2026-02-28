<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🔑 Xác Thực OTP - Music App</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/login.css">
    </head>
    <body>
        <div class="login-card">
            <h2>🔑 Xác Thực OTP</h2>

            <form action="UserController" method="post">
                <input type="hidden" name="txtAction" value="verifyForgotOTP"/>

                <div class="mb-3">
                    <label class="form-label">Nhập mã OTP</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-0 text-light">
                            <i class="bi bi-shield-lock"></i>
                        </span>
                        <input type="text" name="txtOTP" class="form-control" placeholder="Nhập mã OTP gồm 6 chữ số..." required>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger text-center py-2">${error}</div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success text-center py-2">${message}</div>
                </c:if>

                <button type="submit" class="btn-login mt-3">Xác nhận OTP</button>

                <div class="links mt-3">
                    <a href="forgotPassword.jsp">Gửi lại OTP</a> |
                    <a href="login.jsp">Quay lại đăng nhập</a>
                </div>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.js"></script>
    </body>
</html>
