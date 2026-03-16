<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập - miniZing</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/login.css?v=2">
</head>
<body class="spotify-login simple-auth">
    <main class="auth-shell">
        <section class="auth-card">
            <div class="panel-brand">
                <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="miniZing logo">
                <div>
                    <span>miniZing</span>
                    <strong>Đăng nhập</strong>
                </div>
            </div>

            <form action="MainController" method="post" class="login-form">
                <input type="hidden" name="txtAction" value="login"/>

                <div class="mb-3">
                    <label class="form-label">Tên đăng nhập</label>
                    <input type="text" name="txtUsername" class="form-control" placeholder="Nhập tên đăng nhập" value="${username}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <input type="password" name="txtPassword" id="password" class="form-control" placeholder="Nhập mật khẩu" required>
                        <button type="button" class="btn btn-outline-light" id="togglePassword" aria-label="Hiện mật khẩu">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <c:if test="${not empty msg}">
                    <div class="alert alert-danger text-center py-2">${msg}</div>
                </c:if>

                <button type="submit" class="btn-login mt-2">Đăng nhập</button>

                <div class="links mt-3">
                    <a href="forgotPassword.jsp">Quên mật khẩu?</a>
                    <a href="register.jsp">Đăng ký</a>
                </div>
            </form>
        </section>
    </main>

    <script>
        document.getElementById("togglePassword").addEventListener("click", function () {
            const input = document.getElementById("password");
            const icon = this.querySelector("i");
            const isPassword = input.type === "password";
            input.type = isPassword ? "text" : "password";
            icon.className = isPassword ? "bi bi-eye-slash" : "bi bi-eye";
        });
    </script>
</body>
</html>
