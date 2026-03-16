<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Chi tiết gói - miniZing</title>
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
                        <span class="eyebrow">Subscription detail</span>
                        <h1 class="hero-title">Chi tiết gói</h1>
                    </div>
                    <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=list" class="ghost-button">
                        <i class="bi bi-arrow-left"></i>
                        <span>Quay lại</span>
                    </a>
                </section>

                <c:choose>
                    <c:when test="${not empty userSub}">
                        <c:set var="sub" value="${userSub}" />
                        <div class="data-card">
                            <h3><c:out value="${sub.subscription.nameSubscription}" /></h3>
                            <div class="plan-price mb-2"><fmt:formatNumber value="${sub.subscription.price}" pattern="#,##0" /> VNĐ</div>
                            <p class="plan-desc"><c:out value="${sub.subscription.description}" /></p>
                            <div class="tiny-note mb-3">${sub.subscription.durationDay} ngày</div>

                            <div class="toolbar-actions">
                                <c:if test="${sub.isActive}">
                                    <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="m-0">
                                        <input type="hidden" name="txtAction" value="cancel"/>
                                        <input type="hidden" name="subscriptionId" value="${sub.subscriptionId}" />
                                        <button type="submit" class="ghost-button">
                                            <i class="bi bi-x-circle"></i>
                                            <span>Hủy gói</span>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">Bạn chưa có gói đăng ký đang hoạt động.</div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
        <jsp:include page="/includes/footer.jsp" flush="true" />
    </body>
</html>
