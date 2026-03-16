package Util;

import java.util.List;

public class PageResult<T> {

    private final List<T> items;
    private final int currentPage;
    private final int totalPages;
    private final int pageSize;
    private final int totalItems;
    private final int startPage;
    private final int endPage;

    public PageResult(List<T> items, int currentPage, int totalPages, int pageSize,
                      int totalItems, int startPage, int endPage) {
        this.items = items;
        this.currentPage = currentPage;
        this.totalPages = totalPages;
        this.pageSize = pageSize;
        this.totalItems = totalItems;
        this.startPage = startPage;
        this.endPage = endPage;
    }

    public List<T> getItems() {
        return items;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public int getStartPage() {
        return startPage;
    }

    public int getEndPage() {
        return endPage;
    }
}
