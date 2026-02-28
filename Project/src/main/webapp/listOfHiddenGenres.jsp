<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Danh sách thể loại ẩn</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <h2 class="mb-4">Danh sách thể loại đang ẩn</h2>

            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Hình ảnh</th>
                        <th>Nổi bật</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="genre" items="${listOfGenres}">
                        <tr class="table-secondary">
                            <td>${genre.genreId}</td>
                            <td>${genre.name}</td>
                            <td><img src="${genre.image}" alt="${genre.name}" width="100"/></td>
                            <td>
                                <a href="GenreController?txtAction=restoreGenre&genreID=${genre.genreId}" class="btn btn-sm btn-success"
                                   onclick="return confirm('Bạn có chắc muốn khôi phục thể loại này?')">Khôi phục</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <a href="GenreController?txtAction=viewGenre" class="btn btn-primary">Quay lại danh sách</a>
        </div>
    </body>
</html>
