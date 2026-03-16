<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Album đã ẩn - miniZing</title>
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
                        <span class="eyebrow">Hidden albums</span>
                        <h1 class="hero-title">Album ẩn</h1>
                        <p class="hero-copy">Khu vực restore giờ dùng cùng ngôn ngữ thiết kế với các danh sách chính.</p>
                    </div>

                    <a href="AlbumController?txtAction=viewAlbum" class="pill-button">
                        <i class="bi bi-arrow-left-circle"></i>
                        <span>Quay lại danh sách</span>
                    </a>
                </section>

                <c:if test="${not empty message}">
                    <div class="status-banner success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="status-banner error">${error}</div>
                </c:if>

                <div class="album-grid">
                    <c:forEach var="album" items="${listOfAlbums}">
                        <article class="album-card">
                            <div class="album-link">
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
                                    <h3 class="album-name">${album.name}</h3>
                                    <p class="album-meta">
                                        Nghệ sĩ: <c:out value="${album.artist != null ? album.artist.name : '—'}"/><br>
                                        Thể loại: <c:out value="${album.genre != null ? album.genre.name : '—'}"/><br>
                                        Ngày phát hành: <c:out value="${album.releaseDate != null ? album.releaseDate.toLocalDate() : 'Chưa có'}"/>
                                    </p>
                                    <p class="album-artist">Số bài hát: <c:out value="${album.songs != null ? album.songs.size() : 0}"/></p>
                                </div>
                            </div>

                            <div class="album-buttons">
                                <a href="AlbumController?txtAction=restoreAlbum&albumID=${album.albumId}" class="page-action primary">
                                    <i class="bi bi-arrow-clockwise"></i>
                                    <span>Khôi phục</span>
                                </a>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty listOfAlbums}">
                        <div class="empty-state">Không có album nào đang bị ẩn.</div>
                    </c:if>
                </div>

                <jsp:include page="includes/pagination.jsp" />
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
