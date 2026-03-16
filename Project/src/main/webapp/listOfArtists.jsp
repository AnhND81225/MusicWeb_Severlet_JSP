<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Nghệ sĩ - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/top10-hidden-listOfArtists.css?v=2">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel artist-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Artists</span>
                        <h1 class="hero-title">Danh mục nghệ sĩ</h1>
                        <p class="hero-copy">
                            Theo dõi nghệ sĩ, khám phá profile và quản lý danh sách theo cùng một giao diện
                            tối giản, tập trung vào hình ảnh và hành động chính.
                        </p>
                    </div>

                    <div class="quick-stats">
                        <article class="stat-card">
                            <span>Total artists</span>
                            <strong>${totalItemsCount}</strong>
                        </article>
                    </div>
                </section>

                <div class="page-shell">
                    <div class="catalog-toolbar">
                        <form method="get" action="ArtistController" class="search-form">
                            <input type="hidden" name="txtAction" value="search" />
                            <div class="search-field">
                                <i class="bi bi-search"></i>
                                <input type="text" name="keyword" class="search-box"
                                       placeholder="Tìm nghệ sĩ..."
                                       value="<c:out value='${param.keyword}'/>" />
                            </div>
                            <button type="submit" class="ghost-button">Search</button>
                        </form>

                        <div class="action-group">
                            <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                <a href="ArtistController?txtAction=callAdd" class="btn-action primary">
                                    <i class="bi bi-plus-lg"></i>
                                    <span>Thêm nghệ sĩ</span>
                                </a>
                                <a href="ArtistController?txtAction=viewHiddenArtist" class="btn-action">
                                    <i class="bi bi-eye-slash"></i>
                                    <span>Đã ẩn</span>
                                </a>
                            </c:if>
                            <a href="ArtistController?txtAction=top10" class="btn-action">
                                <i class="bi bi-fire"></i>
                                <span>Top follow</span>
                            </a>
                        </div>
                    </div>

                    <div class="artist-grid">
                        <c:forEach var="artist" items="${listOfArtists}">
                            <article class="artist-card"
                                     role="button"
                                     onclick="location.href = 'ArtistController?txtAction=artistInfo&artistID=${artist.artistId}'"
                                     tabindex="0"
                                     onkeypress="if (event.key === 'Enter') location.href = 'ArtistController?txtAction=artistInfo&artistID=${artist.artistId}'">
                                <div class="artist-image-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty artist.image}">
                                            <img src="${artist.image}" alt="${artist.name}" class="artist-image" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/Image/avatar-default.png" alt="No Image" class="artist-image" />
                                        </c:otherwise>
                                    </c:choose>

                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                        <div class="artist-actions">
                                            <a href="ArtistController?txtAction=callUpdate&artistID=${artist.artistId}"
                                               class="action-btn edit" title="Sửa" onclick="event.stopPropagation();">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="ArtistController?txtAction=hideArtist&artistID=${artist.artistId}"
                                               class="action-btn delete" title="Ẩn" onclick="event.stopPropagation();">
                                                <i class="bi bi-eye-slash"></i>
                                            </a>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="artist-info">
                                    <h5 class="artist-name">${artist.name}</h5>
                                    <p class="artist-follow">
                                        <i class="bi bi-people-fill"></i>
                                        ${artist.followerCount} người yêu thích
                                    </p>
                                    <p class="artist-summary">
                                        Mở hồ sơ để xem danh sách bài hát, thông tin nghệ sĩ và các cập nhật liên quan.
                                    </p>
                                </div>
                            </article>
                        </c:forEach>

                        <c:if test="${empty listOfArtists}">
                            <div class="empty-state">Chưa có nghệ sĩ nào để hiển thị.</div>
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
