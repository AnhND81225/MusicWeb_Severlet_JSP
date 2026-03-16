<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/header.css?v=2">

<c:set var="sub" value="${sessionScope.userSubscription}" />
<c:set var="planName" value="${sub != null && sub.subscription != null ? sub.subscription.nameSubscription : 'Free'}" />
<c:set var="endIso" value="${sub != null ? sub.endDate : null}" />
<c:set var="endFormatted" value="" />
<c:if test="${not empty endIso}">
    <c:set var="endOnly" value="${fn:substringBefore(endIso, 'T')}" />
    <c:set var="parts" value="${fn:split(endOnly, '-')}" />
    <c:if test="${fn:length(parts) >= 3}">
        <c:set var="endFormatted" value="${parts[2]}/${parts[1]}/${parts[0]}" />
    </c:if>
</c:if>

<div class="mz-header">
    <div class="header-shell">
        <div class="brand-cluster">
            <a class="brand-link" href="${pageContext.request.contextPath}/SongController?action=viewSongs">
                <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="miniZing logo" class="logo-img">
                <span>
                    <strong>miniZing</strong>
                    <small>Spotify-inspired listening room</small>
                </span>
            </a>
        </div>

        <div class="top-nav">
            <a class="top-link" href="${pageContext.request.contextPath}/SongController?action=viewSongs">
                <i class="bi bi-house-door-fill"></i>
                <span>Home</span>
            </a>
            <a class="top-link" href="${pageContext.request.contextPath}/PlaylistController?action=list">
                <i class="bi bi-collection"></i>
                <span>Playlists</span>
            </a>
            <a class="top-link" href="${pageContext.request.contextPath}/ArtistController?txtAction=viewArtist">
                <i class="bi bi-broadcast"></i>
                <span>Artists</span>
            </a>
            <a class="top-link" href="${pageContext.request.contextPath}/AlbumController?txtAction=viewAlbum">
                <i class="bi bi-disc"></i>
                <span>Albums</span>
            </a>
        </div>

        <div class="user-cluster">
            <c:if test="${not empty sessionScope.user}">
                <a class="plan-chip" href="${pageContext.request.contextPath}/SubscriptionController?txtAction=my">
                    <i class="bi bi-stars"></i>
                    <span>
                        <strong><c:out value="${planName}" /></strong>
                        <small>
                            <c:choose>
                                <c:when test="${not empty endFormatted}">Hết hạn ${endFormatted}</c:when>
                                <c:otherwise>Đang hoạt động</c:otherwise>
                            </c:choose>
                        </small>
                    </span>
                </a>

                <div class="profile-chip">
                    <img src="${pageContext.request.contextPath}/Image/${empty sessionScope.user.avatarUrl ? 'avatar-default.png' : sessionScope.user.avatarUrl}"
                         alt="avatar" class="avatar-img">
                    <span>
                        <strong><c:out value="${sessionScope.user.username}" /></strong>
                        <small><c:out value="${sessionScope.user.role}" /></small>
                    </span>
                </div>

                <form action="${pageContext.request.contextPath}/UserController" method="post" class="logout-form">
                    <input type="hidden" name="txtAction" value="logout" />
                    <button type="submit" class="logout-button">
                        <i class="bi bi-box-arrow-right"></i>
                        <span>Đăng xuất</span>
                    </button>
                </form>
            </c:if>

            <c:if test="${empty sessionScope.user}">
                <a class="auth-link ghost" href="${pageContext.request.contextPath}/register.jsp">Đăng ký</a>
                <a class="auth-link solid" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
            </c:if>
        </div>
    </div>
</div>
