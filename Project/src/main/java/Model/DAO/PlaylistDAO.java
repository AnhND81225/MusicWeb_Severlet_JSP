package Model.DAO;

import Model.DTO.PlaylistDTO;
import Model.DTO.UserDTO;
import Util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;

public class PlaylistDAO {

    // Thêm playlist mới
    public PlaylistDTO addPlaylist(PlaylistDTO playlist) {
        Transaction tx = null;
        try {
            Session session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            session.save(playlist); // Hibernate tự sinh ID
            tx.commit();
            return playlist; // đã có playlistId sau commit
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return null;
        }
    }

    // Cập nhật playlist
    public boolean updatePlaylist(PlaylistDTO playlist) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            playlist.setUpdatedAt(LocalDateTime.now());
            session.update(playlist);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    // Xóa mềm playlist (ẩn playlist)
    public boolean hidePlaylist(int playlistId) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            PlaylistDTO playlist = session.get(PlaylistDTO.class, playlistId);
            if (playlist != null) {
                playlist.setHidden(true);
                playlist.setUpdatedAt(LocalDateTime.now());
                session.update(playlist);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    // Lấy playlist theo ID
    public PlaylistDTO getById(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(PlaylistDTO.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy tất cả playlist của 1 user
    public List<PlaylistDTO> getByUser(UserDTO user) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM tblPlayList p WHERE p.user = :user AND p.hidden = false";
            Query<PlaylistDTO> query = session.createQuery(hql, PlaylistDTO.class);
            query.setParameter("user", user);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy tất cả playlist (admin)
    public List<PlaylistDTO> getAll() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM tblPlayList", PlaylistDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
// Lấy tất cả playlist bị ẩn của 1 user

    public List<PlaylistDTO> getHiddenByUser(UserDTO user) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM tblPlayList p WHERE p.user = :user AND p.hidden = true";
            Query<PlaylistDTO> query = session.createQuery(hql, PlaylistDTO.class);
            query.setParameter("user", user);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
// Restore playlist

    public boolean restorePlaylist(int playlistId) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            PlaylistDTO playlist = session.get(PlaylistDTO.class, playlistId);
            if (playlist != null) {
                playlist.setHidden(false);
                playlist.setUpdatedAt(LocalDateTime.now());
                session.update(playlist);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    // Lấy playlist theo tên (dùng sau khi tạo để lấy lại ID)
    public PlaylistDTO getPlaylistByName(int userId, String name) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM tblPlayList p WHERE p.user.userId = :userId AND p.name = :name AND p.hidden = false ORDER BY p.createdAt DESC";
            Query<PlaylistDTO> query = session.createQuery(hql, PlaylistDTO.class);
            query.setParameter("userId", userId);
            query.setParameter("name", name);
            query.setMaxResults(1);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
