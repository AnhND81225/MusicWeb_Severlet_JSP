<%-- 
    Document   : genreForm
    Created on : Nov 5, 2025, 2:38:08 AM
    Author     : ASUS
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thể loại</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">${genre != null ? "Cập nhật thể loại" : "Thêm thể loại mới"}</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form action="GenreController" method="post" class="card p-4 shadow-sm">
        <input type="hidden" name="txtAction" value="${genre != null ? 'updateGenre' : 'addGenre'}"/>
        <c:if test="${genre != null}">
            <input type="hidden" name="genreID" value="${genre.genreId}"/>
        </c:if>

        <div class="mb-3">
            <label for="name" class="form-label">Tên thể loại</label>
            <input type="text" class="form-control" id="name" name="name" value="${genre != null ? genre.name : ''}" required/>
        </div>

        <div class="mb-3">
            <label for="image" class="form-label">URL hình ảnh</label>
            <input type="text" class="form-control" id="image" name="image" value="${genre != null ? genre.image : ''}" required/>
        </div>

        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="isFeatured" name="isFeatured" ${genre != null && genre.featured ? 'checked' : ''}/>
            <label class="form-check-label" for="isFeatured">Nổi bật</label>
        </div>

        <button type="submit" class="btn btn-primary">${genre != null ? 'Cập nhật' : 'Thêm'}</button>
        <a href="GenreController?txtAction=viewGenre" class="btn btn-secondary ms-2">Quay lại</a>
    </form>
</div>
</body>
</html>

