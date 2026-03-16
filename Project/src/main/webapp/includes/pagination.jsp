<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:if test="${totalPages > 1}">
    <c:set var="pageParamName" value="${empty paginationPageParam ? 'page' : paginationPageParam}" />
    <div class="pagination-shell">
        <div class="pagination-meta">
            Trang ${currentPage}/${totalPages} • ${totalItemsCount} mục
        </div>

        <div class="pagination-actions">
            <c:if test="${currentPage > 1}">
                <a class="page-link ghost"
                   href="${paginationBaseUrl}?${paginationQuery}&${pageParamName}=${currentPage - 1}">
                    <i class="bi bi-chevron-left"></i>
                    <span>Trước</span>
                </a>
            </c:if>

            <c:forEach var="pageNo" begin="${startPage}" end="${endPage}">
                <a class="page-link ${pageNo == currentPage ? 'active' : ''}"
                   href="${paginationBaseUrl}?${paginationQuery}&${pageParamName}=${pageNo}">
                    ${pageNo}
                </a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a class="page-link ghost"
                   href="${paginationBaseUrl}?${paginationQuery}&${pageParamName}=${currentPage + 1}">
                    <span>Sau</span>
                    <i class="bi bi-chevron-right"></i>
                </a>
            </c:if>
        </div>
    </div>
</c:if>
