package Service;

import Model.DAO.NotificationDAO;
import Model.DTO.NotificationDTO;
import Model.DTO.SongDTO;
import Model.DTO.UserDTO;
import Util.HibernateUtil;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

public class NotificationService {

    private final NotificationDAO notificationDAO;
    private final SessionFactory factory;

    // =========================================
    // 🔹 CONSTRUCTOR
    // =========================================
    public NotificationService(NotificationDAO notificationDAO) {
        this.notificationDAO = notificationDAO;
        this.factory = HibernateUtil.getSessionFactory(); // ✅ Dùng chung session factory
    }

    // =========================================
    // 🔹 THÊM THÔNG BÁO
    // =========================================
    public boolean addNotification(NotificationDTO notification) {
        return notificationDAO.insert(notification) > 0;
    }

    // =========================================
    // 🔹 ẨN THÔNG BÁO (XÓA MỀM)
    // =========================================
    public boolean hideNotification(Integer id) {
        return notificationDAO.hideNotification(id);
    }

    // =========================================
    // 🔹 LẤY DANH SÁCH THÔNG BÁO
    // =========================================
    public List<NotificationDTO> getAllNotifications() {
        return notificationDAO.selectAll();
    }

    public List<NotificationDTO> getAllVisibleNotifications() {
        return notificationDAO.selectAllVisible();
    }

    public NotificationDTO getNotificationById(Integer id) {
    try (org.hibernate.Session session = factory.openSession()) {
        return session.get(NotificationDTO.class, id);
    } catch (Exception e) {
        e.printStackTrace();
        return null;
    }
}


    public List<NotificationDTO> getNotificationsByUserId(Integer userId) {
        return notificationDAO.selectByUserId(userId);
    }

    public List<NotificationDTO> getNotificationsBySongId(Integer songId) {
        return notificationDAO.selectBySongId(songId);
    }

    // =========================================
    // 🔹 ĐÁNH DẤU ĐÃ ĐỌC
    // =========================================
    public boolean markNotificationAsRead(Integer notificationId) {
        return notificationDAO.markAsRead(notificationId) > 0;
    }

    // =========================================
    // 🔹 LẤY DANH SÁCH CHƯA ĐỌC
    // =========================================
    public List<NotificationDTO> getUnreadNotificationsByUserId(Integer userId) {
        return notificationDAO.selectUnreadByUserId(userId);
    }

    // =========================================
    // 🔹 ĐẾM SỐ THÔNG BÁO CHƯA ĐỌC
    // =========================================
    public int countUnreadNotificationsByUserId(Integer userId) {
        Long count = notificationDAO.countUnreadByUserId(userId);
        return count != null ? count.intValue() : 0;
    }

    // =========================================
    // 🔹 HÀM THÊM THÔNG BÁO TRẢ LỜI BÌNH LUẬN
    // =========================================
    public void addSimpleReplyNotification(int replierId, int receiverId, int songId) {
        Transaction tx = null;
        try (Session session = factory.openSession()) {
            tx = session.beginTransaction();

            // ⚙️ Debug input
            System.out.println("[DEBUG] Replier=" + replierId + ", Receiver=" + receiverId + ", Song=" + songId);

            UserDTO replier = session.get(UserDTO.class, replierId);
            UserDTO receiver = session.get(UserDTO.class, receiverId);
            SongDTO song = session.get(SongDTO.class, songId);

            System.out.println("[DEBUG] Entities found => Replier: " + (replier != null)
                    + ", Receiver: " + (receiver != null)
                    + ", Song: " + (song != null));

            // 🚫 Không gửi thông báo cho chính mình
            if (replierId == receiverId) {
                System.out.println("[INFO] Bỏ qua thông báo vì người bình luận là chính mình.");
                if (tx != null) tx.rollback();
                return;
            }

            if (replier != null && receiver != null && song != null) {
                String message = replier.getUsername() + " đã trả lời bình luận của bạn trong bài: " + song.getTitle();

                NotificationDTO notification = new NotificationDTO(message, receiver, song);
                notification.setIsRead(false);
                notification.setIsHidden(false);

                session.save(notification);
                tx.commit();

                System.out.println("✅ Notification đã được lưu cho user ID: " + receiverId);
            } else {
                System.err.println("⚠️ Không thể tạo thông báo — kiểm tra dữ liệu input hoặc entity null.");
                if (tx != null) tx.rollback();
            }

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("❌ Lỗi khi tạo thông báo phản hồi:");
            e.printStackTrace();
        }
    }
}
