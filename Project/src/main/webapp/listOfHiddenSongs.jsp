<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Bài hát ẩn - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=3">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/top10-hidden-lisOfSongs.css?v=2">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel song-catalog-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Hidden songs</span>
                        <h1 class="hero-title">Bài hát ẩn</h1>
                        <p class="hero-copy">Danh sách track đang được ẩn khỏi danh sách chính.</p>
                    </div>

                    <a href="SongController?action=viewSongs" class="pill-button">
                        <i class="bi bi-arrow-left-circle"></i>
                        <span>Quay lại bài hát</span>
                    </a>
                </section>

                <c:if test="${not empty message}">
                    <div class="status-banner success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="status-banner error">${error}</div>
                </c:if>

                <section class="song-list">
                    <c:forEach var="song" items="${listOfHiddenSongs}">
                        <article class="song-card">
                            <div class="rank-number"><i class="bi bi-eye-slash"></i></div>

                            <div class="song-cover-area">
                                <c:if test="${not empty song.imagePath}">
                                    <img src="${song.imagePath}" alt="${song.title}" class="song-cover">
                                </c:if>
                            </div>

                            <div class="song-info">
                                <h3 class="song-title">${song.title}</h3>
                                <p class="song-meta">
                                    ${song.genre.name} · ${song.album.name}<br/>
                                    <c:forEach var="artist" items="${song.artists}" varStatus="st">
                                        ${artist.name}<c:if test="${!st.last}">, </c:if>
                                    </c:forEach>
                                </p>
                            </div>

                            <div class="song-actions">
                                <span class="song-plays"><i class="bi bi-headphones"></i> ${song.playCount}</span>
                                <a href="SongController?action=restoreSong&songId=${song.songId}" class="pill-button">
                                    <i class="bi bi-arrow-clockwise"></i>
                                    <span>Khôi phục</span>
                                </a>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty listOfHiddenSongs}">
                        <div class="empty-state">Không có bài hát nào đang bị ẩn.</div>
                    </c:if>
                </section>

                <jsp:include page="includes/pagination.jsp" />
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
