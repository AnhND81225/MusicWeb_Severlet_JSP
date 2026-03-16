package Controller;

import Model.DTO.PlaylistDTO;
import Model.DTO.PlaylistSongDTO;
import Model.DTO.SongDTO;
import Model.DTO.UserDTO;
import Service.PlaylistService;
import Service.SongService;
import Util.PageResult;
import Util.PaginationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet(name = "PlaylistController", urlPatterns = {"/PlaylistController"})
public class PlaylistController extends HttpServlet {

    private static final int PAGE_SIZE = 8;

    private final PlaylistService playlistService = new PlaylistService();
    private final SongService songService = new SongService();

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

        String action = Optional.ofNullable(request.getParameter("action")).orElse("list");

        switch (action) {
            case "list":
                processListPlaylists(request, response);
                break;
            case "view":
                processViewPlaylist(request, response);
                break;
            case "create":
                processCreatePlaylist(request, response);
                break;
            case "callAddSong":
                showAddSongPage(request, response);
                break;
            case "addSong":
                processAddSong(request, response);
                break;
            case "removeSong":
                processRemoveSong(request, response);
                break;
            case "delete":
                processDeletePlaylist(request, response);
                break;
            case "hidden":
                processHiddenPlaylists(request, response);
                break;
            case "restore":
                processRestorePlaylist(request, response);
                break;

            default:
                processListPlaylists(request, response);
                break;
        }
    }

    private void processListPlaylists(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<PlaylistDTO> playlists = playlistService.getPlaylistsByUser(user);
        applyPagination(request, playlists, "playlists",
                "PlaylistController", "action=list");
        transferSessionMessages(request);

        request.getRequestDispatcher("playlistList.jsp").forward(request, response);
    }

    private void processViewPlaylist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int playlistId = Integer.parseInt(request.getParameter("id"));
            PlaylistDTO playlist = playlistService.getPlaylistById(playlistId);
            List<PlaylistSongDTO> songs = playlistService.getSongsInPlaylist(playlistId);

            request.setAttribute("playlist", playlist);
            request.setAttribute("songs", songs);
            transferSessionMessages(request);
            request.getRequestDispatcher("playlistDetail.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("PlaylistController?action=list");
        }
    }

    private void processCreatePlaylist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("playlistName");
        PlaylistDTO playlist = playlistService.createPlaylistAndReturn(user, name);

        if (playlist != null) {
            response.sendRedirect("PlaylistController?action=callAddSong&playlistId=" + playlist.getPlaylistId());
        } else {
            session.setAttribute("error", "Không thể tạo hoặc tìm thấy playlist.");
            response.sendRedirect("PlaylistController?action=list");
        }
    }

    private void showAddSongPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            UserDTO user = (UserDTO) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int playlistId = Integer.parseInt(request.getParameter("playlistId"));
            List<SongDTO> allSongs = songService.getAllSongs();
            List<PlaylistSongDTO> songsInPlaylist = playlistService.getSongsInPlaylist(playlistId);

            // Lấy danh sách ID bài hát đã có
            List<Integer> existingSongIds = songsInPlaylist.stream()
                    .map(ps -> ps.getSong().getSongId())
                    .collect(Collectors.toList());

            // Lọc các bài chưa có trong playlist
            List<SongDTO> songsToAdd = allSongs.stream()
                    .filter(s -> !existingSongIds.contains(s.getSongId()))
                    .collect(Collectors.toList());

            List<PlaylistDTO> playlists = playlistService.getPlaylistsByUser(user);

            request.setAttribute("songs", songsToAdd); // chỉ truyền các bài chưa có
            request.setAttribute("playlistId", playlistId);
            request.setAttribute("playlists", playlists);

            request.getRequestDispatcher("playlistAddSong.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect("PlaylistController?action=list");
        }
    }

    private void processAddSong(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        try {
            int playlistId = Integer.parseInt(request.getParameter("playlistId"));
            PlaylistDTO playlist = playlistService.getPlaylistById(playlistId);

            if (playlist == null) {
                session.setAttribute("error", "Không tìm thấy playlist.");
                response.sendRedirect("PlaylistController?action=list");
                return;
            }

            // ✅ Nhận biết nguồn gọi (để điều hướng khác nhau)
            String fromPage = Optional.ofNullable(request.getParameter("fromPage")).orElse("");

            // ✅ Hai trường hợp: thêm 1 bài (từ modal) hoặc nhiều bài (checkbox)
            String singleSongId = request.getParameter("songId"); // từ modal
            String[] multiSongIds = request.getParameterValues("songIds[]"); // từ checkbox

            int addedCount = 0;

            if (singleSongId != null && !singleSongId.isEmpty()) {
                // 🔹 Thêm 1 bài hát từ modal (listOfSongs)
                int songId = Integer.parseInt(singleSongId);
                SongDTO song = songService.getSongById(songId);
                if (song != null && playlistService.addSongToPlaylist(playlist, song)) {
                    addedCount++;
                }
            } else if (multiSongIds != null && multiSongIds.length > 0) {
                // 🔹 Thêm nhiều bài hát (từ trang chọn checkbox)
                for (String sId : multiSongIds) {
                    int songId = Integer.parseInt(sId);
                    SongDTO song = songService.getSongById(songId);
                    if (song != null && playlistService.addSongToPlaylist(playlist, song)) {
                        addedCount++;
                    }
                }
            } else {
                session.setAttribute("error", "Vui lòng chọn ít nhất một bài hát.");
                response.sendRedirect("PlaylistController?action=callAddSong&playlistId=" + playlistId);
                return;
            }

            // ✅ Thông báo kết quả
            if (addedCount > 0) {
                session.setAttribute("message", "Đã thêm " + addedCount + " bài hát vào playlist!");
            } else {
                session.setAttribute("error", "Bài hát đã tồn tại trong playlist hoặc không hợp lệ.");
            }

            // ✅ Điều hướng tuỳ theo nguồn gọi
            if ("listOfSongs".equals(fromPage)) {
                // 👉 Nếu thêm từ trang danh sách bài hát → quay lại listOfSongs
                response.sendRedirect("SongController?action=viewSongs");
            } else {
                // 👉 Còn lại: trở lại trang chi tiết playlist
                response.sendRedirect("PlaylistController?action=view&id=" + playlistId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra khi thêm bài hát vào playlist.");
            response.sendRedirect("PlaylistController?action=list");
        }
    }

    private void processRemoveSong(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int playlistId = Integer.parseInt(request.getParameter("playlistId"));
            int songId = Integer.parseInt(request.getParameter("songId"));

            playlistService.removeSongFromPlaylist(playlistId, songId);
            response.sendRedirect("PlaylistController?action=view&id=" + playlistId);
        } catch (Exception e) {
            response.sendRedirect("PlaylistController?action=list");
        }
    }

    private void processDeletePlaylist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int playlistId = Integer.parseInt(request.getParameter("id"));
            boolean success = playlistService.hidePlaylist(playlistId);
            session.setAttribute(success ? "message" : "error",
                    success ? "Playlist đã được ẩn." : "Không thể ẩn playlist.");
        } catch (Exception ignored) {
            session.setAttribute("error", "Không thể ẩn playlist.");
        }
        response.sendRedirect("PlaylistController?action=list");
    }

    private void processHiddenPlaylists(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<PlaylistDTO> playlists = playlistService.getHiddenPlaylistsByUser(user);
        applyPagination(request, playlists, "playlists",
                "PlaylistController", "action=hidden");
        transferSessionMessages(request);
        request.getRequestDispatcher("lisOfHiddenPlaylists.jsp").forward(request, response);
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

    private void processRestorePlaylist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int playlistId = Integer.parseInt(request.getParameter("id"));
            boolean success = playlistService.restorePlaylist(playlistId);
            session.setAttribute(success ? "message" : "error",
                    success ? "Playlist đã được khôi phục." : "Không thể khôi phục playlist.");
        } catch (Exception ignored) {
            session.setAttribute("error", "Không thể khôi phục playlist.");
        }
        response.sendRedirect("PlaylistController?action=hidden");
    }

    private void transferSessionMessages(HttpServletRequest request) {
        HttpSession session = request.getSession();
        for (String key : new String[]{"message", "error"}) {
            Object value = session.getAttribute(key);
            if (value != null) {
                request.setAttribute(key, value);
                session.removeAttribute(key);
            }
        }
    }
}
