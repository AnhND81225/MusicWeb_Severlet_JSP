<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🎧 Danh sách Playlist</title>

        <!-- Bootstrap & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Page-specific CSS (scoped) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlistList.css?v=1">
    </head>

    <body>
        <!-- Site root wrapper (flexbox sticky footer friendly) -->
        <div class="site-root">
            <!-- header include -->
            <jsp:include page="includes/header.jsp" />

            <!-- main content (flex-grow to push footer down) -->
            <main class="content playlist-page">
                <div class="container playlist-container">
                    <h2 class="page-heading"><i class="bi bi-music-note-list"></i> Danh sách Playlist</h2>

                    <c:if test="${empty playlists}">
                        <div class="alert alert-info text-center">Bạn chưa có playlist nào 😕</div>
                    </c:if>

                    <div class="playlist-grid">
                        <c:forEach var="p" items="${playlists}">
                            <article class="playlist-card" role="article" aria-label="${p.name}">
                                <div class="playlist-info">
                                    <h5 class="playlist-title"><i class="bi bi-vinyl-fill"></i> <span>${p.name}</span></h5>
                                    <p class="playlist-meta">
                                        <c:if test="${p.isFavoriteList}">
                                            <span class="badge bg-cyan"><i class="bi bi-heart-fill"></i> Yêu thích</span>
                                        </c:if>
                                        <c:if test="${p.hidden}">
                                            <span class="badge bg-danger"><i class="bi bi-eye-slash"></i> Ẩn</span>
                                        </c:if>
                                    </p>
                                </div>

                                <div class="playlist-actions">
                                    <a href="PlaylistController?action=view&id=${p.playlistId}" class="btn btn-cyan" title="Xem">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="PlaylistController?action=callAddSong&playlistId=${p.playlistId}" class="btn btn-green" title="Thêm bài hát">
                                        <i class="bi bi-music-note-beamed"></i>
                                    </a>
                                    <a href="PlaylistController?action=delete&id=${p.playlistId}" class="btn btn-red" title="Xóa"
                                       onclick="return confirm('Bạn có chắc muốn xóa playlist này không?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </div>
                            </article>
                        </c:forEach>
                    </div>

                    <div class="playlist-actions-bottom">
                        <a href="playlistCreate.jsp" class="btn btn-green" title="Tạo playlist mới"><i class="bi bi-plus-circle"></i></a>
                        <a href="SongController?action=viewSongs" class="btn btn-cyan" title="Trang chủ"><i class="bi bi-house"></i></a>
                    </div>
                </div>
            </main>

            <!-- footer include -->
            <jsp:include page="includes/footer.jsp" />
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
