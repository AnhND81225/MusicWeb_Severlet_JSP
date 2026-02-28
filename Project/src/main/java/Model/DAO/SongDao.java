package Model.DAO;

import Model.DTO.ArtistDTO;
import Model.DTO.SongDTO;
import Util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import org.hibernate.SessionFactory;

public class SongDao {

    // =========================
    // 🔍 Truy vấn cơ bản (với fetch để tránh LazyInitializationException)
    // =========================
    public List<SongDTO> getAll() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT s FROM SongDTO s "
                    + "LEFT JOIN FETCH s.artists "
                    + "LEFT JOIN FETCH s.album "
                    + "LEFT JOIN FETCH s.genre "
                    + "WHERE s.hidden = false";
            return session.createQuery(hql, SongDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public SongDTO getById(int id) {
        SongDTO song = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT s FROM SongDTO s "
                    + "LEFT JOIN FETCH s.album "
                    + "LEFT JOIN FETCH s.genre "
                    + "LEFT JOIN FETCH s.artists "
                    + "WHERE s.songId = :id";
            song = session.createQuery(hql, SongDTO.class)
                    .setParameter("id", id)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return song;
    }

    public List<SongDTO> getAllSongs() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM SongDTO", SongDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // =========================
    // ➕ Thêm / 🔄 Cập nhật
    // =========================
    public boolean insert(SongDTO song) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            System.out.println("🎵 [DEBUG] Bắt đầu thêm bài hát: " + song.getTitle());

            // ✅ Đảm bảo album & genre thuộc cùng session
            if (song.getAlbum() != null && song.getAlbum().getAlbumId() > 0) {
                song.setAlbum(session.get(song.getAlbum().getClass(), song.getAlbum().getAlbumId()));
            } else {
                song.setAlbum(null); // Không chọn album thì để null
            }

            if (song.getGenre() != null && song.getGenre().getGenreId() > 0) {
                song.setGenre(session.get(song.getGenre().getClass(), song.getGenre().getGenreId()));
            } else {
                song.setGenre(null); // Không chọn thể loại thì để null
            }

            // ✅ Xử lý danh sách nghệ sĩ (nếu có)
            if (song.getArtists() != null && !song.getArtists().isEmpty()) {
                for (int i = 0; i < song.getArtists().size(); i++) {
                    ArtistDTO artist = song.getArtists().get(i);

                    // Nếu nghệ sĩ chưa có ID => tạo mới
                    if (artist.getArtistId() == 0) {
                        session.saveOrUpdate(artist);
                        System.out.println("🎤 [INFO] Đã tạo mới nghệ sĩ: " + artist.getName());
                    } else {
                        // Lấy lại bản ghi đã tồn tại từ DB trong cùng session
                        ArtistDTO managedArtist = session.get(ArtistDTO.class, artist.getArtistId());
                        song.getArtists().set(i, managedArtist);
                    }
                }
            } else {
                System.out.println("⚠️ [WARN] Không có nghệ sĩ nào được chọn cho bài hát này!");
            }

            // ✅ Lưu bài hát chính
            session.save(song);
            tx.commit();

            System.out.println("✅ [SUCCESS] Đã lưu bài hát thành công: " + song.getTitle());
            return true;

        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            System.err.println("❌ [ERROR] Thêm bài hát thất bại: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(SongDTO song) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // ✅ Lấy bài hát cũ từ DB (tránh lỗi detached)
            SongDTO existing = session.get(SongDTO.class, song.getSongId());
            if (existing == null) {
                System.out.println("⚠️ Không tìm thấy bài hát ID: " + song.getSongId());
                return false;
            }

            // ✅ Cập nhật các thuộc tính cơ bản
            existing.setTitle(song.getTitle());
            existing.setFilePath(song.getFilePath());
            existing.setImagePath(song.getImagePath());
            existing.setDuration(song.getDuration());
            existing.setFeatured(song.isFeatured());
            existing.setPlayCount(song.getPlayCount());

            // ✅ Liên kết album & genre lại trong cùng session
            if (song.getAlbum() != null) {
                existing.setAlbum(session.get(song.getAlbum().getClass(), song.getAlbum().getAlbumId()));
            } else {
                existing.setAlbum(null);
            }

            if (song.getGenre() != null) {
                existing.setGenre(session.get(song.getGenre().getClass(), song.getGenre().getGenreId()));
            } else {
                existing.setGenre(null);
            }

            // ✅ Cập nhật danh sách nghệ sĩ (nếu có)
            if (song.getArtists() != null) {
                existing.setArtists(song.getArtists());
            }

            // ✅ Thực hiện update và commit
            session.update(existing);
            tx.commit();

            System.out.println("✅ Đã cập nhật bài hát thành công: " + existing.getTitle());
            return true;

        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    // =========================
    // ❌ Ẩn / ✅ Khôi phục
    // =========================
    public boolean hide(int songId) {
        return toggleHidden(songId, true);
    }

    public boolean restore(int songId) {
        return toggleHidden(songId, false);
    }

    private boolean toggleHidden(int songId, boolean hide) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            SongDTO song = session.get(SongDTO.class, songId);
            if (song == null) {
                return false;
            }
            tx = session.beginTransaction();
            song.setHidden(hide);
            session.update(song);
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

    // =========================
    // 🔍 Tìm kiếm & Lọc
    // =========================
    public List<SongDTO> getAllWithDetails() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT s FROM SongDTO s "
                    + "LEFT JOIN FETCH s.artists "
                    + "LEFT JOIN FETCH s.album "
                    + "LEFT JOIN FETCH s.genre "
                    + "WHERE s.hidden = false";
            return session.createQuery(hql, SongDTO.class).list();
        }
    }

public List<SongDTO> searchByKeyword(String keyword) {
    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
        String hql = "SELECT DISTINCT s FROM SongDTO s "
                   + "LEFT JOIN FETCH s.artists a "
                   + "WHERE s.hidden = false AND "
                   + "(LOWER(s.title) LIKE :kw OR LOWER(a.name) LIKE :kw)";
        return session.createQuery(hql, SongDTO.class)
                      .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                      .list();
    }
}


    public List<SongDTO> getByAlbum(int albumId) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM SongDTO WHERE hidden = false AND album.albumId = :albumId";
            return session.createQuery(hql, SongDTO.class)
                    .setParameter("albumId", albumId)
                    .list();
        }
    }

    public List<SongDTO> getByArtist(int artistId) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT s FROM SongDTO s "
                    + "JOIN s.artists a "
                    + "WHERE s.hidden = false AND a.artistId = :artistId";
            return session.createQuery(hql, SongDTO.class)
                    .setParameter("artistId", artistId)
                    .list();
        }
    }

    public List<SongDTO> getByGenre(int genreId) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM SongDTO WHERE hidden = false AND genre.genreId = :genreId";
            return session.createQuery(hql, SongDTO.class)
                    .setParameter("genreId", genreId)
                    .list();
        }
    }

    public List<SongDTO> getNewSongs() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM SongDTO WHERE hidden = false AND createdAt >= :recentDate";
            return session.createQuery(hql, SongDTO.class)
                    .setParameter("recentDate", LocalDateTime.now().minusDays(30))
                    .list();
        }
    }

    public List<SongDTO> getFeaturedSongs() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM SongDTO WHERE hidden = false AND isFeatured = true";
            return session.createQuery(hql, SongDTO.class).list();
        }
    }

   

    // =========================
    // ▶️ Tăng lượt nghe
    // =========================
    public boolean increasePlayCount(int songId) {
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            SongDTO song = session.get(SongDTO.class, songId);
            if (song == null || song.isHidden()) {
                return false;
            }
            tx = session.beginTransaction();
            song.setPlayCount(song.getPlayCount() + 1);
            session.update(song);
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

    // =========================
    // 🔍 Các truy vấn khác (sử dụng FETCH để load artists/album/genre)
    // =========================
    

    public List<SongDTO> getHidden() {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT s FROM SongDTO s "
                    + "LEFT JOIN FETCH s.artists "
                    + "LEFT JOIN FETCH s.album "
                    + "LEFT JOIN FETCH s.genre "
                    + "WHERE s.hidden = true";
            return session.createQuery(hql, SongDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> searchByTitle(String title) {
        if (title == null) {
            title = "";
        }
        String kw = "%" + title.toLowerCase() + "%";
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT s FROM SongDTO s "
                    + "LEFT JOIN FETCH s.artists "
                    + "LEFT JOIN FETCH s.album "
                    + "LEFT JOIN FETCH s.genre "
                    + "WHERE s.hidden = false AND LOWER(s.title) LIKE :kw";
            return session.createQuery(hql, SongDTO.class)
                    .setParameter("kw", kw)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<SongDTO> getTopSongs(int limit) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT s FROM SongDTO s "
                    + "LEFT JOIN FETCH s.album "
                    + "LEFT JOIN FETCH s.genre "
                    + "LEFT JOIN FETCH s.artists "
                    + "WHERE s.hidden = false "
                    + "ORDER BY s.playCount DESC";
            return session.createQuery(hql, SongDTO.class)
                    .setMaxResults(limit)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
