<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Playlist đã ẩn - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlistList.css?v=2">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel playlist-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Hidden playlists</span>
                        <h1 class="hero-title">Playlist ẩn</h1>
                        <p class="hero-copy">Màn hình quản lý playlist ẩn đã được kéo về cùng layout card để thao tác restore dễ hơn.</p>
                    </div>

                    <a href="PlaylistController?action=list" class="pill-button">
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

                <div class="playlist-grid">
                    <c:forEach var="p" items="${playlists}">
                        <article class="playlist-card">
                            <div class="playlist-hero">
                                <i class="bi bi-eye-slash"></i>
                            </div>

                            <div>
                                <h5 class="playlist-title">${p.name}</h5>
                                <p class="playlist-summary">Khôi phục playlist để đưa nó quay lại danh sách phát chính và tiếp tục thêm bài hát.</p>
                            </div>

                            <div class="playlist-badges">
                                <c:if test="${p.isFavoriteList}">
                                    <span class="playlist-badge favorite">
                                        <i class="bi bi-heart-fill"></i>
                                        Yêu thích
                                    </span>
                                </c:if>
                                <span class="playlist-badge hidden">
                                    <i class="bi bi-eye-slash"></i>
                                    Đang ẩn
                                </span>
                            </div>

                            <div class="playlist-actions">
                                <a href="PlaylistController?action=view&id=${p.playlistId}" class="page-action">
                                    <i class="bi bi-eye"></i>
                                    <span>Xem</span>
                                </a>
                                <a href="PlaylistController?action=restore&id=${p.playlistId}" class="page-action primary">
                                    <i class="bi bi-arrow-clockwise"></i>
                                    <span>Khôi phục</span>
                                </a>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty playlists}">
                        <div class="empty-state">Không có playlist nào đang bị ẩn.</div>
                    </c:if>
                </div>

                <jsp:include page="includes/pagination.jsp" />
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
