<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🔥 Đăng Ký Tài Khoản</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/register.css?v=1">
    </head>
    <body>
        <div class="register-card">
            <h2>📝 Đăng Ký</h2>

            <!-- ✅ Sửa action: thêm contextPath để luôn trỏ đúng servlet -->
            <form action="${pageContext.request.contextPath}/MainController"
                  method="post" enctype="multipart/form-data">
                <!-- ✅ Bỏ dấu ngoặc kép dư ở cuối -->
                <input type="hidden" name="txtAction" value="register"/>

                <div class="mb-3">
                    <label class="form-label">Tên đăng nhập</label>
                    <input type="text" name="txtUsername" class="form-control"
                           placeholder="Nhập tên người dùng..."
                           value="${fn:escapeXml(requestScope.txtUsername)}" required>
                </div>

                <div class="mb-3 position-relative">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <input type="password" name="txtPassword" class="form-control" placeholder="Nhập mật khẩu..." required>
                        <button class="btn" type="button" id="togglePassword">👁️</button>
                    </div>
                </div>

                <div class="mb-3 position-relative">
                    <label class="form-label">Xác nhận mật khẩu</label>
                    <div class="input-group">
                        <input type="password" name="txtConfirmPassword" class="form-control" placeholder="Nhập lại mật khẩu..." required>
                        <button class="btn" type="button" id="toggleConfirm">👁️</button>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="txtEmail" class="form-control" placeholder="example123@gmail.com"
                           value="${fn:escapeXml(requestScope.txtEmail)}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Ảnh đại diện (tùy chọn)</label>
                    <input type="file" name="avatar" accept="image/png,image/jpeg" class="form-control">
                </div>

                <p style="color:red; font-weight: bold">${error}</p>

                <p style="color:red; font-weight: bold">${message}</p>

                <button type="submit" class="btn-register mt-2">Đăng Ký</button>

                <div class="links mt-3">
                    <a href="login.jsp">🔙 Quay lại đăng nhập</a>
                </div>
            </form>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const togglePassword = document.getElementById("togglePassword");
                const toggleConfirm = document.getElementById("toggleConfirm");
                const passwordInput = document.querySelector('input[name="txtPassword"]');
                const confirmInput = document.querySelector('input[name="txtConfirmPassword"]');
                const form = document.querySelector("form");

                togglePassword.addEventListener("click", function () {
                    const type = passwordInput.type === "password" ? "text" : "password";
                    passwordInput.type = type;
                    this.textContent = type === "password" ? "👁️" : "🙈";
                });

                toggleConfirm.addEventListener("click", function () {
                    const type = confirmInput.type === "password" ? "text" : "password";
                    confirmInput.type = type;
                    this.textContent = type === "password" ? "👁️" : "🙈";
                });

                form.addEventListener("submit", function (e) {
                    if (passwordInput.value !== confirmInput.value) {
                        e.preventDefault();
                        alert("❌ Mật khẩu và xác nhận mật khẩu không khớp!");
                    }
                });
            });
        </script>
    </body>
</html>
