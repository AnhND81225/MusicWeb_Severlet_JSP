<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>🎧 ${song.title} - Đang phát</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/stylePlaySong.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    </head>

    <body class="play-container">
        <!-- 🎶 LAYOUT 2 CỘT: TRÁI (PHÁT + LIKE), PHẢI (BÌNH LUẬN) -->
        <div class="play-layout">

            <!-- 🕹️ CỘT TRÁI -->
            <div class="left-panel">
                <!-- 💿 KHUNG PHÁT NHẠC -->
                <div class="song-card">
                    <div class="cover-area">
                        <div class="wave-circle"></div>
                        <c:choose>
                            <c:when test="${not empty song.imagePath}">
                                <img src="${song.imagePath}" alt="${song.title}" class="cover-image" id="album-cover">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/Images/default-cover.jpg" alt="No Cover" class="cover-image" id="album-cover">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="song-info">
                        <h1 class="song-title">${song.title}</h1>
                        <p class="song-meta">
                            <c:if test="${not empty song.genre}">${song.genre.name}</c:if>
                            <c:if test="${not empty song.album}"> • ${song.album.name}</c:if>
                            </p>
                            <p class="song-artist">
                            <c:forEach var="artist" items="${song.artists}" varStatus="loop">
                                ${artist.name}<c:if test="${!loop.last}">, </c:if>
                            </c:forEach>
                        </p>
                    </div>

                    <div class="audio-box">
                        <c:choose>
                            <c:when test="${not empty song.filePath}">
                                <audio id="audio-player" controls autoplay>
                                    <source src="${pageContext.request.contextPath}/Audio/${song.filePath}" type="audio/mpeg">
                                    Trình duyệt của bạn không hỗ trợ phát nhạc.
                                </audio>
                            </c:when>
                            <c:otherwise>
                                <p>⚠️ Không tìm thấy file âm thanh cho bài hát này.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <a href="SongController?txtAction=viewSongs" class="back-btn">
                        <i class="bi bi-arrow-left-circle"></i> Quay lại danh sách
                    </a>
                </div>

                <!-- ❤️ KHUNG LƯỢT THÍCH -->
                <c:if test="${not empty song}">
                    <div class="like-section">
                        <h5 style="color:#dc3545; text-align:center;">❤️ Lượt thích</h5>
                        <p style="text-align:center;">
                            <strong>${likeCount}</strong> người đã thích bài hát này.
                        </p>

                        <!-- Nếu user đã đăng nhập -->
                        <c:if test="${sessionScope.user != null}">
                            <form action="${pageContext.request.contextPath}/like" method="post" style="text-align:center;">
                                <input type="hidden" name="userId" value="${sessionScope.user.userID}" />
                                <input type="hidden" name="songId" value="${song.songId}" />

                                <c:choose>
                                    <c:when test="${userLiked}">
                                        <button type="submit" class="btn btn-danger">💔 Bỏ thích</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" class="btn btn-outline-danger">❤️ Thích</button>
                                    </c:otherwise>
                                </c:choose>
                            </form>
                        </c:if>

                        <!-- Nếu user chưa đăng nhập -->
                        <c:if test="${sessionScope.user == null}">
                            <div class="alert alert-info mt-3 text-center">
                                Vui lòng <a href="login.jsp" class="text-primary fw-bold">đăng nhập</a> để thả tim bài hát này.
                            </div>
                        </c:if>
                    </div>
                </c:if>

            </div>

            <!-- 💬 CỘT PHẢI: BÌNH LUẬN -->
            <div class="right-panel">
                <div class="comment-section">
                    <jsp:include page="comment.jsp"/>
                </div>
            </div>
        </div>

        <!-- 💫 Hiệu ứng xoay ảnh -->
        <script>
            const audio = document.getElementById('audio-player');
            const cover = document.getElementById('album-cover');
            const wave = document.querySelector('.wave-circle');

            if (audio) {
                audio.addEventListener('play', () => {
                    cover.classList.add('rotate');
                    wave.classList.add('wave-active');
                });
                audio.addEventListener('pause', () => {
                    cover.classList.remove('rotate');
                    wave.classList.remove('wave-active');
                });
                audio.addEventListener('ended', () => {
                    cover.classList.remove('rotate');
                    wave.classList.remove('wave-active');
                });
            }
        </script>
    </body>
</html>
