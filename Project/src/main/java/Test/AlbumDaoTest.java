/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Test;

import Model.DAO.AlbumDao;
import Model.DTO.AlbumDTO;

import java.util.List;

public class AlbumDaoTest {
    public static void main(String[] args) {
        AlbumDao albumDao = new AlbumDao();

        try {
            System.out.println("🔍 Đang lấy danh sách album...");
            List<AlbumDTO> albums = albumDao.getAllAlbums();

            if (albums.isEmpty()) {
                System.out.println("⚠ Không có album nào trong cơ sở dữ liệu.");
            } else {
                System.out.println("✅ Danh sách album:");
                for (AlbumDTO album : albums) {
                    System.out.println("- " + album.getAlbumId() + ": " + album.getName() + " (" + album.getReleaseDate() + ")");
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi truy vấn album:");
            e.printStackTrace();
        }
    }
}
