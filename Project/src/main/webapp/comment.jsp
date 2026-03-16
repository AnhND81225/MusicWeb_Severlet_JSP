<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/comment.css?v=2" />

<div class="comment-wrapper">
    <div class="comment-intro">
        <p class="comment-kicker">Discussion</p>
        <h3 class="comment-title">Cảm nhận của người nghe</h3>
        <p class="comment-copy">Để lại nhận xét, trả lời qua lại và theo dõi cuộc trò chuyện ngay dưới bài hát này.</p>
    </div>

    <c:if test="${not empty COMMENT_MESSAGE}">
        <div class="comment-alert success">${COMMENT_MESSAGE}</div>
    </c:if>
    <c:if test="${not empty COMMENT_ERROR}">
        <div class="comment-alert error">${COMMENT_ERROR}</div>
    </c:if>

    <c:choose>
        <c:when test="${sessionScope.user != null}">
            <form action="${pageContext.request.contextPath}/comment" method="post" class="comment-form">
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="songID" value="${song.songId}" />

                <textarea name="content"
                          class="comment-input"
                          rows="3"
                          placeholder="Chia sẻ cảm nhận của bạn về bài hát này..."
                          required></textarea>

                <div class="comment-form-actions">
                    <span class="comment-form-note">Bình luận của bạn sẽ hiển thị ngay trong cuộc trò chuyện.</span>
                    <button type="submit" class="comment-submit">Gửi bình luận</button>
                </div>
            </form>
        </c:when>
        <c:otherwise>
            <div class="comment-login-note">
                Vui lòng <a href="login.jsp">đăng nhập</a> để bình luận và trả lời.
            </div>
        </c:otherwise>
    </c:choose>

    <div class="comment-thread">
        <c:forEach var="parent" items="${comments}">
            <c:if test="${parent.parentComment == null}">
                <article class="comment-card parent-comment">
                    <div class="comment-card-head">
                        <div class="comment-author-block">
                            <span class="comment-avatar">${parent.user.username.substring(0, 1)}</span>
                            <div>
                                <strong class="comment-user">${parent.user.username}</strong>
                                <small class="comment-time">${parent.createdAt}</small>
                            </div>
                        </div>

                        <div class="comment-actions">
                            <c:if test="${sessionScope.user != null}">
                                <a href="#" class="reply-btn" data-comment-id="${parent.commentId}">Trả lời</a>
                            </c:if>

                            <c:if test="${sessionScope.user != null && sessionScope.user.userID == parent.user.userID}">
                                <form action="${pageContext.request.contextPath}/comment" method="post" class="inline-form">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="commentId" value="${parent.commentId}" />
                                    <input type="hidden" name="songID" value="${song.songId}" />
                                    <button type="submit"
                                            class="delete-btn"
                                            onclick="return confirm('Xóa bình luận này sẽ xóa cả các phản hồi. Tiếp tục?');">
                                        Xóa
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>

                    <p class="comment-content">${parent.content}</p>

                    <div id="reply-form-container-${parent.commentId}" class="reply-form-container">
                        <form action="${pageContext.request.contextPath}/comment" method="post" class="reply-form">
                            <input type="hidden" name="action" value="add" />
                            <input type="hidden" name="songID" value="${song.songId}" />
                            <input type="hidden" name="parentCommentId" value="${parent.commentId}" />

                            <textarea name="content"
                                      class="reply-input"
                                      rows="2"
                                      placeholder="Trả lời ${parent.user.username}..."
                                      required></textarea>

                            <div class="reply-actions">
                                <button type="submit" class="reply-submit">Gửi trả lời</button>
                            </div>
                        </form>
                    </div>

                    <div class="child-thread">
                        <c:forEach var="child" items="${comments}">
                            <c:if test="${child.parentComment != null && child.parentComment.commentId == parent.commentId}">
                                <article class="comment-card child-comment">
                                    <div class="comment-card-head">
                                        <div class="comment-author-block">
                                            <span class="comment-avatar secondary">${child.user.username.substring(0, 1)}</span>
                                            <div>
                                                <strong class="comment-user">${child.user.username}</strong>
                                                <small class="comment-time">${child.createdAt}</small>
                                            </div>
                                        </div>

                                        <c:if test="${sessionScope.user != null && sessionScope.user.userID == child.user.userID}">
                                            <form action="${pageContext.request.contextPath}/comment" method="post" class="inline-form">
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="commentId" value="${child.commentId}" />
                                                <input type="hidden" name="songID" value="${song.songId}" />
                                                <button type="submit"
                                                        class="delete-btn"
                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa phản hồi này?');">
                                                    Xóa
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>

                                    <p class="comment-content">${child.content}</p>
                                </article>
                            </c:if>
                        </c:forEach>
                    </div>
                </article>
            </c:if>
        </c:forEach>

        <c:if test="${empty comments}">
            <div class="empty-comments">Chưa có bình luận nào. Hãy mở đầu cuộc trò chuyện.</div>
        </c:if>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/comment.js" defer></script>
