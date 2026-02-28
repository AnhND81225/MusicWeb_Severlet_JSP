<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🔐 Xác Thực OTP</title>
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"
            />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/otp.css?v=1">
    </head>
    <body>
        <div class="otp-card">
            <h2>🔒 Xác Thực OTP</h2>
            <p class="text-center mb-4">Nhập mã OTP được gửi đến email của bạn</p>

            <form action="MainController" method="post">
                <input type="hidden" name="txtAction" value="verifyOTP" />

                <div class="otp-input-group">
                    <input
                        type="text"
                        name="txtOTP"
                        maxlength="6"
                        class="form-control otp-input"
                        placeholder="Nhập OTP"
                        required
                        />
                </div>

                <button type="submit" class="btn-verify mt-3">✅ Xác Nhận</button>

                <div class="links mt-3">
                    <a href="MainController?txtAction=resendOTP">📩 Gửi lại OTP</a>
                </div>

                <c:if test="${not empty message}">
                    <div class="alert alert-success mt-3">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3">${error}</div>
                </c:if>
            </form>
        </div>

        <script src="JS/otp.js"></script>
    </body>
</html>
