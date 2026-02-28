/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Util;

/**
 *
 * @author ASUS
 */
import com.mpatric.mp3agic.Mp3File;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class AudioUtils {

    // Tải file từ Google Drive về tạm thời
    public static File downloadFromDrive(String fileUrl) throws IOException {
        URL url = new URL(fileUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        File tempFile = File.createTempFile("song", ".mp3");
        try ( InputStream in = conn.getInputStream();  FileOutputStream out = new FileOutputStream(tempFile)) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
        return tempFile;
    }

    // Đọc thời lượng từ file mp3
    public static int getDurationFromMp3(String fileUrl) {
        try {
            File mp3 = downloadFromDrive(fileUrl);
            Mp3File mp3file = new Mp3File(mp3);
            long durationInSeconds = mp3file.getLengthInSeconds();
            mp3.delete(); // Xóa file tạm sau khi xử lý
            return (int) Math.ceil(durationInSeconds / 60.0); // Sửa tại đây
        } catch (Exception e) {
            System.err.println("Lỗi đọc thời lượng từ file: " + fileUrl);
            e.printStackTrace();
            return 0;
        }
    }
}
