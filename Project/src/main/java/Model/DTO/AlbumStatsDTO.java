/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.DTO;

import Model.DTO.AlbumDTO;

public class AlbumStatsDTO {
    private AlbumDTO album;
    private Long totalPlayCount;

    public AlbumStatsDTO(AlbumDTO album, Long totalPlayCount) {
        this.album = album;
        this.totalPlayCount = totalPlayCount;
    }

    public AlbumDTO getAlbum() {
        return album;
    }

    public void setAlbum(AlbumDTO album) {
        this.album = album;
    }

    public Long getTotalPlayCount() {
        return totalPlayCount;
    }

    public void setTotalPlayCount(Long totalPlayCount) {
        this.totalPlayCount = totalPlayCount;
    }
}
