<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Trang chủ - MyMusic</title>
  <!-- Bootstrap CSS CDN (hoặc copy vào static/css) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
</head>
<body>
  <%@ include file="/WEB-INF/views/includes/header.jsp" %>

  <main class="container mt-4">
    <h2>Bài hát nổi bật</h2>

    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
      <c:forEach var="song" items="${songs}">
        <div class="col">
          <div class="card h-100">
            <img src="${song.coverUrl}" class="card-img-top" alt="${song.title}" style="height:180px; object-fit:cover;">
            <div class="card-body d-flex flex-column">
              <h5 class="card-title mb-1">${song.title}</h5>
              <p class="card-text text-muted mb-2">${song.artist}</p>

              <div class="mt-auto d-flex justify-content-between align-items-center">
                <div>
                  <small class="text-muted">${song.duration}</small>
                </div>
                <div>
                  <button class="btn btn-sm btn-outline-primary play-btn"
                          data-audio="${song.audioUrl}"
                          data-title="${song.title}"
                          data-artist="${song.artist}"
                          data-cover="${song.coverUrl}"
                          data-songid="${song.id}">
                    ▶ Phát
                  </button>
                  <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/song/detail?id=${song.id}">Chi tiết</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/includes/footer.jsp" %>

  <!-- Scripts -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/static/js/player.js"></script>
</body>
</html>
