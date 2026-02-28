<%-- 
    Document   : lisOfHiddenPlaylists
    Created on : Nov 8, 2025, 1:21:35 AM
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Playlist</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="text-primary mb-4">🎵 Danh sách Playlist của bạn</h2>

    <!-- Hiển thị thông báo session -->
    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- Danh sách playlist thường -->
    <c:if test="${not empty playlists}">
        <table class="table table-bordered table-hover shadow-sm">
            <thead class="table-primary">
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Tên Playlist</th>
                    <th scope="col">Yêu thích</th>
                    <th scope="col">Ẩn</th>
                    <th scope="col">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${playlists}">
                    <tr>
                        <td>${p.playlistId}</td>
                        <td>${p.name}</td>
                        <td class="text-center">
                            <c:if test="${p.isFavoriteList}">
                                <span class="text-success">✅</span>
                            </c:if>
                        </td>
                        <td class="text-center">
                            <c:if test="${p.hidden}">
                                <span class="text-danger">🚫</span>
                            </c:if>
                        </td>
                        <td>
                            <a href="PlaylistController?action=view&id=${p.playlistId}" class="btn btn-sm btn-info me-1">Xem</a>
                            <a href="PlaylistController?action=callAddSong&playlistId=${p.playlistId}" class="btn btn-sm btn-success me-1">Thêm bài hát</a>
                            <a href="PlaylistController?action=delete&id=${p.playlistId}" class="btn btn-sm btn-danger me-1">Ẩn</a>
                            <c:if test="${p.hidden}">
                                <a href="PlaylistController?action=restore&id=${p.playlistId}" class="btn btn-sm btn-warning">Restore</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <!-- Nếu không có playlist -->
    <c:if test="${empty playlists}">
        <div class="alert alert-warning">Bạn chưa có playlist nào.</div>
    </c:if>

    <!-- Nút tạo playlist mới -->
    <a href="playlistCreate.jsp" class="btn btn-success mt-3">+ Tạo Playlist mới</a>
    <a href="PlaylistController?action=hidden" class="btn btn-secondary mt-3 ms-2">Danh sách Playlist ẩn</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
