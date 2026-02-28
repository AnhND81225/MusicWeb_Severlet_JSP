<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <meta charset="UTF-8">
        <title>❌ Danh sách bài hát ẩn</title>

        <!-- Giao diện chung -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/top10-hidden-lisOfSongs.css?v=1">
    </head>

    <body class="dark-theme">
        <jsp:include page="includes/header.jsp" />
        <main class="music-container mt-0">

            <div class="container">
                <h2 class="page-title"><i class="bi bi-eye-slash"></i> Danh sách bài hát đã ẩn</h2>

                <!-- Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert error">${error}</div>
                </c:if>

                <!-- Danh sách bài hát ẩn -->
                <section class="song-list">
                    <c:forEach var="song" items="${listOfHiddenSongs}">
                        <div class="song-card song-hidden">
                            <!-- Ảnh bìa -->
                            <div class="song-cover-area">
                                <c:if test="${not empty song.imagePath}">
                                    <img src="${song.imagePath}" alt="Ảnh bài hát" class="song-cover">
                                </c:if>
                            </div>

                            <!-- Thông tin -->
                            <div class="song-info">
                                <h3 class="song-title">${song.title}</h3>
                                <p class="song-meta">
                                    ${song.genre.name} · ${song.album.name}<br/>
                                    <c:forEach var="artist" items="${song.artists}" varStatus="st">
                                        ${artist.name}<c:if test="${!st.last}">, </c:if>
                                    </c:forEach>
                                </p>
                                <p class="song-meta">
                                    <i class="bi bi-headphones"></i> ${song.playCount} lượt nghe
                                </p>
                            </div>

                            <div class="song-actions">
                                <a href="SongController?action=restoreSong&songId=${song.songId}"
                                   class="btn success btn-sm"
                                   style="display:inline-flex;align-items:center;gap:8px;
                                   background:linear-gradient(135deg,#4be1a2,#18c67a) !important;
                                   color:#04231a !important;
                                   padding:8px 12px !important;
                                   border-radius:10px !important;
                                   font-weight:800 !important;
                                   box-shadow:0 10px 26px rgba(24,150,90,0.12) !important;
                                   text-decoration:none !important;">
                                    <i class="bi bi-arrow-counterclockwise"></i> Khôi phục
                                </a>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty listOfHiddenSongs}">
                        <p class="empty-msg">Không có bài hát nào đang bị ẩn 🎧</p>
                    </c:if>
                </section>

                <!-- Nút quay lại -->
                <div style="text-align:center; margin-top:30px;">
                    <a href="SongController?action=viewSongs" class="btn danger">
                        <i class="bi bi-arrow-left-circle"></i> Quay lại danh sách bài hát
                    </a>
                </div>

            </div>
        </main>
        <jsp:include page="includes/footer.jsp" />

    </body>
</html>
