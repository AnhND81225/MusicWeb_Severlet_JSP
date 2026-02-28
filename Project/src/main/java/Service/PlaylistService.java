package Service;

import Model.DAO.PlaylistDAO;
import Model.DAO.PlaylistSongDAO;
import Model.DTO.PlaylistDTO;
import Model.DTO.PlaylistSongDTO;
import Model.DTO.PlaylistSongID;
import Model.DTO.SongDTO;
import Model.DTO.UserDTO;

import java.time.LocalDateTime;
import java.util.List;

public class PlaylistService {

    private final PlaylistDAO playlistDAO = new PlaylistDAO();
    private final PlaylistSongDAO playlistSongDAO = new PlaylistSongDAO();

    // ✅ Tạo playlist mới và trả về đối tượng đã có ID
    public PlaylistDTO createPlaylistAndReturn(UserDTO user, String name) {
        System.out.println(name);
        PlaylistDTO playlist = new PlaylistDTO();
        playlist.setName(name);
        playlist.setUser(user);
        playlist.setHidden(false);
        playlist.setIsFavoriteList(false);
        playlist.setCreatedAt(LocalDateTime.now());
        playlist.setUpdatedAt(LocalDateTime.now());

        return playlistDAO.addPlaylist(playlist); // trả về playlist đã có ID
    }

    // ✅ Cập nhật thông tin playlist
    public boolean updatePlaylist(PlaylistDTO playlist) {
        return playlistDAO.updatePlaylist(playlist);
    }

    // ✅ Ẩn playlist (xóa mềm)
    public boolean hidePlaylist(int playlistId) {
        return playlistDAO.hidePlaylist(playlistId);
    }

    // ✅ Lấy playlist theo ID
    public PlaylistDTO getPlaylistById(int id) {
        return playlistDAO.getById(id);
    }

    // ✅ Lấy playlist theo tên (dành cho trường hợp đặc biệt)
    public PlaylistDTO getPlaylistByName(UserDTO user, String name) {
        return playlistDAO.getPlaylistByName(user.getUserID(), name);
    }

    // ✅ Lấy tất cả playlist của người dùng
    public List<PlaylistDTO> getPlaylistsByUser(UserDTO user) {
        return playlistDAO.getByUser(user);
    }

    // ✅ Lấy tất cả playlist (admin)
    public List<PlaylistDTO> getAllPlaylists() {
        return playlistDAO.getAll();
    }

    // ✅ Lấy danh sách bài hát trong một playlist
    public List<PlaylistSongDTO> getSongsInPlaylist(int playlistId) {
        return playlistSongDAO.getSongsInPlaylist(playlistId);
    }

    // ✅ Thêm bài hát vào playlist
    public boolean addSongToPlaylist(PlaylistDTO playlist, SongDTO song) {
        PlaylistSongID id = new PlaylistSongID(playlist.getPlaylistId(), song.getSongId());
        PlaylistSongDTO link = new PlaylistSongDTO(id, playlist, song);
        return playlistSongDAO.addSongToPlaylist(link);
    }

    // ✅ Xóa bài hát khỏi playlist
    public boolean removeSongFromPlaylist(int playlistId, int songId) {
        return playlistSongDAO.removeSongFromPlaylist(playlistId, songId);
    }

    public List<PlaylistDTO> getHiddenPlaylistsByUser(UserDTO user) {
        return playlistDAO.getHiddenByUser(user);
    }

    public boolean restorePlaylist(int playlistId) {
        return playlistDAO.restorePlaylist(playlistId);
    }

}
