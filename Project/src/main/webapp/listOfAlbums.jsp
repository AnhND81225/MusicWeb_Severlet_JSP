<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Albums - miniZing</title>
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
                        <span class="eyebrow">Albums</span>
                        <h1 class="hero-title">Danh mục album</h1>
                        <p class="hero-copy">
                            Tất cả album giờ nằm trong cùng một hệ visual với danh sách bài hát và player,
                            ưu tiên ảnh bìa, metadata chính và thao tác nhanh.
                        </p>
                    </div>

                    <div class="quick-stats">
                        <article class="stat-card">
                            <span>Total albums</span>
                            <strong>${totalItemsCount}</strong>
                        </article>
                    </div>
                </section>

                <div class="page-shell">
                    <c:if test="${not empty message}">
                        <div class="status-banner success">${message}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="status-banner error">${error}</div>
                    </c:if>

                    <div class="catalog-toolbar">
                        <form method="get" action="AlbumController" class="search-form">
                            <input type="hidden" name="txtAction" value="search" />
                            <div class="search-field">
                                <i class="bi bi-search"></i>
                                <input type="text" name="keyword" class="search-input"
                                       placeholder="Tìm album..."
                                       value="<c:out value='${param.keyword}'/>">
                            </div>
                            <button type="submit" class="ghost-button">Search</button>
                        </form>

                        <div class="action-group">
                            <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                <a href="AlbumController?txtAction=callAdd" class="page-action primary">
                                    <i class="bi bi-plus-lg"></i>
                                    <span>Thêm album</span>
                                </a>
                                <a href="AlbumController?txtAction=viewHidden" class="page-action">
                                    <i class="bi bi-eye-slash"></i>
                                    <span>Đã ẩn</span>
                                </a>
                            </c:if>
                            <a href="AlbumController?txtAction=sorted" class="page-action">
                                <i class="bi bi-calendar3"></i>
                                <span>Mới nhất</span>
                            </a>
                            <a href="AlbumController?txtAction=topAlbum" class="page-action">
                                <i class="bi bi-fire"></i>
                                <span>Top albums</span>
                            </a>
                        </div>
                    </div>

                    <div class="album-grid">
                        <c:forEach var="album" items="${listOfAlbums}">
                            <article class="album-card">
                                <a href="AlbumController?txtAction=viewSongs&albumId=${album.albumId}" class="album-link">
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
                                            <span>Thể loại: <c:out value="${album.genre != null ? album.genre.name : '—'}" /></span><br>
                                            <span>Phát hành: <c:out value="${album.releaseDate != null ? album.releaseDate.toLocalDate() : 'Chưa có'}" /></span>
                                        </p>
                                        <p class="album-artist">
                                            Nghệ sĩ: <c:out value="${album.artist != null ? album.artist.name : '—'}" />
                                        </p>
                                    </div>
                                </a>

                                <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                    <div class="album-buttons">
                                        <a href="AlbumController?txtAction=callUpdate&albumID=${album.albumId}" class="btn-edit" title="Sửa">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="AlbumController?txtAction=hideAlbum&albumID=${album.albumId}" class="btn-delete" title="Ẩn">
                                            <i class="bi bi-eye-slash"></i>
                                        </a>
                                    </div>
                                </c:if>
                            </article>
                        </c:forEach>

                        <c:if test="${empty listOfAlbums}">
                            <div class="empty-state">Chưa có album nào trong danh mục.</div>
                        </c:if>
                    </div>

                    <jsp:include page="includes/pagination.jsp" />
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
