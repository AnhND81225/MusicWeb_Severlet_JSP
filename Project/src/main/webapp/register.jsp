<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Đăng ký - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/register.css?v=3">
    </head>
    <body class="spotify-register simple-auth">
        <main class="auth-shell">
            <section class="auth-card register-card-simple">
                <div class="panel-brand">
                    <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="miniZing logo">
                    <div>
                        <span>miniZing</span>
                        <strong>Đăng ký</strong>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/MainController"
                      method="post"
                      enctype="multipart/form-data"
                      class="register-form">
                    <input type="hidden" name="txtAction" value="register" />

                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Tên đăng nhập</label>
                            <input type="text" name="txtUsername" class="form-control"
                                   placeholder="Nhập tên đăng nhập"
                                   value="${fn:escapeXml(requestScope.txtUsername)}" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Email</label>
                            <input type="email" name="txtEmail" class="form-control"
                                   placeholder="Nhập email"
                                   value="${fn:escapeXml(requestScope.txtEmail)}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu</label>
                            <div class="input-group">
                                <input type="password" name="txtPassword" id="password" class="form-control"
                                       placeholder="Nhập mật khẩu" required>
                                <button type="button" class="btn btn-outline-light toggle-btn" id="togglePassword" aria-label="Hiện mật khẩu">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Xác nhận mật khẩu</label>
                            <div class="input-group">
                                <input type="password" name="txtConfirmPassword" id="confirmPassword" class="form-control"
                                       placeholder="Nhập lại mật khẩu" required>
                                <button type="button" class="btn btn-outline-light toggle-btn" id="toggleConfirm" aria-label="Hiện xác nhận mật khẩu">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Ảnh đại diện</label>
                            <input type="file" name="avatar" accept="image/png,image/jpeg" class="form-control">
                        </div>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3 mb-0">${error}</div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-warning mt-3 mb-0">${message}</div>
                    </c:if>

                    <button type="submit" class="btn-register mt-4">Đăng ký</button>

                    <div class="links mt-3">
                        <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/forgotPassword.jsp">Quên mật khẩu</a>
                    </div>
                </form>
            </section>
        </main>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.querySelector(".register-form");
                const passwordInput = document.getElementById("password");
                const confirmInput = document.getElementById("confirmPassword");
                const togglePassword = document.getElementById("togglePassword");
                const toggleConfirm = document.getElementById("toggleConfirm");

                function attachToggle(button, input) {
                    button.addEventListener("click", function () {
                        const nextType = input.type === "password" ? "text" : "password";
                        input.type = nextType;
                        this.innerHTML = nextType === "password"
                                ? '<i class="bi bi-eye"></i>'
                                : '<i class="bi bi-eye-slash"></i>';
                    });
                }

                attachToggle(togglePassword, passwordInput);
                attachToggle(toggleConfirm, confirmInput);

                form.addEventListener("submit", function (event) {
                    if (passwordInput.value !== confirmInput.value) {
                        event.preventDefault();
                        alert("Mật khẩu và xác nhận mật khẩu chưa khớp.");
                    }
                });
            });
        </script>
    </body>
</html>
