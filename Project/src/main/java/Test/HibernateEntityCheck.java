package Test;

import Util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

public class HibernateEntityCheck {
    public static void main(String[] args) {
        try {
            System.out.println("🔍 Đang kiểm tra cấu hình Hibernate...");

            // Mở SessionFactory
            SessionFactory factory = HibernateUtil.getSessionFactory();
            System.out.println("✅ Hibernate SessionFactory khởi tạo thành công.");

            // Mở thử 1 session để test mapping
            Session session = factory.openSession();
            System.out.println("✅ Session mở thành công.");

            session.close();
            factory.close();

            System.out.println("🎉 Hibernate hoạt động bình thường và tất cả entity đã được nhận!");
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi khởi tạo Hibernate!");
            e.printStackTrace();
        }
    }
}
