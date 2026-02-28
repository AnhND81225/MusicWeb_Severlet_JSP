package Model.DAO;

import Model.DTO.ArtistDTO;
import Model.DTO.UserDTO;
import Model.DTO.UserFollowArtist;
import Util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.Collections;
import java.util.List;

public class ArtistDao {

    public boolean insert(ArtistDTO artist) {
        Transaction tx = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            session.save(artist);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.getStatus().canRollback()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    public boolean update(ArtistDTO artist) {
        Transaction tx = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            session.merge(artist);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.getStatus().canRollback()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    public boolean hide(int id) {
        Transaction tx = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            ArtistDTO artist = session.get(ArtistDTO.class, id);
            if (artist == null) {
                return false;
            }
            artist.setHidden(true);
            session.update(artist);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.getStatus().canRollback()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    public ArtistDTO getById(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(ArtistDTO.class, id);
        }
    }

    public ArtistDTO getByIdWithDetails(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM ArtistDTO a "
                    + "LEFT JOIN FETCH a.albums "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.artistId = :id AND a.isHidden = false";
            return session.createQuery(hql, ArtistDTO.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    public ArtistDTO getByIdIncludingHidden(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM ArtistDTO a "
                    + "LEFT JOIN FETCH a.albums "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.artistId = :id";
            return session.createQuery(hql, ArtistDTO.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    public List<ArtistDTO> getAll() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM ArtistDTO WHERE isHidden = false", ArtistDTO.class).list();
        }
    }

    public List<ArtistDTO> getAllWithAlbums() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM ArtistDTO a "
                    + "LEFT JOIN FETCH a.albums "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = false";
            return session.createQuery(hql, ArtistDTO.class).list();
        }
    }

    public List<ArtistDTO> getPopularWithAlbums() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM ArtistDTO a "
                    + "LEFT JOIN FETCH a.albums "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = false AND a.isPopular = true";
            return session.createQuery(hql, ArtistDTO.class).list();
        }
    }

    public List<ArtistDTO> getTopArtistsByFollowerCount(int limit) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM ArtistDTO a WHERE a.isHidden = false ORDER BY a.followerCount DESC";
            return session.createQuery(hql, ArtistDTO.class)
                    .setMaxResults(limit)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public boolean incrementFollower(int artistId) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();

            ArtistDTO artist = session.get(ArtistDTO.class, artistId);
            if (artist == null || artist.isHidden()) {
                return false;
            }

            artist.setFollowerCount(artist.getFollowerCount() + 1);
            session.update(artist);

            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean restore(int id) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            ArtistDTO artist = session.get(ArtistDTO.class, id);
            if (artist == null) {
                return false;
            }
            artist.setHidden(false);
            session.update(artist);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.getStatus().canRollback()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
// Lấy danh sách nghệ sĩ đã bị ẩn

    public List<ArtistDTO> getAllHidden() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM ArtistDTO WHERE isHidden = true", ArtistDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<ArtistDTO> searchByName(String name) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM ArtistDTO a "
                    + "WHERE a.isHidden = false AND LOWER(a.name) LIKE :name";
            return session.createQuery(hql, ArtistDTO.class)
                    .setParameter("name", "%" + name.toLowerCase() + "%")
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
// ✅ Kiểm tra người dùng đã follow nghệ sĩ chưa

    public boolean hasUserFollowedArtist(int userId, int artistId) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(u) FROM UserFollowArtist u WHERE u.user.userID = :userId AND u.artist.artistId = :artistId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("userId", userId)
                    .setParameter("artistId", artistId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

// ✅ Thực hiện follow nếu chưa có, và tăng followerCount cho nghệ sĩ
    public boolean followArtist(int userId, int artistId) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // Kiểm tra tồn tại
            String checkHql = "SELECT COUNT(u) FROM UserFollowArtist u WHERE u.user.userID = :userId AND u.artist.artistId = :artistId";
            Long exists = session.createQuery(checkHql, Long.class)
                    .setParameter("userId", userId)
                    .setParameter("artistId", artistId)
                    .uniqueResult();

            if (exists != null && exists > 0) {
                return false; // Đã follow rồi
            }

            // Lấy user và artist
            UserDTO user = session.get(UserDTO.class, userId);
            ArtistDTO artist = session.get(ArtistDTO.class, artistId);

            if (user == null || artist == null) {
                return false;
            }

            // Tạo bản ghi mới trong bảng trung gian
            UserFollowArtist follow = new UserFollowArtist();
            follow.setUser(user);
            follow.setArtist(artist);
            session.save(follow);

            // Tăng followerCount
            artist.setFollowerCount(artist.getFollowerCount() + 1);
            session.update(artist);

            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.getStatus().canRollback()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

}
