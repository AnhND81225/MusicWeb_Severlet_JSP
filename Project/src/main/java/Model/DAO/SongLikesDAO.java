package Model.DAO;

import Model.DTO.SongDTO;
import Model.DTO.SongLikesDTO;
import Model.DTO.UserDTO;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

public class SongLikesDAO {

    private SessionFactory factory;

    public SongLikesDAO(SessionFactory factory) {
        this.factory = factory;
    }

    // Thêm like
    public int insert(SongLikesDTO x) {
        int kq = 0;
        Transaction tx = null;
        try ( Session session = factory.openSession()) {
            tx = session.beginTransaction();
            session.save(x);
            tx.commit();
            kq = 1;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
        }
        return kq;
    }

    // Bỏ like (xóa mềm)
    public int deleteSoft(SongLikesDTO x) {
        int kq = 0;
        Transaction tx = null;
        try ( Session session = factory.openSession()) {
            tx = session.beginTransaction();
            SongLikesDTO a = session.get(SongLikesDTO.class, x.getLikeId());
            if (a != null && !a.getIsHidden()) {
                a.setIsHidden(true);
                session.update(a);
                kq = 1;
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
        }
        return kq;
    }

    // Lấy tất cả like (bao gồm cả ẩn nếu muốn)
    public List<SongLikesDTO> selectAll() {
        try ( Session session = factory.openSession()) {
            return session.createQuery("FROM SongLikesDTO", SongLikesDTO.class).list();
        }
    }

    // Lấy like theo ID
    public SongLikesDTO selectById(Integer id) {
        try ( Session session = factory.openSession()) {
            return session.get(SongLikesDTO.class, id);
        }
    }

    // Lấy tất cả like chưa bị ẩn (thường dùng trong app)
    public List<SongLikesDTO> selectAllVisible() {
        try ( Session session = factory.openSession()) {
            return session.createQuery("FROM SongLikesDTO WHERE isHidden = false", SongLikesDTO.class).list();
        }
    }

    public SongLikesDTO selectByUserAndSong(UserDTO user, SongDTO song) {
        try ( Session session = factory.openSession()) {
            return session.createQuery("FROM SongLikesDTO WHERE user = :user AND song = :song", SongLikesDTO.class)
                    .setParameter("user", user)
                    .setParameter("song", song)
                    .uniqueResult();
        }
    }

    public int deleteHard(int likeId) {
        Transaction tx = null;
        try ( Session session = factory.openSession()) {
            tx = session.beginTransaction();
            SongLikesDTO like = session.get(SongLikesDTO.class, likeId);
            if (like != null) {
                session.delete(like);
                tx.commit();
                return 1;
            }
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
        }
        return 0;
    }

    // SỬ DỤNG HQL CHUẨN MỰC
    public long countVisibleLikesBySongId(int songId) {
        try ( Session session = factory.openSession()) {

            // HQL an toàn: Dùng tên thuộc tính DTO và giá trị số 0
            Long count = session.createQuery(
                    // Dùng tên thuộc tính DTO và giá trị số 0
                    // KHÔNG dùng s.likeId (vì nó có thể là lỗi), mà dùng s
                    "SELECT COUNT(s) FROM SongLikesDTO s WHERE s.song.songId = :songId AND s.isHidden = FALSE",
                    Long.class)
                    .setParameter("songId", songId)
                    .uniqueResult();

            // Xử lý NULL: Đảm bảo trả về 0 nếu null
            return count != null ? count : 0;

        } catch (Exception e) {
            // NẾU CÓ LỖI, IN RA CONSOLE VÀ TRẢ VỀ 0
            e.printStackTrace();
            return 0;
        }
    }
}