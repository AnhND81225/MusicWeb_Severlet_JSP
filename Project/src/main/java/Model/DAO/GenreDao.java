package Model.DAO;

import Model.DTO.GenreDTO;
import Util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.Collections;
import java.util.List;

public class GenreDao {

    // Thêm genre
    public boolean insert(GenreDTO genre) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.save(genre);
            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật genre
    public boolean update(GenreDTO genre) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.update(genre);
            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy genre theo id
    public GenreDTO getById(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(GenreDTO.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy genre kèm songs
    public GenreDTO getByIdWithSongs(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT g FROM GenreDTO g LEFT JOIN FETCH g.songs WHERE g.genreId = :id";
            return session.createQuery(hql, GenreDTO.class)
                    .setParameter("id", id)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy genre kèm tất cả chi tiết (songs, albums, artists)
    public GenreDTO getByIdWithDetails(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT g FROM GenreDTO g " +
                         "LEFT JOIN FETCH g.songs " +
                         "LEFT JOIN FETCH g.albums " +
                         "LEFT JOIN FETCH g.artists " +
                         "WHERE g.genreId = :id";
            return session.createQuery(hql, GenreDTO.class)
                    .setParameter("id", id)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy tất cả genre
    public List<GenreDTO> getAll() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM GenreDTO", GenreDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Lấy tất cả genre chưa bị ẩn
    public List<GenreDTO> getVisibleGenres() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM GenreDTO WHERE isHidden = false";
            return session.createQuery(hql, GenreDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Lấy tất cả genre đã bị ẩn
    public List<GenreDTO> getHiddenGenres() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM GenreDTO WHERE isHidden = true";
            return session.createQuery(hql, GenreDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Lấy tất cả genre kèm chi tiết (songs, albums, artists)
    public List<GenreDTO> getAllWithDetails() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT g FROM GenreDTO g " +
                         "LEFT JOIN FETCH g.songs " +
                         "LEFT JOIN FETCH g.albums " +
                         "LEFT JOIN FETCH g.artists";
            return session.createQuery(hql, GenreDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Lấy các genre nổi bật
    public List<GenreDTO> getFeaturedGenres() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM GenreDTO WHERE isFeatured = true AND isHidden = false";
            return session.createQuery(hql, GenreDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Tìm kiếm theo tên
    public List<GenreDTO> searchByKeyword(String keyword) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM GenreDTO WHERE LOWER(name) LIKE :kw AND isHidden = false";
            return session.createQuery(hql, GenreDTO.class)
                    .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Ẩn genre
    public boolean hide(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            GenreDTO genre = session.get(GenreDTO.class, id);
            if (genre == null) {
                return false;
            }
            Transaction tx = session.beginTransaction();
            genre.setHidden(true);
            session.update(genre);
            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hiển thị lại genre
    public boolean restore(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            GenreDTO genre = session.get(GenreDTO.class, id);
            if (genre == null) {
                return false;
            }
            Transaction tx = session.beginTransaction();
            genre.setHidden(false);
            session.update(genre);
            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
