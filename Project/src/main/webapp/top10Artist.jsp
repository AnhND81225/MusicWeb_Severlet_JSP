<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>🏆 Top 10 Nghệ Sĩ theo lượt Follow</title>

        <!-- Bootstrap + Icons (single include) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Page CSS scoped to artist page -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/top10-hidden-listOfArtists.css?v=1">
    </head>

    <body>
        <!-- header (inside body so main .artist-page won't override it) -->
        <jsp:include page="includes/header.jsp" />

        <!-- main content (scoped class .artist-page) -->
        <main class="artist-page">
            <div class="container py-5">
                <!-- toolbar / back button -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="page-heading mb-0">
                        <i class="bi bi-trophy-fill"></i> TOP 10 NGHỆ SĨ THEO LƯỢT FOLLOW
                    </h2>

                    <div class="ms-auto">
                        <a href="ArtistController?txtAction=viewArtist" class="btn-action">
                            <i class="bi bi-arrow-left-circle"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- grid of artists -->
                <div class="artist-grid">
                    <c:forEach var="artist" items="${topArtists}" varStatus="loop">
                        <article class="artist-card shadow-sm
                                 ${loop.index == 0 ? 'top-1' : (loop.index == 1 ? 'top-2' : (loop.index == 2 ? 'top-3' : ''))}"
                                 role="button"
                                 onclick="location.href = 'ArtistController?txtAction=artistInfo&artistID=${artist.artistId}'"
                                 tabindex="0"
                                 onkeypress="if (event.key === 'Enter')
                                             location.href = 'ArtistController?txtAction=artistInfo&artistID=${artist.artistId}'">

                            <c:if test="${loop.index < 10}">
                                <div class="top-badge">#${loop.index + 1}</div>
                            </c:if>

                            <div class="artist-image-wrapper">
                                <c:choose>
                                    <c:when test="${not empty artist.image}">
                                        <img src="${artist.image}" alt="${artist.name}" class="artist-image" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/Image/avatar-default.png"
                                             alt="ảnh mặc định" class="artist-image" />
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="artist-info">
                                <h5 class="artist-name mb-1">${artist.name}</h5>

                                <p class="artist-follow mb-3">
                                    <i class="bi bi-people-fill"></i>
                                    <c:choose>
                                        <c:when test="${artist.followerCount != null && artist.followerCount > 0}">
                                            ${artist.followerCount} người yêu thích
                                        </c:when>
                                        <c:otherwise>Chưa có người theo dõi</c:otherwise>
                                    </c:choose>
                                </p>

                                <a href="ArtistController?txtAction=artistInfo&artistID=${artist.artistId}"
                                   class="btn btn-action w-100 text-center">
                                    <i class="bi bi-eye"></i> Xem thông tin
                                </a>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </div>
        </main>

        <!-- footer -->
        <jsp:include page="includes/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
