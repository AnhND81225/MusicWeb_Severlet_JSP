<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết album - miniZing</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/songOfAlbumStyle.css?v=2">
</head>
<body class="spotify-app">
    <div class="app-shell">
        <jsp:include page="includes/header.jsp" />

        <main class="content-panel album-detail-page">
            <section class="album-hero">
                <div class="album-cover-block">
                    <c:choose>
                        <c:when test="${not empty album.coverImage}">
                            <img src="${album.coverImage}" alt="${album.name}" class="album-cover-image">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="${album.name}" class="album-cover-image">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="album-copy">
                    <span class="eyebrow">Album</span>
                    <h1 class="hero-title">${album.name}</h1>
                    <p class="album-meta-line">
                        <span><i class="bi bi-calendar3"></i> <c:out value="${album.releaseDate != null ? album.releaseDate.toLocalDate() : 'Chưa có'}" /></span>
                        <span><i class="bi bi-music-note-list"></i> ${albumSongTotalCount} bài hát</span>
                    </p>
                    <p class="album-artist-line">
                        <i class="bi bi-person-circle"></i>
                        <c:out value="${album.artist != null ? album.artist.name : 'Không xác định'}" />
                    </p>
                    <p class="hero-copy">
                        Màn hình chi tiết album được gom lại theo cùng bố cục với playlist và artist detail:
                        artwork lớn, thông tin chính rõ ràng và danh sách bài hát ngay bên dưới.
                    </p>

                    <div class="hero-actions">
                        <a href="AlbumController?txtAction=viewAlbum" class="ghost-button">
                            <i class="bi bi-arrow-left-circle"></i>
                            <span>Danh mục album</span>
                        </a>
                        <a href="AlbumController?txtAction=topAlbum" class="ghost-button">
                            <i class="bi bi-fire"></i>
                            <span>Top albums</span>
                        </a>
                    </div>
                </div>
            </section>

            <div class="quick-stats">
                <article class="stat-card">
                    <span>Album</span>
                    <strong>${album.name}</strong>
                </article>
                <article class="stat-card">
                    <span>Nghệ sĩ</span>
                    <strong><c:out value="${album.artist != null ? album.artist.name : 'Chưa có'}" /></strong>
                </article>
                <article class="stat-card">
                    <span>Bài hát</span>
                    <strong>${albumSongTotalCount}</strong>
                </article>
            </div>

            <div class="album-detail-shell">
                <section class="track-list-panel">
                    <div class="section-head">
                        <div>
                            <span class="section-kicker">Tracklist</span>
                            <h2>Danh sách bài hát</h2>
                        </div>
                        <span class="count-chip">${albumSongTotalCount} bài</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty albumSongs}">
                            <div class="empty-state">Album này chưa có bài hát nào.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="track-stack">
                                <c:forEach var="song" items="${albumSongs}" varStatus="loop">
                                    <article class="track-card">
                                        <div class="track-index">#${pageStartIndex + loop.index}</div>

                                        <div class="track-art">
                                            <c:choose>
                                                <c:when test="${not empty song.imagePath}">
                                                    <img src="${song.imagePath}" alt="${song.title}" class="track-thumb">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="${song.title}" class="track-thumb">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="track-copy">
                                            <h3 class="track-name">${song.title}</h3>
                                            <p class="track-artist">
                                                <c:forEach var="artist" items="${song.artists}" varStatus="loop2">
                                                    ${artist.name}<c:if test="${!loop2.last}">, </c:if>
                                                </c:forEach>
                                            </p>
                                            <p class="track-meta">
                                                <c:if test="${song.genre != null}">${song.genre.name}</c:if>
                                                <c:if test="${song.duration != null}"> · ${song.duration}s</c:if>
                                            </p>
                                        </div>

                                        <div class="track-tools">
                                            <audio controls preload="none" class="audio-preview">
                                                <source src="${pageContext.request.contextPath}/Audio/${song.filePath}" type="audio/mpeg">
                                                Trình duyệt của bạn không hỗ trợ phát nhạc.
                                            </audio>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                            <jsp:include page="includes/pagination.jsp" />
                        </c:otherwise>
                    </c:choose>
                </section>

                <aside class="album-side-panel">
                    <h3>Tổng quan</h3>
                    <div class="insight-list">
                        <div class="insight-item">
                            <span>Tên album</span>
                            <strong>${album.name}</strong>
                        </div>
                        <div class="insight-item">
                            <span>Phát hành</span>
                            <strong><c:out value="${album.releaseDate != null ? album.releaseDate.toLocalDate() : 'Chưa có'}" /></strong>
                        </div>
                        <div class="insight-item">
                            <span>Điểm bắt đầu</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty albumSongs}">${albumSongs[0].title}</c:when>
                                    <c:otherwise>Chưa có bài hát</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                    </div>
                </aside>
            </div>
        </main>
    </div>

    <jsp:include page="includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
