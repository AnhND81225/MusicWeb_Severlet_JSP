<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ====== LIÊN KẾT CSS & JS ====== -->
<link rel="stylesheet" href="CSS/comment.css" />


<div class="comment-wrapper mt-5 mb-5">
    <h4 class="comment-title">💬 Bình luận</h4>

    <!-- ====== THÔNG BÁO ====== -->
    <c:if test="${not empty COMMENT_MESSAGE}">
        <div class="alert alert-success comment-alert">${COMMENT_MESSAGE}</div>
    </c:if>
    <c:if test="${not empty COMMENT_ERROR}">
        <div class="alert alert-danger comment-alert">${COMMENT_ERROR}</div>
    </c:if>

    <!-- ====== FORM GỬI BÌNH LUẬN ====== -->
    <c:choose>
        <c:when test="${sessionScope.user != null}">
            <form action="${pageContext.request.contextPath}/comment" method="post" class="comment-form">
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="songID" value="${song.songId}" />

                <textarea name="content" class="form-control comment-input" rows="3"
                          placeholder="Hãy chia sẻ cảm nhận của bạn về bài hát này..." required></textarea>

                <button type="submit" class="btn comment-btn">Gửi bình luận</button>
            </form>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info text-center mt-3">
                🎧 Vui lòng <a href="login.jsp" class="alert-link fw-bold">đăng nhập</a> để bình luận nhé.
            </div>
        </c:otherwise>
    </c:choose>

    <!-- ====== DANH SÁCH BÌNH LUẬN ====== -->
    <div class="comment-section mt-4">
        <c:forEach var="parent" items="${comments}">
            <c:if test="${parent.parentComment == null}">
                <div class="comment-box parent-comment">
                    <div class="comment-header">
                        <span class="comment-user">🎤 ${parent.user.username}</span>
                        <small class="comment-time">${parent.createdAt}</small>
                    </div>
                    <p class="comment-content">${parent.content}</p>

                    <!-- ACTIONS -->
                    <div class="comment-actions">
                        <c:if test="${sessionScope.user != null}">
                            <a href="#" class="reply-btn" data-comment-id="${parent.commentId}">↩️ Trả lời</a>
                        </c:if>

                        <c:if test="${sessionScope.user != null && sessionScope.user.userID == parent.user.userID}">
                            <form action="${pageContext.request.contextPath}/comment" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="commentId" value="${parent.commentId}" />
                                <input type="hidden" name="songID" value="${song.songId}" />
                                <button type="submit" class="delete-btn"
                                        onclick="return confirm('Xóa bình luận này sẽ xóa cả các phản hồi. Tiếp tục?');">
                                    ❌
                                </button>
                            </form>
                        </c:if>
                    </div>

                    <!-- FORM TRẢ LỜI -->
                    <div id="reply-form-container-${parent.commentId}" class="reply-form-container">
                        <form action="${pageContext.request.contextPath}/comment" method="post">
                            <input type="hidden" name="action" value="add" />
                            <input type="hidden" name="songID" value="${song.songId}" />
                            <input type="hidden" name="parentCommentId" value="${parent.commentId}" />

                            <textarea name="content" class="form-control reply-input"
                                      placeholder="Trả lời ${parent.user.username}..." required></textarea>

                            <button type="submit" class="btn btn-sm reply-btn-submit">Gửi trả lời</button>
                        </form>
                    </div>

                    <!-- COMMENT CON -->
                    <c:forEach var="child" items="${comments}">
                        <c:if test="${child.parentComment != null && child.parentComment.commentId == parent.commentId}">
                            <div class="comment-box child-comment">
                                <div class="comment-header">
                                    <span class="comment-user">🎧 ${child.user.username}</span>
                                    <small class="comment-time">${child.createdAt}</small>
                                </div>
                                <p class="comment-content">${child.content}</p>

                                <c:if test="${sessionScope.user != null && sessionScope.user.userID == child.user.userID}">
                                    <form action="${pageContext.request.contextPath}/comment" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="commentId" value="${child.commentId}" />
                                        <input type="hidden" name="songID" value="${song.songId}" />
                                        <button type="submit" class="delete-btn"
                                                onclick="return confirm('Bạn có chắc chắn muốn xóa phản hồi này?');">
                                            ❌
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </c:if>
        </c:forEach>
    </div>
</div>
<script src="js/comment.js" defer></script>
