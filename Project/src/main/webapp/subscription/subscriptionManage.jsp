
<%-- 
    Document   : subscriptionManager
    Created on : 06-Nov-2025 (edited)
    Author     : phant
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Mini Zing - Quản lý gói đăng ký</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Project CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css?v=1">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/subscription-manager.css?v=1">

    </head>
    <body>
        <jsp:include page="/includes/header.jsp" flush="true" />

        <div class="container my-4">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <h2 class="mb-0">Quản lý gói đăng ký</h2>

                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=list"
                       class="btn-back btn-sm" aria-label="Quay lại">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>

                    <c:if test="${not empty sessionScope.role and sessionScope.role == 'Admin'}">
                        <a href="${pageContext.request.contextPath}/subscription/subscriptionCreate.jsp" class="btn btn-gold btn-sm">
                            <i class="bi bi-plus-lg me-1"></i> Thêm gói mới
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Admin check (lowercase 'admin') -->
            <c:choose>
                <c:when test="${not empty sessionScope.role and sessionScope.role == 'Admin'}">
                    <c:if test="${not empty plans}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên gói</th>
                                        <th>Giá (VNĐ)</th>
                                        <th>Thời lượng</th>
                                        <th>Mô tả</th>
                                        <th>Hidden</th>
                                        <th style="width:240px">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${plans}">
                                        <tr>
                                            <td><c:out value="${p.planID}" /></td>
                                            <td><strong><c:out value="${p.nameSubscription}" /></strong></td>
                                            <td><fmt:formatNumber value="${p.price}" pattern="#,##0" /> VNĐ</td>
                                            <td><c:out value="${p.durationDay}" /> ngày</td>
                                            <td style="max-width:360px; white-space:pre-wrap;"><c:out value="${p.description}" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.hidden}">
                                                        <span class="badge bg-secondary">Yes</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success">No</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <a class="btn btn-sm btn-outline-primary" 
                                                       href="${pageContext.request.contextPath}/SubscriptionController?txtAction=edit&id=${p.planID}">
                                                        <i class="bi bi-pencil-fill me-1"></i> Sửa
                                                    </a>

                                                    <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="m-0">
                                                        <input type="hidden" name="txtAction" value="toggleHide"/>
                                                        <input type="hidden" name="id" value="${p.planID}" />
                                                        <button type="submit" class="btn btn-sm ${p.hidden ? 'btn-outline-success' : 'btn-outline-danger'}">
                                                            <i class="bi ${p.hidden ? 'bi-eye-fill' : 'bi-eye-slash-fill'} me-1"></i>
                                                            <c:out value="${p.hidden ? 'Unhide' : 'Hide'}" />
                                                        </button>
                                                    </form>

                                                    <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="m-0" onsubmit="return confirm('Bạn có chắc muốn xóa gói này không?');">
                                                        <input type="hidden" name="txtAction" value="delete"/>
                                                        <input type="hidden" name="id" value="${p.planID}" />
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="bi bi-trash-fill me-1"></i> Xóa
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <c:if test="${empty plans}">
                        <div class="alert alert-secondary">Hiện chưa có gói đăng ký nào.</div>
                    </c:if>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-warning">Bạn không có quyền truy cập trang này. (Cần quyền <strong>Admin</strong>)</div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="/includes/footer.jsp" flush="true" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
