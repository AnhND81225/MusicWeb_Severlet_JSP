<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Bảng xếp hạng bài hát - miniZing</title>
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
                        <span class="eyebrow">Top songs</span>
                        <h1 class="hero-title">Bảng xếp hạng bài hát</h1>
                        <p class="hero-copy">Những track được nghe nhiều nhất trong danh sách hiện tại.</p>
                    </div>

                    <a href="SongController?action=viewSongs" class="pill-button">
                        <i class="bi bi-arrow-left-circle"></i>
                        <span>Quay lại bài hát</span>
                    </a>
                </section>

                <section class="song-list">
                    <c:forEach var="song" items="${topSongs}" varStatus="loop">
                        <article class="song-card ${loop.index == 0 ? 'rank-1' : (loop.index == 1 ? 'rank-2' : (loop.index == 2 ? 'rank-3' : ''))}">
                            <div class="rank-number">#${loop.index + 1}</div>

                            <div class="song-cover-area">
                                <img src="${song.imagePath}" alt="${song.title}" class="song-cover">
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
                                <c:if test="${not empty song.filePath}">
                                    <audio controls preload="none">
                                        <source src="${pageContext.request.contextPath}/Audio/${song.filePath}" type="audio/mpeg">
                                        Trình duyệt của bạn không hỗ trợ phát nhạc
                                    </audio>
                                </c:if>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty topSongs}">
                        <div class="empty-state">Chưa có bài hát nào để xếp hạng.</div>
                    </c:if>
                </section>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
