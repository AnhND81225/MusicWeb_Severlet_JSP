package Test;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateTest {
    public static void main(String[] args) {
        try {
            // Tạo đối tượng cấu hình Hibernate từ file hibernate.cfg.xml
            Configuration configuration = new Configuration();
            configuration.configure("hibernate.cfg.xml");

            // Tạo SessionFactory từ cấu hình
            SessionFactory sessionFactory = configuration.buildSessionFactory();

            // Mở phiên làm việc (session)
            Session session = sessionFactory.openSession();

            // Bắt đầu giao dịch
            session.beginTransaction();

            // Không cần thêm dữ liệu, chỉ cần mở session để Hibernate tạo bảng
            System.out.println("Hibernate đã kết nối thành công và bảng đã được tạo (nếu chưa có).");

            // Kết thúc giao dịch
            session.getTransaction().commit();

            // Đóng session
            session.close();
            sessionFactory.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
