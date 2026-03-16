package Controller;

import Model.DAO.CommentDAO;
import Model.DAO.NotificationDAO;
import Model.DAO.UserDAO;
import Model.DTO.CommentDTO;
import Model.DTO.UserDTO;
import Service.CommentService;
import Service.NotificationService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.SessionFactory;
import Util.HibernateUtil;

@WebServlet(name = "CommentController", urlPatterns = {"/comment"})
public class CommentController extends HttpServlet {

    private CommentService commentService;
    private NotificationService notificationService;

   @Override
    public void init() throws ServletException {
        // Lấy SessionFactory (Giữ nguyên)
        SessionFactory factory = HibernateUtil.getSessionFactory();
        
        // 1. Khởi tạo các DAO
        NotificationDAO notificationDAO = new NotificationDAO();
        CommentDAO commentDAO = new CommentDAO();
        
        // ⭐ SỬA LỖI: Dùng constructor có tham số để đảm bảo tính nhất quán ⭐
        UserDAO userDAO = new UserDAO(); 

        // 2. Khởi tạo Service
        this.notificationService = new NotificationService(notificationDAO);
        
        // ⭐ ĐÚNG: Truyền đủ 3 dependency vào CommentService ⭐
        this.commentService = new CommentService(commentDAO, this.notificationService, userDAO); 
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    handleAddComment(request, response);
                    break;
                case "delete":
                    handleDeleteComment(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action!");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid numeric parameter!");
        }
    }

    // Controller.CommentController.handleAddComment
// Trong CommentController.java
    // Trong handleAddComment (Đã sửa logic lấy tham số)
// Trong handleAddComment
private void handleAddComment(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

    request.setCharacterEncoding("UTF-8");

    // ✅ 1. Kiểm tra user đăng nhập
    UserDTO currentUser = (UserDTO) request.getSession().getAttribute("user");
    if (currentUser == null) {
        request.getSession().setAttribute("COMMENT_ERROR", "Bạn phải đăng nhập để bình luận!");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ✅ 2. Lấy nội dung và tham số
    String content = request.getParameter("content");
    String songParam = request.getParameter("songID");
    String parentIdParam = request.getParameter("parentCommentId");

    if (songParam == null || songParam.trim().isEmpty()) {
        request.getSession().setAttribute("COMMENT_ERROR", "Thiếu ID bài hát.");
        response.sendRedirect(request.getContextPath() + "/SongController?action=viewSongs");
        return;
    }

    int songId = Integer.parseInt(songParam.trim());
    Integer parentCommentId = null;
    if (parentIdParam != null && !parentIdParam.trim().isEmpty()) {
        parentCommentId = Integer.parseInt(parentIdParam.trim());
    }

    try {
        // ✅ 3. Lưu comment
        boolean success = commentService.addComment(content, currentUser.getUserID(), songId, parentCommentId);

        // ✅ 4. Nếu là reply → gửi thông báo
        if (success && parentCommentId != null) {
            try {
                CommentDTO parentComment = commentService.getCommentById(parentCommentId);
                if (parentComment != null) {
                    int parentUserId = parentComment.getUser().getUserID();
                    int songRefId = parentComment.getSong().getSongId();

                    // 🚫 Không gửi cho chính mình
                    if (parentUserId != currentUser.getUserID()) {
                        this.notificationService.addSimpleReplyNotification(
                                currentUser.getUserID(), // người bình luận
                                parentUserId,            // người nhận
                                songRefId                // bài hát
                        );
                        System.out.println("✅ Gửi thông báo reply từ " + currentUser.getUsername() + " → userId=" + parentUserId);
                    }
                }
            } catch (Exception e) {
                System.err.println("⚠️ Lỗi khi gửi thông báo trả lời: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // ✅ 5. Set message
        if (success) {
            request.getSession().setAttribute("COMMENT_MESSAGE", "Đã thêm bình luận thành công!");
        } else {
            request.getSession().setAttribute("COMMENT_ERROR", "Không thể thêm bình luận.");
        }

    } catch (Exception e) {
        System.err.println("❌ Lỗi khi thêm bình luận: " + e.getMessage());
        e.printStackTrace();
        request.getSession().setAttribute("COMMENT_ERROR", "Lỗi hệ thống khi thêm bình luận.");
    }

    // ✅ 6. Quay lại trang bài hát
    String redirectUrl = request.getContextPath() + "/SongController?action=play&songId=" + songId;
    response.sendRedirect(redirectUrl);
}





// KHÔNG CẦN THIẾT SỬA ĐỔI processPlaySong VÌ BẠN ĐÃ SỬA ĐÚNG SONGID Ở ĐÂY

    private void handleDeleteComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String commentIdParam = request.getParameter("commentId");
        String songIdParam = request.getParameter("songID");

        // Lấy ID người dùng đang đăng nhập
        Model.DTO.UserDTO user = (Model.DTO.UserDTO) request.getSession().getAttribute("user");

        if (user == null) {
            request.getSession().setAttribute("COMMENT_ERROR", "Bạn phải đăng nhập để xóa bình luận!");
            response.sendRedirect(request.getContextPath() + "/UserController");
            return;
        }

        int songId = 0;
        try {
            int commentId = Integer.parseInt(commentIdParam);
            songId = Integer.parseInt(songIdParam);

            // 1. Lấy CommentDTO để kiểm tra ID người dùng
            CommentDTO commentToDelete = commentService.getCommentById(commentId); // ✅ Cần phương thức này trong Service

            if (commentToDelete != null && commentToDelete.getUser().getUserID() == user.getUserID()) {

                // 2. Gọi Service để XÓA (Sử dụng Soft Delete trong DAO của bạn)
                boolean success = commentService.softDelete(commentId); // ✅ Cần phương thức softDelete trong Service

                if (success) {
                    // Thông báo thành công (Có thể đặt vào Session hoặc Request)
                    request.getSession().setAttribute("COMMENT_MESSAGE", "Bình luận đã được xóa thành công!");
                } else {
                    request.getSession().setAttribute("COMMENT_ERROR", "Không thể xóa bình luận do lỗi hệ thống.");
                }
            } else {
                // Lỗi quyền
                request.getSession().setAttribute("COMMENT_ERROR", "Bạn không có quyền xóa bình luận này.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("COMMENT_ERROR", "Lỗi hệ thống khi xóa bình luận.");
        }

        // Quay lại trang nhạc
       String redirectUrl = request.getContextPath() + "/SongController?action=play&songId=" + songId;
response.sendRedirect(redirectUrl);
    }
}
