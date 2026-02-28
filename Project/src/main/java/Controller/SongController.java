package Controller;

import Model.DAO.CommentDAO;
import Model.DAO.NotificationDAO;
import Model.DAO.UserDAO;
import Model.DTO.PlaylistDTO;
import Model.DTO.SongDTO;
import Service.AlbumService;
import Service.CommentService;
import Service.GenreService;
import Service.NotificationService;
import Service.PlaylistService;
import Service.SongService;
import Service.ValidationService;

import Service.CommentService;
import Model.DAO.CommentDAO;
import Model.DTO.CommentDTO;

import Model.DAO.NotificationDAO;
import Model.DAO.SongLikesDAO;
import Model.DAO.UserDAO;
import Model.DTO.UserDTO;
import Service.NotificationService;
import Service.SongLikesService;
import org.hibernate.SessionFactory;
import Util.HibernateUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "SongController", urlPatterns = {"/SongController"})
public class SongController extends HttpServlet {

    private final SongService songService = new SongService();
    private final ValidationService validator = new ValidationService();
    private final AlbumService albumService = new AlbumService();
    private final GenreService genreService = new GenreService();
    private CommentService commentService;
    private UserDAO userDAO;
    private NotificationService notificationService;

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

        String action = Optional.ofNullable(request.getParameter("action")).orElse("viewSongs");

        switch (action) {
            case "addSong":
                processAddSong(request, response);
                break;
            case "updateSong":
                processUpdateSong(request, response);
                break;
            case "callAdd":
                showForm(request, response, null);
                break;
            case "callUpdate":
                showUpdateForm(request, response);
                break;
            case "hideSong":
                processHideSong(request, response);
                break;
            case "restoreSong":
                processRestoreSong(request, response);
                break;
            case "topSongs":
                processTopSongs(request, response);
                break;
            case "play":
                processPlaySong(request, response);
                break;
            case "home":
                processHomePage(request, response);
                break;
            case "search":
                processSearchSong(request, response);
                break;
            case "viewHiddenSongs":
                processViewHiddenSongs(request, response);
                break;
            default:
                processViewSongs(request, response);
                break;
        }
    }

    private void processHomePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // =========================================
        // 🔹 LẤY DANH SÁCH BÀI HÁT (PLAYLIST)
        // =========================================
        List<SongDTO> playlist = songService.getAllSongsWithDetails();
        if (playlist == null) {
            playlist = new java.util.ArrayList<>();
        }
        request.setAttribute("playlist", playlist);

        if (!playlist.isEmpty()) {
            request.setAttribute("currentSong", playlist.get(0));
        } else {
            request.setAttribute("currentSong", null);
        }

        // =========================================
        // 🔹 LẤY USER HIỆN TẠI
        // =========================================
        HttpSession session = request.getSession(false);
        UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;

        // =========================================
        // 🔹 LẤY THÔNG BÁO CHƯA ĐỌC
        // =========================================
        if (currentUser != null) {
            try {
                // ✅ Dùng NotificationDAO bản mới — không cần SessionFactory
                NotificationService ns = new NotificationService(new NotificationDAO());

                List<Model.DTO.NotificationDTO> unreadNotifications
                        = ns.getUnreadNotificationsByUserId(currentUser.getUserID());

                int unreadCount = ns.countUnreadNotificationsByUserId(currentUser.getUserID());

                request.setAttribute("unreadNotifications", unreadNotifications);
                request.setAttribute("unreadCount", unreadCount);

            } catch (Exception e) {
                System.err.println("⚠️ Lỗi khi tải danh sách thông báo: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // =========================================
        // 🔹 CHUYỂN TỚI TRANG HOME
        // =========================================
        request.getRequestDispatcher("HomePage.jsp").forward(request, response);
    }

    // ================== HIỂN THỊ DANH SÁCH BÀI HÁT ==================
    private void processViewSongs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<SongDTO> songs = songService.getAllSongsWithDetails();
        request.setAttribute("listOfSongs", songs);
        request.setAttribute("listOfAlbums", albumService.getAllAlbums());
        request.setAttribute("listOfGenres", genreService.getAllGenres());

        request.setAttribute("s", new SongDTO());
        request.setAttribute("update", false);

        transferSessionMessages(request);

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null) {
            List<PlaylistDTO> userPlaylists = new PlaylistService().getPlaylistsByUser(user);
            request.setAttribute("userPlaylists", userPlaylists);
        }

        transferSessionMessages(request);
        request.getRequestDispatcher("/listOfSongs.jsp").forward(request, response);
    }

    // ================== FORM THÊM / SỬA ==================
    private void showForm(HttpServletRequest request, HttpServletResponse response, SongDTO song)
            throws ServletException, IOException {

        request.setAttribute("s", song);
        request.setAttribute("update", song != null);
        request.setAttribute("listOfAlbums", albumService.getAllAlbums());
        request.setAttribute("listOfGenres", genreService.getAllGenres());
        transferSessionMessages(request);

        // 📁 Lấy danh sách tất cả file .mp3 trong thư mục Audio
        String audioPath = getServletContext().getRealPath("/Audio");
        java.io.File audioFolder = new java.io.File(audioPath);
        java.util.List<String> audioFiles = new java.util.ArrayList<>();

        if (audioFolder.exists() && audioFolder.isDirectory()) {
            for (java.io.File f : audioFolder.listFiles()) {
                if (f.isFile() && f.getName().toLowerCase().endsWith(".mp3")) {
                    audioFiles.add(f.getName());
                }
            }
        }

        // Gửi danh sách file sang JSP để hiển thị trong datalist
        request.setAttribute("audioFiles", audioFiles);

        request.getRequestDispatcher("/songForm.jsp").forward(request, response);
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("songId");
            if (idStr == null) {
                idStr = request.getParameter("songID");
            }
            if (idStr == null || !idStr.matches("\\d+")) {
                throw new IllegalArgumentException("ID không hợp lệ");
            }
            int id = Integer.parseInt(idStr);
            SongDTO song = songService.getSongById(id);
            if (song == null) {
                throw new Exception("Không tìm thấy bài hát");
            }
            showForm(request, response, song);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Không tìm thấy bài hát cần cập nhật.");
            response.sendRedirect("SongController?action=viewSongs");
        }
    }

    // ================== THÊM / CẬP NHẬT ==================
    private void processAddSong(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SongDTO song = extractSongFromRequest(request);

        if (!validator.isValid(song)) {
            request.getSession().setAttribute("error", "Thông tin bài hát không hợp lệ.");
            request.getSession().setAttribute("song", song);
            response.sendRedirect("SongController?action=callAdd");
            return;
        }

        boolean success = songService.addSong(song);
        HttpSession session = request.getSession(false);
        UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;
        if (success && currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            try {
                System.out.println("📢 Admin " + currentUser.getUsername() + " vừa thêm bài hát mới: " + song.getTitle());

                // lấy tất cả user chưa bị ẩn
                java.util.List<Model.DTO.UserDTO> allUsers = (this.userDAO != null)
                        ? this.userDAO.getVisibleUsers()
                        : new java.util.ArrayList<>();

                // trigger service (giữ nguyên cách bạn gọi)
                Service.NotificationTriggerService triggerService
                        = new Service.NotificationTriggerService(this.notificationService);

                triggerService.onNewSongAddedByAdmin(currentUser, song, allUsers);

                System.out.println("✅ Gửi thông báo thành công cho tất cả user hoạt động!");

            } catch (Exception e) {
                System.err.println("⚠️ Lỗi khi gửi thông báo bài hát mới: " + e.getMessage());
                e.printStackTrace();
            }
            request.getSession().setAttribute(success ? "message" : "error",
                    success ? "Đã thêm bài hát thành công!" : "Không thể thêm bài hát.");
            response.sendRedirect("SongController?action=viewSongs");
        }
    }

    private void processUpdateSong(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SongDTO song = extractSongFromRequest(request);
        System.out.println("🎯 Update request received: ID=" + song.getSongId());

        if (!validator.isValid(song)) {
            request.getSession().setAttribute("error", "Thông tin bài hát không hợp lệ.");
            request.getSession().setAttribute("song", song);
            response.sendRedirect("SongController?action=callUpdate&songId=" + song.getSongId());
            return;
        }

        boolean success = songService.updateSong(song);
        System.out.println("✅ Update result: " + success);
        request.getSession().setAttribute(success ? "message" : "error",
                success ? "Đã cập nhật bài hát thành công!" : "Không thể cập nhật bài hát.");
        response.sendRedirect("SongController?action=viewSongs");
    }

    // ================== ẨN / KHÔI PHỤC ==================
    private void processHideSong(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("songId"));
            songService.hideSong(id);
        } catch (Exception ignored) {
        }
        response.sendRedirect("SongController?action=viewSongs");
    }

    private void processRestoreSong(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("songId"));
            songService.restoreSong(id);
        } catch (Exception ignored) {
        }
        response.sendRedirect("SongController?action=viewSongs");
    }

    // ================== TÌM KIẾM & TOP ==================
    private void processSearchSong(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = Optional.ofNullable(request.getParameter("keyword")).orElse("").trim();
        List<SongDTO> songs = songService.searchSongsByTitle(keyword);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("listOfSongs", songs);
        transferSessionMessages(request);
        request.getRequestDispatcher("/listOfSongs.jsp").forward(request, response);
    }

    private void processTopSongs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SongDTO> topSongs = songService.getTopSongs(10);
        request.setAttribute("topSongs", topSongs);
        request.getRequestDispatcher("/top10Songs.jsp").forward(request, response);
    }

    // ================== PHÁT NHẠC ==================
    private void processPlaySong(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            String idStr = request.getParameter("songId");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Thiếu ID bài hát.");
                response.sendRedirect("SongController?action=viewSongs");
                return;
            }

            int id = Integer.parseInt(idStr.trim());
            boolean success = songService.increasePlayCount(id);
            if (!success) {
                request.getSession().setAttribute("error", "Không thể tăng lượt nghe.");
                response.sendRedirect("SongController?action=viewSongs");
                return;
            }

            SongDTO song = songService.getSongById(id);
            if (song == null || song.getFilePath() == null || song.getFilePath().isEmpty()) {
                request.getSession().setAttribute("error", "Không tìm thấy bài hát hoặc file.");
                response.sendRedirect("SongController?action=viewSongs");
                return;
            }

            request.setAttribute("song", song);
            // 💖 Lấy thông tin lượt thích
            try {
                // ✅ Tạo SessionFactory an toàn (dùng chung với HibernateUtil hoặc cấu hình hiện có)
                org.hibernate.SessionFactory factory = Util.HibernateUtil.getSessionFactory();
                Model.DAO.SongLikesDAO likesDAO = new Model.DAO.SongLikesDAO(factory);
                Service.SongLikesService likesService = new Service.SongLikesService(likesDAO);

                // Đếm lượt thích hiển thị
                long likeCount = likesService.getLikeCountBySongId(id);

                // Kiểm tra user hiện tại
                HttpSession session = request.getSession(false);
                Model.DTO.UserDTO currentUser = (session != null)
                        ? (Model.DTO.UserDTO) session.getAttribute("user")
                        : null;

                boolean userLiked = false;
                if (currentUser != null) {
                    userLiked = likesService.isLiked(currentUser.getUserID(), id);
                }

                request.setAttribute("likeCount", likeCount);
                request.setAttribute("userLiked", userLiked);

                System.out.println("💗 Song ID=" + id + " | LikeCount=" + likeCount + " | UserLiked=" + userLiked);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("likeCount", 0L);
                request.setAttribute("userLiked", false);
            }

            // 🟢 Load danh sách bình luận
            try {
                List<Model.DTO.CommentDTO> comments = commentService.getCommentsBySongId(id);
                request.setAttribute("comments", comments);
                System.out.println("✅ Đã load " + (comments != null ? comments.size() : 0) + " bình luận cho bài hát ID=" + id);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("comments", new java.util.ArrayList<>());
            }

            request.getRequestDispatcher("/playSong.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi phát bài hát.");
            response.sendRedirect("SongController?action=viewSongs");
        }
    }

    // ================== TRÍCH XUẤT DỮ LIỆU ==================
    private SongDTO extractSongFromRequest(HttpServletRequest request) {
        SongDTO song = new SongDTO();

        // ID
        try {
            String idStr = request.getParameter("songId");
            if (idStr != null && !idStr.trim().isEmpty()) {
                song.setSongId(Integer.parseInt(idStr));
            }
        } catch (Exception ignored) {
        }

        // Tiêu đề, file, ảnh
        song.setTitle(request.getParameter("title"));
        song.setFilePath(request.getParameter("filePath"));
        song.setImagePath(request.getParameter("imagePath"));
        song.setFeatured(request.getParameter("isFeatured") != null);

        // Thời lượng
        try {
            int autoDuration = Util.AudioUtils.getDurationFromMp3(song.getFilePath());
            song.setDuration(autoDuration > 0 ? autoDuration : parseIntSafe(request.getParameter("duration")));
        } catch (Exception e) {
            song.setDuration(parseIntSafe(request.getParameter("duration")));
        }

        // Lượt nghe
        String playCountStr = request.getParameter("playCount");
        song.setPlayCount(parseIntSafe(playCountStr));

        // Album
        try {
            String albumIdStr = request.getParameter("albumId");
            if (albumIdStr != null && !albumIdStr.trim().isEmpty()) {
                int albumId = Integer.parseInt(albumIdStr);
                song.setAlbum(albumService.getAllAlbums().stream()
                        .filter(a -> a.getAlbumId() == albumId)
                        .findFirst().orElse(null));
            }
        } catch (Exception ignored) {
        }

        // Thể loại
        try {
            String genreIdStr = request.getParameter("genreId");
            if (genreIdStr != null && !genreIdStr.trim().isEmpty()) {
                int genreId = Integer.parseInt(genreIdStr);
                song.setGenre(genreService.getAllGenres().stream()
                        .filter(g -> g.getGenreId() == genreId)
                        .findFirst().orElse(null));
            }
        } catch (Exception ignored) {
        }

        // Nghệ sĩ
        String artistNamesStr = request.getParameter("artistNames");
        if (artistNamesStr != null && !artistNamesStr.trim().isEmpty()) {
            String[] names = artistNamesStr.split(",");
            List<Model.DTO.ArtistDTO> artists = new java.util.ArrayList<>();
            for (String name : names) {
                String trimmed = name.trim();
                if (!trimmed.isEmpty()) {
                    Model.DTO.ArtistDTO artist = songService.findOrCreateArtistByName(trimmed);
                    if (artist != null) {
                        artists.add(artist);
                    }
                }
            }
            song.setArtists(artists);
        }

        return song;
    }

    private int parseIntSafe(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return 0;
            }
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    // ================== ẨN DANH SÁCH BÀI HÁT ==================
    private void processViewHiddenSongs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SongDTO> hiddenSongs = songService.getHiddenSongs();
        request.setAttribute("listOfHiddenSongs", hiddenSongs);
        transferSessionMessages(request);
        request.getRequestDispatcher("/listOfHiddenSongs.jsp").forward(request, response);
    }

    private void transferSessionMessages(HttpServletRequest request) {
        HttpSession session = request.getSession();
        for (String key : new String[]{"message", "error", "song"}) {
            Object value = session.getAttribute(key);
            if (value != null) {
                request.setAttribute(key, value);
                session.removeAttribute(key);
            }
        }
    }

    // ✅ Hàm dùng chung để load thông báo cho user hiện tại
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("🔧 Servlet init bắt đầu");

        try {

            CommentDAO commentDAO = new CommentDAO();
            NotificationDAO notificationDAO = new NotificationDAO();
            UserDAO userDAO = new UserDAO();

            this.notificationService = new NotificationService(notificationDAO);
            this.userDAO = userDAO;

            this.commentService = new CommentService(
                    commentDAO,
                    this.notificationService,
                    this.userDAO
            );

            System.out.println("✅ Controllers and Services initialized successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to init SongController dependencies", e);
        }
    }

    private void loadUserNotifications(HttpServletRequest request, UserDTO user) {
        if (user != null) {
            try {
                NotificationService ns = new NotificationService(new NotificationDAO());
                List<Model.DTO.NotificationDTO> unreadNotifications = ns.getUnreadNotificationsByUserId(user.getUserID());
                int unreadCount = ns.countUnreadNotificationsByUserId(user.getUserID());

                request.setAttribute("unreadNotifications", unreadNotifications);
                request.setAttribute("unreadCount", unreadCount);

                HttpSession session = request.getSession();
                session.setAttribute("unreadNotifications", unreadNotifications);
                session.setAttribute("unreadCount", unreadCount);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
