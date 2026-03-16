<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>🎧 MiniZing Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- 🔗 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

    <!-- 🟦 HEADER -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="adminDashboard.jsp">🎧 MiniZing Admin</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarAdmin">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarAdmin">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="AlbumController?txtAction=viewAlbum"><i class="bi bi-disc"></i> Album</a></li>
                    <li class="nav-item"><a class="nav-link" href="ArtistController?txtAction=viewArtist"><i class="bi bi-person-music"></i> Nghệ sĩ</a></li>
                    <li class="nav-item"><a class="nav-link" href="SongController?txtAction=viewSong"><i class="bi bi-music-note-list"></i> Bài hát</a></li>
                    <li class="nav-item"><a class="nav-link" href="GenreController?txtAction=viewGenre"><i class="bi bi-tags"></i> Thể loại</a></li>
                    <li class="nav-item"><a class="nav-link" href="UserController?txtAction=viewUser"><i class="bi bi-people"></i> Người dùng</a></li>
                    <li class="nav-item"><a class="nav-link text-warning" href="LogoutController"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 🔶 CONTENT -->
    <div class="container-fluid mt-4">
        <div class="row">
            <!-- 📁 Sidebar -->
            <aside class="col-md-3 col-lg-2 bg-white border-end p-3">
                <h5 class="text-secondary mb-3">Danh mục quản lý</h5>
                <div class="list-group list-group-flush">
                    <a href="AlbumController?txtAction=viewAlbum" class="list-group-item list-group-item-action">
                        <i class="bi bi-disc"></i> Quản lý Album
                    </a>
                    <a href="SongController?txtAction=viewSong" class="list-group-item list-group-item-action">
                        <i class="bi bi-music-note-beamed"></i> Quản lý Bài hát
                    </a>
                    <a href="ArtistController?txtAction=viewArtist" class="list-group-item list-group-item-action">
                        <i class="bi bi-person"></i> Quản lý Nghệ sĩ
                    </a>
                    <a href="GenreController?txtAction=viewGenre" class="list-group-item list-group-item-action">
                        <i class="bi bi-tags"></i> Quản lý Thể loại
                    </a>
                    <a href="UserController?txtAction=viewUser" class="list-group-item list-group-item-action">
                        <i class="bi bi-people"></i> Quản lý Người dùng
                    </a>    
                </div>
            </aside>

            <!-- 📊 Main Panel -->
            <main class="col-md-9 col-lg-10 px-4">
                <h3 class="mb-4 text-primary fw-bold">Bảng điều khiển</h3>

                <!-- 🔔 Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <!-- 🧩 Nội dung động -->
    <%-- <jsp:include page="/adminStats.jsp" /> --%>

            </main>
        </div>
    </div>

    <!-- 🧾 FOOTER -->
    <footer class="text-center mt-4 mb-3 text-muted">
        <hr>
        <p>&copy; 2025 Mini Zing Admin Panel. All rights reserved.</p>
    </footer>

    <!-- ⚙️ JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>
</html>
