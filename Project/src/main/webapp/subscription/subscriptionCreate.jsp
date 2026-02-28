<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Mini Zing - Tạo gói đăng ký</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Project CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css?v=1">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/subscription.css?v=1">
    </head>
    <body>
        <!-- HEADER -->
        <jsp:include page="/includes/header.jsp" flush="true" />

        <!-- MAIN CONTENT -->
        <main class="subscription-container">
            <h2 class="subscription-title">Tạo gói đăng ký mới</h2>

            <div class="subscription-form">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center justify-content-center">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <c:out value="${error}" />
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" novalidate>
                    <input type="hidden" name="txtAction" value="createSubmit"/>

                    <label for="name">Tên gói</label>
                    <input id="name" name="name" type="text" required maxlength="120" placeholder="Ví dụ: Premium">

                    <label for="price">Giá (VNĐ)</label>
                    <input id="price" name="price" type="number" required min="0" step="1000" placeholder="100000">

                    <label for="duration">Thời lượng (ngày)</label>
                    <input id="duration" name="duration" type="number" required min="1" placeholder="30">

                    <label for="description">Mô tả</label>
                    <textarea id="description" name="description" rows="4" placeholder="Ghi rõ quyền lợi của gói..."></textarea>

                    <div class="form-actions">
                        <button type="submit" class="btn-blue">
                            <i class="bi bi-save me-1"></i> Tạo gói
                        </button>
                        <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=manage" class="btn-outline">
                            <i class="bi bi-x-circle me-1"></i> Hủy
                        </a>
                    </div>
                </form>
            </div>
        </main>

        <!-- FOOTER -->
        <jsp:include page="/includes/footer.jsp" flush="true" />

        <!-- Bootstrap JS + Validation -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Bootstrap validation
            (function () {
                'use strict';
                var forms = document.querySelectorAll('.needs-validation');
                Array.prototype.slice.call(forms).forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            })();
        </script>
    </body>
</html>