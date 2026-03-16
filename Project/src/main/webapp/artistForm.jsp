<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><c:choose><c:when test="${artist != null}">Chỉnh sửa nghệ sĩ</c:when><c:otherwise>Thêm nghệ sĩ</c:otherwise></c:choose> - miniZing</title>
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
                        <span class="eyebrow">Artist form</span>
                        <h1 class="hero-title"><c:choose><c:when test="${artist != null}">Chỉnh sửa nghệ sĩ</c:when><c:otherwise>Nghệ sĩ mới</c:otherwise></c:choose></h1>
                    </div>
                </section>

                <div class="admin-form-card">
                    <form action="ArtistController" method="post" class="admin-form">
                        <c:if test="${not empty error}"><div class="status-banner error">${error}</div></c:if>
                        <c:if test="${not empty message}"><div class="status-banner success">${message}</div></c:if>

                        <input type="hidden" name="txtAction" value="${artist != null ? 'updateArtist' : 'addArtist'}" />
                        <c:if test="${artist != null}">
                            <input type="hidden" name="artistID" value="${artist.artistId}" />
                        </c:if>

                        <div class="field-grid">
                            <div>
                                <label>Tên nghệ sĩ</label>
                                <input type="text" name="name" value="${artist.name}" required />
                            </div>
                            <div>
                                <label>Số người theo dõi</label>
                                <input type="number" name="followerCount" min="0" value="${artist != null ? artist.followerCount : 0}" required />
                            </div>
                        </div>

                        <div>
                            <label>Tiểu sử</label>
                            <textarea name="bio" rows="4">${artist.bio}</textarea>
                        </div>

                        <div>
                            <label>Ảnh đại diện</label>
                            <input type="text" name="image" value="${artist.image}" />
                        </div>

                        <label class="form-check">
                            <input type="checkbox" name="isPopular" <c:if test="${artist != null && artist.popular}">checked</c:if> />
                            <span>Đánh dấu nghệ sĩ phổ biến</span>
                        </label>

                        <div class="form-actions">
                            <a href="ArtistController?txtAction=viewArtist" class="ghost-button"><i class="bi bi-arrow-left-circle"></i><span>Quay lại</span></a>
                            <button type="submit" class="pill-button"><i class="bi bi-save"></i><span><c:choose><c:when test="${artist != null}">Lưu thay đổi</c:when><c:otherwise>Thêm nghệ sĩ</c:otherwise></c:choose></span></button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
