<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🎤 Nghệ sĩ</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Page CSS (scoped) -->
        <link href="${pageContext.request.contextPath}/CSS/top10-hidden-listOfArtists.css?v=1" rel="stylesheet">
    </head>

    <body class="dark-theme">
        <!-- HEADER -->
        <jsp:include page="includes/header.jsp" />

        <!-- MAIN (scoped so header/footer not affected) -->
        <main class="artist-page">
            <div class="container py-5">

                <!-- Top row: title + search + actions -->
                <div class="d-flex flex-wrap align-items-center gap-3 mb-4">
                    <h2 class="fw-bold text-light mb-0"><i class="bi bi-vinyl"></i> NGHỆ SĨ</h2>

                    <!-- search (kept compact) -->
                    <form method="get" action="ArtistController" class="ms-auto me-2 artist-search d-flex align-items-center">
                        <input type="text" name="keyword" class="search-box"
                               placeholder="🔍 Tìm nghệ sĩ..." value="<c:out value='${param.keyword}'/>" />
                        <input type="hidden" name="txtAction" value="search" />
                    </form>

                    <!-- actions -->
                    <div class="d-flex gap-2">
                        <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                            <a href="ArtistController?txtAction=callAdd" class="btn-action"><i class="bi bi-plus-circle"></i> Thêm</a>
                            <a href="ArtistController?txtAction=viewHiddenArtist" class="btn-action"><i class="bi bi-eye-slash"></i> Đã ẩn</a>
                        </c:if>
                        <a href="ArtistController?txtAction=top10" class="btn-action"><i class="bi bi-fire"></i> Top</a>
                    </div>
                </div>

                <!-- Grid of artists -->
                <div class="artist-grid">
                    <c:forEach var="artist" items="${listOfArtists}" varStatus="loop">
                        <article class="artist-card shadow-sm"
                                 role="button"
                                 onclick="location.href = 'ArtistController?txtAction=artistInfo&artistID=${artist.artistId}'"
                                 tabindex="0"
                                 onkeypress="if (event.key === 'Enter')
                                             location.href = 'ArtistController?txtAction=artistInfo&artistID=${artist.artistId}'">

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
                                <h5 class="artist-name mb-1">${artist.name}</h5>
                                <p class="artist-follow mb-1"><i class="bi bi-people-fill"></i> ${artist.followerCount} người yêu thích</p>
                            </div>
                        </article>
                    </c:forEach>
                </div>

                <!-- footer include -->
                <jsp:include page="includes/footer.jsp" />
            </div>
        </main>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
