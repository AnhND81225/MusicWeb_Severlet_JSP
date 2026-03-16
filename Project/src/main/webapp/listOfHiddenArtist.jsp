<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Nghệ sĩ đã ẩn - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/top10-hidden-listOfArtists.css?v=2">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel artist-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Hidden artists</span>
                        <h1 class="hero-title">Nghệ sĩ ẩn</h1>
                        <p class="hero-copy">Khu vực quản trị này giúp restore nhanh mà không rời khỏi visual mới của ứng dụng.</p>
                    </div>

                    <a href="ArtistController?txtAction=viewArtist" class="pill-button">
                        <i class="bi bi-arrow-left-circle"></i>
                        <span>Quay lại danh sách</span>
                    </a>
                </section>

                <c:if test="${not empty message}">
                    <div class="status-banner success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="status-banner error">${error}</div>
                </c:if>

                <div class="artist-grid">
                    <c:forEach var="artist" items="${listOfArtists}">
                        <article class="artist-card">
                            <div class="artist-image-wrapper">
                                <c:choose>
                                    <c:when test="${not empty artist.image}">
                                        <img src="${artist.image}" alt="${artist.name}" class="artist-image">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/Image/avatar-default.png" alt="No Image" class="artist-image">
                                    </c:otherwise>
                                </c:choose>

                                <div class="artist-actions">
                                    <a href="ArtistController?txtAction=restoreArtist&artistID=${artist.artistId}"
                                       class="action-btn edit" title="Khôi phục">
                                        <i class="bi bi-arrow-clockwise"></i>
                                    </a>
                                </div>
                            </div>

                            <div class="artist-info">
                                <h5 class="artist-name">${artist.name}</h5>
                                <p class="artist-follow">
                                    <i class="bi bi-people-fill"></i>
                                    <c:choose>
                                        <c:when test="${artist.followerCount != null && artist.followerCount > 0}">
                                            ${artist.followerCount} người theo dõi
                                        </c:when>
                                        <c:otherwise>Chưa có người theo dõi</c:otherwise>
                                    </c:choose>
                                </p>
                                <a href="ArtistController?txtAction=restoreArtist&artistID=${artist.artistId}" class="btn-action primary">
                                    <i class="bi bi-arrow-repeat"></i>
                                    <span>Khôi phục nghệ sĩ</span>
                                </a>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty listOfArtists}">
                        <div class="empty-state">Không có nghệ sĩ nào đang bị ẩn.</div>
                    </c:if>
                </div>

                <jsp:include page="includes/pagination.jsp" />
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
