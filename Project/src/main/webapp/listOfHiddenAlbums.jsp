<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>👁️ Album đã ẩn</title>

        <!-- Bootstrap + Icons (duy nhất) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- CSS trang (đã tạo trước đó) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/top10-hidden-listOfAlbums.css?v=1">
    </head>

    <body>
        <!-- HEADER (phải nằm trong body) -->
        <jsp:include page="includes/header.jsp" />

        <div class="album-container">
            <main class="container py-4">
                <!-- 🌈 TIÊU ĐỀ -->
                <h1 class="album-title text-center mb-4">
                    <i class="bi bi-eye-slash"></i> ALBUM ĐÃ ẨN
                </h1>

                <!-- 🔔 THÔNG BÁO -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <!-- 📀 TOOLBAR -->
                <div class="album-toolbar mb-3">
                    <a href="AlbumController?txtAction=viewAlbum" class="btn-action">
                        ⬅️ Quay lại danh sách Album
                    </a>
                </div>

                <!-- bảng -->
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle shadow-lg"
                           style="background: rgba(255,255,255,0.05); border-radius: 12px; overflow: hidden;">
                        <thead style="background: linear-gradient(90deg,#007bff,#00c6ff); color:#fff;">
                            <tr>
                                <th>Tên Album</th>
                                <th>Nghệ sĩ</th>
                                <th>Thể loại</th>
                                <th>Ngày phát hành</th>
                                <th>Số bài hát</th>
                                <th>Ảnh bìa</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="album" items="${listOfAlbums}">
                                <tr>
                                    <td>${album.name}</td>
                                    <td><c:out value="${album.artist != null ? album.artist.name : '—'}"/></td>
                                    <td><c:out value="${album.genre != null ? album.genre.name : '—'}"/></td>
                                    <td><c:out value="${album.releaseDate != null ? album.releaseDate.toLocalDate() : 'Chưa có'}"/></td>
                                    <td><c:out value="${album.songs != null ? album.songs.size() : 0}"/></td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty album.coverImage}">
                                                <img src="${album.coverImage}" alt="Cover" class="img-thumbnail"
                                                     style="width:70px;height:70px;object-fit:cover;border:1px solid rgba(0,198,255,0.3);box-shadow:0 0 12px rgba(0,198,255,0.3);">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Không có ảnh</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="AlbumController?txtAction=restoreAlbum&albumID=${album.albumId}"
                                           class="btn-action">
                                            🔄 Khôi phục
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- FOOTER (đặt trong body, sau main) -->
        <jsp:include page="includes/footer.jsp" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
