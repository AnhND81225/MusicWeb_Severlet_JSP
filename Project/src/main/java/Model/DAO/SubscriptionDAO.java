/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.DAO;

import Model.DTO.SubscriptionDTO;
import Util.HibernateUtil;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

/**
 *
 * @author phant
 */
public class SubscriptionDAO {

    // Thêm gói subscription mới
    public boolean addSubscription(SubscriptionDTO sub) {
        boolean isSuccess = false;
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(sub);
            tx.commit();
            isSuccess = true;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Cập nhật thông tin gói subscription
    public boolean updateSubscription(SubscriptionDTO sub) {
        boolean isSuccess = false;
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(sub);
            tx.commit();
            isSuccess = true;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Xóa cứng gói subscription (chỉ dùng nếu chắc chắn)
    public boolean deleteSubscription(int planId) {
        boolean isSuccess = false;
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            SubscriptionDTO sub = session.get(SubscriptionDTO.class, planId);
            if (sub != null) {
                session.delete(sub);
                isSuccess = true;
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Xóa mềm (ẩn gói) — thêm field `hidden` trong DTO
    public boolean hideSubscription(int planId) {
        boolean isSuccess = false;
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            SubscriptionDTO sub = session.get(SubscriptionDTO.class, planId);
            if (sub != null) {
                sub.setHidden(true);
                session.update(sub);
                isSuccess = true;
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Lấy gói subscription theo ID
    public SubscriptionDTO getById(int planId) {
        SubscriptionDTO sub = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            sub = session.get(SubscriptionDTO.class, planId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sub;
    }

    // Lấy tất cả gói subscription
    public List<SubscriptionDTO> getAllSubscriptions() {
        List<SubscriptionDTO> list = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            list = session.createQuery("FROM SubscriptionDTO", SubscriptionDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public SubscriptionDTO getByName(String name) {
        SubscriptionDTO sub = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<SubscriptionDTO> query = session.createQuery(
                    "FROM SubscriptionDTO WHERE nameSubscription = :name", SubscriptionDTO.class);
            query.setParameter("name", name);
            sub = query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sub;
    }
}
