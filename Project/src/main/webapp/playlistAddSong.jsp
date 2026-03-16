<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Thêm bài hát vào playlist - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=3">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlistAddSong.css?v=2">
    </head>

    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp"/>

            <main class="content-panel playlist-addsong">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Playlist editor</span>
                        <h1 class="hero-title">Thêm bài hát</h1>
                        <p class="hero-copy">Chọn playlist, tìm track và thêm nhiều bài hát trong một lượt.</p>
                    </div>
                </section>

                <form action="PlaylistController" method="post">
                    <input type="hidden" name="action" value="addSong"/>

                    <div class="mb-4">
                        <label>Chọn playlist</label>
                        <select name="playlistId" class="form-select" required>
                            <option value="">-- Chọn playlist --</option>
                            <c:forEach var="pl" items="${playlists}">
                                <option value="${pl.playlistId}" <c:if test="${pl.playlistId == playlistId}">selected</c:if>>
                                    ${pl.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="search-bar">
                        <input type="text" id="songSearch" placeholder="Tìm bài hát...">
                        <div class="action-btns">
                            <button type="button" class="btn-icon" onclick="toggleAllSongs(true)" title="Chọn tất cả">
                                <i class="bi bi-check-all"></i>
                            </button>
                            <button type="button" class="btn-icon" onclick="toggleAllSongs(false)" title="Bỏ chọn">
                                <i class="bi bi-x-circle"></i>
                            </button>
                        </div>
                    </div>

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

                    <div class="bottom-actions">
                        <button type="submit" class="pill-button">
                            <i class="bi bi-plus-circle"></i>
                            <span>Thêm bài hát</span>
                        </button>
                        <a href="PlaylistController?action=list" class="ghost-button">
                            <i class="bi bi-arrow-left-circle"></i>
                            <span>Quay lại</span>
                        </a>
                    </div>
                </form>
            </main>
        </div>

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
