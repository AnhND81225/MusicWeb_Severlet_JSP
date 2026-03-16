package Util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;

public final class PaginationUtil {

    private PaginationUtil() {
    }

    public static int parsePage(String pageParam) {
        try {
            int page = Integer.parseInt(pageParam);
            return Math.max(page, 1);
        } catch (Exception e) {
            return 1;
        }
    }

    public static <T> PageResult<T> paginate(List<T> items, int currentPage, int pageSize) {
        List<T> safeItems = items == null ? Collections.emptyList() : items;
        int safePageSize = Math.max(pageSize, 1);
        int totalItems = safeItems.size();
        int totalPages = Math.max((int) Math.ceil((double) totalItems / safePageSize), 1);
        int safeCurrentPage = Math.min(Math.max(currentPage, 1), totalPages);

        int fromIndex = Math.min((safeCurrentPage - 1) * safePageSize, totalItems);
        int toIndex = Math.min(fromIndex + safePageSize, totalItems);
        List<T> pageItems = safeItems.subList(fromIndex, toIndex);

        int startPage = Math.max(1, safeCurrentPage - 2);
        int endPage = Math.min(totalPages, startPage + 4);
        startPage = Math.max(1, endPage - 4);

        return new PageResult<>(pageItems, safeCurrentPage, totalPages, safePageSize,
                totalItems, startPage, endPage);
    }

    public static String encode(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}
