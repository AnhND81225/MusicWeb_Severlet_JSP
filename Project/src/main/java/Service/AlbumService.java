package Service;

import Form.AlbumFormData;
import Model.DAO.AlbumDao;
import Model.DAO.SongDao;
import Model.DTO.AlbumDTO;
import Model.DTO.AlbumStatsDTO;
import Model.DTO.ArtistDTO;
import Model.DTO.GenreDTO;
import Model.DTO.SongDTO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AlbumService {

    private final AlbumDao albumDao = new AlbumDao();
    private final GenreService genreService = new GenreService();
    private final ArtistService artistService = new ArtistService();
    private final SongService songService = new SongService();

    // =========================
    // 🔧 CRUD Album
    // =========================
    public boolean createAlbum(AlbumDTO album) {
        if (album == null || album.getName() == null || album.getName().trim().isEmpty()) {
            return false;
        }
        album.setCreatedDate(LocalDateTime.now());
        album.setUpdatedDate(LocalDateTime.now());
        return albumDao.create(album);
    }

    public boolean updateAlbum(AlbumDTO album) {
        if (album == null || album.getAlbumId() <= 0) {
            return false;
        }
        album.setUpdatedDate(LocalDateTime.now());
        return albumDao.update(album);
    }

    public AlbumDTO getAlbumById(int albumId) {
        return albumDao.getByIdWithDetails(albumId);
    }

    public boolean hideAlbum(int albumId) {
        return albumDao.hide(albumId);
    }

    public boolean restoreAlbum(int albumId) {
        return albumDao.restore(albumId);
    }

    // =========================
    // 📋 Danh sách Album
    // =========================
    public List<AlbumDTO> getAllAlbums() {
        return albumDao.getVisibleAlbums();
    }

    public List<AlbumDTO> getHiddenAlbums() {
        return albumDao.getHiddenAlbums();
    }

    public void updateAlbumSongs(AlbumDTO album, String[] songIds) {
        SongDao songDao = new SongDao();
        List<SongDTO> selectedSongs = new ArrayList<>();

        for (String idStr : songIds) {
            try {
                int id = Integer.parseInt(idStr);
                SongDTO song = songDao.getById(id);
                if (song != null) {
                    song.setAlbum(album); // Gán lại album cho bài hát
                    selectedSongs.add(song);
                }
            } catch (NumberFormatException ignored) {
            }
        }

        album.setSongs(selectedSongs);
    }

    public List<AlbumStatsDTO> getTopAlbumsByPlayCount() {
        return albumDao.getTopAlbumsByPlayCount();
    }

    public List<AlbumDTO> getNewAlbums() {
        return albumDao.getNewAlbums();
    }

    public List<AlbumDTO> getAlbumsSortedByReleaseDate() {
        return albumDao.getSortedByReleaseDate();
    }

    // =========================
    // 🔍 Tìm kiếm & Lọc
    // =========================
    public List<AlbumDTO> searchAlbumsByKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllAlbums();
        }
        return albumDao.searchByKeyword(keyword.trim());
    }

    public List<AlbumDTO> searchAlbumByName(String name) {
        return albumDao.searchAlbumByName(name);
    }

    public List<AlbumDTO> getAlbumsByArtist(int artistId) {
        return albumDao.getByArtist(artistId);
    }

    public List<AlbumDTO> getAlbumsByGenre(int genreId) {
        return albumDao.getByGenre(genreId);
    }

    // =========================
    // 🎵 Bài hát trong Album
    // =========================
    public SongDTO addSongToAlbum(SongDTO song, int albumId) {
        if (song == null) {
            return null;
        }
        return albumDao.addSong(song, albumId);
    }

    // =========================
// 🧠 Xử lý dữ liệu từ request
// =========================
    public AlbumDTO extractAlbumFromRequest(HttpServletRequest request, boolean isUpdate) {
        AlbumDTO album;

        // 🔧 Khởi tạo album theo chế độ thêm hoặc cập nhật
        if (isUpdate) {
            try {
                int id = Integer.parseInt(request.getParameter("albumID"));
                album = getAlbumById(id);
            } catch (Exception e) {
                album = new AlbumDTO();
                album.setAlbumId(-1); // Đánh dấu lỗi nếu cần
            }
        } else {
            album = new AlbumDTO();
            album.setCreatedDate(LocalDateTime.now());
        }

        // 🏷️ Tên album
        album.setName(Optional.ofNullable(request.getParameter("name")).orElse("").trim());

        // 📅 Ngày phát hành
        try {
            String dateStr = request.getParameter("releaseDate");
            if (dateStr != null && !dateStr.trim().isEmpty()) {
                album.setReleaseDate(LocalDate.parse(dateStr).atStartOfDay());
            }
        } catch (Exception e) {
            album.setReleaseDate(null);
        }

        // 👤 Nghệ sĩ
        String artistName = request.getParameter("artistName");
        if (artistName != null && !artistName.trim().isEmpty()) {
            ArtistDTO artist = artistService.findOrCreateByName(artistName.trim());
            album.setArtist(artist);
        }

        // 🎵 Thể loại
        try {
            int genreId = Integer.parseInt(request.getParameter("genreId"));
            GenreDTO genre = genreService.getGenreById(genreId);
            album.setGenre(genre);
        } catch (Exception ignored) {
        }

        // 🖼️ Ảnh bìa
        album.setCoverImage(Optional.ofNullable(request.getParameter("coverImage")).orElse("").trim());

        // 🌟 Nổi bật
        album.setFeatured(request.getParameter("isFeatured") != null);

        // 🎶 Danh sách bài hát
        String[] songIds = request.getParameterValues("songIds[]");
        if (songIds != null && songIds.length > 0) {
            List<SongDTO> selectedSongs = new ArrayList<>();
            for (String idStr : songIds) {
                try {
                    int songId = Integer.parseInt(idStr);
                    SongDTO song = songService.getSongById(songId);
                    if (song != null) {
                        song.setAlbum(album); // ✅ Gán album cho bài hát
                        selectedSongs.add(song);
                    }
                } catch (NumberFormatException ignored) {
                }
            }
            album.setSongs(selectedSongs); // ✅ Gán danh sách bài hát cho album
        }

        // 🕒 Cập nhật thời gian
        album.setUpdatedDate(LocalDateTime.now());

        return album;
    }

    public AlbumFormData prepareFormData() {
        AlbumFormData data = new AlbumFormData();
        data.setGenres(genreService.getAllGenres());
        data.setArtists(artistService.getAllArtists());
        data.setSongs(songService.getAllSongs()); // nếu chưa có

        return data;
    }

    // =========================
    // 💬 Chuyển thông báo từ session sang request
    // =========================
    public void transferSessionMessages(HttpServletRequest request) {
        HttpSession session = request.getSession();
        for (String key : new String[]{"message", "error", "a", "releaseDateStr"}) {
            Object value = session.getAttribute(key);
            if (value != null) {
                request.setAttribute(key, value);
                session.removeAttribute(key);
            }
        }
    }
}
