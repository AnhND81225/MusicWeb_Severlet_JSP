<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Gói đăng ký - miniZing</title>
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
                        <span class="eyebrow">Subscription</span>
                        <h1 class="hero-title">Gói đăng ký</h1>
                        <p class="hero-copy">Chọn gói phù hợp để nâng cấp trải nghiệm nghe nhạc và quản lý quyền lợi dễ hơn.</p>
                    </div>

                    <div class="toolbar-actions">
                        <c:if test="${not empty sessionScope.role and sessionScope.role == 'Admin'}">
                            <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=manage" class="pill-button">
                                <i class="bi bi-gear-fill"></i>
                                <span>Quản lý gói</span>
                            </a>
                        </c:if>
                    </div>
                </section>

                <c:if test="${not empty sessionScope.userSubscription}">
                    <c:set var="mySub" value="${sessionScope.userSubscription}" />
                    <div class="status-banner info">
                        Bạn đang sử dụng gói
                        <strong><c:out value="${not empty mySub.subscription.nameSubscription ? mySub.subscription.nameSubscription : 'Free Plan'}"/></strong>.
                        <a class="ms-2 text-white" href="${pageContext.request.contextPath}/SubscriptionController?txtAction=my">Xem chi tiết</a>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty plans}">
                        <div class="plan-grid">
                            <c:forEach var="p" items="${plans}">
                                <article class="plan-card">
                                    <span class="plan-badge"><i class="bi bi-stars"></i> Plan</span>
                                    <h3><c:out value="${p.nameSubscription}"/></h3>
                                    <div class="plan-price"><fmt:formatNumber value="${p.price}" pattern="#,##0" /> VNĐ</div>
                                    <div class="plan-meta">${p.durationDay} ngày</div>
                                    <p class="plan-desc"><c:out value="${p.description}" /></p>

                                    <div class="plan-actions">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.userSubscription and sessionScope.userSubscription.subscription.planID == p.planID}">
                                                <button class="ghost-button" disabled>Đang dùng</button>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="m-0">
                                                    <input type="hidden" name="txtAction" value="buy"/>
                                                    <input type="hidden" name="planId" value="${p.planID}"/>
                                                    <button type="submit" class="pill-button">
                                                        <i class="bi bi-cart-plus"></i>
                                                        <span>Mua ngay</span>
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">Hiện chưa có gói đăng ký nào.</div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>

        <jsp:include page="/includes/footer.jsp" flush="true" />
    </body>
</html>
