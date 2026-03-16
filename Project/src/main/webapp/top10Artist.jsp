<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Top nghệ sĩ - miniZing</title>
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
                        <span class="eyebrow">Top artists</span>
                        <h1 class="hero-title">Bảng xếp hạng nghệ sĩ</h1>
                        <p class="hero-copy">Bảng xếp hạng follow được đưa về cùng layout chung để trải nghiệm liền mạch hơn.</p>
                    </div>

                    <a href="ArtistController?txtAction=viewArtist" class="pill-button">
                        <i class="bi bi-arrow-left-circle"></i>
                        <span>Quay lại</span>
                    </a>
                </section>

                <div class="artist-grid">
                    <c:forEach var="artist" items="${topArtists}" varStatus="loop">
                        <article class="artist-card ${loop.index == 0 ? 'top-1' : (loop.index == 1 ? 'top-2' : (loop.index == 2 ? 'top-3' : ''))}"
                                 role="button"
                                 onclick="location.href = 'ArtistController?txtAction=artistInfo&artistID=${artist.artistId}'"
                                 tabindex="0"
                                 onkeypress="if (event.key === 'Enter') location.href = 'ArtistController?txtAction=artistInfo&artistID=${artist.artistId}'">
                            <div class="top-badge">#${loop.index + 1}</div>

                            <div class="artist-image-wrapper">
                                <c:choose>
                                    <c:when test="${not empty artist.image}">
                                        <img src="${artist.image}" alt="${artist.name}" class="artist-image" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/Image/avatar-default.png" alt="No Image" class="artist-image" />
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="artist-info">
                                <h5 class="artist-name">${artist.name}</h5>
                                <p class="artist-follow">
                                    <i class="bi bi-people-fill"></i>
                                    <c:choose>
                                        <c:when test="${artist.followerCount != null && artist.followerCount > 0}">
                                            ${artist.followerCount} người yêu thích
                                        </c:when>
                                        <c:otherwise>Chưa có người theo dõi</c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="artist-summary">Mở profile để xem thông tin chi tiết, album và các bài hát đã gắn với nghệ sĩ này.</p>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty topArtists}">
                        <div class="empty-state">Chưa có dữ liệu follow để xếp hạng.</div>
                    </c:if>
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
