<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Kết quả tìm kiếm - ${keyword}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-light">
<jsp:include page="navbar.jsp"/>

<div class="container py-4">
    <h3>Kết quả tìm kiếm cho: "<c:out value="${keyword}"/>"</h3>
    <hr>

    <c:if test="${empty songs and empty artists and empty albums and empty genres}">
        <p>❌ Không tìm thấy kết quả phù hợp.</p>
    </c:if>

    <!-- BÀI HÁT -->
    <c:if test="${not empty songs}">
        <h4>🎵 Bài hát</h4>
        <ul class="list-group mb-4">
            <c:forEach var="s" items="${songs}">
                <li class="list-group-item bg-secondary text-white">
                    <a href="SongController?action=play&songId=${s.songId}" class="text-white">
                        ${s.title}
                    </a>
                    <small class="text-light"> - ${s.album != null ? s.album.name : "Chưa có album"}</small>
                </li>
            </c:forEach>
        </ul>
    </c:if>

    <!-- NGHỆ SĨ -->
    <c:if test="${not empty artists}">
        <h4>👩‍🎤 Nghệ sĩ</h4>
        <ul class="list-group mb-4">
            <c:forEach var="a" items="${artists}">
                <li class="list-group-item bg-secondary text-white">
                    <a href="ArtistController?txtAction=artistInfo&artistID=${a.artistId}" class="text-white">
                        ${a.name}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </c:if>

    <!-- ALBUM -->
    <c:if test="${not empty albums}">
        <h4>💿 Album</h4>
        <ul class="list-group mb-4">
            <c:forEach var="al" items="${albums}">
                <li class="list-group-item bg-secondary text-white">
                    <a href="AlbumController?txtAction=viewSongs&albumId=${al.albumId}" class="text-white">
                        ${al.name}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </c:if>

    <!-- THỂ LOẠI -->
    <c:if test="${not empty genres}">
        <h4>🎧 Thể loại</h4>
        <ul class="list-group">
            <c:forEach var="g" items="${genres}">
                <li class="list-group-item bg-secondary text-white">
                    ${g.name}
                </li>
            </c:forEach>
        </ul>
    </c:if>

</div>
</body>
</html>
