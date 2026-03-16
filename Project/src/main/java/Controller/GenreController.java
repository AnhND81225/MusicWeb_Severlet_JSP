package Controller;

import Model.DTO.GenreDTO;
import Service.GenreService;
import Service.ValidationService;
import Util.PageResult;
import Util.PaginationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "GenreController", urlPatterns = {"/GenreController"})
public class GenreController extends HttpServlet {

    private static final int PAGE_SIZE = 8;

    private final GenreService genreService = new GenreService();
    private final ValidationService validator = new ValidationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = Optional.ofNullable(request.getParameter("txtAction")).orElse("viewGenre");

        switch (action) {
            case "addGenre":
                processAddGenre(request, response);
                break;
            case "updateGenre":
                processUpdateGenre(request, response);
                break;
            case "callAdd":
                showForm(request, response, null);
                break;
            case "callUpdate":
                showUpdateForm(request, response);
                break;
            case "hideGenre":
                processHideGenre(request, response);
                break;
            case "restoreGenre":
                processRestoreGenre(request, response);
                break;
            case "searchGenre":
                processSearchGenre(request, response);
                break;
            case "featured":
                processFeaturedGenres(request, response);
                break;
            case "viewHiddenGenre":
                processViewHiddenGenres(request, response);
                break;
            default:
                processViewGenres(request, response);
                break;
        }
    }

        private void processViewGenres(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            List<GenreDTO> genres = genreService.getVisibleGenres();
            applyPagination(request, genres, "listOfGenres",
                    "GenreController", "txtAction=viewGenre");
            transferSessionMessages(request);
            request.getRequestDispatcher("/listOfGenres.jsp").forward(request, response);
        }

        private void processFeaturedGenres(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            List<GenreDTO> genres = genreService.getFeaturedGenres();
            applyPagination(request, genres, "listOfGenres",
                    "GenreController", "txtAction=featured");
            transferSessionMessages(request);
            request.getRequestDispatcher("/featuredGenres.jsp").forward(request, response);
        }

        private void processViewHiddenGenres(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            List<GenreDTO> genres = genreService.getHiddenGenres();
            applyPagination(request, genres, "listOfGenres",
                    "GenreController", "txtAction=viewHiddenGenre");
            transferSessionMessages(request);
            request.getRequestDispatcher("/listOfHiddenGenres.jsp").forward(request, response);
        }

    private void showForm(HttpServletRequest request, HttpServletResponse response, GenreDTO genre)
            throws ServletException, IOException {
        request.setAttribute("genre", genre);
        transferSessionMessages(request);
        request.getRequestDispatcher("/genreForm.jsp").forward(request, response);
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("genreID"));
            GenreDTO genre = genreService.getGenreById(id);
            if (genre == null) {
                throw new Exception("Không tìm thấy thể loại");
            }
            showForm(request, response, genre);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Không tìm thấy thể loại cần cập nhật.");
            response.sendRedirect("GenreController?txtAction=viewGenre");
        }
    }

        private void processSearchGenre(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            String keyword = Optional.ofNullable(request.getParameter("keyword")).orElse("").trim();
            List<GenreDTO> listOfGenres = genreService.searchGenres(keyword);

            applyPagination(request, listOfGenres, "listOfGenres",
                    "GenreController", "txtAction=searchGenre&keyword=" + PaginationUtil.encode(keyword));
            request.setAttribute("message", "Tìm thấy " + listOfGenres.size() + " thể loại phù hợp.");
            request.getRequestDispatcher("/listOfGenres.jsp").forward(request, response);
        }

    private <T> void applyPagination(HttpServletRequest request, List<T> items, String attrName,
                                     String baseUrl, String query) {
        PageResult<T> pageResult = PaginationUtil.paginate(
                items,
                PaginationUtil.parsePage(request.getParameter("page")),
                PAGE_SIZE
        );

        request.setAttribute(attrName, pageResult.getItems());
        request.setAttribute("currentPage", pageResult.getCurrentPage());
        request.setAttribute("totalPages", pageResult.getTotalPages());
        request.setAttribute("totalItemsCount", pageResult.getTotalItems());
        request.setAttribute("pageSize", pageResult.getPageSize());
        request.setAttribute("pageStartIndex", pageResult.getTotalItems() == 0
                ? 0
                : ((pageResult.getCurrentPage() - 1) * pageResult.getPageSize()) + 1);
        request.setAttribute("startPage", pageResult.getStartPage());
        request.setAttribute("endPage", pageResult.getEndPage());
        request.setAttribute("paginationBaseUrl", baseUrl);
        request.setAttribute("paginationQuery", query);
    }

    private void processAddGenre(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        GenreDTO genre = extractGenreFromRequest(request);
        if (!validator.isValid(genre)) {
            request.getSession().setAttribute("error", "Thông tin thể loại không hợp lệ.");
            request.getSession().setAttribute("genre", genre);
            response.sendRedirect("GenreController?txtAction=callAdd");
            return;
        }

        boolean success = genreService.addGenre(genre);
        request.getSession().setAttribute(success ? "message" : "error",
                success ? "Đã thêm thể loại thành công!" : "Không thể thêm thể loại.");
        response.sendRedirect("GenreController?txtAction=viewGenre");
    }

    private void processUpdateGenre(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        GenreDTO genre = extractGenreFromRequest(request);
        if (!validator.isValid(genre)) {
            request.getSession().setAttribute("error", "Thông tin thể loại không hợp lệ.");
            request.getSession().setAttribute("genre", genre);
            response.sendRedirect("GenreController?txtAction=callUpdate&genreID=" + genre.getGenreId());
            return;
        }

        boolean success = genreService.updateGenre(genre);
        request.getSession().setAttribute(success ? "message" : "error",
                success ? "Đã cập nhật thể loại thành công!" : "Không thể cập nhật thể loại.");
        response.sendRedirect("GenreController?txtAction=viewGenre");
    }

    private void processHideGenre(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("genreID"));
            genreService.hideGenre(id);
        } catch (Exception ignored) {}
        response.sendRedirect("GenreController?txtAction=viewGenre");
    }

    private void processRestoreGenre(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("genreID"));
            genreService.restoreGenre(id);
        } catch (Exception ignored) {
        }
        response.sendRedirect("GenreController?txtAction=viewGenre");
    }

    private GenreDTO extractGenreFromRequest(HttpServletRequest request) {
        GenreDTO genre = new GenreDTO();

        try {
            String idStr = request.getParameter("genreID");
            if (idStr != null && !idStr.trim().isEmpty()) {
                genre.setGenreId(Integer.parseInt(idStr));
            }
        } catch (Exception ignored) {}

        genre.setName(request.getParameter("name"));
        genre.setImage(request.getParameter("image"));
        genre.setFeatured(request.getParameter("isFeatured") != null);
        genre.setHidden(request.getParameter("isHidden") != null);

        return genre;
    }

    private void transferSessionMessages(HttpServletRequest request) {
        HttpSession session = request.getSession();
        for (String key : new String[]{"message", "error", "genre"}) {
            Object value = session.getAttribute(key);
            if (value != null) {
                request.setAttribute(key, value);
                session.removeAttribute(key);
            }
        }
    }
}
