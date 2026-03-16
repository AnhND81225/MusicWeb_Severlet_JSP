<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản lý gói - miniZing</title>
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
                        <span class="eyebrow">Subscription manage</span>
                        <h1 class="hero-title">Quản lý gói</h1>
                    </div>
                    <div class="toolbar-actions">
                        <a href="${pageContext.request.contextPath}/SubscriptionController?txtAction=list" class="ghost-button">
                            <i class="bi bi-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/subscription/subscriptionCreate.jsp" class="pill-button">
                            <i class="bi bi-plus-lg"></i>
                            <span>Thêm gói</span>
                        </a>
                    </div>
                </section>

                <c:choose>
                    <c:when test="${not empty sessionScope.role and sessionScope.role == 'Admin'}">
                        <div class="data-card">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên gói</th>
                                        <th>Giá</th>
                                        <th>Thời lượng</th>
                                        <th>Mô tả</th>
                                        <th>Ẩn</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${plans}">
                                        <tr>
                                            <td>${p.planID}</td>
                                            <td>${p.nameSubscription}</td>
                                            <td><fmt:formatNumber value="${p.price}" pattern="#,##0" /> VNĐ</td>
                                            <td>${p.durationDay} ngày</td>
                                            <td>${p.description}</td>
                                            <td>${p.hidden ? 'Yes' : 'No'}</td>
                                            <td>
                                                <div class="toolbar-actions">
                                                    <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="m-0">
                                                        <input type="hidden" name="txtAction" value="toggleHide"/>
                                                        <input type="hidden" name="id" value="${p.planID}" />
                                                        <button type="submit" class="ghost-button">${p.hidden ? 'Hiện' : 'Ẩn'}</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/SubscriptionController" method="post" class="m-0" onsubmit="return confirm('Bạn có chắc muốn xóa gói này không?');">
                                                        <input type="hidden" name="txtAction" value="delete"/>
                                                        <input type="hidden" name="id" value="${p.planID}" />
                                                        <button type="submit" class="ghost-button">Xóa</button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="status-banner warning">Bạn không có quyền truy cập trang này.</div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
        <jsp:include page="/includes/footer.jsp" flush="true" />
    </body>
</html>
