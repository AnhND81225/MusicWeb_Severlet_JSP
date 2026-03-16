<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Genres - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/genre-page.css?v=1">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel genre-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Genres</span>
                        <h1 class="hero-title">Danh mục thể loại</h1>
                        <p class="hero-copy">Danh sách thể loại đã được chuyển từ bảng cũ sang card grid để đồng bộ với phần album, artist và playlist.</p>
                    </div>
                </section>

                <c:if test="${not empty message}">
                    <div class="status-banner success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="status-banner error">${error}</div>
                </c:if>

                <div class="catalog-toolbar">
                    <form method="get" action="GenreController" class="search-form">
                        <input type="hidden" name="txtAction" value="searchGenre"/>
                        <div class="search-field">
                            <i class="bi bi-search"></i>
                            <input type="text" name="keyword" class="search-input" placeholder="Tìm kiếm thể loại theo tên..."/>
                        </div>
                        <button type="submit" class="ghost-button">Search</button>
                    </form>

                    <div class="action-group">
                        <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                            <a href="GenreController?txtAction=callAdd" class="page-action primary">
                                <i class="bi bi-plus-lg"></i>
                                <span>Thêm thể loại</span>
                            </a>
                        </c:if>
                        <a href="GenreController?txtAction=viewHiddenGenre" class="page-action">
                            <i class="bi bi-eye-slash"></i>
                            <span>Thể loại ẩn</span>
                        </a>
                    </div>
                </div>

                <div class="genre-grid">
                    <c:forEach var="genre" items="${listOfGenres}">
                        <article class="genre-card">
                            <div class="genre-cover">
                                <img src="${genre.image}" alt="${genre.name}"/>
                            </div>

                            <div class="genre-body">
                                <h3 class="genre-title">${genre.name}</h3>
                                <div class="genre-badges">
                                    <c:if test="${genre.featured}">
                                        <span class="genre-badge featured">
                                            <i class="bi bi-stars"></i>
                                            Nổi bật
                                        </span>
                                    </c:if>
                                    <c:if test="${genre.hidden}">
                                        <span class="genre-badge hidden">
                                            <i class="bi bi-eye-slash"></i>
                                            Ẩn
                                        </span>
                                    </c:if>
                                </div>

                                <p class="genre-meta">ID thể loại: ${genre.genreId}</p>

                                <div class="genre-actions">
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                        <c:choose>
                                            <c:when test="${!genre.hidden}">
                                                <a href="GenreController?txtAction=callUpdate&genreID=${genre.genreId}" class="page-action">
                                                    <i class="bi bi-pencil"></i>
                                                    <span>Sửa</span>
                                                </a>
                                                <a href="GenreController?txtAction=hideGenre&genreID=${genre.genreId}" class="page-action"
                                                   onclick="return confirm('Bạn có chắc muốn ẩn thể loại này?')">
                                                    <i class="bi bi-eye-slash"></i>
                                                    <span>Ẩn</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="GenreController?txtAction=restoreGenre&genreID=${genre.genreId}" class="page-action primary"
                                                   onclick="return confirm('Bạn có chắc muốn khôi phục thể loại này?')">
                                                    <i class="bi bi-arrow-clockwise"></i>
                                                    <span>Khôi phục</span>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </div>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty listOfGenres}">
                        <div class="empty-state">Chưa có thể loại nào để hiển thị.</div>
                    </c:if>
                </div>

                <jsp:include page="includes/pagination.jsp" />
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
