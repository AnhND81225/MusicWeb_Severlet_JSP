package Service;

import Model.DAO.GenreDao;
import Model.DTO.GenreDTO;

import java.util.List;

public class GenreService {

    private final GenreDao genreDao = new GenreDao();

    // Thêm genre
    public boolean addGenre(GenreDTO genre) {
        return genreDao.insert(genre);
    }

    // Cập nhật genre
    public boolean updateGenre(GenreDTO genre) {
        return genreDao.update(genre);
    }

    // Ẩn genre
    public boolean hideGenre(int id) {
        return genreDao.hide(id);
    }

    // Hiển thị lại genre
    public boolean restoreGenre(int id) {
        return genreDao.restore(id);
    }

    // Lấy genre theo id
    public GenreDTO getGenreById(int id) {
        return genreDao.getById(id);
    }

    // Lấy genre theo id kèm songs
    public GenreDTO getGenreByIdWithSongs(int id) {
        return genreDao.getByIdWithSongs(id);
    }

    // Lấy genre theo id kèm tất cả chi tiết
    public GenreDTO getGenreByIdWithDetails(int id) {
        return genreDao.getByIdWithDetails(id);
    }

    // Lấy tất cả genre
    public List<GenreDTO> getAllGenres() {
        return genreDao.getAll();
    }

    // Lấy tất cả genre chưa bị ẩn
    public List<GenreDTO> getVisibleGenres() {
        return genreDao.getVisibleGenres();
    }

    // Lấy tất cả genre đã bị ẩn
    public List<GenreDTO> getHiddenGenres() {
        return genreDao.getHiddenGenres();
    }

    // Lấy tất cả genre kèm chi tiết
    public List<GenreDTO> getAllGenresWithDetails() {
        return genreDao.getAllWithDetails();
    }

    // Lấy các genre nổi bật
    public List<GenreDTO> getFeaturedGenres() {
        return genreDao.getFeaturedGenres();
    }

    // Tìm kiếm genre
    public List<GenreDTO> searchGenres(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getVisibleGenres();
        }
        return genreDao.searchByKeyword(keyword.trim());
    }
}
