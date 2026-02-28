<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>➕ Tạo Playlist mới</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Dùng cùng CSS với trang playlist list để đồng nhất tone -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playlistList.css?v=1">
        <!-- (Nếu bạn muốn CSS riêng, đổi thành playlistCreate.css và dán snippet CSS ở dưới) -->
    </head>
    <body>
        <div class="site-root"><!-- để tương thích sticky footer -->
            <jsp:include page="includes/header.jsp" />

            <!-- Sử dụng .playlist-page để kế thừa background / tone -->
            <main class="content playlist-page">
                <div class="container playlist-container" style="padding-top:24px;">
                    <h2 class="page-heading"><i class="bi bi-plus-circle"></i> Tạo Playlist mới</h2>

                    <!-- Form card: dùng class .form-card để áp style giống card trên playlistList -->
                    <div class="form-card" style="max-width:900px;">
                        <form action="PlaylistController" method="post" class="p-3">
                            <input type="hidden" name="action" value="create">
                            <div class="mb-3">
                                <label for="playlistName" class="form-label">Tên Playlist:</label>
                                <input id="playlistName" name="playlistName" type="text" class="form-control" placeholder="Nhập tên playlist...">
                            </div>

                            <div class="d-flex gap-3 align-items-center mt-3">
                                <button type="submit" class="btn btn-green"><i class="bi bi-check-circle"></i> Tạo</button>
                                <a href="PlaylistController?action=list" class="btn btn-outline-light"><i class="bi bi-arrow-left-circle"></i> Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>

            <jsp:include page="includes/footer.jsp" />
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
