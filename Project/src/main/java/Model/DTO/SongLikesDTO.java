/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.DTO;

import java.io.Serializable;
import java.time.LocalDateTime;
import javax.persistence.*;

@Entity
@Table(name = "SongLikes", uniqueConstraints = { 
    @UniqueConstraint(columnNames = {"user_id", "song_id"}) // Ràng buộc UNIQUE (user_id, song_id)
})
public class SongLikesDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "like_id")
    private Integer likeId; // INT IDENTITY(1,1)

    @Column(name = "is_hidden", nullable = false)
    private Boolean isHidden = false; // Xóa mềm (ẩn like thay vì xóa record)

    // Khóa ngoại: Many-to-One tới Users
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id", nullable = false)
    private UserDTO user;

    // Khóa ngoại: Many-to-One tới Song
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "song_id", referencedColumnName = "song_id", nullable = false)
    private SongDTO song;
    
    

    // Constructors
    public SongLikesDTO() {}

    public SongLikesDTO(UserDTO user, SongDTO song) {
        this.user = user;
        this.song = song;
//        this.isHidden = false;
    }

    // Getters & Setters
    public Integer getLikeId() {
        return likeId;
    }

    public void setLikeId(Integer likeId) {
        this.likeId = likeId;
    }


    public Boolean getIsHidden() {
        return isHidden;
    }

    public void setIsHidden(Boolean isHidden) {
        this.isHidden = isHidden;
    }

    public UserDTO getUser() {
        return user;
    }

    public void setUser(UserDTO user) {
        this.user = user;
    }

    public SongDTO getSong() {
        return song;
    }

    public void setSong(SongDTO song) {
        this.song = song;
    }
}