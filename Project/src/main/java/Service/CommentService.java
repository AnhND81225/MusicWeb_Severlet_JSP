package Service;

import Model.DAO.CommentDAO;
import Model.DAO.UserDAO;
import Model.DTO.CommentDTO;
import Model.DTO.SongDTO;
import Model.DTO.UserDTO;
import java.util.List;

public class CommentService {

    private final CommentDAO commentDAO;
    private final UserDAO userDAO;
    private final NotificationService notificationService; // Giữ lại dependency để dùng nếu cần trong tương lai

    // ✅ Constructor
    public CommentService(CommentDAO commentDAO, NotificationService notificationService, UserDAO userDAO) {
        this.commentDAO = commentDAO;
        this.notificationService = notificationService;
        this.userDAO = userDAO;
    }

    // ✅ Lấy comment theo ID
    public CommentDTO getCommentById(int commentId) {
        return commentDAO.selectById(commentId);
    }

    // ✅ Thêm bình luận (Comment hoặc Reply)
    public boolean addComment(String content, int userId, int songId, Integer parentCommentId) {
        try {
            // 1️⃣ Tải User người bình luận
            UserDTO replierUser = userDAO.getUserById(userId);
            if (replierUser == null) {
                System.err.println("❌ Không tìm thấy User ID: " + userId);
                return false;
            }

            // 2️⃣ Khởi tạo đối tượng SongDTO cho khóa ngoại
            SongDTO song = new SongDTO();
            song.setSongId(songId);

            // 3️⃣ Tạo comment mới
            CommentDTO comment = new CommentDTO(content.trim(), replierUser, song);

            // 4️⃣ Nếu là reply → gán tham chiếu comment cha
            if (parentCommentId != null) {
                CommentDTO parentRef = new CommentDTO();
                parentRef.setCommentId(parentCommentId);
                comment.setParentComment(parentRef);
            }

            // 5️⃣ Lưu vào DB
            int result = commentDAO.insert(comment);
            boolean success = result == 1;

            if (success) {
                System.out.println("✅ Đã thêm bình luận thành công cho bài hát ID=" + songId);
            } else {
                System.err.println("⚠️ Thêm bình luận thất bại cho bài hát ID=" + songId);
            }

            // ❌ KHÔNG gửi notification ở đây — đã xử lý ở CommentController
            return success;

        } catch (Exception e) {
            System.err.println("⚠️ Lỗi trong addComment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Xóa mềm bình luận
    public boolean softDelete(int commentId) {
        try {
            // 1️⃣ Xóa mềm comment cha
            boolean parentDeleted = commentDAO.softDelete(commentId) == 1;

            if (parentDeleted) {
                // 2️⃣ Xóa mềm tất cả comment con (reply)
                commentDAO.softDeleteChildren(commentId);
                System.out.println("🗑️ Đã ẩn bình luận #" + commentId + " và các phản hồi con.");
                return true;
            } else {
                System.err.println("⚠️ Không thể xóa bình luận #" + commentId + " (có thể đã bị ẩn trước đó).");
                return false;
            }
        } catch (Exception e) {
            System.err.println("⚠️ Lỗi khi xóa bình luận: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Lấy danh sách comment theo bài hát
    public List<CommentDTO> getCommentsBySongId(int songId) {
        try {
            return commentDAO.selectBySongId(songId);
        } catch (Exception e) {
            System.err.println("⚠️ Lỗi khi lấy danh sách comment cho bài hát ID=" + songId);
            e.printStackTrace();
            return java.util.Collections.emptyList();
        }
    }

    // ✅ Xóa cứng (nếu cần dùng trong admin)
    public int deleteComment(int commentId) {
        CommentDTO comment = commentDAO.selectById(commentId);
        if (comment == null || comment.isHidden()) {
            return -1;
        }
        if (commentDAO.softDelete(commentId) == 1) {
            return comment.getSong().getSongId();
        }
        return -1;
    }
}