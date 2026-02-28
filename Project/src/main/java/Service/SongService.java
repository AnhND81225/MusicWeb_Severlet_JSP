package Service;

import Model.DAO.SongDao;
import Model.DTO.ArtistDTO;
import Model.DTO.SongDTO;

import java.util.Collections;
import java.util.List;

public class SongService {

    private final SongDao songDao = new SongDao();

    private final GenreService genreService = new GenreService();
    private final ArtistService artistService = new ArtistService();
    // =========================
    // 🔧 CRUD
    // =========================

    public boolean addSong(SongDTO song) {
        try {
            return songDao.insert(song);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSong(SongDTO song) {
        try {
            return songDao.update(song);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hideSong(int songId) {
        try {
            return songDao.hide(songId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<SongDTO> getAllSongsWithDetails() {
        return songDao.getAllWithDetails();
    }

    public boolean restoreSong(int songId) {
        try {
            return songDao.restore(songId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================
    // 📋 Truy vấn
    // =========================
    public SongDTO getSongById(int songId) {
        try {
            return songDao.getById(songId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<SongDTO> getAllSongs() {
        try {
            return songDao.getAll();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> getHiddenSongs() {
        try {
            return songDao.getHidden();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> getSongsByAlbum(int albumId) {
        try {
            return songDao.getByAlbum(albumId);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> getSongsByArtist(int artistId) {
        try {
            return songDao.getByArtist(artistId);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> getSongsByGenre(int genreId) {
        try {
            return songDao.getByGenre(genreId);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // =========================
    // 🔍 Tìm kiếm & Lọc
    // =========================
    public List<SongDTO> searchSongs(String keyword) {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return getAllSongs();
            }
            return songDao.searchByKeyword(keyword.trim());
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> getNewSongs() {
        try {
            return songDao.getNewSongs();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> searchSongsByTitle(String title) {
        return new SongDao().searchByTitle(title);
    }

    public List<SongDTO> getFeaturedSongs() {
        try {
            return songDao.getFeaturedSongs();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> getTopSongs(int limit) {
        try {
            return songDao.getTopSongs(limit);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Model.DTO.GenreDTO> getAllGenres() {
        try {
            return genreService.getAllGenres();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public ArtistDTO findOrCreateArtistByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        return artistService.findOrCreateByName(name.trim());
    }

    // =========================
    // ▶️ Tăng lượt nghe
    // =========================
    public boolean increasePlayCount(int songId) {
        try {
            return songDao.increasePlayCount(songId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // =========================
// 🔀 Lấy bài hát ngẫu nhiên
// =========================

    public SongDTO getRandomSong() {
        try {
            List<SongDTO> songs = songDao.getAllWithDetails();
            if (songs == null || songs.isEmpty()) {
                return null;
            }
            java.util.Random random = new java.util.Random();
            return songs.get(random.nextInt(songs.size()));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
