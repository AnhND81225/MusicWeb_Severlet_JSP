<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>❤️ Lượt thích bài hát</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: "Inter", sans-serif;
            color: #212529;
            padding: 30px 0;
        }

        .song-like-section {
            max-width: 420px;
            margin: 0 auto;
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
            padding: 24px;
            transition: all 0.3s ease;
        }

        .song-like-section:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 14px rgba(0, 0, 0, 0.15);
        }

        .song-like-section h5 {
            text-align: center;
            font-weight: 700;
            color: #dc3545;
            margin-bottom: 20px;
        }

        .song-like-section p {
            text-align: center;
            font-size: 15px;
        }

        .song-like-section form {
            display: flex;
            justify-content: center;
        }

        .song-like-section button {
            font-size: 16px;
            font-weight: 600;
            padding: 8px 22px;
            border-radius: 8px;
            transition: all 0.25s ease-in-out;
        }

        .song-like-section button:hover {
            transform: scale(1.05);
        }

        .alert-info {
            text-align: center;
            font-size: 14px;
        }

        .alert-info a {
            color: #0d6efd;
            font-weight: 600;
            text-decoration: none;
        }

        .alert-info a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
    <div class="song-like-section">

        <h5>❤️ Lượt thích</h5>

        <!-- Hiển thị số lượt thích -->
        <p class="mb-3">
            <strong>${likeCount}</strong> người đã thích bài hát này.
        </p>

        <!-- Nếu user đã đăng nhập -->
        <c:if test="${sessionScope.user != null}">
            <form action="${pageContext.request.contextPath}/like" method="post">
                <input type="hidden" name="userId" value="${sessionScope.user.userID}" />
                <input type="hidden" name="songId" value="${song.songId}" />

                <c:choose>
                    <c:when test="${userLiked}">
                        <button type="submit" class="btn btn-danger">
                            💔 Bỏ thích
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="submit" class="btn btn-outline-danger">
                            ❤️ Thích
                        </button>
                    </c:otherwise>
                </c:choose>
            </form>
        </c:if>

        <!-- Nếu user chưa đăng nhập -->
        <c:if test="${sessionScope.user == null}">
            <div class="alert alert-info mt-3">
                Vui lòng <a href="login.jsp">đăng nhập</a> để thả tim bài hát này.
            </div>
        </c:if>
    </div>
</body>
</html>
