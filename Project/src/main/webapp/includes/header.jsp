<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>miniZing - Navbar</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Scoped header CSS -->
    <link href="${pageContext.request.contextPath}/CSS/header.css?v=1" rel="stylesheet">

    <!-- Optional global CSS -->
    <link href="${pageContext.request.contextPath}/CSS/hfter.css?v=1" rel="stylesheet">
</head>
<body>
<div class="mz-header"><!-- scope wrapper -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-gradient shadow-sm">
        <div class="container">
            <!-- Logo -->
            <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/Image/logo.png" alt="logo"
                     width="60" height="60" class="me-2 logo-img">
                <span class="brand-text fw-bold fs-4">miniZing</span>
            </a>

            <!-- Toggler -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                    aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Collapse: left group (links) + right group (user actions) -->
            <div class="collapse navbar-collapse" id="mainNavbar">
                <!-- LEFT NAV: My Playlist, Album, Nghệ sĩ, Bài hát -->
                <ul class="navbar-nav left-nav d-flex align-items-center">
                    <li class="nav-item me-3">
                        <a class="nav-link playlist-link text-light" href="${pageContext.request.contextPath}/PlaylistController?txtAction=view">My Playlist</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link text-light" href="${pageContext.request.contextPath}/AlbumController?txtAction=viewAlbum">Album</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link text-light" href="${pageContext.request.contextPath}/ArtistController?txtAction=viewArtist">Nghệ sĩ</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link text-light" href="${pageContext.request.contextPath}/SongController?txtAction=viewSongs">Bài hát</a>
                    </li>
                </ul>

                <!-- RIGHT NAV: push to right using ms-auto -->
                <ul class="navbar-nav right-nav d-flex align-items-center ms-auto">
                    <!-- Nếu đã đăng nhập -->
                    <c:if test="${not empty sessionScope.user}">
                        <li class="nav-item d-flex align-items-center me-3">
                            <img src="${pageContext.request.contextPath}/Image/${empty sessionScope.user.avatarUrl ? 'avatar-default.png' : sessionScope.user.avatarUrl}"
                                 alt="avatar" width="45" height="45"
                                 class="rounded-circle me-2 avatar-img">
                            <span class="text-white small">
                                Xin chào, <strong><c:out value="${sessionScope.user.username}" /></strong>
                            </span>
                        </li>

                        <!-- Subscription -->
                        <c:set var="sub" value="${sessionScope.userSubscription}" />
                        <li class="nav-item me-2">
                            <c:choose>
                                <c:when test="${not empty sub}">
                                    <c:set var="planName" value="${sub.subscription != null ? sub.subscription.nameSubscription : 'Free Plan'}" />
                                    <c:set var="endIso" value="${sub.endDate}" />
                                    <c:set var="endFormatted" value="" />
                                    <c:if test="${not empty endIso}">
                                        <c:set var="endOnly" value="${fn:substringBefore(endIso, 'T')}" />
                                        <c:set var="parts" value="${fn:split(endOnly, '-')}" />
                                        <c:if test="${fn:length(parts) >= 3}">
                                            <c:set var="endFormatted" value="${parts[2]}/${parts[1]}/${parts[0]}" />
                                        </c:if>
                                    </c:if>

                                    <a class="nav-link d-flex align-items-center text-light"
                                       href="${pageContext.request.contextPath}/SubscriptionController?txtAction=my">
                                        <i class="bi bi-star-fill me-2 star-icon"></i>
                                        <div class="d-flex flex-column" style="line-height:1;">
                                            <small class="text-light mb-0 plan-label">Gói</small>
                                            <strong class="plan-name"><c:out value="${planName}" /></strong>
                                        </div>
                                        <c:if test="${not empty endFormatted}">
                                            <span class="ms-2 small text-warning plan-expiry">
                                                (Hết hạn: <c:out value="${endFormatted}" />)
                                            </span>
                                        </c:if>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a class="nav-link d-flex align-items-center text-light"
                                       href="${pageContext.request.contextPath}/SubscriptionController?txtAction=list">
                                        <i class="bi bi-star me-2 text-light"></i>
                                        <span class="small text-light">Chưa có gói</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>

                        <li class="nav-item">
                            <form action="${pageContext.request.contextPath}/UserController" method="post" class="m-0">
                                <input type="hidden" name="txtAction" value="logout" />
                                <button type="submit" class="btn btn-danger btn-sm">Đăng xuất</button>
                            </form>
                        </li>
                    </c:if>

                    <!-- Nếu chưa đăng nhập -->
                    <c:if test="${empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link btn btn-gold ms-2 px-3" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link btn btn-gold ms-2 px-3" href="${pageContext.request.contextPath}/register.jsp">Đăng ký</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
