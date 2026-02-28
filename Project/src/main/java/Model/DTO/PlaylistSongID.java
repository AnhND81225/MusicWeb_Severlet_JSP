/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.DTO;

import java.io.Serializable;
import java.util.Objects;

/**
 *
 * @author phant
 */
public class PlaylistSongID implements Serializable{
    private Integer playlistId;
    private Integer songId;

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 97 * hash + Objects.hashCode(this.playlistId);
        hash = 97 * hash + Objects.hashCode(this.songId);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final PlaylistSongID other = (PlaylistSongID) obj;
        if (!Objects.equals(this.playlistId, other.playlistId)) {
            return false;
        }
        return Objects.equals(this.songId, other.songId);
    }

    public PlaylistSongID() {
    }

    public PlaylistSongID(Integer playlistId, Integer songId) {
        this.playlistId = playlistId;
        this.songId = songId;
    }

    public Integer getPlaylistId() {
        return playlistId;
    }

    public void setPlaylistId(Integer playlistId) {
        this.playlistId = playlistId;
    }

    public Integer getSongId() {
        return songId;
    }

    public void setSongId(Integer songId) {
        this.songId = songId;
    }
    
}
