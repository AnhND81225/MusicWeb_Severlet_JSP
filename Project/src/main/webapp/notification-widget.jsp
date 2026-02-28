
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- G?n CSS + JS ri�ng -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/notification.css" />
<c:set var="unreadNotifications" value="${unreadNotifications != null ? unreadNotifications : sessionScope.unreadNotifications}" />
<c:set var="unreadCount" value="${unreadCount != null ? unreadCount : sessionScope.unreadCount}" />

<div class="notification-widget neon-card">
    <div class="notification-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">Th�ng b�o g?n ?�y</h5>
        <c:if test="${unreadCount > 0}">
            <span id="notification-badge" class="badge-pill">${unreadCount}</span>
        </c:if>
    </div>

    <hr class="divider" />

    <c:choose>
        <c:when test="${not empty unreadNotifications}">
            <ul class="notification-list">
                <c:forEach var="n" items="${unreadNotifications}" varStatus="loop" begin="0" end="4">
                    <li class="notification-item">
                        <div class="notification-content">
                            <a href="${pageContext.request.contextPath}/notification?action=read&id=${n.notificationId}"
                               class="notification-link">
                                <b><c:out value="${n.message}" default="Kh�ng c� n?i dung th�ng b�o" /></b><br />
                                <c:if test="${n.song != null}">
                                    ? <span class="song-title">${n.song.title}</span><br />
                                </c:if>
                                <span class="time-text">${n.createdAt}</span>
                            </a>
                        </div>

                        <div class="delete-wrapper">
    <form action="${pageContext.request.contextPath}/notification" method="post" class="delete-form">
        <input type="hidden" name="action" value="hide" />
        <input type="hidden" name="id" value="${n.notificationId}" />
        <button type="submit" class="delete-btn" title="X�a th�ng b�o"
                onclick="return confirm('B?n c� ch?c mu?n x�a th�ng b�o n�y kh�ng?');">
            ?
        </button>
    </form>
</div>

                    </li>
                </c:forEach>
            </ul>
        </c:when>

        <c:otherwise>
            <div class="no-notification">Ch?a c� th�ng b�o m?i.</div>
        </c:otherwise>
    </c:choose>
</div>

<script src="${pageContext.request.contextPath}/js/notification.js" defer></script>
