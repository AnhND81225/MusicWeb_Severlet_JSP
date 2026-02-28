/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import Model.DAO.SongLikesDAO;
import Model.DTO.SongDTO;
import Model.DTO.SongLikesDTO;
import Model.DTO.UserDTO;
import java.util.List;

public class SongLikesService {

    private SongLikesDAO dao;

    public SongLikesService(SongLikesDAO dao) {
        this.dao = dao;
    }

    // Thêm like
    public boolean addLike(UserDTO user, SongDTO song) {
        SongLikesDTO existing = dao.selectByUserAndSong(user, song);
        if (existing == null) {
            return dao.insert(new SongLikesDTO(user, song)) > 0;
        }
        return false;
    }

    // Bỏ like (xóa mềm)
    public boolean removeLike(SongLikesDTO like) {
        return dao.deleteSoft(like) > 0;
    }

    // Lấy tất cả like (có thể bao gồm ẩn)
    public List<SongLikesDTO> getAllLikes() {
        return dao.selectAll();
    }

    // Lấy tất cả like hiển thị (isHidden = false)
    public List<SongLikesDTO> getAllVisibleLikes() {
        return dao.selectAllVisible();
    }

    // Lấy like theo ID
    public SongLikesDTO getLikeById(Integer id) {
        return dao.selectById(id);
    }

    public boolean toggleLike(int userId, int songId) {
        // Tạo DTO tham chiếu ID an toàn
        UserDTO user = new UserDTO();
        user.setUserID(userId);
        SongDTO song = new SongDTO();
        song.setSongId(songId);

        // 1. Kiểm tra sự tồn tại của Like (kể cả đã ẩn)
        SongLikesDTO existingLike = dao.selectByUserAndSong(user, song);

        if (existingLike == null) {
            SongLikesDTO newLike = new SongLikesDTO(user, song);
            newLike.setIsHidden(Boolean.FALSE); // <-- BẮT BUỘC SỬA
            return dao.insert(newLike) > 0;

        } else if (existingLike.getIsHidden()) {
            // TRƯỜNG HỢP 2: Đã từng Like, nhưng bị xóa mềm (isHidden=true) -> Khôi phục (LIKE)
            existingLike.setIsHidden(false);
            // Cần phương thức update/restore trong DAO (chưa có, nên dùng softDelete logic ngược)
            // Vì DAO của bạn dùng deleteSoft, chúng ta cần một hàm restore.
            // Tạm thời, giả sử DAO có hàm update
            // return dao.restore(existingLike) > 0; 

            // Hoặc cách đơn giản nhất: Xóa record cũ và tạo record mới (Nếu bạn không cần lịch sử isHidden)
            dao.deleteHard(existingLike.getLikeId()); // Giả định hàm xóa cứng tồn tại
            return dao.insert(new SongLikesDTO(user, song)) > 0;

        } else {
            // TRƯỜNG HỢP 3: Đã Like (isHidden=false) -> Bỏ thích (UNLIKE - Xóa mềm)
            return dao.deleteSoft(existingLike) > 0;
        }
    }

    /**
     * Kiểm tra xem User đã Like bài hát này chưa (chỉ kiểm tra trạng thái hiển
     * thị).
     */
    public boolean isLiked(int userId, int songId) {
        UserDTO user = new UserDTO();
        user.setUserID(userId);
        SongDTO song = new SongDTO();
        song.setSongId(songId);

        SongLikesDTO like = dao.selectByUserAndSong(user, song);
        return like != null && !like.getIsHidden();
    }

    //lay so luot like hien thi cho 1 bai hat
    public long getLikeCountBySongId(int songId) {
        return dao.countVisibleLikesBySongId(songId);
    }

}
