<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>🎭 Nghệ sĩ đã ẩn</title>

        <!-- Bootstrap + Icons (single include) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Page CSS (same as top10/listOfArtists) -->
        <link href="${pageContext.request.contextPath}/CSS/top10-hidden-listOfArtists.css?v=1" rel="stylesheet">
    </head>

    <body>
        <!-- HEADER (inside body) -->
        <jsp:include page="/includes/header.jsp" />

        <!-- MAIN (scoped) -->
        <main class="artist-page">
            <div class="container py-5">

                <!-- header row: title + back -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold text-light mb-0"><i class="bi bi-eye-slash"></i> NGHỆ SĨ ĐÃ ẨN</h2>
                    <a href="ArtistController?txtAction=viewArtist" class="btn-action">
                        <i class="bi bi-arrow-left-circle"></i> Quay lại danh sách
                    </a>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert success text-center mb-3">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert error text-center mb-3">${error}</div>
                </c:if>

                <!-- Grid nghệ sĩ -->
                <div class="artist-grid">
                    <c:forEach var="artist" items="${listOfArtists}">
                        <article class="artist-card shadow-sm" role="group" aria-label="${artist.name}">
                            <div class="artist-image-wrapper position-relative">
                                <c:choose>
                                    <c:when test="${not empty artist.image}">
                                        <img src="${artist.image}" alt="${artist.name}" class="artist-image">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/Image/avatar-default.png"
                                             alt="No Image" class="artist-image">
                                    </c:otherwise>
                                </c:choose>

                                <!-- small action icon on image (restore) -->
                                <div class="artist-actions">
                                    <a href="ArtistController?txtAction=restoreArtist&artistID=${artist.artistId}"
                                       class="action-btn edit" title="Khôi phục" aria-label="Khôi phục ${artist.name}">
                                        <i class="bi bi-arrow-clockwise"></i>
                                    </a>
                                </div>
                            </div>

                            <div class="artist-info">
                                <h5 class="artist-name mb-1">${artist.name}</h5>

                                <p class="artist-follow mb-2">
                                    <i class="bi bi-people"></i>
                                    <c:choose>
                                        <c:when test="${artist.followerCount != null && artist.followerCount > 0}">
                                            <span class="text-white">${artist.followerCount}</span> người theo dõi
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa có người theo dõi</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <a href="ArtistController?txtAction=restoreArtist&artistID=${artist.artistId}"
                                   class="btn-action small w-100 text-center" title="Khôi phục nghệ sĩ">
                                    <i class="bi bi-arrow-repeat"></i> Khôi phục nghệ sĩ
                                </a>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty listOfArtists}">
                        <div class="text-center text-muted py-5 w-100">
                            <i class="bi bi-person-x fs-1 d-block mb-2"></i>
                            Không có nghệ sĩ nào đã ẩn.
                        </div>
                    </c:if>
                </div>

            </div>
        </main>

        <!-- FOOTER -->
        <jsp:include page="/includes/footer.jsp" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
