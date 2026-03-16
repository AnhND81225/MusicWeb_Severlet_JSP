<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><c:choose><c:when test="${update}">Chỉnh sửa bài hát</c:when><c:otherwise>Thêm bài hát</c:otherwise></c:choose> - miniZing</title>
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
                        <span class="eyebrow">Song form</span>
                        <h1 class="hero-title"><c:choose><c:when test="${update}">Chỉnh sửa bài hát</c:when><c:otherwise>Bài hát mới</c:otherwise></c:choose></h1>
                    </div>
                </section>

                <div class="admin-form-card">
                    <form action="SongController" method="post" class="admin-form">
                        <c:if test="${not empty message}"><div class="status-banner success">${message}</div></c:if>
                        <c:if test="${not empty error}"><div class="status-banner error">${error}</div></c:if>

                        <input type="hidden" name="action" value="${update ? 'updateSong' : 'addSong'}" />
                        <c:if test="${update}">
                            <input type="hidden" name="songId" value="${s.songId}" />
                            <input type="hidden" name="playCount" value="${s.playCount}" />
                        </c:if>

                        <div class="field-grid">
                            <div>
                                <label for="title">Tiêu đề</label>
                                <input type="text" id="title" name="title" value="${s.title != null ? s.title : ''}" required />
                            </div>
                            <div>
                                <label for="artistNames">Nghệ sĩ</label>
                                <c:set var="artistNames" value="" />
                                <c:forEach var="a" items="${s.artists}" varStatus="loop">
                                    <c:set var="artistNames" value="${artistNames}${a.name}${!loop.last ? ', ' : ''}" />
                                </c:forEach>
                                <input type="text" id="artistNames" name="artistNames" value="${artistNames}" placeholder="Ví dụ: Obito, HIEUTHUHAI" />
                            </div>
                        </div>

                        <div class="field-grid">
                            <div>
                                <label for="filePath">File nhạc</label>
                                <input list="audioFiles" id="filePath" name="filePath" value="${s.filePath != null ? s.filePath : ''}" placeholder="Tên file .mp3" required />
                                <datalist id="audioFiles">
                                    <c:forEach var="file" items="${audioFiles}">
                                        <option value="${file}"></option>
                                    </c:forEach>
                                </datalist>
                            </div>
                            <div>
                                <label for="imagePath">Ảnh bài hát</label>
                                <input type="text" id="imagePath" name="imagePath" value="${s.imagePath != null ? s.imagePath : ''}" placeholder="URL ảnh" />
                                <c:if test="${update && not empty s.imagePath}">
                                    <img src="${s.imagePath}" alt="Preview" class="song-image-preview" />
                                </c:if>
                            </div>
                        </div>

                        <div class="field-grid">
                            <div>
                                <label for="albumId">Album</label>
                                <select name="albumId" id="albumId" class="form-select">
                                    <option value="">-- Không có --</option>
                                    <c:forEach var="album" items="${listOfAlbums}">
                                        <option value="${album.albumId}" <c:if test="${s.album != null && s.album.albumId == album.albumId}">selected</c:if>>${album.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label for="genreId">Thể loại</label>
                                <select name="genreId" id="genreId" class="form-select" required>
                                    <option value="">-- Chọn thể loại --</option>
                                    <c:forEach var="genre" items="${listOfGenres}">
                                        <option value="${genre.genreId}" <c:if test="${s.genre != null && s.genre.genreId == genre.genreId}">selected</c:if>>${genre.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <label class="form-check">
                            <input type="checkbox" name="isFeatured" <c:if test="${s != null && s.featured}">checked</c:if> />
                            <span>Đánh dấu bài hát nổi bật</span>
                        </label>

                        <div class="form-actions">
                            <a href="SongController?action=viewSongs" class="ghost-button"><i class="bi bi-arrow-left-circle"></i><span>Quay lại</span></a>
                            <button type="submit" class="pill-button"><i class="bi bi-save"></i><span><c:choose><c:when test="${update}">Lưu thay đổi</c:when><c:otherwise>Thêm bài hát</c:otherwise></c:choose></span></button>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
