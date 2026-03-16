<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Playlists - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlistList.css?v=2">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel playlist-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Playlists</span>
                        <h1 class="hero-title">Bộ playlist</h1>
                        <p class="hero-copy">Playlist giờ có layout card rõ hơn, tách bạch hành động xem, thêm bài hát và quản lý trạng thái.</p>
                    </div>

                    <div class="quick-stats">
                        <article class="stat-card">
                            <span>Total playlists</span>
                            <strong>${totalItemsCount}</strong>
                        </article>
                    </div>
                </section>

                <div class="page-shell">
                    <c:if test="${not empty message}">
                        <div class="status-banner success">${message}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="status-banner error">${error}</div>
                    </c:if>

                    <c:if test="${empty playlists}">
                        <div class="empty-state">Bạn chưa có playlist nào. Tạo mới để bắt đầu gom nhạc theo ý thích.</div>
                    </c:if>

                    <div class="playlist-grid">
                        <c:forEach var="p" items="${playlists}">
                            <article class="playlist-card">
                                <div class="playlist-hero">
                                    <i class="bi bi-music-note-list"></i>
                                </div>

                                <div>
                                    <h5 class="playlist-title">${p.name}</h5>
                                    <p class="playlist-summary">Mở playlist để xem danh sách bài hát, phát ngay hoặc thêm track mới vào bộ sưu tập.</p>
                                </div>

                                <div class="playlist-badges">
                                    <c:if test="${p.isFavoriteList}">
                                        <span class="playlist-badge favorite">
                                            <i class="bi bi-heart-fill"></i>
                                            Yêu thích
                                        </span>
                                    </c:if>
                                    <c:if test="${p.hidden}">
                                        <span class="playlist-badge hidden">
                                            <i class="bi bi-eye-slash"></i>
                                            Ẩn
                                        </span>
                                    </c:if>
                                </div>

                                <div class="playlist-actions">
                                    <a href="PlaylistController?action=view&id=${p.playlistId}" class="page-action primary">
                                        <i class="bi bi-play-circle"></i>
                                        <span>Mở playlist</span>
                                    </a>
                                    <a href="PlaylistController?action=callAddSong&playlistId=${p.playlistId}" class="page-action">
                                        <i class="bi bi-plus-circle"></i>
                                        <span>Thêm bài hát</span>
                                    </a>
                                    <a href="PlaylistController?action=delete&id=${p.playlistId}" class="page-action danger"
                                       onclick="return confirm('Bạn có chắc muốn xóa playlist này không?')">
                                        <i class="bi bi-trash"></i>
                                        <span>Xóa</span>
                                    </a>
                                </div>
                            </article>
                        </c:forEach>
                    </div>

                    <jsp:include page="includes/pagination.jsp" />

                    <div class="playlist-actions-bottom">
                        <a href="playlistCreate.jsp" class="page-action primary">
                            <i class="bi bi-plus-lg"></i>
                            <span>Tạo playlist</span>
                        </a>
                        <a href="PlaylistController?action=hidden" class="page-action">
                            <i class="bi bi-eye-slash"></i>
                            <span>Playlist ẩn</span>
                        </a>
                        <a href="SongController?action=viewSongs" class="page-action">
                            <i class="bi bi-house"></i>
                            <span>Về bài hát</span>
                        </a>
                    </div>
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
