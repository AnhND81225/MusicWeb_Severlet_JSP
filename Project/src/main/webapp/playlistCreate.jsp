<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Tạo playlist - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=3">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlistList.css?v=3">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />

            <main class="content-panel playlist-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Playlist create</span>
                        <h1 class="hero-title">Playlist mới</h1>
                        <p class="hero-copy">Đặt tên playlist trước, sau đó thêm bài hát ở bước tiếp theo.</p>
                    </div>
                </section>

                <div class="data-card" style="max-width: 720px;">
                    <form action="PlaylistController" method="post" class="form-stack">
                        <input type="hidden" name="action" value="create">

                        <div>
                            <label for="playlistName" class="form-label">Tên playlist</label>
                            <input id="playlistName" name="playlistName" type="text" class="form-control" placeholder="Nhập tên playlist..." required>
                        </div>

                        <div class="toolbar-actions">
                            <button type="submit" class="page-action primary">
                                <i class="bi bi-check-circle"></i>
                                <span>Tạo playlist</span>
                            </button>
                            <a href="PlaylistController?action=list" class="page-action">
                                <i class="bi bi-arrow-left-circle"></i>
                                <span>Quay lại</span>
                            </a>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
