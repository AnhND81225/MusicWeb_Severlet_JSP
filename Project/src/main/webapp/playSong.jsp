<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${song.title} - Đang phát</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/header.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/footer.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/stylePlaySong.css?v=2">
</head>
<body class="spotify-app">
    <div class="app-shell">
        <jsp:include page="includes/header.jsp" />

        <main class="player-page">
            <section class="player-hero">
                <div class="player-artwork">
                    <div class="glow-ring"></div>
                    <c:choose>
                        <c:when test="${not empty song.imagePath}">
                            <img src="${song.imagePath}" alt="${song.title}" class="cover-image" id="album-cover">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="${song.title}" class="cover-image" id="album-cover">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="player-meta-block">
                    <span class="eyebrow">Track</span>
                    <h1 class="track-title">${song.title}</h1>
                    <p class="track-context">
                        <c:if test="${not empty song.genre}">${song.genre.name}</c:if>
                        <c:if test="${not empty song.album}"> • ${song.album.name}</c:if>
                    </p>
                    <p class="track-artists">
                        <c:forEach var="artist" items="${song.artists}" varStatus="loop">
                            ${artist.name}<c:if test="${!loop.last}">, </c:if>
                        </c:forEach>
                    </p>

                    <div class="player-actions">
                        <a href="SongController?action=viewSongs" class="ghost-button">
                            <i class="bi bi-arrow-left"></i>
                            <span>Quay lại bài hát</span>
                        </a>
                        <a href="SongController?action=topSongs" class="ghost-button">
                            <i class="bi bi-fire"></i>
                            <span>Top songs</span>
                        </a>
                    </div>

                    <div class="audio-shell">
                        <c:choose>
                            <c:when test="${not empty song.filePath}">
                                <audio id="audio-player" controls autoplay>
                                    <source src="${pageContext.request.contextPath}/Audio/${song.filePath}" type="audio/mpeg">
                                    Trình duyệt của bạn không hỗ trợ phát nhạc.
                                </audio>
                            </c:when>
                            <c:otherwise>
                                <p>Không tìm thấy file âm thanh cho bài hát này.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="track-stats">
                        <div class="stat-card">
                            <span>Lượt thích</span>
                            <strong>${likeCount}</strong>
                        </div>
                        <div class="stat-card">
                            <span>Thể loại</span>
                            <strong><c:out value="${song.genre.name}" /></strong>
                        </div>
                        <div class="stat-card">
                            <span>Album</span>
                            <strong><c:out value="${song.album.name}" /></strong>
                        </div>
                    </div>
                </div>
            </section>

            <section class="player-grid">
                <article class="player-panel like-panel">
                    <div class="panel-head">
                        <h2>Yêu thích bài hát này</h2>
                        <span>Like & save</span>
                    </div>

                    <p class="panel-copy">
                        Thêm bài hát vào danh sách yêu thích để quay lại nhanh hơn trong những lần nghe tiếp theo.
                    </p>

                    <c:if test="${sessionScope.user != null}">
                        <form action="${pageContext.request.contextPath}/like" method="post" class="like-form">
                            <input type="hidden" name="userId" value="${sessionScope.user.userID}" />
                            <input type="hidden" name="songId" value="${song.songId}" />

                            <c:choose>
                                <c:when test="${userLiked}">
                                    <button type="submit" class="pill-button unlike">
                                        <i class="bi bi-heartbreak-fill"></i>
                                        <span>Bỏ thích</span>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="pill-button">
                                        <i class="bi bi-heart-fill"></i>
                                        <span>Thích bài hát</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </c:if>

                    <c:if test="${sessionScope.user == null}">
                        <div class="login-note">
                            Vui lòng <a href="login.jsp">đăng nhập</a> để thả tim và lưu bài hát này.
                        </div>
                    </c:if>
                </article>

                <article class="player-panel comment-panel" id="comment-section">
                    <div class="panel-head">
                        <h2>Bình luận</h2>
                        <span>Community</span>
                    </div>
                    <jsp:include page="comment.jsp"/>
                </article>
            </section>
        </main>

        <jsp:include page="includes/footer.jsp" />
    </div>

    <script>
        const audio = document.getElementById('audio-player');
        const cover = document.getElementById('album-cover');
        const glow = document.querySelector('.glow-ring');

        if (audio) {
            audio.addEventListener('play', () => {
                glow.classList.add('wave-active');
            });
            audio.addEventListener('pause', () => {
                glow.classList.remove('wave-active');
            });
            audio.addEventListener('ended', () => {
                glow.classList.remove('wave-active');
            });
        }
    </script>
</body>
</html>
