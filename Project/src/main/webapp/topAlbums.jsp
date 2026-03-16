<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Top albums - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/album-page.css?v=2">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel album-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Top albums</span>
                        <h1 class="hero-title">Bảng xếp hạng album</h1>
                        <p class="hero-copy">Bảng top được chuyển sang layout card để ưu tiên artwork và các chỉ số chính.</p>
                    </div>

                    <a href="AlbumController?txtAction=viewAlbum" class="pill-button">
                        <i class="bi bi-arrow-left-circle"></i>
                        <span>Quay lại danh sách</span>
                    </a>
                </section>

                <div class="album-grid">
                    <c:forEach var="stat" items="${topAlbums}">
                        <article class="album-card">
                            <a class="album-link" href="AlbumController?txtAction=viewSongs&albumId=${stat.album.albumId}">
                                <div class="album-cover">
                                    <c:choose>
                                        <c:when test="${not empty stat.album.coverImage}">
                                            <img src="${stat.album.coverImage}" alt="${stat.album.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-cover">Không có ảnh bìa</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="album-info">
                                    <span class="album-badge">
                                        <i class="bi bi-graph-up-arrow"></i>
                                        ${stat.totalPlayCount} lượt nghe
                                    </span>
                                    <h3 class="album-name">${stat.album.name}</h3>
                                    <p class="album-meta">
                                        Nghệ sĩ: <c:out value="${stat.album.artist != null ? stat.album.artist.name : '—'}"/><br>
                                        Thể loại: <c:out value="${stat.album.genre != null ? stat.album.genre.name : '—'}"/><br>
                                        Phát hành: <c:out value="${stat.album.releaseDate != null ? stat.album.releaseDate : 'Chưa có'}"/>
                                    </p>
                                </div>
                            </a>

                            <div class="album-buttons">
                                <a class="btn-edit" href="AlbumController?txtAction=viewSongs&albumId=${stat.album.albumId}" title="Xem chi tiết">
                                    <i class="bi bi-music-note-beamed"></i>
                                </a>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty topAlbums}">
                        <div class="empty-state">Chưa có dữ liệu nghe để xếp hạng album.</div>
                    </c:if>
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
