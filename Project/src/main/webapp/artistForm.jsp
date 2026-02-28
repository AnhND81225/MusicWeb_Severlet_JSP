<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>
        <c:choose>
            <c:when test="${artist != null}">✏️ Cập nhật nghệ sĩ</c:when>
            <c:otherwise>➕ Thêm nghệ sĩ mới</c:otherwise>
        </c:choose>
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/addForm.css">
</head>

<body class="add-form-body">
<div class="add-form-container">
    <form action="ArtistController" method="post" class="add-form">
        <h2 class="form-title">
            <c:choose>
                <c:when test="${artist != null}">✏️ Cập nhật nghệ sĩ</c:when>
                <c:otherwise>➕ Thêm nghệ sĩ mới</c:otherwise>
            </c:choose>
        </h2>

        <c:if test="${not empty error}">
            <div class="alert error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert success">${message}</div>
        </c:if>

        <input type="hidden" name="txtAction" value="${artist != null ? 'updateArtist' : 'addArtist'}" />
        <c:if test="${artist != null}">
            <input type="hidden" name="artistID" value="${artist.artistId}" />
        </c:if>

        <label>Tên nghệ sĩ</label>
        <input type="text" name="name" value="${artist.name}" required />

        <label>Tiểu sử</label>
        <textarea name="bio" rows="4">${artist.bio}</textarea>

        <label>Ảnh đại diện (URL)</label>
        <input type="text" name="image" value="${artist.image}" />

        <label>Số người theo dõi</label>
        <input type="number" name="followerCount" min="0" value="${artist != null ? artist.followerCount : 0}" required />

        <div class="form-check">
            <input class="form-check-input" type="checkbox" name="isPopular" id="isPopular"
                   <c:if test="${artist != null && artist.popular}">checked</c:if> />
            <label class="form-check-label" for="isPopular">🌟 Đánh dấu là nghệ sĩ phổ biến</label>
        </div>

        <div class="form-actions">
            <a href="ArtistController?txtAction=viewArtist" class="btn btn-cancel">⬅️ Quay lại</a>
            <button type="submit" class="btn btn-submit">
                <c:choose>
                    <c:when test="${artist != null}">💾 Lưu thay đổi</c:when>
                    <c:otherwise>➕ Thêm mới</c:otherwise>
                </c:choose>
            </button>
        </div>
    </form>
</div>
</body>
</html>
