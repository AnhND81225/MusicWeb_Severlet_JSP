package Model.DTO;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "Artist")
public class ArtistDTO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "artist_id")
    private int artistId;

    @Column(name = "name", nullable = false, length = 150)
    private String name;

    @Column(name = "bio", columnDefinition = "NVARCHAR(MAX)")
    private String bio;

    @Column(name = "image", length = 255)
    private String image;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "is_hidden")
    private boolean isHidden = false;

    @Column(name = "is_popular")
    private boolean isPopular = false;

    @Column(name = "follower_count")
    private int followerCount = 0;

    @ManyToMany(mappedBy = "artists")
    private List<SongDTO> songs;

    @ManyToOne
    @JoinColumn(name = "genre_id")
    private GenreDTO genre;

    @OneToMany(mappedBy = "artist", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Set<AlbumDTO> albums;

    @ManyToMany
    @JoinTable(
        name = "Artist_Genre",
        joinColumns = @JoinColumn(name = "artist_id"),
        inverseJoinColumns = @JoinColumn(name = "genre_id")
    )
    private Set<GenreDTO> genres;

    // ✅ Quan hệ FOLLOW - nhiều user có thể follow 1 nghệ sĩ
    @ManyToMany(mappedBy = "followedArtists")
    private Set<UserDTO> followers;

    public ArtistDTO() {}

    public ArtistDTO(int artistId, String name, String bio, String image,
                     LocalDateTime createdAt, LocalDateTime updatedAt,
                     boolean isHidden, boolean isPopular, int followerCount,
                     List<SongDTO> songs) {
        this.artistId = artistId;
        this.name = name;
        this.bio = bio;
        this.image = image;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isHidden = isHidden;
        this.isPopular = isPopular;
        this.followerCount = followerCount;
        this.songs = songs;
    }

    // Getters và setters
    public int getArtistId() {
        return artistId;
    }

    public void setArtistId(int artistId) {
        this.artistId = artistId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isHidden() {
        return isHidden;
    }

    public void setHidden(boolean hidden) {
        isHidden = hidden;
    }

    public boolean isPopular() {
        return isPopular;
    }

    public void setPopular(boolean popular) {
        isPopular = popular;
    }

    public int getFollowerCount() {
        return followerCount;
    }

    public void setFollowerCount(int followerCount) {
        this.followerCount = followerCount;
    }

    public List<SongDTO> getSongs() {
        return songs;
    }

    public void setSongs(List<SongDTO> songs) {
        this.songs = songs;
    }

    public Set<AlbumDTO> getAlbums() {
        return albums;
    }

    public void setAlbums(Set<AlbumDTO> albums) {
        this.albums = albums;
    }

    public Set<GenreDTO> getGenres() {
        return genres;
    }

    public void setGenres(Set<GenreDTO> genres) {
        this.genres = genres;
    }

    public Set<UserDTO> getFollowers() {
        return followers;
    }

    public void setFollowers(Set<UserDTO> followers) {
        this.followers = followers;
    }
}
