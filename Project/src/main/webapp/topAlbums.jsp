<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🎵 Top Albums</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap + Icons (single include) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Page CSS (use the album-page CSS we created earlier) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/album-page.css?v=1">
    </head>

    <body>
        <!-- header (inside body so CSS of main won't override it) -->
        <jsp:include page="includes/header.jsp" />

        <!-- main content (scoped class: album-page) -->
        <main class="album-page">
            <div class="container album-wrap py-4">
                <h1 class="album-title text-center mb-3">
                    <i class="bi bi-fire"></i> TOP ALBUMS
                </h1>

                <!-- Toolbar with Back button -->
                <div class="album-toolbar d-flex align-items-center mb-3">
                    <!-- Back to view album list -->
                    <a href="AlbumController?txtAction=viewAlbum" class="btn-action">
                        <i class="bi bi-arrow-left-circle"></i> Quay lại danh sách Album
                    </a>

                    <!-- optional space for other actions -->
                    <div class="ms-auto">
                        <!-- you can put other toolbar buttons here if needed -->
                    </div>
                </div>

                <div class="album-grid">
                    <c:forEach var="stat" items="${topAlbums}">
                        <article class="album-card" aria-label="${stat.album.name}">
                            <a class="album-link" href="AlbumController?txtAction=viewDetail&albumID=${stat.album.albumId}">
                                <div class="album-cover">
                                    <c:choose>
                                        <c:when test="${not empty stat.album.coverImage}">
                                            <img src="${stat.album.coverImage}" alt="${stat.album.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-cover">Không có ảnh</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="album-info">
                                    <h3 class="album-name">${stat.album.name}</h3>
                                    <p class="album-meta mb-2">
                                        <span>Nghệ sĩ: <c:out value="${stat.album.artist != null ? stat.album.artist.name : '—'}"/></span><br>
                                        <span>Thể loại: <c:out value="${stat.album.genre != null ? stat.album.genre.name : '—'}"/></span><br>
                                        <span>Phát hành: <c:out value="${stat.album.releaseDate != null ? stat.album.releaseDate : 'Chưa có'}"/></span>
                                    </p>
                                    <p class="album-artist"><strong>Lượt nghe:</strong> ${stat.totalPlayCount}</p>
                                </div>
                            </a>

                            <div class="album-buttons">
                                <a class="btn-edit" href="AlbumController?txtAction=viewDetail&albumID=${stat.album.albumId}" title="Xem chi tiết">
                                    <i class="bi bi-music-note-beamed"></i>
                                </a>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </div>
        </main>

        <!-- footer -->
        <jsp:include page="includes/footer.jsp" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
