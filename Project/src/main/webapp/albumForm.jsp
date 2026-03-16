<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><c:choose><c:when test="${update}">Chỉnh sửa album</c:when><c:otherwise>Thêm album</c:otherwise></c:choose> - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=3">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/addForm.css?v=2">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />
            <main class="content-panel admin-form-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Album form</span>
                        <h1 class="hero-title"><c:choose><c:when test="${update}">Chỉnh sửa album</c:when><c:otherwise>Album mới</c:otherwise></c:choose></h1>
                    </div>
                </section>

                <div class="admin-form-card">
                    <form method="post" action="AlbumController" class="admin-form">
                        <c:if test="${not empty error}"><div class="status-banner error">${error}</div></c:if>
                        <c:if test="${not empty message}"><div class="status-banner success">${message}</div></c:if>

                        <input type="hidden" name="txtAction" value="${update ? 'updateAlbum' : 'addAlbum'}" />
                        <c:if test="${update}">
                            <input type="hidden" name="albumID" value="${a.albumId}" />
                        </c:if>

                        <div class="field-grid">
                            <div>
                                <label>Tên album</label>
                                <input type="text" name="name" value="${a.name != null ? a.name : ''}" required />
                            </div>
                            <div>
                                <label>Ngày phát hành</label>
                                <input type="date" name="releaseDate" value="${releaseDateStr != null ? releaseDateStr : ''}" required />
                            </div>
                        </div>

                        <div class="field-grid">
                            <div>
                                <label>Nghệ sĩ</label>
                                <input type="text" name="artistName" value="${a.artist != null ? a.artist.name : ''}" required />
                            </div>
                            <div>
                                <label>Thể loại</label>
                                <select name="genreId" required>
                                    <option value="">-- Chọn thể loại --</option>
                                    <c:forEach var="g" items="${listOfGenres}">
                                        <option value="${g.genreId}" <c:if test="${a.genre != null && a.genre.genreId == g.genreId}">selected</c:if>>${g.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label>Tìm bài hát</label>
                            <input type="text" id="songSearch" placeholder="Tìm bài hát..." />
                        </div>

                        <div class="toolbar-actions">
                            <button type="button" class="ghost-button" onclick="toggleAllSongs(true)">Chọn tất cả</button>
                            <button type="button" class="ghost-button" onclick="toggleAllSongs(false)">Bỏ chọn</button>
                        </div>

                        <div id="songList" class="song-pick-list">
                            <c:forEach var="s" items="${listOfSongs}">
                                <label class="song-item">
                                    <input class="song-checkbox" type="checkbox" name="songIds[]" value="${s.songId}"
                                           <c:if test="${not empty a.songs}">
                                               <c:forEach var="song" items="${a.songs}">
                                                   <c:if test="${song.songId == s.songId}">checked</c:if>
                                               </c:forEach>
                                           </c:if> />
                                    <span>${s.title} (${s.duration} giây)</span>
                                </label>
                            </c:forEach>
                        </div>

                        <div>
                            <label>Ảnh bìa</label>
                            <input type="text" name="coverImage" value="${a.coverImage != null ? a.coverImage : ''}" />
                        </div>

                        <label class="form-check">
                            <input type="checkbox" name="isFeatured" <c:if test="${a != null && a.featured}">checked</c:if> />
                            <span>Đánh dấu album nổi bật</span>
                        </label>

                        <div class="form-actions">
                            <a href="AlbumController?txtAction=viewAlbum" class="ghost-button"><i class="bi bi-arrow-left-circle"></i><span>Quay lại</span></a>
                            <button type="submit" class="pill-button"><i class="bi bi-save"></i><span><c:choose><c:when test="${update}">Lưu thay đổi</c:when><c:otherwise>Thêm album</c:otherwise></c:choose></span></button>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />

        <script>
            document.getElementById("songSearch").addEventListener("input", function () {
                const keyword = this.value.toLowerCase();
                document.querySelectorAll(".song-item").forEach(item => {
                    const text = item.textContent.toLowerCase();
                    item.style.display = text.includes(keyword) ? "flex" : "none";
                });
            });
            function toggleAllSongs(selectAll) {
                document.querySelectorAll(".song-checkbox").forEach(cb => cb.checked = selectAll);
            }
        </script>
    </body>
</html>
