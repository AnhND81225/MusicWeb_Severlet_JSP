<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Xác thực OTP - miniZing</title>
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
                <div class="flow-badge">OTP</div>
                <h1>Mã xác thực</h1>
                <p>Nhập mã OTP được gửi về email để tiếp tục bước đặt lại mật khẩu.</p>
                <div class="flow-points">
                    <div class="flow-point"><strong>Mã 6 chữ số</strong><span>Kiểm tra hộp thư đến và cả thư mục spam nếu chưa thấy email.</span></div>
                    <div class="flow-point"><strong>Bước tiếp theo</strong><span>Sau khi xác thực thành công, bạn sẽ được đưa tới màn hình đặt mật khẩu mới.</span></div>
                </div>
            </section>

            <section class="flow-panel">
                <div class="panel-brand">
                    <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="miniZing logo">
                    <div>
                        <span>OTP verification</span>
                        <strong>Mã OTP</strong>
                    </div>
                </div>

                <form action="UserController" method="post">
                    <input type="hidden" name="txtAction" value="verifyForgotOTP"/>
                    <div class="mb-3">
                        <label class="form-label">Mã OTP</label>
                        <input type="text" name="txtOTP" class="form-control" placeholder="Nhập mã OTP gồm 6 chữ số..." required>
                    </div>

                    <c:if test="${not empty error}"><div class="alert alert-danger text-center py-2">${error}</div></c:if>
                    <c:if test="${not empty message}"><div class="alert alert-success text-center py-2">${message}</div></c:if>

                    <button type="submit" class="flow-button mt-3">Xác nhận OTP</button>

                    <div class="flow-links">
                        <a href="forgotPassword.jsp">Gửi lại OTP</a>
                        <a href="login.jsp">Đăng nhập</a>
                    </div>
                </form>
            </section>
        </main>
    </body>
</html>
