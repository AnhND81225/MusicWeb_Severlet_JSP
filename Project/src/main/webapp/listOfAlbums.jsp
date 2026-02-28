<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🎵 Danh Sách Album</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Page CSS (self-contained, matches other pages) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/album-page.css?v=1">
    </head>

    <body>
        <!-- wrapper so footer can be sticky (if footer.css uses .site-root) -->
        <div class="site-root">
            <!-- header -->
            <jsp:include page="includes/header.jsp" />

            <!-- album page (scoped styles) -->
            <main class="album-page">
                <div class="container album-wrap py-4">
                    <h1 class="album-title"><i class="bi bi-disc-fill"></i> ALBUM</h1>

                    <c:if test="${not empty message}">
                        <div class="alert success">${message}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert error">${error}</div>
                    </c:if>

                    <div class="album-toolbar d-flex flex-wrap align-items-center gap-3 mb-3">
                        <form method="get" action="AlbumController" class="search-bar d-flex align-items-center">
                            <input type="text" name="keyword" class="form-control search-input" placeholder="🔍 Tìm album..."
                                   value="<c:out value='${param.txtKeyword}'/>">
                            <input type="hidden" name="txtAction" value="search"/>
                        </form>

                        <div class="album-actions ms-auto d-flex flex-wrap gap-2">
                            <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                <a href="AlbumController?txtAction=callAdd" class="btn btn-action"><i class="bi bi-plus-circle"></i> Thêm</a>
                                <a href="AlbumController?txtAction=viewHidden" class="btn btn-action"><i class="bi bi-eye-slash"></i> Đã ẩn</a>
                            </c:if>
                            <a href="AlbumController?txtAction=sorted" class="btn btn-action"><i class="bi bi-calendar3"></i> Mới</a>
                            <a href="AlbumController?txtAction=topAlbum" class="btn btn-action"><i class="bi bi-fire"></i> Top</a>
                        </div>
                    </div>

                    <div class="album-grid">
                        <c:forEach var="album" items="${listOfAlbums}">
                            <article class="album-card" aria-label="${album.name}">
                                <a href="AlbumController?txtAction=viewSongs&albumId=${album.albumId}" class="album-link d-flex">
                                    <div class="album-cover">
                                        <c:choose>
                                            <c:when test="${not empty album.coverImage}">
                                                <img src="${album.coverImage}" alt="${album.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-cover">Không có ảnh</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="album-info">
                                        <h3 class="album-name">${album.name}</h3>
                                        <p class="album-meta">
                                            <span><c:out value="${album.genre != null ? album.genre.name : '—'}" /></span> •
                                            <span><c:out value="${album.releaseDate != null ? album.releaseDate.toLocalDate() : 'Chưa có'}" /></span>
                                        </p>
                                        <p class="album-artist"><c:out value="${album.artist != null ? album.artist.name : '—'}" /></p>
                                    </div>
                                </a>

                                <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                    <div class="album-buttons">
                                        <a href="AlbumController?txtAction=callUpdate&albumID=${album.albumId}" class="btn-edit" title="Sửa"><i class="bi bi-pencil"></i></a>
                                        <a href="AlbumController?txtAction=hideAlbum&albumID=${album.albumId}" class="btn-delete" title="Ẩn"><i class="bi bi-trash"></i></a>
                                    </div>
                                </c:if>
                            </article>
                        </c:forEach>
                    </div>

                </div>
            </main>

            <!-- footer -->
            <jsp:include page="includes/footer.jsp" />
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
