package Model.DAO;

import Model.DTO.CommentDTO;
import Util.HibernateUtil;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class CommentDAO {

    public CommentDAO() {
        // Không cần truyền SessionFactory, dùng HibernateUtil
    }

    // =========================================
    // 🔹 THÊM COMMENT
    // =========================================
    public int insert(CommentDTO x) {
        Transaction tx = null;
        int kq = 0;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
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

    // =========================================
    // 🔹 ẨN CÁC COMMENT CON CỦA 1 COMMENT CHA
    // =========================================
    public int softDeleteChildren(int parentCommentId) {
    Transaction tx = null;
    int updatedRows = 0;
    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
        tx = session.beginTransaction();
        updatedRows = session.createQuery(
            "UPDATE CommentDTO c SET c.isHidden = true WHERE c.parentComment.commentId = :parentCommentId AND c.isHidden = false"
        )
        .setParameter("parentCommentId", parentCommentId)
        .executeUpdate();
        tx.commit();
    } catch (Exception e) {
        if (tx != null) tx.rollback();
        e.printStackTrace();
    }
    return updatedRows;
}


    // =========================================
    // 🔹 ẨN COMMENT (XÓA MỀM) — KHÔNG ẢNH HƯỞNG COMMENT CON
    // =========================================
    public int softDelete(int id) {
    Transaction tx = null;
    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
        tx = session.beginTransaction();
        CommentDTO c = session.get(CommentDTO.class, id);
        if (c != null && !c.isHidden()) {
            c.setHidden(true);
            session.update(c);
            tx.commit();
            return 1;
        } else {
            if (tx != null) tx.rollback();
        }
    } catch (Exception e) {
        if (tx != null) tx.rollback();
        e.printStackTrace();
    }
    return 0;
}


    // =========================================
    // 🔹 LẤY COMMENT THEO ID
    // =========================================
    public CommentDTO selectById(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            // 🔹 Tải EAGERLY: buộc Hibernate tải luôn UserDTO cùng CommentDTO
            return session.createQuery(
                    "SELECT c FROM CommentDTO c JOIN FETCH c.user WHERE c.commentId = :id",
                    CommentDTO.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    // =========================================
    // 🔹 LẤY DANH SÁCH COMMENT THEO SONG_ID
    // =========================================
    public List<CommentDTO> selectBySongId(int songId) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "SELECT c FROM CommentDTO c "
                    + "JOIN FETCH c.user "
                    + // Tải EAGERLY UserDTO
                    "LEFT JOIN FETCH c.parentComment "
                    + // Tải EAGERLY Parent Comment
                    "WHERE c.song.songId = :songId AND c.isHidden = false "
                    + "ORDER BY c.createdAt DESC", // Mới nhất lên đầu
                    CommentDTO.class)
                    .setParameter("songId", songId)
                    .list();
        }
    }
}
