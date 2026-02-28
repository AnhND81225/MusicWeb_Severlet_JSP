<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🔒 Đặt Lại Mật Khẩu - Music App</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/login.css?v=1">
    </head>
    <body>
        <div class="login-card">
            <h2>🔒 Đặt Lại Mật Khẩu</h2>

            <form action="UserController" method="post">
                <input type="hidden" name="txtAction" value="resetPassword"/>

                <div class="mb-3">
                    <label class="form-label">Mật khẩu mới</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-0 text-light">
                            <i class="bi bi-lock"></i>
                        </span>
                        <input type="password" name="txtNewPassword" id="newPassword" class="form-control" placeholder="Nhập mật khẩu mới..." required>
                        <button type="button" class="btn btn-outline-light" id="toggleNewPassword">👁</button>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Xác nhận mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-0 text-light">
                            <i class="bi bi-lock-fill"></i>
                        </span>
                        <input type="password" name="txtConfirmPassword" id="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu..." required>
                        <button type="button" class="btn btn-outline-light" id="toggleConfirmPassword">👁</button>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger text-center py-2">${error}</div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success text-center py-2">${message}</div>
                </c:if>

                <button type="submit" class="btn-login mt-3">Cập nhật mật khẩu</button>

                <div class="links mt-3">
                    <a href="login.jsp">Quay lại đăng nhập</a>
                </div>
            </form>
        </div>

        <script>
            const toggleNew = document.getElementById("toggleNewPassword");
            const toggleConfirm = document.getElementById("toggleConfirmPassword");
            const newPass = document.getElementById("newPassword");
            const confirmPass = document.getElementById("confirmPassword");

            toggleNew.addEventListener("click", () => {
                const type = newPass.getAttribute("type") === "password" ? "text" : "password";
                newPass.setAttribute("type", type);
            });

            toggleConfirm.addEventListener("click", () => {
                const type = confirmPass.getAttribute("type") === "password" ? "text" : "password";
                confirmPass.setAttribute("type", type);
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.js"></script>
    </body>
</html>
