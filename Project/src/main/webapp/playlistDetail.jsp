<%-- 
    Document   : playlistDetail
    Created on : 05-Nov-2025, 17:50:00
    Author     : phant
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🎧 Chi tiết Playlist</title>

        <!-- Bootstrap + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Use same CSS as playlist-addsong page to keep tone & background identical -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlistAddSong.css?v=1">
    </head>

    <body class="dark-theme">
        <!-- HEADER -->
        <jsp:include page="includes/header.jsp"/>

        <!-- MAIN (uses same root class as addSong to inherit background & styles) -->
        <main class="playlist-addsong">
            <div class="container">
                <h2><i class="bi bi-music-note-beamed"></i> Playlist: <span style="color:var(--accent-cyan); font-weight:800;">${playlist.name}</span></h2>

                <div class="mb-4 d-flex gap-2 flex-wrap">
                    <a href="PlaylistController?action=callAddSong&playlistId=${playlist.playlistId}" class="btn btn-green">
                        <i class="bi bi-plus-circle"></i> Thêm bài hát
                    </a>
                    <a href="PlaylistController?action=list" class="btn btn-outline-light ms-auto">
                        <i class="bi bi-arrow-left-circle"></i> Quay lại
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty songs}">
                        <!-- reuse song-list style from playlistAddSong page -->
                        <div class="song-list">
                            <c:forEach var="ps" items="${songs}">
                                <c:if test="${ps.song != null}">
                                    <label class="song-card" role="article" aria-label="${ps.song.title}">
                                        <input type="checkbox" class="song-checkbox" disabled>
                                        <img src="${ps.song.imagePath}" alt="${ps.song.title}" class="song-thumb">
                                        <div class="song-info">
                                            <h5 class="song-title">${ps.song.title}</h5>
                                            <p class="song-meta">${ps.song.album.name} · 
                                                <c:forEach var="artist" items="${ps.song.artists}" varStatus="st">
                                                    <c:out value="${artist.name}" />
                                                    <c:if test="${!st.last}">, </c:if>
                                                </c:forEach>
                                            </p>

                                            <audio controls class="audio-preview" preload="none">
                                                <source src="${pageContext.request.contextPath}/Audio/${ps.song.filePath}" type="audio/mpeg">
                                                Trình duyệt của bạn không hỗ trợ phát nhạc.
                                            </audio>
                                        </div>

                                        <div class="song-actions d-flex flex-column align-items-center">
                                            <a href="PlaylistController?action=removeSong&playlistId=${playlist.playlistId}&songId=${ps.song.songId}"
                                               class="btn btn-red" title="Xóa khỏi playlist" data-tooltip="Xóa khỏi playlist" aria-label="Xóa ${ps.song.title}">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </label>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="alert alert-info text-center">Playlist chưa có bài hát nào 🎶</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <!-- FOOTER -->
        <jsp:include page="includes/footer.jsp"/>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
