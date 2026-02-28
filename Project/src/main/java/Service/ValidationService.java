package Service;

import Model.DTO.*;

public class ValidationService {

    // Hàm kiểm tra chi tiết, trả về lỗi cụ thể
    public String validateSongDetailed(SongDTO song) {
        if (song == null) return "❌ Không nhận được dữ liệu bài hát.";

        if (!notEmpty(song.getTitle())) {
            return "⚠️ Tiêu đề bài hát không được để trống.";
        }

        if (!notEmpty(song.getFilePath())) {
            return "🎧 Bạn chưa chọn file nhạc để tải lên.";
        }

        // Kiểm tra định dạng file nhạc
        String lower = song.getFilePath().toLowerCase();
        if (!(lower.endsWith(".mp3") || lower.endsWith(".wav") || lower.endsWith(".flac"))) {
            return "🚫 File không hợp lệ. Chỉ chấp nhận file nhạc (.mp3, .wav, .flac).";
        }

        if (song.getArtists() == null || song.getArtists().isEmpty()) {
            return "👤 Vui lòng chọn ít nhất một nghệ sĩ thể hiện.";
        }

        if (song.getGenre() == null) {
            return "🎶 Vui lòng chọn ít nhất một thể loại nhạc.";
        }


        return null; // Không có lỗi
    }

    // Giữ lại hàm cũ để tương thích
    public boolean isValid(Object dto) {
        if (dto == null) return false;
        if (dto instanceof SongDTO) return validateSong((SongDTO) dto);
        if (dto instanceof ArtistDTO) return validateArtist((ArtistDTO) dto);
        if (dto instanceof AlbumDTO) return validateAlbum((AlbumDTO) dto);
        if (dto instanceof GenreDTO) return validateGenre((GenreDTO) dto);
        return false;
    }

    private boolean validateSong(SongDTO song) {
        return notEmpty(song.getTitle())
                && notEmpty(song.getFilePath())
                && song.getArtists() != null && !song.getArtists().isEmpty();
    }

    private boolean validateArtist(ArtistDTO artist) {
        return notEmpty(artist.getName())
                && notEmpty(artist.getBio());
    }

    private boolean validateAlbum(AlbumDTO album) {
        return notEmpty(album.getName())
                && album.getReleaseDate() != null
                && album.getReleaseDate().getYear() + 1900 > 1900;
    }

    private boolean validateGenre(GenreDTO genre) {
        return notEmpty(genre.getName());
    }

    private boolean notEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
}
