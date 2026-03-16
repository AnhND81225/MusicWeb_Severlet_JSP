<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="mt-5">
    <h4>💬 Bình luận</h4>

    <!-- Form thêm bình luận -->
    <form action="CommentController" method="post" class="mb-4">
        <input type="hidden" name="songId" value="${song.id}">
        <textarea name="content" class="form-control" rows="3" placeholder="Viết bình luận..." required></textarea>
        <button type="submit" name="txtAction" value="addComment" class="btn btn-primary mt-2">Gửi bình luận</button>
    </form>

    <!-- Danh sách bình luận -->
    <div class="list-group">
        <c:forEach var="cmt" items="${comments}">
            <div class="list-group-item">
                <strong>${cmt.user.fullname}:</strong>
                <p class="mb-0">${cmt.content}</p>
                <small class="text-muted">${cmt.createdAt}</small>
            </div>
        </c:forEach>
    </div>
</div>
