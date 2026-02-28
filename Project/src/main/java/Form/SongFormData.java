/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Form;

import Model.DTO.AlbumDTO;
import Model.DTO.ArtistDTO;
import Model.DTO.GenreDTO;
import java.util.List;

/**
 *
 * @author ASUS
 */


public class SongFormData {

    private List<ArtistDTO> artists;
    private List<AlbumDTO> albums;
    private List<GenreDTO> genres;

    public List<ArtistDTO> getArtists() {
        return artists;
    }

    public void setArtists(List<ArtistDTO> artists) {
        this.artists = artists;
    }

    public List<AlbumDTO> getAlbums() {
        return albums;
    }

    public void setAlbums(List<AlbumDTO> albums) {
        this.albums = albums;
    }

    public List<GenreDTO> getGenres() {
        return genres;
    }

    public void setGenres(List<GenreDTO> genres) {
        this.genres = genres;
    }
}
