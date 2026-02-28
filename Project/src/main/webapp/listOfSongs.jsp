<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🎵 Danh sách bài hát</title>

        <!-- Bootstrap & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- CSS riêng của listOfSongs (scoped) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/listOfSongs.css?v=1">
    </head>

    <body>
        <jsp:include page="includes/header.jsp" />

        <!-- wrapper scoped cho trang danh sách bài hát -->
        <div class="list-songs-page">
            <!-- giữ class dark-theme nếu bạn muốn kế thừa một vài style chung,
                 nhưng tất cả style chính của trang này được scope vào .list-songs-page -->
            <div class="dark-theme">
                <div class="page-dark-cyan">
                    <!-- ====================================== -->
                    <!--   Notification Widget & Song List     -->
                    <!-- ====================================== -->
                    <main class="music-container">
                        <!-- 🔔 Notification Widget -->
                        <c:set var="unreadNotifications"
                               value="${unreadNotifications != null ? unreadNotifications : sessionScope.unreadNotifications}" />
                        <c:set var="unreadCount"
                               value="${unreadCount != null ? unreadCount : sessionScope.unreadCount}" />

                        <div class="notification-widget mt-4">
                            <h5 class="mb-3">
                                🔔 Thông báo gần đây
                                <c:if test="${unreadCount > 0}">
                                    <span class="badge bg-danger">${unreadCount}</span>
                                </c:if>
                            </h5>

                            <c:choose>
                                <c:when test="${not empty unreadNotifications}">
                                    <ul class="list-group list-group-flush">
                                        <c:forEach var="n" items="${unreadNotifications}" varStatus="loop" begin="0" end="4">
                                            <li class="notification-item">
                                                <a href="${pageContext.request.contextPath}/SongController?action=play&songId=${n.song.songId}#comment-section"
                                                   onclick="markAsReadAndRedirect(${n.notificationId}, this.href); return false;"
                                                   style="text-decoration:none; color:inherit; display:block;">
                                                    <small>
                                                        <b>${n.message}</b><br/>
                                                        <c:if test="${n.song != null}">
                                                            🎵 <span class="text-info">${n.song.title}</span><br/>
                                                        </c:if>
                                                        <span class="text-muted">${n.createdAt}</span>
                                                    </small>
                                                </a>
                                                <form action="${pageContext.request.contextPath}/notification" method="post" style="margin:0;">
                                                    <input type="hidden" name="action" value="hide">
                                                    <input type="hidden" name="id" value="${n.notificationId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger mt-1"
                                                            title="Xóa thông báo"
                                                            onclick="return confirm('Bạn có chắc muốn xóa thông báo này không?');">
                                                        ❌
                                                    </button>
                                                </form>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-secondary">Chưa có thông báo mới.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 🎶 Danh sách bài hát -->
                        <h2 class="page-title"><i class="bi bi-music-note-beamed"></i> Danh sách bài hát</h2>

                        <c:if test="${not empty message}">
                            <div class="alert success">${message}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert error">${error}</div>
                        </c:if>

                        <!-- THANH HÀNH ĐỘNG -->
                        <div class="action-bar">
                            <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                <a href="SongController?action=callAdd" class="btn primary"><i class="bi bi-plus-lg"></i> Thêm bài hát</a>
                                <a href="SongController?action=viewHiddenSongs" class="btn danger"><i class="bi bi-eye-slash"></i> Ẩn</a>
                            </c:if>
                            <a href="SongController?action=topSongs" class="btn warning"><i class="bi bi-fire"></i> Top 10</a>
                            <a href="MainController" class="btn home"><i class="bi bi-house-door-fill"></i> Trang chủ</a>
                        </div>

                        <!-- THANH TÌM KIẾM -->
                        <form method="get" action="SongController" class="search-bar">
                            <input type="hidden" name="action" value="search" />
                            <input type="text" name="keyword" class="search-input"
                                   placeholder="🔍 Tìm bài hát, nghệ sĩ hoặc thể loại..."
                                   value="<c:out value='${searchKeyword}'/>" />
                            <button type="submit" class="btn success"><i class="bi bi-search"></i> Tìm</button>
                        </form>

                        <!-- DANH SÁCH BÀI HÁT -->
                        <section class="song-list">
                            <c:forEach var="song" items="${listOfSongs}">
                                <div class="song-card">
                                    <div class="song-cover-area">
                                        <img src="${song.imagePath}" alt="cover" class="song-cover" />
                                    </div>

                                    <div class="song-info">
                                        <p class="song-title">${song.title}</p>
                                        <p class="song-meta">
                                            ${song.genre.name} · ${song.album.name}<br/>
                                            <c:forEach var="artist" items="${song.artists}">
                                                ${artist.name}
                                            </c:forEach>
                                        </p>
                                    </div>

                                    <div class="song-actions">
                                        <span class="song-plays"><i class="bi bi-headphones"></i> ${song.playCount}</span>
                                        <div class="song-btns">
                                            <a href="SongController?action=play&songId=${song.songId}" class="btn success btn-sm" title="Phát">
                                                <i class="bi bi-play-fill"></i>
                                            </a>

                                            <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                                <a href="SongController?action=callUpdate&songId=${song.songId}" class="btn warning btn-sm" title="Sửa">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>
                                                <a href="SongController?action=hideSong&songId=${song.songId}" class="btn danger btn-sm" title="Ẩn">
                                                    <i class="bi bi-eye-slash"></i>
                                                </a>
                                            </c:if>

                                            <button type="button" class="btn info btn-sm" title="Thêm vào playlist"
                                                    onclick="openPlaylistModal('${song.songId}')">
                                                <i class="bi bi-plus-circle"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty listOfSongs}">
                                <p class="empty-msg">Không có bài hát nào để hiển thị 🎧</p>
                            </c:if>
                        </section>

                        <!-- 🎧 MODAL CHỌN PLAYLIST -->
                        <div id="playlistModal" class="modal-overlay">
                            <div class="modal-box">
                                <h3>🎵 Thêm bài hát vào playlist</h3>
                                <form action="PlaylistController" method="post">
                                    <input type="hidden" name="action" value="addSong">
                                    <input type="hidden" name="fromPage" value="listOfSongs">
                                    <input type="hidden" name="songId" id="modalSongId">

                                    <label for="playlistSelect" style="font-weight:600; font-size:0.95rem;">Chọn playlist:</label>
                                    <select name="playlistId" id="playlistSelect">
                                        <c:forEach var="playlist" items="${userPlaylists}">
                                            <option value="${playlist.playlistId}">${playlist.name}</option>
                                        </c:forEach>
                                    </select>

                                    <div class="modal-buttons">
                                        <button type="submit" class="btn"><i class="bi bi-check2-circle"></i> Xác nhận</button>
                                        <button type="button" class="btn secondary-outline" onclick="closePlaylistModal()">
                                            <i class="bi bi-x-circle"></i> Hủy
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
        </div>

        <jsp:include page="includes/footer.jsp" />

        <!-- SCRIPT -->
        <script>
            function openPlaylistModal(songId) {
                const modal = document.getElementById("playlistModal");
                const input = document.getElementById("modalSongId");
                input.value = songId;
                modal.classList.add("show");
            }

            function closePlaylistModal() {
                const modal = document.getElementById("playlistModal");
                modal.classList.remove("show");
            }

            window.addEventListener("click", function (e) {
                const modal = document.getElementById("playlistModal");
                if (e.target === modal)
                    closePlaylistModal();
            });
        </script>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
