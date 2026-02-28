<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
    <title>
        <c:choose>
            <c:when test="${update}">✏️ Cập nhật Album</c:when>
            <c:otherwise>➕ Thêm Album</c:otherwise>
        </c:choose>
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/addForm.css">
</head>

<body class="add-form-body">
<div class="add-form-container">
    <form method="post" action="AlbumController" class="add-form">
        <h2 class="form-title">
            <c:choose>
                <c:when test="${update}">✏️ Cập nhật Album</c:when>
                <c:otherwise>➕ Thêm Album mới</c:otherwise>
            </c:choose>
        </h2>

        <c:if test="${not empty error}">
            <div class="alert error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert success">${message}</div>
        </c:if>

        <input type="hidden" name="txtAction" value="${update ? 'updateAlbum' : 'addAlbum'}" />
        <c:if test="${update}">
            <input type="hidden" name="albumID" value="${a.albumId}" />
        </c:if>

        <label>Tên Album</label>
        <input type="text" name="name" value="${a.name != null ? a.name : ''}" required />

        <label>Ngày phát hành</label>
        <input type="date" name="releaseDate" value="${releaseDateStr != null ? releaseDateStr : ''}" required />

        <label>Nghệ sĩ</label>
        <input type="text" name="artistName" value="${a.artist != null ? a.artist.name : ''}" required />

        <label>Thể loại</label>
        <select name="genreId" required>
            <option value="">-- Chọn thể loại --</option>
            <c:forEach var="g" items="${listOfGenres}">
                <option value="${g.genreId}" <c:if test="${a.genre != null && a.genre.genreId == g.genreId}">selected</c:if>>${g.name}</option>
            </c:forEach>
        </select>

        <label>Chọn bài hát cho album</label>
        <input type="text" id="songSearch" placeholder="🔍 Tìm bài hát..." />

        <div style="margin-top:8px;">
            <button type="button" class="btn btn-cancel" onclick="toggleAllSongs(true)">Chọn tất cả</button>
            <button type="button" class="btn btn-cancel" onclick="toggleAllSongs(false)">Bỏ chọn</button>
        </div>

        <div id="songList" style="margin-top:10px;">
            <c:forEach var="s" items="${listOfSongs}">
                <div class="form-check song-item">
                    <input class="form-check-input song-checkbox" type="checkbox" name="songIds[]" value="${s.songId}"
                           <c:if test="${not empty a.songs}">
                               <c:forEach var="song" items="${a.songs}">
                                   <c:if test="${song.songId == s.songId}">checked</c:if>
                               </c:forEach>
                           </c:if> />
                    <label class="form-check-label">
                        ${s.title} (${s.duration} giây)
                        <c:if test="${not empty s.imagePath}">
                            <img src="${s.imagePath}" class="song-image-preview" />
                        </c:if>
                    </label>
                </div>
            </c:forEach>
        </div>

        <label>Ảnh bìa (URL)</label>
        <input type="text" name="coverImage" value="${a.coverImage != null ? a.coverImage : ''}" />

        <div class="form-check">
            <input class="form-check-input" type="checkbox" name="isFeatured" id="isFeatured"
                   <c:if test="${a != null && a.featured}">checked</c:if> />
            <label class="form-check-label" for="isFeatured">🌟 Đánh dấu là Album nổi bật</label>
        </div>

        <div class="form-actions">
            <a href="AlbumController?txtAction=viewAlbum" class="btn btn-cancel">⬅️ Quay lại</a>
            <button type="submit" class="btn btn-submit">
                <c:choose>
                    <c:when test="${update}">💾 Lưu thay đổi</c:when>
                    <c:otherwise>➕ Thêm Album</c:otherwise>
                </c:choose>
            </button>
        </div>
    </form>
</div>

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
