<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thông Báo</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="bg-dark text-light">
    <div class="container mt-5">
        <h2 class="text-center mb-4">🔔 Thông Báo Của Bạn</h2>
        <p class="text-center text-info">
            Bạn có <b>${unreadCount}</b> thông báo chưa đọc
        </p>

        <c:choose>
            <c:when test="${not empty notifications}">
                <div class="list-group">
                    <c:forEach var="n" items="${notifications}">
    
    <%-- CHỈ HIỂN THỊ THÔNG BÁO CHƯA ĐỌC --%>
    <c:if test="${!n.isRead}"> 
        <div class="list-group-item list-group-item-action 
                    list-group-item-success 
                    d-flex justify-content-between align-items-start">
            
            <a href="<c:if test="${n.song != null}">SongController?txtAction=play&songID=${n.song.songId}</c:if><c:if test="${n.song == null}">#</c:if>"
               onclick="fetch('notification?action=read&id=${n.notificationId}')" 
               style="text-decoration: none; color: inherit; flex-grow: 1;">
                
                <div class="d-flex w-100 justify-content-between">
                    <h5 class="mb-1">${n.message}</h5>
                    <small>${n.createdAt}</small>
                </div>
                
                <c:if test="${n.song != null}">
                    <p class="mb-1">Liên quan đến bài hát: ${n.song.title}</p>
                </c:if>
            </a>

            <form action="notification" method="POST" class="ms-3">
                <input type="hidden" name="action" value="hide"/>
                <input type="hidden" name="id" value="${n.notificationId}"/>
                <button type="submit" class="btn btn-sm btn-outline-danger" title="Ẩn thông báo này">
                    </button>
            </form>
        </div>
    </c:if>
    
</c:forEach>
                </div>
            </c:when>

            <c:otherwise>
                <div class="alert alert-warning text-center">
                    Bạn chưa có thông báo nào.
                </div>
            </c:otherwise>
        </c:choose>

        <div class="mt-4 text-center">
            <a href="SongController?txtAction=home" class="btn btn-outline-light">
                ⬅ Quay lại trang chủ
            </a>
        </div>
    </div>
</body>
</html>
