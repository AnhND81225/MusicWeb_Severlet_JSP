<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Danh sách thể loại</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    </head>
    <body class="bg-light">
        <jsp:include page="includes/header.jsp" />

        <div class="container mt-5">
            <form method="get" action="GenreController" class="row mb-4">
                <input type="hidden" name="txtAction" value="searchGenre"/>
                <div class="col-md-10">
                    <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm thể loại theo tên..."/>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">🔍 Tìm kiếm</button>
                </div>
            </form>

            <h2 class="mb-4">Danh sách thể loại</h2>

            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Hình ảnh</th>
                        <th>Nổi bật</th>
                        <th>Ẩn</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="genre" items="${listOfGenres}">
                        <tr class="${genre.hidden ? 'table-secondary' : ''}">
                            <td>${genre.genreId}</td>
                            <td>${genre.name}</td>
                            <td><img src="${genre.image}" alt="${genre.name}" width="100"/></td>
                            <td>${genre.featured ? "✔" : ""}</td>
                            <td>${genre.hidden ? "✔" : ""}</td>
                            <td>
                                <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                                    <c:choose>
                                        <c:when test="${!genre.hidden}">
                                            <a href="GenreController?txtAction=callUpdate&genreID=${genre.genreId}" class="btn btn-sm btn-warning">Sửa</a>
                                            <a href="GenreController?txtAction=hideGenre&genreID=${genre.genreId}" class="btn btn-sm btn-danger"
                                               onclick="return confirm('Bạn có chắc muốn ẩn thể loại này?')">Ẩn</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="GenreController?txtAction=restoreGenre&genreID=${genre.genreId}" class="btn btn-sm btn-success"
                                               onclick="return confirm('Bạn có chắc muốn khôi phục thể loại này?')">Khôi phục</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

      <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Artist'}">
                <a href="GenreController?txtAction=callAdd" class="btn btn-success">Thêm thể loại mới</a>
            </c:if>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
