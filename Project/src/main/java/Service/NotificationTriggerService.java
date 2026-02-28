package Service;

import Model.DTO.NotificationDTO;
import Model.DTO.UserDTO;
import Model.DTO.SongDTO;
import java.util.List;

public class NotificationTriggerService {

    private final NotificationService notificationService;

    public NotificationTriggerService(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    /**
     * 🔔 Khi người dùng trả lời bình luận → Gửi thông báo cho người viết bình luận gốc.
     */
    public void onCommentReplied(UserDTO replier, UserDTO parentUser, SongDTO song) {
        // Không gửi cho chính người trả lời
        if (parentUser != null && replier != null 
                && !replier.getUserID().equals(parentUser.getUserID())) {

            String msg = replier.getUsername()
                    + " đã trả lời bình luận của bạn trong bài: "
                    + song.getTitle();

            NotificationDTO n = new NotificationDTO(msg, parentUser, song);
            notificationService.addNotification(n);
        }
    }

    /**
     * 🔔 Khi ADMIN thêm bài hát mới → Gửi thông báo cho toàn bộ người dùng.
     */
    public void onNewSongAddedByAdmin(UserDTO admin, SongDTO song, List<UserDTO> allUsers) {
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            // Không phải admin thì không được gửi thông báo
            return;
        }

        for (UserDTO user : allUsers) {
            // Bỏ qua chính admin
            if (!user.getUserID().equals(admin.getUserID())) {
                String msg = "🎵 Bài hát mới vừa được thêm: " + song.getTitle();
                NotificationDTO n = new NotificationDTO(msg, user, song);
                notificationService.addNotification(n);
            }
        }
    }
}
