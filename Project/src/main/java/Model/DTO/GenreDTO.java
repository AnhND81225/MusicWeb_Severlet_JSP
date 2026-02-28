package Model.DTO;

import java.util.Set;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "Genre")
public class GenreDTO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "genre_id")
    private int genreId;

    @Column(name = "name", nullable = false, unique = true, length = 100)
    private String name;

    @Column(name = "is_featured")
    private Boolean isFeatured = false;

    @Column(name = "is_hidden")
    private Boolean isHidden = false;

    @Column(name = "image", length = 255)
    private String image;

    // Quan hệ 1:N với Album
    @OneToMany(mappedBy = "genre", fetch = FetchType.LAZY)
    private List<AlbumDTO> albums;

    // Quan hệ 1:N với Song
    @OneToMany(mappedBy = "genre", fetch = FetchType.LAZY)
    private List<SongDTO> songs;

    // Quan hệ N:N với Artist
    @ManyToMany(mappedBy = "genres")
    private Set<ArtistDTO> artists;

    public GenreDTO() {
    }

    public GenreDTO(String name, Boolean isFeatured, Boolean isHidden, String image) {
        this.name = name;
        this.isFeatured = isFeatured;
        this.isHidden = isHidden;
        this.image = image;
    }

    // Getters & Setters
    public int getGenreId() {
        return genreId;
    }

    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Boolean isFeatured() {
        return isFeatured;
    }

    public void setFeatured(Boolean featured) {
        isFeatured = featured;
    }

    public Boolean isHidden() {
        return isHidden;
    }

    public void setHidden(Boolean hidden) {
        isHidden = hidden;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public List<AlbumDTO> getAlbums() {
        return albums;
    }

    public void setAlbums(List<AlbumDTO> albums) {
        this.albums = albums;
    }

    public List<SongDTO> getSongs() {
        return songs;
    }

    public void setSongs(List<SongDTO> songs) {
        this.songs = songs;
    }

    public Set<ArtistDTO> getArtists() {
        return artists;
    }

    public void setArtists(Set<ArtistDTO> artists) {
        this.artists = artists;
    }
}
