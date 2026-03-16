package Model.DAO;

import Model.DTO.NotificationDTO;
import Model.DTO.SongDTO;
import Model.DTO.UserDTO;
import Util.HibernateUtil;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.NativeQuery;

public class NotificationDAO {

    public NotificationDAO() {}

    // ====================================================
    // 🔹 THÊM THÔNG BÁO
    // ====================================================
    public int insert(NotificationDTO x) {
        int kq = 0;
        Transaction tx = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // Gắn entity tham chiếu nếu cần
            if (x.getUser() != null && x.getUser().getUserID() != null) {
                UserDTO userRef = session.get(UserDTO.class, x.getUser().getUserID());
                x.setUser(userRef);
            }

            if (x.getSong() != null && x.getSong().getSongId() != 0) {
                SongDTO songRef = session.get(SongDTO.class, x.getSong().getSongId());
                x.setSong(songRef);
            }

            if (x.getIsRead() == null) x.setIsRead(false);
            if (x.getIsHidden() == null) x.setIsHidden(false);

            session.save(x);
            session.flush();
            tx.commit();
            kq = 1;

            System.out.println("✅ Notification saved for user_id=" + x.getUser().getUserID()
                    + ", song_id=" + (x.getSong() != null ? x.getSong().getSongId() : "null"));

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("❌ Error inserting notification:");
            e.printStackTrace();
        }

        return kq;
    }

    // ====================================================
    // 🔹 ẨN THÔNG BÁO (XÓA MỀM)
    // ====================================================
    public boolean hideNotification(Integer id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            NotificationDTO notification = session.get(NotificationDTO.class, id);
            if (notification != null && (notification.getIsHidden() == null || !notification.getIsHidden())) {
                notification.setIsHidden(true);
                session.update(notification);
                tx.commit();
                return true;
            }
            if (tx != null) tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("❌ Error hiding notification ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ====================================================
    // 🔹 LẤY TẤT CẢ THÔNG BÁO
    // ====================================================
    public List<NotificationDTO> selectAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql = "SELECT * FROM notification ORDER BY created_at DESC";
            NativeQuery<NotificationDTO> query = session.createNativeQuery(sql, NotificationDTO.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ====================================================
    // 🔹 LẤY TẤT CẢ THÔNG BÁO KHÔNG ẨN
    // ====================================================
    public List<NotificationDTO> selectAllVisible() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql =
                "SELECT * FROM notification " +
                "WHERE (is_hidden = false OR is_hidden IS NULL) " +
                "ORDER BY created_at DESC";
            NativeQuery<NotificationDTO> query = session.createNativeQuery(sql, NotificationDTO.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ====================================================
    // 🔹 LẤY THEO USER_ID
    // ====================================================
    public List<NotificationDTO> selectByUserId(Integer userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql =
                "SELECT * FROM notification " +
                "WHERE user_id = :userId " +
                "AND (is_hidden = false OR is_hidden IS NULL) " +
                "ORDER BY created_at DESC";
            NativeQuery<NotificationDTO> query = session.createNativeQuery(sql, NotificationDTO.class);
            query.setParameter("userId", userId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ====================================================
    // 🔹 LẤY CHƯA ĐỌC THEO USER_ID
    // ====================================================
    public List<NotificationDTO> selectUnreadByUserId(Integer userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql =
                "SELECT * FROM notification " +
                "WHERE user_id = :userId " +
                "AND (is_hidden = false OR is_hidden IS NULL) " +
                "AND (is_read = false OR is_read IS NULL) " +
                "ORDER BY created_at DESC";
            NativeQuery<NotificationDTO> query = session.createNativeQuery(sql, NotificationDTO.class);
            query.setParameter("userId", userId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ====================================================
    // 🔹 LẤY THEO SONG_ID
    // ====================================================
    public List<NotificationDTO> selectBySongId(Integer songId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql =
                "SELECT * FROM notification " +
                "WHERE song_id = :songId " +
                "AND (is_hidden = false OR is_hidden IS NULL) " +
                "ORDER BY created_at DESC";
            NativeQuery<NotificationDTO> query = session.createNativeQuery(sql, NotificationDTO.class);
            query.setParameter("songId", songId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ====================================================
    // 🔹 ĐÁNH DẤU ĐÃ ĐỌC
    // ====================================================
    public int markAsRead(Integer notificationId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            NotificationDTO notification = session.get(NotificationDTO.class, notificationId);
            if (notification != null && (notification.getIsRead() == null || !notification.getIsRead())) {
                notification.setIsRead(true);
                session.update(notification);
                tx.commit();
                return 1;
            }
            if (tx != null) tx.rollback();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
        return 0;
    }

    // ====================================================
    // 🔹 ĐẾM SỐ THÔNG BÁO CHƯA ĐỌC
    // ====================================================
    public Long countUnreadByUserId(Integer userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql =
                "SELECT COUNT(*) FROM notification " +
                "WHERE user_id = :userId " +
                "AND (is_hidden = false OR is_hidden IS NULL) " +
                "AND (is_read = false OR is_read IS NULL)";
            NativeQuery<?> query = session.createNativeQuery(sql);
            query.setParameter("userId", userId);
            Object result = query.uniqueResult();
            if (result instanceof Number) {
                return ((Number) result).longValue();
            }
            return 0L;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }
}
