<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách bài hát - miniZing</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/header.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/footer.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/listOfSongs.css?v=2">
</head>
<body class="spotify-app">
    <c:set var="heroSong" value="${not empty listOfSongs ? listOfSongs[0] : null}" />
    <c:set var="unreadNotifications"
           value="${unreadNotifications != null ? unreadNotifications : sessionScope.unreadNotifications}" />
    <c:set var="unreadCount"
           value="${unreadCount != null ? unreadCount : sessionScope.unreadCount}" />

    <div class="app-shell">
        <jsp:include page="includes/header.jsp" />

        <div class="app-grid library-page">
            <aside class="left-rail">
                <div class="rail-brand">
                    <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="miniZing">
                    <div>
                        <strong>Danh sách bài hát</strong>
                        <span>${totalItemsCount} bài hát đang sẵn sàng</span>
                    </div>
                </div>

                <div class="rail-section">
                    <span class="rail-label">Khám phá</span>
                    <div class="rail-nav">
                        <a class="rail-link active" href="${pageContext.request.contextPath}/SongController?action=viewSongs">
                            <i class="bi bi-collection-play-fill"></i>
                            <span>All songs</span>
                        </a>
                        <a class="rail-link" href="${pageContext.request.contextPath}/SongController?action=topSongs">
                            <i class="bi bi-graph-up-arrow"></i>
                            <span>Top 10</span>
                        </a>
                        <a class="rail-link" href="${pageContext.request.contextPath}/PlaylistController?action=list">
                            <i class="bi bi-music-note-list"></i>
                            <span>Playlists</span>
                        </a>
                        <a class="rail-link" href="${pageContext.request.contextPath}/ArtistController?txtAction=viewArtist">
                            <i class="bi bi-person-badge"></i>
                            <span>Artists</span>
                        </a>
                    </div>
                </div>

                <div class="rail-section">
                    <span class="rail-label">Quick picks</span>
                    <div class="rail-playlists">
                        <c:choose>
                            <c:when test="${not empty userPlaylists}">
                                <c:forEach var="playlist" items="${userPlaylists}" begin="0" end="4">
                                    <a class="playlist-pill" href="${pageContext.request.contextPath}/PlaylistController?action=view&id=${playlist.playlistId}">
                                        <span class="playlist-meta">
                                            <span class="badge-note">
                                                <c:choose>
                                                    <c:when test="${playlist.isFavoriteList}">★</c:when>
                                                    <c:otherwise>♪</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span>${playlist.name}</span>
                                        </span>
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    Chưa có playlist cá nhân. Hãy bắt đầu bằng việc thêm bài hát đầu tiên.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </aside>

            <main class="content-panel">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Songs</span>
                        <h1 class="hero-title">Danh sách bài hát</h1>
                        <p class="hero-copy">
                            Giao diện mới tập trung vào thói quen nghe nhạc: mở bài nhanh, xem playlist cá nhân,
                            theo dõi thông báo và quản lý danh sách phát theo cách gọn gàng, hiện đại.
                        </p>
                    </div>

                    <div class="header-actions">
                        <a href="${pageContext.request.contextPath}/SongController?action=topSongs" class="pill-button">
                            <i class="bi bi-play-fill"></i>
                            <span>Play trending</span>
                        </a>
                        <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                            <a href="${pageContext.request.contextPath}/SongController?action=callAdd" class="ghost-button">
                                <i class="bi bi-plus-lg"></i>
                                <span>Thêm bài hát</span>
                            </a>
                        </c:if>
                    </div>
                </section>

                <div class="quick-stats">
                    <article class="stat-card">
                        <span>Tracks</span>
                        <strong>${totalItemsCount}</strong>
                    </article>
                    <article class="stat-card">
                        <span>Playlists</span>
                        <strong>${fn:length(userPlaylists)}</strong>
                    </article>
                    <article class="stat-card">
                        <span>Unread alerts</span>
                        <strong>${empty unreadCount ? 0 : unreadCount}</strong>
                    </article>
                </div>

                <div class="panel-grid">
                    <section>
                        <div class="toolbar-row">
                            <form method="get" action="SongController" class="search-bar">
                                <input type="hidden" name="action" value="search" />
                                <div class="search-input-wrap">
                                    <i class="bi bi-search"></i>
                                    <input type="text" name="keyword" class="search-input"
                                           placeholder="Tìm bài hát, nghệ sĩ hoặc thể loại..."
                                           value="<c:out value='${searchKeyword}'/>" />
                                </div>
                                <button type="submit" class="ghost-button">Search</button>
                            </form>

                            <div class="toolbar-actions">
                                <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                    <a href="${pageContext.request.contextPath}/SongController?action=viewHiddenSongs" class="filter-chip">
                                        <i class="bi bi-eye-slash"></i>
                                        <span>Bài hát ẩn</span>
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/MainController" class="filter-chip">
                                    <i class="bi bi-grid-fill"></i>
                                    <span>Dashboard</span>
                                </a>
                            </div>
                        </div>

                        <c:if test="${not empty message}">
                            <div class="status-banner success">${message}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="status-banner error">${error}</div>
                        </c:if>

                        <section class="song-list">
                            <c:forEach var="song" items="${listOfSongs}" varStatus="loop">
                                <article class="song-card">
                                    <div class="song-rank">
                                        <span>#${pageStartIndex + loop.index}</span>
                                    </div>

                                    <div class="song-cover-area">
                                        <img src="${empty song.imagePath ? pageContext.request.contextPath.concat('/Image/logo.PNG') : song.imagePath}" alt="cover" class="song-cover" />
                                        <a href="SongController?action=play&songId=${song.songId}" class="cover-play">
                                            <i class="bi bi-play-fill"></i>
                                        </a>
                                    </div>

                                    <div class="song-info">
                                        <div class="song-main">
                                            <p class="song-title">${song.title}</p>
                                            <p class="song-meta">
                                                <c:forEach var="artist" items="${song.artists}" varStatus="artistLoop">
                                                    ${artist.name}<c:if test="${!artistLoop.last}">, </c:if>
                                                </c:forEach>
                                            </p>
                                        </div>
                                        <div class="song-submeta">
                                            <span>${song.genre.name}</span>
                                            <span>${song.album.name}</span>
                                            <span>${song.duration}s</span>
                                        </div>
                                    </div>

                                    <div class="song-actions">
                                        <span class="song-plays">
                                            <i class="bi bi-headphones"></i>
                                            ${song.playCount}
                                        </span>

                                        <div class="song-btns">
                                            <a href="SongController?action=play&songId=${song.songId}" class="icon-action primary" title="Phát">
                                                <i class="bi bi-play-fill"></i>
                                            </a>

                                            <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                                <a href="SongController?action=callUpdate&songId=${song.songId}" class="icon-action" title="Sửa">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>
                                                <a href="SongController?action=hideSong&songId=${song.songId}" class="icon-action danger" title="Ẩn">
                                                    <i class="bi bi-eye-slash"></i>
                                                </a>
                                            </c:if>

                                            <button type="button" class="icon-action" title="Thêm vào playlist"
                                                    onclick="openPlaylistModal('${song.songId}')">
                                                <i class="bi bi-plus-circle"></i>
                                            </button>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>

                            <c:if test="${empty listOfSongs}">
                                <div class="empty-state">
                                    Hiện chưa có bài hát nào để hiển thị.
                                </div>
                            </c:if>
                        </section>

                        <jsp:include page="includes/pagination.jsp" />
                    </section>

                    <aside class="mini-panel">
                        <h3 class="panel-title">Thông báo mới</h3>

                        <c:choose>
                            <c:when test="${not empty unreadNotifications}">
                                <div class="notification-list">
                                    <c:forEach var="n" items="${unreadNotifications}" begin="0" end="4">
                                        <article class="notice-card">
                                            <a href="${pageContext.request.contextPath}/SongController?action=play&songId=${n.song.songId}#comment-section"
                                               class="notice-link"
                                               onclick="markAsReadAndRedirect(${n.notificationId}, this.href); return false;">
                                                <span class="notice-dot"></span>
                                                <div>
                                                    <strong>${n.message}</strong>
                                                    <small>
                                                        <c:if test="${n.song != null}">${n.song.title} • </c:if>
                                                        ${n.createdAt}
                                                    </small>
                                                </div>
                                            </a>

                                            <form action="${pageContext.request.contextPath}/notification" method="post">
                                                <input type="hidden" name="action" value="hide">
                                                <input type="hidden" name="id" value="${n.notificationId}">
                                                <button type="submit" class="hide-notice"
                                                        onclick="return confirm('Bạn có chắc muốn xóa thông báo này không?');">
                                                    <i class="bi bi-x-lg"></i>
                                                </button>
                                            </form>
                                        </article>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">Chưa có thông báo mới. Mọi thứ đang rất yên tĩnh.</div>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${heroSong != null}">
                            <div class="hero-spotlight">
                                <span class="rail-label">Spotlight</span>
                                <img src="${empty heroSong.imagePath ? pageContext.request.contextPath.concat('/Image/logo.PNG') : heroSong.imagePath}" alt="${heroSong.title}">
                                <strong>${heroSong.title}</strong>
                                <small>
                                    <c:forEach var="artist" items="${heroSong.artists}" varStatus="artistLoop">
                                        ${artist.name}<c:if test="${!artistLoop.last}">, </c:if>
                                    </c:forEach>
                                </small>
                                <a href="SongController?action=play&songId=${heroSong.songId}" class="pill-button spotlight-button">
                                    <i class="bi bi-play-fill"></i>
                                    <span>Play now</span>
                                </a>
                            </div>
                        </c:if>
                    </aside>
                </div>

                <div id="playlistModal" class="modal-overlay">
                    <div class="modal-box">
                        <h3>Thêm bài hát vào playlist</h3>
                        <form action="PlaylistController" method="post">
                            <input type="hidden" name="action" value="addSong">
                            <input type="hidden" name="fromPage" value="listOfSongs">
                            <input type="hidden" name="songId" id="modalSongId">

                            <label for="playlistSelect">Chọn playlist</label>
                            <select name="playlistId" id="playlistSelect">
                                <c:forEach var="playlist" items="${userPlaylists}">
                                    <option value="${playlist.playlistId}">${playlist.name}</option>
                                </c:forEach>
                            </select>

                            <div class="modal-buttons">
                                <button type="submit" class="pill-button">Xác nhận</button>
                                <button type="button" class="ghost-button" onclick="closePlaylistModal()">Hủy</button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </div>

    <script>
        function openPlaylistModal(songId) {
            const modal = document.getElementById("playlistModal");
            const input = document.getElementById("modalSongId");
            input.value = songId;
            modal.classList.add("show");
        }

        function closePlaylistModal() {
            document.getElementById("playlistModal").classList.remove("show");
        }

        window.addEventListener("click", function (e) {
            const modal = document.getElementById("playlistModal");
            if (e.target === modal) {
                closePlaylistModal();
            }
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
