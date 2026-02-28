package Model.DAO;

import Model.DTO.PlaylistSongDTO;
import Model.DTO.PlaylistSongID;
import Model.DTO.PlaylistDTO;
import Model.DTO.SongDTO;
import Util.HibernateUtil;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class PlaylistSongDAO {

    // Thêm bài hát vào playlist
    public boolean addSongToPlaylist(PlaylistSongDTO playlistSong) {
        boolean isSuccess = false;
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(playlistSong);
            tx.commit();
            isSuccess = true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Xóa bài hát khỏi playlist
    public boolean removeSongFromPlaylist(int playlistId, int songId) {
        boolean isSuccess = false;
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            PlaylistSongID id = new PlaylistSongID();
            id.setPlaylistId(playlistId);
            id.setSongId(songId);
            PlaylistSongDTO playlistSong = session.get(PlaylistSongDTO.class, id);
            if (playlistSong != null) {
                session.delete(playlistSong);
                isSuccess = true;
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Cập nhật vị trí bài hát trong playlist
    public boolean updateSongPosition(int playlistId, int songId, int newPosition) {
        boolean isSuccess = false;
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            PlaylistSongID id = new PlaylistSongID();
            id.setPlaylistId(playlistId);
            id.setSongId(songId);
            PlaylistSongDTO playlistSong = session.get(PlaylistSongDTO.class, id);
            if (playlistSong != null) {
                session.update(playlistSong);
                isSuccess = true;
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Lấy danh sách bài hát trong 1 playlist
    public List<PlaylistSongDTO> getSongsInPlaylist(int playlistId) {
        List<PlaylistSongDTO> list = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PlaylistSongDTO> query = session.createQuery(
                "FROM PlaylistSongDTO WHERE playlist.playlistId = :pid ",
                PlaylistSongDTO.class);
            query.setParameter("pid", playlistId);
            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
