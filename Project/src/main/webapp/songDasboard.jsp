<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard bài hát</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container py-4">
    <h2 class="mb-4 text-primary"><i class="bi bi-speedometer2"></i> MENU</h2>

    <div class="row g-4">
        <!-- 🎵 Bài hát -->
        <div class="col-md-6 col-lg-3">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-music-note-list"></i> Bài hát</h5>
                    <ul class="list-group list-group-flush">
                        <c:forEach var="song" items="${formData.songs}">
                            <li class="list-group-item">${song.title} <br><small class="text-muted">${song.genre.name}</small></li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 🎤 Nghệ sĩ -->
        <div class="col-md-6 col-lg-3">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-person-lines-fill"></i> Nghệ sĩ</h5>
                    <ul class="list-group list-group-flush">
                        <c:forEach var="artist" items="${formData.artists}">
                            <li class="list-group-item">${artist.name}</li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 💿 Album -->
        <div class="col-md-6 col-lg-3">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-disc-fill"></i> Album</h5>
                    <ul class="list-group list-group-flush">
                        <c:forEach var="album" items="${formData.albums}">
                            <li class="list-group-item">${album.name}</li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 🎶 Thể loại -->
        <div class="col-md-6 col-lg-3">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-tags-fill"></i> Thể loại</h5>
                    <ul class="list-group list-group-flush">
                        <c:forEach var="genre" items="${formData.genres}">
                            <li class="list-group-item">${genre.name}</li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>
