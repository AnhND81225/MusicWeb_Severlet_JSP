<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🎵 Thông tin nghệ sĩ</title>

        <!-- Bootstrap + Icon -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- CSS giao diện nghệ sĩ -->
        <link href="${pageContext.request.contextPath}/CSS/artistInformation.css" rel="stylesheet">
    </head>

    <body class="dark-theme">

        <!-- 🌟 Header -->
        <jsp:include page="/includes/header.jsp" />

        <div class="container-artist">

            <!-- 👤 Thông tin nghệ sĩ -->
            <c:if test="${not empty artist}">
                <div class="artist-header">
                    <img src="<c:out value='${empty artist.image ? "https://maunailxinh.com/wp-content/uploads/2025/06/avatar-an-danh-1.jpg" : artist.image}'/>"
                         alt="${artist.name}" class="artist-avatar">

                    <div class="artist-info">
                        <h1 class="artist-name">${artist.name}</h1>
                        <p class="artist-followers"><i class="bi bi-people"></i> ${artist.followerCount} người quan tâm</p>

                        <!-- ✅ Logic hiển thị nút Quan tâm / Đang quan tâm -->
                        <c:choose>
                            <c:when test="${hasFollowed}">
                                <button type="button" class="btn btn-secondary" disabled>
                                    <i class="bi bi-person-check"></i> Đang quan tâm
                                </button>
                            </c:when>
                            <c:otherwise>
                                <form action="ArtistController" method="post" onsubmit="event.stopPropagation();">
                                    <input type="hidden" name="txtAction" value="follow">
                                    <input type="hidden" name="artistID" value="${artist.artistId}">
                                    <button type="submit" class="btn-blue">
                                        <i class="bi bi-person-plus"></i> Quan tâm
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
            <!-- sau khối artist-header (ngay trước phần "Bài hát nổi bật") -->
            <div class="artist-nav mt-3 mb-3">
                <!-- điều hướng về trang Top Artists (cập nhật txtAction nếu controller khác) -->
                <a href="ArtistController?txtAction=topArtists"
                   class="btn-back"
                   title="Quay lại Top Artists"
                   aria-label="Quay lại Top Artists">
                    <i class="bi bi-arrow-up-circle"></i> Top Nghệ Sĩ
                </a>
            </div>
            <!-- 🎧 Bài hát nổi bật -->
            <h3 class="section-title"><i class="bi bi-music-note-beamed"></i> Bài hát nổi bật</h3>

            <c:choose>
                <c:when test="${empty songs}">
                    <p class="text-muted">Không có bài hát nào liên quan.</p>
                </c:when>
                <c:otherwise>
                    <div class="song-list">
                        <c:forEach var="song" items="${songs}">
                            <div class="song-item">
                                <!-- Ảnh -->
                                <img src="<c:out value='${empty song.imagePath ? "/images/songs/default.jpg" : song.imagePath}'/>"
                                     alt="${song.title}" class="song-thumb">

                                <!-- Thông tin -->
                                <div class="song-info">
                                    <p class="song-title">${song.title}</p>
                                    <p class="song-artist">${artist.name}</p>
                                </div>

                                <!-- 🔊 Audio -->
                                <c:if test="${not empty song.filePath}">
                                    <div class="audio-box">
                                        <audio controls preload="none">
                                            <source src="${pageContext.request.contextPath}/Audio/${song.filePath}" type="audio/mpeg" />
                                            Trình duyệt của bạn không hỗ trợ phát nhạc.
                                        </audio>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 💿 Album liên quan -->
        <h3 class="section-title"><i class="bi bi-disc"></i> Album liên quan</h3>

        <c:choose>
            <c:when test="${empty albums}">
                <p class="text-muted">Không có album nào liên quan.</p>
            </c:when>
            <c:otherwise>
                <div class="album-list">
                    <c:forEach var="album" items="${albums}">
                        <div class="album-card">
                            <img src="<c:out value='${empty album.coverImage ? "/images/albums/default.jpg" : album.coverImage}'/>"
                                 alt="${album.name}" class="album-cover">

                            <h5 class="album-name">${album.name}</h5>
                            <p class="album-date"><i class="bi bi-calendar3"></i> ${album.releaseDate}</p>

                            <c:if test="${not empty album.songs}">
                                <button class="btn-blue small mt-2" onclick="playAlbum('${album.albumId}')">
                                    ▶ Phát toàn bộ
                                </button>

                                <div id="album-player-${album.albumId}" style="display:none;">
                                    <c:forEach var="song" items="${album.songs}">
                                        <p class="mb-1"><strong>${song.title}</strong></p>
                                        <div class="audio-box">
                                            <audio controls preload="none">
                                                <source src="${pageContext.request.contextPath}/Audio/${song.filePath}" type="audio/mpeg" />
                                                Trình duyệt của bạn không hỗ trợ phát nhạc.
                                            </audio>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 🔙 Quay lại -->
    <div class="text-center mt-5">
        <a href="ArtistController?txtAction=viewArtist" class="btn-back">
            <i class="bi bi-arrow-left-circle"></i> Quay lại danh sách
        </a>
    </div>

    <!-- 🌟 Footer -->
    <jsp:include page="/includes/footer.jsp" />

</div>

<!-- 🎵 Script phát toàn bộ album -->
<script>
    function playAlbum(albumId) {
        const container = document.getElementById('album-player-' + albumId);
        if (container) {
            container.style.display = 'block';
            const audios = container.querySelectorAll('audio');
            if (audios.length > 0) {
                audios[0].play();
                for (let i = 0; i < audios.length - 1; i++) {
                    audios[i].addEventListener('ended', () => audios[i + 1].play());
                }
            }
        }
    }
</script>

</body>
</html>
