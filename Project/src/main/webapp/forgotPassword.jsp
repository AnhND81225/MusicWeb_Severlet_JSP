<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Khôi phục mật khẩu - miniZing</title>
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
                <div class="flow-badge">Recovery</div>
                <h1>Khôi phục mật khẩu</h1>
                <p>Nhập email để nhận mã OTP và tiếp tục khôi phục quyền truy cập tài khoản.</p>
                <div class="flow-points">
                    <div class="flow-point"><strong>Email xác thực</strong><span>Hệ thống sẽ gửi mã OTP đến hộp thư của bạn.</span></div>
                    <div class="flow-point"><strong>Bước tiếp theo</strong><span>Nhập mã OTP rồi đặt lại mật khẩu mới.</span></div>
                </div>
            </section>

            <section class="flow-panel">
                <div class="panel-brand">
                    <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="miniZing logo">
                    <div>
                        <span>Account recovery</span>
                        <strong>Email khôi phục</strong>
                    </div>
                </div>

                <form action="UserController" method="post">
                    <input type="hidden" name="txtAction" value="forgotPassword"/>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="txtEmail" class="form-control" placeholder="Nhập email của bạn..." required>
                    </div>

                    <c:if test="${not empty error}"><div class="alert alert-danger text-center py-2">${error}</div></c:if>
                    <c:if test="${not empty message}"><div class="alert alert-success text-center py-2">${message}</div></c:if>

                    <button type="submit" class="flow-button mt-3">Gửi mã OTP</button>

                    <div class="flow-links">
                        <a href="login.jsp">Đăng nhập</a>
                        <a href="register.jsp">Đăng ký</a>
                    </div>
                </form>
            </section>
        </main>
    </body>
</html>
