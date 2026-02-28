package Model.Service;

import Model.DAO.UserSubscriptionDAO;
import Model.DAO.SubscriptionDAO;
import Model.DAO.UserDAO;
import Model.DTO.UserSubscriptionDTO;
import Model.DTO.SubscriptionDTO;
import Model.DTO.UserDTO;
import java.time.LocalDateTime;
import java.util.List;

public class UserSubscriptionService {

    private final UserSubscriptionDAO userSubDAO = new UserSubscriptionDAO();
    private final SubscriptionDAO subDAO = new SubscriptionDAO();
    private final UserDAO userDAO = new UserDAO();

    /**
     * ✅ Tạo mới gói subscription cho user (dùng sau khi đăng ký hoặc mua)
     */
    public boolean createSubscription(UserDTO user, SubscriptionDTO plan) {
        try {
            if (user == null || plan == null) {
                System.out.println("❌ user hoặc plan null");
                return false;
            }

            // Hủy gói hiện tại nếu đang active
            UserSubscriptionDTO current = getCurrentSubscription(user);
            if (current != null && Boolean.TRUE.equals(current.getIsActive())) {
                current.setIsActive(false);
                userSubDAO.updateSubscription(current);
            }

            UserSubscriptionDTO newSub = new UserSubscriptionDTO();
            newSub.setUser(user);
            newSub.setSubscription(plan);
            newSub.setStartDate(LocalDateTime.now());
            newSub.setEndDate(LocalDateTime.now().plusDays(plan.getDurationDay()));
            newSub.setIsActive(true);
            newSub.setIsDeleted(false);

            return userSubDAO.addSubscription(newSub);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ✅ Lấy gói hiện tại đang active và chưa hết hạn
     */
    public UserSubscriptionDTO getCurrentSubscription(UserDTO user) {
        if (user == null) {
            return null;
        }

        try {
            List<UserSubscriptionDTO> list = userSubDAO.getByUser(user);
            if (list == null || list.isEmpty()) {
                return null;
            }

            for (UserSubscriptionDTO s : list) {
                if (Boolean.TRUE.equals(s.getIsActive())) {
                    if (s.getEndDate() != null && s.getEndDate().isAfter(LocalDateTime.now())) {
                        return s;
                    } else {
                        // nếu đã hết hạn → tự tắt
                        s.setIsActive(false);
                        userSubDAO.updateSubscription(s);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✅ Lấy subscription đang active (dựa theo userId)
     */
    public UserSubscriptionDTO getActiveSubscriptionByUser(int userId) {
        try {
            UserDTO user = userDAO.getUserById(userId);
            return getCurrentSubscription(user);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * ✅ Hủy gói hiện tại (user chủ động)
     */
    public boolean cancelSubscription(int userId) {
        try {
            UserSubscriptionDTO active = getActiveSubscriptionByUser(userId);
            if (active == null) {
                return false;
            }

            active.setIsActive(false);
            active.setEndDate(LocalDateTime.now());
            return userSubDAO.updateSubscription(active);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ✅ Dành riêng cho SubscriptionController — đăng ký gói mới theo userId +
     * planId
     */
    public boolean subscribeUserToPlan(int userId, int planId) {
        try {
            UserDTO user = userDAO.getUserById(userId);
            SubscriptionDTO plan = subDAO.getById(planId);
            if (user == null || plan == null) {
                System.out.println("❌ Không tìm thấy user hoặc plan!");
                return false;
            }
            return createSubscription(user, plan);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ✅ Lấy toàn bộ lịch sử đăng ký của user
     */
    public List<UserSubscriptionDTO> getAllSubscriptionsByUser(int userId) {
        try {
            UserDTO user = userDAO.getUserById(userId);
            if (user == null) {
                return null;
            }
            return userSubDAO.getByUser(user);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * ✅ Quét toàn bộ DB và tự hủy gói hết hạn (dùng khi user login)
     */
    public void checkAndUpdateStatus() {
        try {
            List<UserSubscriptionDTO> list = userSubDAO.getActiveSubscriptions();
            if (list == null || list.isEmpty()) {
                return;
            }

            for (UserSubscriptionDTO s : list) {
                if (s.getEndDate() != null && s.getEndDate().isBefore(LocalDateTime.now())) {
                    s.setIsActive(false);
                    userSubDAO.updateSubscription(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
