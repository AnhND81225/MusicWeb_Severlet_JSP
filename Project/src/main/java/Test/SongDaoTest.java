/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Test;

import Model.DAO.SongDao;
import Model.DTO.SongDTO;

import java.util.List;

public class SongDaoTest {
    public static void main(String[] args) {
        SongDao songDao = new SongDao();

        try {
            System.out.println("🎶 Đang lấy danh sách bài hát...");
            List<SongDTO> songs = songDao.getAllSongs();

            if (songs.isEmpty()) {
                System.out.println("⚠ Không có bài hát nào trong cơ sở dữ liệu.");
            } else {
                System.out.println("✅ Danh sách bài hát:");
                for (SongDTO song : songs) {
                    System.out.println("- " + song.getSongId() + ": " + song.getTitle() + " (" + song.getDuration() + " phút)");
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi truy vấn bài hát:");
            e.printStackTrace();
        }
    }
}
