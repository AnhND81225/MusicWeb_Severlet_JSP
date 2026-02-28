    package Controller;

    import Model.DTO.AlbumDTO;
    import Model.DTO.ArtistDTO;
    import Model.DTO.SongDTO;
    import Service.AlbumService;
    import Service.ArtistService;
    import Service.SongService;
    import Service.ValidationService;

    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.*;
    import java.io.IOException;
    import java.util.List;
    import java.util.Optional;

    @WebServlet(name = "ArtistController", urlPatterns = {"/ArtistController"})
    public class ArtistController extends HttpServlet {

        private final ArtistService artistService = new ArtistService();
        private final ValidationService validator = new ValidationService();
        private final AlbumService albumService = new AlbumService();
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

            String action = Optional.ofNullable(request.getParameter("txtAction")).orElse("viewArtist");

            switch (action) {
                case "addArtist":
                    processAddArtist(request, response);
                    break;
                case "updateArtist":
                    processUpdateArtist(request, response);
                    break;
                case "callAdd":
                    showForm(request, response, null);
                    break;
                case "callUpdate":
                    showUpdateForm(request, response);
                    break;
                case "hideArtist":
                    processHideArtist(request, response);
                    break;
                case "search":
                    processSearchArtist(request, response);
                    break;
                case "artistInfo":
                    processArtistInfo(request, response);
                    break;
                case "follow":
                    processFollowArtist(request, response);
                    break;
                case "top10":
                    processTop10Artists(request, response);
                    break;
                case "restoreArtist":
                    processRestoreArtist(request, response);
                    break;
                case "viewHiddenArtist":
                    processViewHiddenArtists(request, response);
                    break;

                default:
                    processViewArtists(request, response);
                    break;
            }
        }

        private void processViewArtists(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            List<ArtistDTO> artists = artistService.getAllArtists();
            request.setAttribute("listOfArtists", artists);
            transferSessionMessages(request);
            request.getRequestDispatcher("/listOfArtists.jsp").forward(request, response);
        }

        private void showForm(HttpServletRequest request, HttpServletResponse response, ArtistDTO artist)
                throws ServletException, IOException {
            request.setAttribute("artist", artist);
            transferSessionMessages(request);
            request.getRequestDispatcher("/artistForm.jsp").forward(request, response);
        }

        private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            String idStr = request.getParameter("artistID");

            try {
                if (idStr == null || !idStr.matches("\\d+")) {
                    throw new IllegalArgumentException("ID không hợp lệ");
                }

                int id = Integer.parseInt(idStr);
                ArtistDTO artist = artistService.getByIdWithDetails(id); // ✅ chỉ lấy nghệ sĩ chưa bị ẩn

                if (artist == null) {
                    throw new Exception("Không tìm thấy nghệ sĩ cần cập nhật.");
                }

                showForm(request, response, artist);
            } catch (Exception e) {
                request.getSession().setAttribute("error", e.getMessage());
                response.sendRedirect("ArtistController?txtAction=viewArtist");
            }
        }

        private void processAddArtist(HttpServletRequest request, HttpServletResponse response)
                throws IOException {
            ArtistDTO artist = artistService.extractArtistFromRequest(request);

            if (!validator.isValid(artist)) {
                request.getSession().setAttribute("error", "Thông tin nghệ sĩ không hợp lệ.");
                request.getSession().setAttribute("artist", artist);
                response.sendRedirect("ArtistController?txtAction=callAdd");
                return;
            }

            boolean success = artistService.addArtist(artist);
            request.getSession().setAttribute(success ? "message" : "error",
                    success ? "Đã thêm nghệ sĩ thành công!" : "Không thể thêm nghệ sĩ.");
            response.sendRedirect("ArtistController?txtAction=viewArtist");
        }

        private void processUpdateArtist(HttpServletRequest request, HttpServletResponse response)
                throws IOException {
            ArtistDTO artist = artistService.extractArtistFromRequest(request);

            if (!validator.isValid(artist)) {
                request.getSession().setAttribute("error", "Thông tin nghệ sĩ không hợp lệ.");
                request.getSession().setAttribute("artist", artist);
                response.sendRedirect("ArtistController?txtAction=callUpdate&artistID=" + artist.getArtistId());
                return;
            }

            boolean success = artistService.updateArtist(artist);
            request.getSession().setAttribute(success ? "message" : "error",
                    success ? "Đã cập nhật nghệ sĩ thành công!" : "Không thể cập nhật nghệ sĩ.");
            response.sendRedirect("ArtistController?txtAction=viewArtist");
        }

        private void processHideArtist(HttpServletRequest request, HttpServletResponse response)
                throws IOException {
            try {
                int id = Integer.parseInt(request.getParameter("artistID"));
                artistService.hideArtist(id);
            } catch (Exception ignored) {
            }
            response.sendRedirect("ArtistController?txtAction=viewArtist");
        }

        private void processSearchArtist(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            String keyword = Optional.ofNullable(request.getParameter("keyword")).orElse("").trim();

            List<ArtistDTO> matchedArtists = artistService.searchArtistsByName(keyword);

            request.setAttribute("listOfArtists", matchedArtists);
            request.setAttribute("searchKeyword", keyword);
            request.getRequestDispatcher("/listOfArtists.jsp").forward(request, response);
        }

        private void processTop10Artists(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            List<ArtistDTO> topArtists = artistService.getTopArtistsByFollowerCount(10); // lấy top 10
            request.setAttribute("topArtists", topArtists);
            transferSessionMessages(request);
            request.getRequestDispatcher("/top10Artist.jsp").forward(request, response);
        }

        private void processRestoreArtist(HttpServletRequest request, HttpServletResponse response) throws IOException {
            try {
                int id = Integer.parseInt(request.getParameter("artistID"));
                boolean success = artistService.restoreArtist(id);
                request.getSession().setAttribute(success ? "message" : "error",
                        success ? "Đã khôi phục nghệ sĩ!" : "Không thể khôi phục.");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Lỗi khi khôi phục nghệ sĩ.");
            }
            response.sendRedirect("ArtistController?txtAction=viewHiddenArtist");
        }

        private void processViewHiddenArtists(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            List<ArtistDTO> hiddenArtists = artistService.getHiddenArtists();
            request.setAttribute("listOfArtists", hiddenArtists);
            transferSessionMessages(request);
            request.getRequestDispatcher("/listOfHiddenArtist.jsp").forward(request, response);
        }

        private void processArtistInfo(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            try {
                int artistId = Integer.parseInt(request.getParameter("artistID"));
                HttpSession session = request.getSession();

                // ✅ Lấy thông tin người dùng hiện tại (nếu đăng nhập)
                Integer userId = (Integer) session.getAttribute("userId");

                // Lấy thông tin nghệ sĩ
                ArtistDTO artist = artistService.getByIdWithDetails(artistId);
                List<SongDTO> songs = songService.getSongsByArtist(artistId);
                List<AlbumDTO> albums = albumService.getAlbumsByArtist(artistId);

                for (AlbumDTO album : albums) {
                    List<SongDTO> albumSongs = songService.getSongsByAlbum(album.getAlbumId());
                    album.setSongs(albumSongs);
                }

                // ✅ Kiểm tra xem user đã follow nghệ sĩ này chưa
                boolean hasFollowed = false;
                if (userId != null) {
                    hasFollowed = artistService.hasUserFollowedArtist(userId, artistId);
                }

                // ✅ Truyền dữ liệu sang JSP
                request.setAttribute("artist", artist);
                request.setAttribute("songs", songs);
                request.setAttribute("albums", albums);
                request.setAttribute("hasFollowed", hasFollowed);

                request.getRequestDispatcher("/artistInformation.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("ArtistController?txtAction=viewArtist");
            }
        }

        private void processFollowArtist(HttpServletRequest request, HttpServletResponse response)
                throws IOException {
            HttpSession session = request.getSession();

            try {
                // ✅ Lấy user hiện tại từ session (ví dụ bạn lưu user sau khi login)
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null) {
                    session.setAttribute("error", "Bạn cần đăng nhập để follow nghệ sĩ.");
                    response.sendRedirect("login.jsp");
                    return;
                }

                int artistId = Integer.parseInt(request.getParameter("artistID"));

                // ✅ Kiểm tra nếu user đã follow rồi
                if (artistService.hasUserFollowedArtist(userId, artistId)) {
                    session.setAttribute("error", "Bạn đã follow nghệ sĩ này rồi!");
                } else {
                    boolean success = artistService.followArtist(userId, artistId);
                    session.setAttribute(success ? "message" : "error",
                            success ? "Đã follow nghệ sĩ thành công!" : "Không thể follow nghệ sĩ.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Đã xảy ra lỗi khi follow nghệ sĩ.");
            }

            // ✅ Quay lại trang thông tin nghệ sĩ
            response.sendRedirect("ArtistController?txtAction=artistInfo&artistID=" + request.getParameter("artistID"));
        }

        private void transferSessionMessages(HttpServletRequest request) {
            HttpSession session = request.getSession();
            for (String key : new String[]{"message", "error", "artist"}) {
                Object value = session.getAttribute(key);
                if (value != null) {
                    request.setAttribute(key, value);
                    session.removeAttribute(key);
                }
            }
        }
    }
