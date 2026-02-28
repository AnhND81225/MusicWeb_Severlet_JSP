<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>miniZing - Footer</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="${pageContext.request.contextPath}/CSS/footer.css?v=1" rel="stylesheet">
    </head>

    <body class="has-fixed-footer">
        <footer id="siteFooter" class="site-footer glass-footer py-3 fixed">
            <div class="container d-flex flex-wrap justify-content-between align-items-center">
                <div class="d-flex align-items-center mb-2 mb-lg-0">
                    <img src="${pageContext.request.contextPath}/Image/logo.png" alt="miniZing" class="footer-logo me-2">
                    <div>
                        <div class="footer-brand">miniZing</div>
                        <small class="footer-note">© 2025 miniZing. All rights reserved.</small>
                    </div>
                </div>

                <div class="text-end">
                    <div class="footer-made">
                        Made with <span class="heart">♥</span> by miniZing Team
                    </div>
                </div>
            </div>
        </footer>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
