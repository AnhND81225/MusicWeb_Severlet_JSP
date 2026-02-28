package Form;

import Model.DTO.ArtistDTO;
import Model.DTO.GenreDTO;
import Model.DTO.SongDTO;
import java.util.List;

public class AlbumFormData {
    private List<GenreDTO> genres;
    private List<ArtistDTO> artists;
    private List<SongDTO> songs;

    public List<GenreDTO> getGenres() {
        return genres;
    }

    public void setGenres(List<GenreDTO> genres) {
        this.genres = genres;
    }

    public List<ArtistDTO> getArtists() {
        return artists;
    }

    public void setArtists(List<ArtistDTO> artists) {
        this.artists = artists;
    }

    public List<SongDTO> getSongs() {
        return songs;
    }

    public void setSongs(List<SongDTO> songs) {
        this.songs = songs;
    }
}
