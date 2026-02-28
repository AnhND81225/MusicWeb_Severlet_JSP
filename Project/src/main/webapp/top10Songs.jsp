<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
    <head>
        <meta charset="UTF-8">
        <title>? Top 10 Bài Hát N?i B?t</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/top10-hidden-lisOfSongs.css?v=1">
    </head>

    <body class="dark-theme">
        <jsp:include page="includes/header.jsp" />
        <main class="music-container">
            <div class="container">
                <h2 class="page-title"><i class="bi bi-fire"></i>Top 10 bài hát nổi bật</h2>

                <section class="song-list">
                    <c:forEach var="song" items="${topSongs}" varStatus="loop">
                        <div class="song-card
                             <c:choose>
                                 <c:when test='${loop.index == 0}'>rank-1</c:when>
                                 <c:when test='${loop.index == 1}'>rank-2</c:when>
                                 <c:when test='${loop.index == 2}'>rank-3</c:when>
                             </c:choose>">

                            <!-- H?ng -->
                            <div class="rank-number">#${loop.index + 1}</div>

                            <!-- ?nh bìa -->
                            <div class="song-cover-area">
                                <img src="${song.imagePath}" alt="?nh bìa" class="song-cover">
                            </div>

                            <!-- Thông tin -->
                            <div class="song-info">
                                <h3 class="song-title">${song.title}</h3>
                                <p class="song-meta">
                                    ${song.genre.name} · ${song.album.name}<br/>
                                    <c:forEach var="artist" items="${song.artists}" varStatus="st">
                                        ${artist.name}<c:if test="${!st.last}">, </c:if>
                                    </c:forEach>
                                </p>
                            </div>

                            <!-- Audio + L??t nghe -->
                            <div class="song-actions">
                                <span class="song-plays"><i class="bi bi-play-circle"></i> ${song.playCount}</span>
                                <c:if test="${not empty song.filePath}">
                                    <div class="audio-player">
                                        <audio controls preload="none">
                                            <!-- ? ???ng d?n phát nh?c ?úng -->
                                            <source src="${pageContext.request.contextPath}/Audio/${song.filePath}" type="audio/mpeg">
                                            Trình duyệt của bạn không hỗ trợ phát nhạc
                                        </audio>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty topSongs}">
                        <p class="empty-msg">Không có bài hát</p>
                    </c:if>
                </section>

                <div style="text-align:center;margin-top:30px;">
                    <a href="SongController?action=viewSongs" class="btn danger">
                        <i class="bi bi-arrow-left-circle"></i> Quay lại danh sách bài hát
                    </a>
                </div>
            </div>
        </main>
        <jsp:include page="includes/footer.jsp" />

    </body>
</html>

