<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><c:choose><c:when test="${genre != null}">Chỉnh sửa thể loại</c:when><c:otherwise>Thêm thể loại</c:otherwise></c:choose> - miniZing</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/spotify-shell.css?v=3">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/addForm.css?v=2">
    </head>
    <body class="spotify-app">
        <div class="app-shell">
            <jsp:include page="includes/header.jsp" />
            <main class="content-panel admin-form-page">
                <section class="section-header">
                    <div>
                        <span class="eyebrow">Genre form</span>
                        <h1 class="hero-title"><c:choose><c:when test="${genre != null}">Chỉnh sửa thể loại</c:when><c:otherwise>Thể loại mới</c:otherwise></c:choose></h1>
                    </div>
                </section>

                <div class="admin-form-card">
                    <form action="GenreController" method="post" class="admin-form">
                        <c:if test="${not empty error}"><div class="status-banner error">${error}</div></c:if>
                        <c:if test="${not empty message}"><div class="status-banner success">${message}</div></c:if>

                        <input type="hidden" name="txtAction" value="${genre != null ? 'updateGenre' : 'addGenre'}"/>
                        <c:if test="${genre != null}">
                            <input type="hidden" name="genreID" value="${genre.genreId}"/>
                        </c:if>

                        <div class="field-grid">
                            <div>
                                <label for="name">Tên thể loại</label>
                                <input type="text" id="name" name="name" value="${genre != null ? genre.name : ''}" required/>
                            </div>
                            <div>
                                <label for="image">Ảnh thể loại</label>
                                <input type="text" id="image" name="image" value="${genre != null ? genre.image : ''}" required/>
                            </div>
                        </div>

                        <label class="form-check">
                            <input type="checkbox" id="isFeatured" name="isFeatured" ${genre != null && genre.featured ? 'checked' : ''}/>
                            <span>Nổi bật</span>
                        </label>

                        <div class="form-actions">
                            <a href="GenreController?txtAction=viewGenre" class="ghost-button"><i class="bi bi-arrow-left-circle"></i><span>Quay lại</span></a>
                            <button type="submit" class="pill-button"><i class="bi bi-save"></i><span>${genre != null ? 'Cập nhật' : 'Thêm thể loại'}</span></button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
