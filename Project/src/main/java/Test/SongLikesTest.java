/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Test;

import Model.DAO.SongLikesDAO;
import Model.DTO.SongDTO;
import Model.DTO.SongLikesDTO;
import Model.DTO.UserDTO;
import Service.SongLikesService;
import Util.HibernateUtil;
import org.hibernate.SessionFactory;

public class SongLikesTest {

    public static void main(String[] args) {
        // Khởi tạo SessionFactory (giả sử bạn đã có HibernateUtil)
        SessionFactory factory = HibernateUtil.getSessionFactory();

        // Tạo DAO và Service
        SongLikesDAO dao = new SongLikesDAO(factory);
        SongLikesService service = new SongLikesService(dao);

        // Tạo user và song với ID đã tồn tại trong database
        UserDTO user = new UserDTO();
        user.setUserID(1); // ID người dùng đã có trong DB

        SongDTO song = new SongDTO();
        song.setSongId(2); // ID bài hát đã có trong DB

        // Gọi hàm addLike
        boolean result = service.addLike(user, song);

        // In kết quả
        if (result) {
            System.out.println("✅ Like đã được thêm thành công!");
        } else {
            System.out.println("⚠️ Người dùng đã like bài hát này rồi hoặc có lỗi xảy ra.");
        }

        // Đóng SessionFactory nếu cần
        factory.close();
    }
}




