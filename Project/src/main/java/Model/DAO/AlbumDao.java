package Model.DAO;

import Model.DTO.AlbumDTO;
import Model.DTO.AlbumStatsDTO;
import Model.DTO.SongDTO;
import Util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import org.hibernate.Hibernate;

public class AlbumDao {

    public boolean create(AlbumDTO album) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(album);
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

    public boolean update(AlbumDTO album) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(album);
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

    public AlbumDTO getById(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(AlbumDTO.class, id);
        }
    }

    public AlbumDTO getByIdWithDetails(int id) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist "
                    + "LEFT JOIN FETCH a.genre "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.albumId = :id";
            return session.createQuery(hql, AlbumDTO.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    public List<AlbumDTO> getVisibleAlbums() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist "
                    + "LEFT JOIN FETCH a.genre "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = false ORDER BY a.releaseDate DESC";
            return session.createQuery(hql, AlbumDTO.class).list();
        }
    }

    public List<AlbumDTO> getHiddenAlbums() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist "
                    + "LEFT JOIN FETCH a.genre "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = true ORDER BY a.updatedDate DESC";
            return session.createQuery(hql, AlbumDTO.class).list();
        }
    }

    public List<AlbumDTO> getByArtist(int artistId) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist "
                    + "LEFT JOIN FETCH a.genre "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = false AND a.artist.artistId = :artistId";
            return session.createQuery(hql, AlbumDTO.class)
                    .setParameter("artistId", artistId)
                    .list();
        }
    }

    public List<AlbumDTO> getByGenre(int genreId) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = false AND a.genre.genreId = :genreId";
            return session.createQuery(hql, AlbumDTO.class)
                    .setParameter("genreId", genreId)
                    .list();
        }
    }

    public List<AlbumStatsDTO> getTopAlbumsByPlayCount() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT new Model.DTO.AlbumStatsDTO(a, SUM(s.playCount)) "
                    + "FROM AlbumDTO a JOIN a.songs s "
                    + "WHERE a.isHidden = false "
                    + "GROUP BY a "
                    + "ORDER BY SUM(s.playCount) DESC";

            List<AlbumStatsDTO> results = session.createQuery(hql, AlbumStatsDTO.class).list();

            // Ép load các quan hệ LAZY ngay trong session
            for (AlbumStatsDTO stat : results) {
                AlbumDTO album = stat.getAlbum();

                if (album.getArtist() != null) {
                    Hibernate.initialize(album.getArtist());
                }
                if (album.getGenre() != null) {
                    Hibernate.initialize(album.getGenre());
                }
                if (album.getSongs() != null) {
                    Hibernate.initialize(album.getSongs());
                }
            }

            return results;
        }
    }

    public List<AlbumDTO> getAllAlbums() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM AlbumDTO", AlbumDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<AlbumDTO> getNewAlbums() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            LocalDate thirtyDaysAgo = LocalDate.now().minusDays(30);
            String hql = "SELECT DISTINCT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist "
                    + "LEFT JOIN FETCH a.genre "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = false AND a.releaseDate >= :thirtyDaysAgo";
            return session.createQuery(hql, AlbumDTO.class)
                    .setParameter("thirtyDaysAgo", thirtyDaysAgo.atStartOfDay())
                    .list();
        }
    }

    public List<AlbumDTO> getSortedByReleaseDate() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist "
                    + "LEFT JOIN FETCH a.genre "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = false ORDER BY a.releaseDate DESC";
            return session.createQuery(hql, AlbumDTO.class).list();
        }
    }

    public List<AlbumDTO> searchByKeyword(String keyword) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist ar "
                    + "LEFT JOIN FETCH a.genre g "
                    + "LEFT JOIN FETCH a.songs s "
                    + "WHERE a.isHidden = false AND ("
                    + "LOWER(a.name) LIKE :kw OR "
                    + "LOWER(ar.name) LIKE :kw OR "
                    + "LOWER(g.name) LIKE :kw)";

            return session.createQuery(hql, AlbumDTO.class)
                    .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // Tránh null để không lỗi JSP
        }
    }

    public List<AlbumDTO> searchAlbumByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return Collections.emptyList();
        }
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT a FROM AlbumDTO a "
                    + "LEFT JOIN FETCH a.artist "
                    + "LEFT JOIN FETCH a.genre "
                    + "LEFT JOIN FETCH a.songs "
                    + "WHERE a.isHidden = false AND LOWER(a.name) LIKE :name";
            return session.createQuery(hql, AlbumDTO.class)
                    .setParameter("name", "%" + name.toLowerCase() + "%")
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public boolean hide(int albumId) {
        return toggleHidden(albumId, true);
    }

    public boolean restore(int albumId) {
        return toggleHidden(albumId, false);
    }

    private boolean toggleHidden(int albumId, boolean hide) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            AlbumDTO album = session.get(AlbumDTO.class, albumId);
            if (album == null) {
                return false;
            }
            tx = session.beginTransaction();
            album.setHidden(hide);
            session.update(album);
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

    public SongDTO addSong(SongDTO song, int albumId) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            AlbumDTO album = session.get(AlbumDTO.class, albumId);
            if (album == null) {
                throw new IllegalArgumentException("Không tìm thấy album với ID: " + albumId);
            }
            tx = session.beginTransaction();
            song.setAlbum(album);
            session.save(song);
            tx.commit();
            return song;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return null;
        }
    }
}