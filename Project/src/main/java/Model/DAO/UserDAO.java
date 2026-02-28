package Model.DAO;

import Model.DTO.UserDTO;
import Util.HibernateUtil;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class UserDAO {

    // Thêm user mới
    public boolean addUser(UserDTO user) {
        boolean isSuccess = false;
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(user);
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

    // Cập nhật user
    public boolean updateUser(UserDTO user) {
        boolean isSuccess = false;
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            user.setUpdatedAt(java.time.LocalDateTime.now());
            session.update(user);
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

    // XÓA MỀM user (ẩn user)
    public boolean hideUser(int userId) {
        boolean isSuccess = false;
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            UserDTO user = session.get(UserDTO.class, userId);
            if (user != null && !user.isHidden()) {
                user.setHidden(true);
                user.setUpdatedAt(java.time.LocalDateTime.now());
                session.update(user);
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

    // Khôi phục user đã ẩn
    public boolean unhideUser(int userId) {
        boolean isSuccess = false;
        Transaction tx = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            UserDTO user = session.get(UserDTO.class, userId);
            if (user != null && user.isHidden()) {
                user.setHidden(false);
                user.setUpdatedAt(java.time.LocalDateTime.now());
                session.update(user);
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

    // Lấy user theo ID (kể cả ẩn)
    public UserDTO getUserById(int userId) {
        UserDTO user = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            user = session.get(UserDTO.class, userId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Lấy user theo username (chỉ lấy user chưa bị ẩn)
    public UserDTO getUserByUsername(String username) {
        UserDTO user = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<UserDTO> query = session.createQuery(
                    "FROM tblUser WHERE username = :username", UserDTO.class);
            query.setParameter("username", username);
            user = query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Lấy tất cả user chưa ẩn
    public List<UserDTO> getVisibleUsers() {
        List<UserDTO> users = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            users = session.createQuery("FROM tblUser WHERE hidden = false", UserDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    // Lấy tất cả user đã bị ẩn
    public List<UserDTO> getHiddenUsers() {
        List<UserDTO> users = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            users = session.createQuery("FROM tblUser WHERE hidden = true", UserDTO.class).list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean isUserExist(String username) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<UserDTO> query = session.createQuery("FROM tblUser WHERE username = :username", UserDTO.class);
            query.setParameter("username", username);
            UserDTO user = query.uniqueResult();
            return user != null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExist(String email) {
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<UserDTO> query = session.createQuery("FROM tblUser WHERE email = :email", UserDTO.class);
            query.setParameter("email", email);
            UserDTO user = query.uniqueResult();
            return user != null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public UserDTO getUserByEmail(String email) {
        UserDTO user = null;
        try ( Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<UserDTO> query = session.createQuery("FROM tblUser WHERE email = :email", UserDTO.class);
            query.setParameter("email", email);
            user = query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

}
