
<%-- 
    Document   : subscriptionList
    Created on : 06-Nov-2025 (bootstrap UI)
    Author     : phant (edited)
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Mini Zing - Gói đăng ký</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Project CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css?v=1">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/subscription-list.css?v=1">

    </head>
    <body>
        <jsp:include page="/includes/header.jsp" flush="true" />

        <div class="container my-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h2 class="mb-0">Các gói đăng ký</h2>
                    <small class="text-muted d-block">Chọn gói phù hợp với bạn</small>
                </div>

                <!-- Admin manage button -->
                <div>
                    <c:if test="${not empty sessionScope.role and sessionScope.role == 'Admin'}">
                        <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=manage"
                           class="btn-admin btn-sm me-2">
                            <i class="bi bi-gear-fill me-1"></i> Quản lý gói
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Nếu user đang có gói hiện tại -->
            <c:if test="${not empty sessionScope.userSubscription}">
                <c:set var="mySub" value="${sessionScope.userSubscription}" />
                <div class="alert alert-info d-flex align-items-center">
                    <i class="bi bi-award-fill me-3" style="font-size:1.35rem;color:#FFD166"></i>
                    <div>
                        Bạn đang sử dụng gói:
                        <strong>
                            <c:out value="${not empty mySub.subscription.nameSubscription ? mySub.subscription.nameSubscription : 'Free Plan'}"/>
                        </strong>
                        <c:if test="${not empty mySub.endDate}">
                            &nbsp;— Hết hạn:
                            <c:set var="endIso" value="${mySub.endDate}" />
                            <c:set var="endFormatted" value="" />
                            <c:if test="${not empty endIso}">
                                <c:set var="endOnly" value="${fn:substringBefore(endIso, 'T')}" />
                                <c:set var="parts" value="${fn:split(endOnly, '-')}" />
                                <c:if test="${fn:length(parts) >= 3}">
                                    <c:set var="endFormatted" value="${parts[2]}/${parts[1]}/${parts[0]}" />
                                </c:if>
                            </c:if>
                            <strong class="text-warning"> <c:out value="${endFormatted}" /></strong>
                        </c:if>
                        <div class="mt-1"><a class="link-primary" href="${pageContext.request.contextPath}/SubscriptionController?txtAction=my">Xem chi tiết</a></div>
                    </div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty plans}">
                    <!-- Grid cards -->
                    <div class="row g-3">
                        <c:forEach var="p" items="${plans}">
                            <div class="col-12 col-sm-6 col-md-4">
                                <div class="card h-100 shadow-sm">
                                    <div class="card-body d-flex flex-column">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="card-title mb-0"><c:out value="${p.nameSubscription}"/></h5>
                                            <span class="badge bg-primary">Hot</span>
                                        </div>

                                        <div class="mb-3">
                                            <h3 class="fw-bold mb-0">
                                                <fmt:formatNumber value="${p.price}" pattern="#,##0" /> VNĐ
                                            </h3>
                                            <small class="text-muted">${p.durationDay} ngày</small>
                                        </div>

                                        <p class="card-text text-secondary mb-4" style="white-space:pre-wrap;">
                                            <c:out value="${p.description}" />
                                        </p>

                                        <div class="mt-auto d-flex gap-2 align-items-center">
                                            <!-- If user currently uses this plan, show disabled -->
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.userSubscription and sessionScope.userSubscription.subscription.planID == p.planID}">
                                                    <button class="btn btn-outline-secondary btn-sm w-100" disabled>
                                                        <i class="bi bi-check-circle me-1"></i> Đang dùng
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="w-100 m-0">
                                                        <input type="hidden" name="txtAction" value="buy"/>
                                                        <input type="hidden" name="planId" value="${p.planID}"/>
                                                        <button type="submit" class="btn btn-gold w-100 btn-sm">
                                                            <i class="bi bi-cart-plus me-2"></i> Mua ngay
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="card-footer bg-transparent border-0 d-flex justify-content-between align-items-center">
                                        <small class="text-muted">Gói gồm: <c:out value="${p.durationDay}"/> ngày</small>
                                        <small class="text-muted">ID: <c:out value="${p.planID}" /></small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-secondary">Không có gói đăng ký nào vào lúc này.</div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="/includes/footer.jsp" flush="true" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
