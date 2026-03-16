<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Thể loại ẩn - miniZing</title>
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
                        <span class="eyebrow">Hidden genres</span>
                        <h1 class="hero-title">Thể loại ẩn</h1>
                        <p class="hero-copy">Bạn có thể restore nhanh trực tiếp từ card thay vì quay lại bảng quản trị cũ.</p>
                    </div>

                    <a href="GenreController?txtAction=viewGenre" class="pill-button">
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

                <div class="genre-grid">
                    <c:forEach var="genre" items="${listOfGenres}">
                        <article class="genre-card">
                            <div class="genre-cover">
                                <img src="${genre.image}" alt="${genre.name}"/>
                            </div>

                            <div class="genre-body">
                                <h3 class="genre-title">${genre.name}</h3>
                                <div class="genre-badges">
                                    <span class="genre-badge hidden">
                                        <i class="bi bi-eye-slash"></i>
                                        Đang ẩn
                                    </span>
                                </div>
                                <p class="genre-meta">ID thể loại: ${genre.genreId}</p>

                                <div class="genre-actions">
                                    <a href="GenreController?txtAction=restoreGenre&genreID=${genre.genreId}" class="page-action primary"
                                       onclick="return confirm('Bạn có chắc muốn khôi phục thể loại này?')">
                                        <i class="bi bi-arrow-clockwise"></i>
                                        <span>Khôi phục</span>
                                    </a>
                                </div>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty listOfGenres}">
                        <div class="empty-state">Không có thể loại nào đang bị ẩn.</div>
                    </c:if>
                </div>

                <jsp:include page="includes/pagination.jsp" />
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
