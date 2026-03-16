<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Tạo gói đăng ký - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=3">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/subscription-shell.css?v=1">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="/includes/header.jsp" flush="true" />
            <main class="content-panel subscription-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Subscription create</span>
                        <h1 class="hero-title">Gói mới</h1>
                    </div>
                </section>

                <div class="data-card form-stack">
                    <c:if test="${not empty error}">
                        <div class="status-banner warning">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="form-stack">
                        <input type="hidden" name="txtAction" value="createSubmit"/>
                        <div>
                            <label for="name">Tên gói</label>
                            <input id="name" name="name" type="text" class="form-control" required maxlength="120" placeholder="Ví dụ: Premium">
                        </div>
                        <div>
                            <label for="price">Giá</label>
                            <input id="price" name="price" type="number" class="form-control" required min="0" step="1000" placeholder="100000">
                        </div>
                        <div>
                            <label for="duration">Thời lượng</label>
                            <input id="duration" name="duration" type="number" class="form-control" required min="1" placeholder="30">
                        </div>
                        <div>
                            <label for="description">Mô tả</label>
                            <textarea id="description" name="description" class="form-control" rows="4" placeholder="Ghi rõ quyền lợi của gói..."></textarea>
                        </div>
                        <div class="toolbar-actions">
                            <button type="submit" class="pill-button"><i class="bi bi-save"></i><span>Tạo gói</span></button>
                            <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=manage" class="ghost-button"><i class="bi bi-x-circle"></i><span>Hủy</span></a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
        <jsp:include page="/includes/footer.jsp" flush="true" />
    </body>
</html>
