<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🎧 Thêm bài hát vào Playlist</title>

        <!-- 🔗 Bootstrap + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlistAddSong.css?v=1">
    </head>

    <body class="dark-theme">

        <!-- ✅ HEADER -->
        <jsp:include page="includes/header.jsp"/>

        <!-- 🎶 MAIN -->
        <main class="playlist-addsong">
            <div class="container">
                <h2><i class="bi bi-music-note-list"></i> Thêm bài hát vào Playlist</h2>

                <form action="PlaylistController" method="post">
                    <input type="hidden" name="action" value="addSong"/>

                    <!-- Playlist chọn -->
                    <div class="mb-4">
                        <label>🎶 Chọn Playlist:</label>
                        <select name="playlistId" class="form-select" required>
                            <option value="">-- Chọn playlist --</option>
                            <c:forEach var="pl" items="${playlists}">
                                <option value="${pl.playlistId}" <c:if test="${pl.playlistId == playlistId}">selected</c:if>>
                                    ${pl.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Thanh tìm kiếm -->
                    <div class="search-bar">
                        <input type="text" id="songSearch" placeholder="🔍 Tìm bài hát...">
                        <div class="action-btns">
                            <button type="button" class="btn-icon" onclick="toggleAllSongs(true)" title="Chọn tất cả">
                                <i class="bi bi-check-all"></i>
                            </button>
                            <button type="button" class="btn-icon" onclick="toggleAllSongs(false)" title="Bỏ chọn">
                                <i class="bi bi-x-circle"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Danh sách bài hát -->
                    <div class="song-list" id="songList">
                        <c:forEach var="s" items="${songs}">
                            <label class="song-card">
                                <input type="checkbox" class="song-checkbox" name="songIds[]" value="${s.songId}">
                                <img src="${s.imagePath}" alt="${s.title}" class="song-thumb">
                                <div class="song-info">
                                    <h5 class="song-title">${s.title}</h5>
                                    <p class="song-meta">${s.duration} giây</p>
                                </div>
                            </label>
                        </c:forEach>
                    </div>

                    <!-- Nút -->
                    <div class="bottom-actions">
                        <button type="submit" class="btn btn-green"><i class="bi bi-plus-circle"></i> Thêm</button>
                        <a href="PlaylistController?action=list" class="btn btn-cyan"><i class="bi bi-arrow-left-circle"></i> Quay lại</a>
                    </div>
                </form>
            </div>
        </main>

        <!-- ✅ FOOTER -->
        <jsp:include page="includes/footer.jsp"/>

        <script>
            document.getElementById("songSearch").addEventListener("input", function () {
                const keyword = this.value.toLowerCase();
                document.querySelectorAll(".song-card").forEach(card => {
                    const text = card.textContent.toLowerCase();
                    card.style.display = text.includes(keyword) ? "flex" : "none";
                });
            });
            function toggleAllSongs(selectAll) {
                document.querySelectorAll(".song-checkbox").forEach(cb => cb.checked = selectAll);
            }
        </script>
    </body>
</html>
