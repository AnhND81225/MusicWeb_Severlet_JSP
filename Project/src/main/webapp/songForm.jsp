<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
    <head>
        <title>
            <c:choose>
                <c:when test="${update}">✏️ Cập nhật bài hát</c:when>
                <c:otherwise>➕ Thêm bài hát mới</c:otherwise>
            </c:choose>
        </title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/addForm.css?v=1">
    </head>

    <body class="add-form-body">
        <div class="add-form-container">
            <form action="SongController" method="post" class="add-form">
                <h2 class="form-title">
                    <c:choose>
                        <c:when test="${update}">✏️ Cập nhật bài hát</c:when>
                        <c:otherwise>➕ Thêm bài hát mới</c:otherwise>
                    </c:choose>
                </h2>

                <!-- ✅ Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert error">${error}</div>
                </c:if>

                <!-- ✅ Dữ liệu ẩn -->
                <input type="hidden" name="action" value="${update ? 'updateSong' : 'addSong'}" />
                <c:if test="${update}">
                    <input type="hidden" name="songId" value="${s.songId}" />
                    <input type="hidden" name="playCount" value="${s.playCount}" />
                </c:if>

                <!-- 🎵 Tiêu đề -->
                <label for="title">Tiêu đề bài hát</label>
                <input type="text" id="title" name="title" value="${s.title != null ? s.title : ''}" required />

                <!-- 🎧 File nhạc -->
                <label for="filePath">Đường dẫn file nhạc</label>
                <input list="audioFiles" id="filePath" name="filePath"
                       class="form-input" value="${s.filePath != null ? s.filePath : ''}"
                       placeholder="Chọn hoặc nhập tên file .mp3" required />
                <datalist id="audioFiles">
                    <c:forEach var="file" items="${audioFiles}">
                        <option value="${file}"></option>
                    </c:forEach>
                </datalist>

                <!-- 🖼️ Ảnh bài hát -->
                <label for="imagePath">Đường dẫn ảnh bài hát</label>
                <input type="text" id="imagePath" name="imagePath"
                       value="${s.imagePath != null ? s.imagePath : ''}" placeholder="URL ảnh hoặc base64" />
                <c:if test="${update && not empty s.imagePath}">
                    <img src="${s.imagePath}" alt="Preview" class="song-image-preview" />
                </c:if>

                <!-- 💿 Album -->
                <label for="albumId">Album</label>
                <select name="albumId" id="albumId" class="form-select">
                    <option value="">-- Không có --</option>
                    <c:forEach var="album" items="${listOfAlbums}">
                        <option value="${album.albumId}"
                                <c:if test="${s.album != null && s.album.albumId == album.albumId}">selected</c:if>>
                            ${album.name}
                        </option>
                    </c:forEach>
                </select>

                <!-- 🎶 Thể loại -->
                <label for="genreId">Thể loại</label>
                <select name="genreId" id="genreId" class="form-select" required>
                    <option value="">-- Chọn thể loại --</option>
                    <c:forEach var="genre" items="${listOfGenres}">
                        <option value="${genre.genreId}"
                                <c:if test="${s.genre != null && s.genre.genreId == genre.genreId}">selected</c:if>>
                            ${genre.name}
                        </option>
                    </c:forEach>
                </select>

                <!-- 👥 Nghệ sĩ -->
                <label for="artistNames">Nghệ sĩ (cách nhau bởi dấu phẩy)</label>
                <c:set var="artistNames" value="" />
                <c:forEach var="a" items="${s.artists}" varStatus="loop">
                    <c:set var="artistNames" value="${artistNames}${a.name}${!loop.last ? ', ' : ''}" />
                </c:forEach>
                <input type="text" id="artistNames" name="artistNames"
                       value="${artistNames}" placeholder="Ví dụ: Obito, HIEUTHUHAI" />

                <!-- ⭐ Nổi bật -->
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="isFeatured" id="isFeatured"
                           <c:if test="${s != null && s.featured}">checked</c:if> />
                           <label class="form-check-label" for="isFeatured">
                               ⭐ Đánh dấu là bài hát nổi bật
                           </label>
                    </div>

                    <!-- 🔘 Nút hành động -->
                    <div class="form-actions">
                        <a href="SongController?action=viewSongs" class="btn btn-cancel">
                            ⬅️ Quay lại
                        </a>
                        <button type="submit" class="btn btn-submit">
                        <c:choose>
                            <c:when test="${update}">💾 Lưu thay đổi</c:when>
                            <c:otherwise>➕ Thêm bài hát</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </body>
</html>
