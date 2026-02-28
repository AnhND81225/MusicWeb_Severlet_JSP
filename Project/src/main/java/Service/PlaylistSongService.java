package Service;

import Model.DAO.PlaylistSongDAO;
import Model.DTO.PlaylistSongDTO;
import Model.DTO.PlaylistSongID;
import Model.DTO.PlaylistDTO;
import Model.DTO.SongDTO;
import java.util.List;

public class PlaylistSongService {

    private final PlaylistSongDAO playlistSongDAO = new PlaylistSongDAO();

    // ✅ Thêm bài hát vào playlist
    public boolean addSongToPlaylist(PlaylistDTO playlist, SongDTO song) {
        try {
            // Kiểm tra bài hát đã tồn tại trong playlist chưa
            List<PlaylistSongDTO> songs = playlistSongDAO.getSongsInPlaylist(playlist.getPlaylistId());
            for (PlaylistSongDTO s : songs) {
//                if (s.getSong().getSongId().equals(song.getSongId())) {
//                    System.out.println("Song already in playlist!");
//                    return false;
//                }
            }

            PlaylistSongID id = new PlaylistSongID(playlist.getPlaylistId(), song.getSongId());
            PlaylistSongDTO playlistSong = new PlaylistSongDTO(id, playlist, song);

            return playlistSongDAO.addSongToPlaylist(playlistSong);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Xóa bài hát khỏi playlist
    public boolean removeSongFromPlaylist(PlaylistDTO playlist, SongDTO song) {
        try {
            return playlistSongDAO.removeSongFromPlaylist(
                playlist.getPlaylistId(), song.getSongId());
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Lấy danh sách bài hát trong playlist
    public List<PlaylistSongDTO> getSongsInPlaylist(PlaylistDTO playlist) {
        return playlistSongDAO.getSongsInPlaylist(playlist.getPlaylistId());
    }
}
