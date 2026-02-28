<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${album.name} - Album</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/songOfAlbumStyle.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>

<body class="album-song-container">

    <!-- 🌟 HEADER ALBUM -->
    <div class="album-header">
        <div class="album-cover">
            <c:choose>
                <c:when test="${not empty album.coverImage}">
                    <img src="${album.coverImage}" alt="${album.name}">
                </c:when>
                <c:otherwise>
                    <div class="no-cover">Không có ảnh bìa</div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="album-info">
            <p class="album-meta">
                Album • 
                <c:out value="${album.releaseDate != null ? album.releaseDate.toLocalDate() : 'Chưa có'}" />
                • <c:out value="${albumSongs.size()}"/> bài hát
            </p>

            <h1 class="album-title">${album.name}</h1>

            <p class="album-artist">
                <i class="bi bi-person-circle"></i>
                <c:out value="${album.artist != null ? album.artist.name : 'Không xác định'}" />
            </p>
        </div>
    </div>

    <!-- 🎵 DANH SÁCH BÀI HÁT -->
    <div class="song-list">
        <div class="song-list-header">
            <span>#</span>
            <span>Tiêu đề</span>
            <span>Nghệ sĩ</span>
            <span>Nghe</span>
        </div>

        <c:forEach var="song" items="${albumSongs}" varStatus="loop">
            <div class="song-item">
                <span class="song-index">${loop.index + 1}</span>

                <div class="song-info">
                    <c:choose>
                        <c:when test="${not empty song.imagePath}">
                            <img src="${song.imagePath}" alt="${song.title}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/default_cover.png" alt="cover">
                        </c:otherwise>
                    </c:choose>

                    <span class="song-title">${song.title}</span>
                </div>

                <span class="song-artist">
                    <c:forEach var="artist" items="${song.artists}" varStatus="loop2">
                        ${artist.name}<c:if test="${!loop2.last}">, </c:if>
                    </c:forEach>
                </span>

                <!-- 🔊 AUDIO BOX -->
                <div class="song-action">
                    <div class="audio-box">
                        <audio controls preload="none">
                            <source src="${pageContext.request.contextPath}/Audio/${song.filePath}" type="audio/mpeg">
                            Trình duyệt của bạn không hỗ trợ phát nhạc.
                        </audio>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty albumSongs}">
            <p class="empty-msg">Album này chưa có bài hát nào 🎧</p>
        </c:if>
    </div>

    <!-- 🔙 Nút quay lại -->
    <div class="back-btn">
        <a href="AlbumController?txtAction=viewAlbum" class="btn-back">
            <i class="bi bi-arrow-left-circle"></i> Quay lại danh sách Album
        </a>
    </div>

</body>
</html>
