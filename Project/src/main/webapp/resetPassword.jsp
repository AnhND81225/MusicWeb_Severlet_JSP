<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Đặt lại mật khẩu - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/auth-flow.css?v=1">
    </head>
    <body class="auth-flow">
        <main class="flow-stage">
            <section class="flow-showcase">
                <div class="flow-badge">Password</div>
                <h1>Mật khẩu mới</h1>
                <p>Tạo mật khẩu mới để hoàn tất quy trình khôi phục tài khoản.</p>
                <div class="flow-points">
                    <div class="flow-point"><strong>Bảo mật</strong><span>Dùng mật khẩu đủ dài và khác với các tài khoản khác của bạn.</span></div>
                    <div class="flow-point"><strong>Xác nhận</strong><span>Nhập lại cùng một mật khẩu ở cả hai ô để tránh sai lệch.</span></div>
                </div>
            </section>

            <section class="flow-panel">
                <div class="panel-brand">
                    <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="miniZing logo">
                    <div>
                        <span>Password reset</span>
                        <strong>Mật khẩu mới</strong>
                    </div>
                </div>

                <form action="UserController" method="post">
                    <input type="hidden" name="txtAction" value="resetPassword"/>

                    <div class="mb-3">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" name="txtNewPassword" id="newPassword" class="form-control" placeholder="Nhập mật khẩu mới..." required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Xác nhận mật khẩu</label>
                        <input type="password" name="txtConfirmPassword" id="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu..." required>
                    </div>

                    <c:if test="${not empty error}"><div class="alert alert-danger text-center py-2">${error}</div></c:if>
                    <c:if test="${not empty message}"><div class="alert alert-success text-center py-2">${message}</div></c:if>

                    <button type="submit" class="flow-button mt-3">Cập nhật mật khẩu</button>

                    <div class="flow-links">
                        <a href="login.jsp">Đăng nhập</a>
                    </div>
                </form>
            </section>
        </main>
    </body>
</html>
