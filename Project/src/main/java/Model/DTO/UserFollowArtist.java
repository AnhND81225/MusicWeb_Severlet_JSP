package Model.DTO;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "UserFollowArtist")
@IdClass(UserFollowArtist.PK.class)
public class UserFollowArtist implements Serializable {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserDTO user;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "artist_id", nullable = false)
    private ArtistDTO artist;

    @Column(name = "follow_time", nullable = false)
    private LocalDateTime followTime = LocalDateTime.now();

    public static class PK implements Serializable {
        private Integer user;
        private Integer artist;

        public PK() {}
        public PK(Integer user, Integer artist) {
            this.user = user;
            this.artist = artist;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof PK)) return false;
            PK pk = (PK) o;
            return user.equals(pk.user) && artist.equals(pk.artist);
        }

        @Override
        public int hashCode() {
            return user.hashCode() + artist.hashCode();
        }
    }

    public UserDTO getUser() {
        return user;
    }

    public void setUser(UserDTO user) {
        this.user = user;
    }

    public ArtistDTO getArtist() {
        return artist;
    }

    public void setArtist(ArtistDTO artist) {
        this.artist = artist;
    }

    public LocalDateTime getFollowTime() {
        return followTime;
    }

    public void setFollowTime(LocalDateTime followTime) {
        this.followTime = followTime;
    }
}
