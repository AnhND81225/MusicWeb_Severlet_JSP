/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.DTO;

import java.io.Serializable;
import java.time.LocalDateTime;
import javax.persistence.*;

@Entity
@Table(name = "Notification")
public class NotificationDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id")
    private Integer notificationId; // INT IDENTITY(1,1)

    @Column(name = "message", nullable = false, columnDefinition = "NVARCHAR(255)")
    private String message;

    @Column(name = "is_read", nullable = false)
    private Boolean isRead = false; // BIT DEFAULT 0

    @Column(name = "is_hidden", nullable = false)
    private Boolean isHidden = false; // Xóa mềm (ẩn thông báo)

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt; // DATETIME DEFAULT GETDATE()

    @ManyToOne(fetch = FetchType.EAGER)
@JoinColumn(name = "user_id", referencedColumnName = "user_id", nullable = false)
private UserDTO user;

@ManyToOne(fetch = FetchType.EAGER)
@JoinColumn(name = "song_id", referencedColumnName = "song_id")
private SongDTO song;

    // Constructors
    public NotificationDTO() {}

    public NotificationDTO(String message, UserDTO user, SongDTO song) {
        this.message = message;
        this.user = user;
        this.song = song;
        this.isRead = false;
        this.isHidden = false;
    }

    // Getters & Setters
    public Integer getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(Boolean isRead) {
        this.isRead = isRead;
    }

    public Boolean getIsHidden() {
        return isHidden;
    }

    public void setIsHidden(Boolean isHidden) {
        this.isHidden = isHidden;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
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