<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Chi tiết nghệ sĩ - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/artistInformation.css?v=2">
    </head>
    <body class="spotify-app">
        <c:set var="songCount" value="${songTotalItemsCount}" />
        <c:set var="albumCount" value="${albumTotalItemsCount}" />

        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel artist-detail-page">
                <c:if test="${not empty artist}">
                    <section class="artist-hero">
                        <div class="artist-cover">
                            <c:choose>
                                <c:when test="${not empty artist.image}">
                                    <img src="${artist.image}" alt="${artist.name}" class="artist-avatar">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/Image/avatar-default.png" alt="${artist.name}" class="artist-avatar">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="artist-copy">
                            <span class="eyebrow">Artist</span>
                            <h1 class="hero-title">${artist.name}</h1>
                            <p class="artist-meta">
                                <i class="bi bi-people-fill"></i>
                                ${artist.followerCount} người quan tâm
                            </p>
                            <p class="hero-copy">
                                Hồ sơ nghệ sĩ được gom về cùng một bố cục rõ ràng hơn: bài hát ở trọng tâm,
                                album nằm thành cụm riêng và thao tác follow hoặc quay lại luôn xuất hiện ở vị trí dễ thấy.
                            </p>

                            <div class="hero-actions">
                                <a href="ArtistController?txtAction=viewArtist" class="ghost-button">
                                    <i class="bi bi-arrow-left-circle"></i>
                                    <span>Danh sách nghệ sĩ</span>
                                </a>
                                <a href="ArtistController?txtAction=top10" class="ghost-button">
                                    <i class="bi bi-fire"></i>
                                    <span>Top nghệ sĩ</span>
                                </a>

                                <c:choose>
                                    <c:when test="${hasFollowed}">
                                        <span class="follow-state followed">
                                            <i class="bi bi-person-check-fill"></i>
                                            <span>Đang quan tâm</span>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="ArtistController" method="post" class="follow-form">
                                            <input type="hidden" name="txtAction" value="follow">
                                            <input type="hidden" name="artistID" value="${artist.artistId}">
                                            <button type="submit" class="pill-button">
                                                <i class="bi bi-person-plus-fill"></i>
                                                <span>Quan tâm</span>
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </section>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="feedback-banner success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="feedback-banner error">${error}</div>
                </c:if>

                <div class="quick-stats artist-stats">
                    <article class="stat-card">
                        <span>Follower</span>
                        <strong>${artist.followerCount}</strong>
                    </article>
                    <article class="stat-card">
                        <span>Bài hát</span>
                        <strong>${songCount}</strong>
                    </article>
                    <article class="stat-card">
                        <span>Album</span>
                        <strong>${albumCount}</strong>
                    </article>
                </div>

                <div class="detail-layout">
                    <section class="content-block songs-block">
                        <div class="block-head">
                            <div>
                                <span class="section-kicker">Catalog</span>
                                <h2 class="section-title">Bài hát</h2>
                            </div>
                            <span class="count-chip">${songCount} bài</span>
                        </div>

                        <c:choose>
                            <c:when test="${empty songs}">
                                <div class="empty-state">Chưa có bài hát nào liên quan tới nghệ sĩ này.</div>
                            </c:when>
                            <c:otherwise>
                                <div class="song-stack">
                                    <c:forEach var="song" items="${songs}" varStatus="songLoop">
                                        <article class="song-row">
                                            <div class="song-thumb-wrap">
                                                <c:choose>
                                                    <c:when test="${not empty song.imagePath}">
                                                        <img src="${song.imagePath}" alt="${song.title}" class="song-thumb">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="${song.title}" class="song-thumb">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="song-body">
                                                <h3 class="song-name">${song.title}</h3>
                                                <p class="song-meta-line">
                                                    <c:if test="${song.genre != null}">${song.genre.name}</c:if>
                                                    <c:if test="${song.album != null}"> · ${song.album.name}</c:if>
                                                </p>
                                                <p class="song-submeta">
                                                    <i class="bi bi-mic-fill"></i>
                                                    <span>${artist.name}</span>
                                                </p>
                                            </div>

                                            <div class="song-tools">
                                                <span class="play-chip">
                                                    #${songPageStartIndex + songLoop.index}
                                                </span>
                                                <span class="play-chip">
                                                    <i class="bi bi-headphones"></i>
                                                    ${song.playCount}
                                                </span>
                                                <a href="SongController?action=play&songId=${song.songId}" class="pill-button small-button">
                                                    <i class="bi bi-play-fill"></i>
                                                    <span>Phát</span>
                                                </a>
                                            </div>
                                        </article>
                                    </c:forEach>
                                </div>
                                <c:set var="currentPage" value="${songCurrentPage}" scope="request" />
                                <c:set var="totalPages" value="${songTotalPages}" scope="request" />
                                <c:set var="totalItemsCount" value="${songTotalItemsCount}" scope="request" />
                                <c:set var="startPage" value="${songStartPage}" scope="request" />
                                <c:set var="endPage" value="${songEndPage}" scope="request" />
                                <c:set var="paginationBaseUrl" value="${songPaginationBaseUrl}" scope="request" />
                                <c:set var="paginationQuery" value="${songPaginationQuery}" scope="request" />
                                <c:set var="paginationPageParam" value="${songPaginationPageParam}" scope="request" />
                                <jsp:include page="includes/pagination.jsp" />
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <aside class="sidebar-stack">
                        <section class="side-card">
                            <h3>Tổng quan</h3>
                            <div class="insight-list">
                                <div class="insight-item">
                                    <span>Trạng thái</span>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${hasFollowed}">Đã theo dõi</c:when>
                                            <c:otherwise>Chưa theo dõi</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>
                                <div class="insight-item">
                                    <span>Nhạc nổi bật</span>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${songCount > 0}">${songs[0].title}</c:when>
                                            <c:otherwise>Chưa có dữ liệu</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>
                                <div class="insight-item">
                                    <span>Điểm nhấn</span>
                                    <strong>${albumCount} album, ${songCount} bài hát</strong>
                                </div>
                            </div>
                        </section>

                        <section class="side-card">
                            <h3>Điều hướng</h3>
                            <div class="nav-links">
                                <a href="ArtistController?txtAction=viewArtist" class="nav-link-card">
                                    <i class="bi bi-grid-fill"></i>
                                    <span>Danh mục nghệ sĩ</span>
                                </a>
                                <a href="ArtistController?txtAction=top10" class="nav-link-card">
                                    <i class="bi bi-bar-chart-fill"></i>
                                    <span>Bảng xếp hạng</span>
                                </a>
                                <a href="SongController?action=viewSongs" class="nav-link-card">
                                    <i class="bi bi-music-note-list"></i>
                                    <span>Danh sách bài hát</span>
                                </a>
                            </div>
                        </section>
                    </aside>
                </div>

                <section class="content-block albums-block">
                    <div class="block-head">
                        <div>
                            <span class="section-kicker">Discography</span>
                            <h2 class="section-title">Album</h2>
                        </div>
                        <span class="count-chip">${albumCount} mục</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty albums}">
                            <div class="empty-state">Chưa có album nào liên quan tới nghệ sĩ này.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="album-grid">
                                <c:forEach var="album" items="${albums}">
                                    <article class="album-card">
                                        <c:choose>
                                            <c:when test="${not empty album.coverImage}">
                                                <img src="${album.coverImage}" alt="${album.name}" class="album-cover">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/Image/logo.PNG" alt="${album.name}" class="album-cover">
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="album-copy">
                                            <h3 class="album-name">${album.name}</h3>
                                            <p class="album-meta">
                                                <i class="bi bi-calendar3"></i>
                                                <span>${album.releaseDate}</span>
                                            </p>
                                            <p class="album-summary">${fn:length(album.songs)} bài hát trong album này.</p>

                                            <c:if test="${not empty album.songs}">
                                                <div class="album-song-list">
                                                    <c:forEach var="albumSong" items="${album.songs}" begin="0" end="2">
                                                        <div class="album-song-row">
                                                            <span>${albumSong.title}</span>
                                                            <a href="SongController?action=play&songId=${albumSong.songId}">
                                                                <i class="bi bi-play-circle"></i>
                                                            </a>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                            <c:set var="currentPage" value="${albumCurrentPage}" scope="request" />
                            <c:set var="totalPages" value="${albumTotalPages}" scope="request" />
                            <c:set var="totalItemsCount" value="${albumTotalItemsCount}" scope="request" />
                            <c:set var="startPage" value="${albumStartPage}" scope="request" />
                            <c:set var="endPage" value="${albumEndPage}" scope="request" />
                            <c:set var="paginationBaseUrl" value="${albumPaginationBaseUrl}" scope="request" />
                            <c:set var="paginationQuery" value="${albumPaginationQuery}" scope="request" />
                            <c:set var="paginationPageParam" value="${albumPaginationPageParam}" scope="request" />
                            <jsp:include page="includes/pagination.jsp" />
                        </c:otherwise>
                    </c:choose>
                </section>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
