package Controller;

import Form.AlbumFormData;
import Model.DTO.AlbumDTO;
import Model.DTO.AlbumStatsDTO;
import Service.AlbumService;
import Service.GenreService;
import Service.ValidationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "AlbumController", urlPatterns = {"/AlbumController"})
public class AlbumController extends HttpServlet {

    private final AlbumService albumService = new AlbumService();
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

        String action = Optional.ofNullable(request.getParameter("txtAction")).orElse("viewAlbum");

        switch (action) {
            case "addAlbum":
                processSaveAlbum(request, response, false);
                break;
            case "viewSongs":
                processViewSongsOfAlbum(request, response);
                break;
            case "updateAlbum":
                processSaveAlbum(request, response, true);
                break;
            case "callAdd":
                showAlbumForm(request, response, false);
                break;
            case "callUpdate":
                showUpdateForm(request, response);
                break;
            case "hideAlbum":
                processToggleAlbum(request, response, true);
                break;
            case "restoreAlbum":
                processToggleAlbum(request, response, false);
                break;
            case "viewHidden":
                forwardAlbumList(request, response, albumService.getHiddenAlbums(), "listOfHiddenAlbums.jsp");
                break;
            case "topAlbum":
                processTopAlbum(request, response);
                break;
            case "sorted":
                processSortedAlbums(request, response);
                break;
            case "byArtist":
                processAlbumsByArtist(request, response);
                break;
            case "search":
                processSearchAlbums(request, response);
                break;
            case "byGenre":
                processAlbumsByGenre(request, response);
                break;
            default:
                forwardAlbumList(request, response, albumService.getAllAlbums(), "listOfAlbums.jsp");
                break;
        }
    }

    private void showAlbumForm(HttpServletRequest req, HttpServletResponse res, boolean update)
            throws ServletException, IOException {
        AlbumFormData formData = albumService.prepareFormData();
        req.setAttribute("listOfGenres", formData.getGenres());
        req.setAttribute("listOfArtists", formData.getArtists());
        req.setAttribute("listOfSongs", formData.getSongs());
        req.setAttribute("update", update);
        albumService.transferSessionMessages(req);
        req.getRequestDispatcher("/albumForm.jsp").forward(req, res);
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("albumID"));
            AlbumDTO album = albumService.getAlbumById(id);
            if (album == null) {
                throw new Exception("Không tìm thấy album");
            }
            request.setAttribute("a", album);
            request.setAttribute("releaseDateStr", album.getReleaseDate().toLocalDate().toString());
            showAlbumForm(request, response, true);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Không tìm thấy album cần cập nhật.");
            response.sendRedirect("AlbumController?txtAction=viewAlbum");
        }
    }

    private void processSearchAlbums(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = Optional.ofNullable(request.getParameter("keyword")).orElse("").trim();
        List<AlbumDTO> matchedAlbums = albumService.searchAlbumByName(keyword);
        request.setAttribute("listOfAlbums", matchedAlbums);
        albumService.transferSessionMessages(request);
        request.getRequestDispatcher("/listOfAlbums.jsp").forward(request, response);
    }

    private void processViewSongsOfAlbum(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int albumId = Integer.parseInt(request.getParameter("albumId"));

            // Lấy thông tin chi tiết album
            AlbumDTO album = albumService.getAlbumById(albumId);

            // Gọi sang SongService để lấy các bài hát thuộc album
            Service.SongService songService = new Service.SongService();
            List<Model.DTO.SongDTO> albumSongs = songService.getSongsByAlbum(albumId);

            // Đưa dữ liệu qua JSP
            request.setAttribute("album", album);
            request.setAttribute("albumSongs", albumSongs);

            // Gọi trang hiển thị danh sách bài hát trong album
            request.getRequestDispatcher("/songOfAlbums.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AlbumController?txtAction=viewAlbum");
        }
    }

    private void processSaveAlbum(HttpServletRequest request, HttpServletResponse response, boolean isUpdate)
            throws IOException {
        HttpSession session = request.getSession();
        AlbumDTO album = albumService.extractAlbumFromRequest(request, isUpdate);

        if (album.getReleaseDate() != null) {
            session.setAttribute("releaseDateStr", album.getReleaseDate().toLocalDate().toString());
        }

        if (!validator.isValid(album)) {
            session.setAttribute("error", "Thông tin album không hợp lệ.");
            session.setAttribute("a", album);
            session.setAttribute("update", isUpdate);
            String redirectAction = isUpdate ? "callUpdate&albumID=" + album.getAlbumId() : "callAdd";
            response.sendRedirect("AlbumController?txtAction=" + redirectAction);
            return;
        }

        boolean success = isUpdate ? albumService.updateAlbum(album) : albumService.createAlbum(album);
        session.setAttribute(success ? "message" : "error",
                success ? "Đã " + (isUpdate ? "cập nhật" : "thêm") + " album thành công!" : "Không thể lưu album.");
        response.sendRedirect("AlbumController?txtAction=viewAlbum");
    }

    private void processSortedAlbums(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AlbumDTO> sortedAlbums = albumService.getAlbumsSortedByReleaseDate();
        request.setAttribute("listOfAlbums", sortedAlbums);
        albumService.transferSessionMessages(request);
        request.getRequestDispatcher("/listOfAlbums.jsp").forward(request, response);
    }

    private void processToggleAlbum(HttpServletRequest request, HttpServletResponse response, boolean hide)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("albumID"));
            if (hide) {
                albumService.hideAlbum(id);
            } else {
                albumService.restoreAlbum(id);
            }
        } catch (Exception ignored) {
        }
        response.sendRedirect("AlbumController?txtAction=" + (hide ? "viewAlbum" : "viewHidden"));
    }

    private void processAlbumsByArtist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int artistId = Integer.parseInt(request.getParameter("artistID"));
            List<AlbumDTO> albums = albumService.getAlbumsByArtist(artistId);
            request.setAttribute("listOfAlbums", albums);
            request.getRequestDispatcher("/listOfAlbums.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("AlbumController?txtAction=viewAlbum");
        }
    }

    private void processAlbumsByGenre(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int genreId = Integer.parseInt(request.getParameter("genreID"));
            List<AlbumDTO> albums = albumService.getAlbumsByGenre(genreId);
            request.setAttribute("listOfAlbums", albums);
            request.getRequestDispatcher("/listOfAlbums.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("AlbumController?txtAction=viewAlbum");
        }
    }

    private void processTopAlbum(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<AlbumStatsDTO> topAlbums = albumService.getTopAlbumsByPlayCount();
        request.setAttribute("topAlbums", topAlbums);
        albumService.transferSessionMessages(request);
        request.getRequestDispatcher("/topAlbums.jsp").forward(request, response);
    }

    private void forwardAlbumList(HttpServletRequest request, HttpServletResponse response,
            List<AlbumDTO> albums, String jspPath)
            throws ServletException, IOException {
        request.setAttribute("listOfAlbums", albums);
        albumService.transferSessionMessages(request);
        request.getRequestDispatcher("/" + jspPath).forward(request, response);
    }
    
}