package Model.DAO;

import Model.DTO.UserSubscriptionDTO;
import Model.DTO.UserDTO;
import Model.DTO.SubscriptionDTO;
import Util.HibernateUtil;
import java.time.LocalDateTime;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class UserSubscriptionDAO {

    //Thêm mới 1 user subscription
    public boolean addSubscription(UserSubscriptionDTO userSub) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(userSub);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    //Cập nhật subscription
    public boolean updateSubscription(UserSubscriptionDTO userSub) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(userSub);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    //Lấy subscription theo ID
    public UserSubscriptionDTO getById(int subscriptionId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(UserSubscriptionDTO.class, subscriptionId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //Lấy theo user
    public List<UserSubscriptionDTO> getByUser(UserDTO user) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<UserSubscriptionDTO> query = session.createQuery(
                "FROM UserSubscriptionDTO WHERE user = :user", UserSubscriptionDTO.class);
            query.setParameter("user", user);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //Danh sách active
    public List<UserSubscriptionDTO> getActiveSubscriptions() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM UserSubscriptionDTO WHERE isActive = true", UserSubscriptionDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //Hết hạn
    public List<UserSubscriptionDTO> getExpiredSubscriptions() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<UserSubscriptionDTO> query = session.createQuery(
                "FROM UserSubscriptionDTO WHERE endDate < :now", UserSubscriptionDTO.class);
            query.setParameter("now", LocalDateTime.now());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //Tất cả
    public List<UserSubscriptionDTO> getAllSubscriptions() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM UserSubscriptionDTO", UserSubscriptionDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //Theo user + plan
    public UserSubscriptionDTO getByUserAndPlan(UserDTO user, SubscriptionDTO plan) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<UserSubscriptionDTO> query = session.createQuery(
                "FROM UserSubscriptionDTO WHERE user = :user AND subscription = :plan", UserSubscriptionDTO.class);
            query.setParameter("user", user);
            query.setParameter("plan", plan);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //Xóa mềm
    public boolean softDeleteSubscription(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            UserSubscriptionDTO sub = session.get(UserSubscriptionDTO.class, id);
            if (sub != null && (sub.getIsDeleted() == null || !sub.getIsDeleted())) {
                sub.setIsDeleted(true);
                session.update(sub);
            }
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    //Bản ghi chưa xóa
    public List<UserSubscriptionDTO> getActiveRecords() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM UserSubscriptionDTO WHERE isDeleted = false", UserSubscriptionDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
