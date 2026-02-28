<%-- 
    Document   : mySubscription (subscription detail)
    Edited on  : 2025-11-07
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
        <title>Mini Zing - Chi tiết gói</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Project CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css?v=1">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/subscription-detail.css?v=1">

    </head>
    <body>
        <jsp:include page="/includes/header.jsp" flush="true" />

        <div class="container my-4">
            <h2 class="mb-3">Chi tiết gói đăng ký</h2>

            <c:choose>
                <c:when test="${not empty userSub}">
                    <c:set var="sub" value="${userSub}" />

                    <div class="card shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h4 class="card-title mb-1"><c:out value="${sub.subscription.nameSubscription}" /></h4>
                                    <small class="text-muted">Gói ID: <c:out value="${sub.subscription.planID}" /></small>
                                </div>
                                <div class="text-end">
                                    <h3 class="fw-bold mb-0">
                                        <fmt:formatNumber value="${sub.subscription.price}" pattern="#,##0" /> VNĐ
                                    </h3>
                                    <small class="text-muted">${sub.subscription.durationDay} ngày</small>
                                </div>
                            </div>

                            <p class="text-secondary mb-3" style="white-space:pre-wrap;">
                                <c:out value="${sub.subscription.description}" />
                            </p>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <div class="small text-muted">Ngày bắt đầu</div>
                                    <div class="fw-medium">
                                        <c:choose>
                                            <c:when test="${not empty sub.startDate}">
                                                <c:set var="sIso" value="${sub.startDate}" />
                                                <c:set var="sOnly" value="${fn:substringBefore(sIso, 'T')}" />
                                                <c:set var="sParts" value="${fn:split(sOnly, '-')}" />
                                                <c:if test="${fn:length(sParts) >= 3}">
                                                    <c:set var="startFormatted" value="${sParts[2]}/${sParts[1]}/${sParts[0]}" />
                                                </c:if>
                                                <c:out value="${startFormatted}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="small text-muted">Ngày hết hạn</div>
                                    <div class="fw-medium">
                                        <c:choose>
                                            <c:when test="${not empty sub.endDate}">
                                                <c:set var="eIso" value="${sub.endDate}" />
                                                <c:set var="eOnly" value="${fn:substringBefore(eIso, 'T')}" />
                                                <c:set var="eParts" value="${fn:split(eOnly, '-')}" />
                                                <c:if test="${fn:length(eParts) >= 3}">
                                                    <c:set var="endFormatted" value="${eParts[2]}/${eParts[1]}/${eParts[0]}" />
                                                </c:if>
                                                <c:out value="${endFormatted}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <span class="small text-muted">Trạng thái: </span>
                                <c:choose>
                                    <c:when test="${sub.isActive}">
                                        <span class="badge bg-success">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Đã hết hạn</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=list" class="btn btn-outline-primary">
                                    <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
                                </a>

                                <c:if test="${sub.isActive}">
                                    <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="m-0">
                                        <input type="hidden" name="txtAction" value="cancel"/>
                                        <input type="hidden" name="subscriptionId" value="${sub.subscriptionId}" />
                                        <button type="submit" class="btn btn-danger">
                                            <i class="bi bi-x-circle me-1"></i> Hủy gói
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>

                        <div class="card-footer bg-transparent border-0 text-muted">
                            <small>Ghi chú: Nếu bạn hủy, gói sẽ chấm dứt ngay lập tức.</small>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-warning">Bạn chưa có gói đăng ký đang hoạt động.</div>
                    <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=list" class="btn btn-gold">
                        Xem các gói hiện có
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="/includes/footer.jsp" flush="true" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>