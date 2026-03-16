<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Chi tiết playlist - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlist-detail.css?v=1">
    </head>

    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel playlist-detail-page">
                <section class="playlist-hero">
                    <div class="playlist-cover">
                        <i class="bi bi-vinyl-fill"></i>
                    </div>

                    <div class="playlist-copy">
                        <span class="eyebrow">Playlist detail</span>
                        <h1 class="hero-title">${playlist.name}</h1>
                        <p>
                            Mở từng track, nghe nhanh ngay trong danh sách và quản lý playlist trong cùng một màn hình.
                        </p>

                        <div class="detail-actions">
                            <a href="PlaylistController?action=callAddSong&playlistId=${playlist.playlistId}" class="pill-button">
                                <i class="bi bi-plus-circle"></i>
                                <span>Thêm bài hát</span>
                            </a>
                            <a href="PlaylistController?action=list" class="ghost-button">
                                <i class="bi bi-arrow-left-circle"></i>
                                <span>Quay lại</span>
                            </a>
                        </div>
                    </div>
                </section>

                <div class="detail-shell">
                    <section class="song-list">
                        <c:choose>
                            <c:when test="${not empty songs}">
                                <c:forEach var="ps" items="${songs}">
                                    <c:if test="${ps.song != null}">
                                        <article class="song-card">
                                            <c:choose>
                                                <c:when test="${not empty ps.song.imagePath}">
                                                    <img src="${ps.song.imagePath}" alt="${ps.song.title}" class="song-thumb">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="song-thumb placeholder">
                                                        <i class="bi bi-music-note"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="song-info">
                                                <h5 class="song-title">${ps.song.title}</h5>
                                                <p class="song-meta">
                                                    ${ps.song.album.name} ·
                                                    <c:forEach var="artist" items="${ps.song.artists}" varStatus="st">
                                                        <c:out value="${artist.name}" />
                                                        <c:if test="${!st.last}">, </c:if>
                                                    </c:forEach>
                                                </p>

                                                <audio controls class="audio-preview" preload="none">
                                                    <source src="${pageContext.request.contextPath}/Audio/${ps.song.filePath}" type="audio/mpeg">
                                                    Trình duyệt của bạn không hỗ trợ phát nhạc.
                                                </audio>
                                            </div>

                                            <div class="song-actions">
                                                <a href="PlaylistController?action=removeSong&playlistId=${playlist.playlistId}&songId=${ps.song.songId}"
                                                   class="ghost-button"
                                                   onclick="return confirm('Bạn có chắc muốn xóa bài hát này khỏi playlist?');">
                                                    <i class="bi bi-trash"></i>
                                                    <span>Xóa</span>
                                                </a>
                                            </div>
                                        </article>
                                    </c:if>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <div class="empty-state">Playlist chưa có bài hát nào. Hãy thêm track đầu tiên để bắt đầu.</div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <aside class="insight-panel">
                        <h3>Tổng quan</h3>
                        <div class="insight-list">
                            <div class="insight-item">
                                <span>Tên playlist</span>
                                <strong>${playlist.name}</strong>
                            </div>
                            <div class="insight-item">
                                <span>Số bài hát</span>
                                <strong>${fn:length(songs)}</strong>
                            </div>
                            <div class="insight-item">
                                <span>Hành động tiếp theo</span>
                                <strong>Thêm bài hát hoặc phát thử ngay</strong>
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
