package Model.Service;

import Model.DAO.SubscriptionDAO;
import Model.DTO.SubscriptionDTO;
import java.util.ArrayList;
import java.util.List;

public class SubscriptionService {

    private final SubscriptionDAO subscriptionDAO = new SubscriptionDAO();

    /* ---------- Public API ---------- */
    // public list: trả các gói "visible" (hidden == null || false)
    public List<SubscriptionDTO> getAll() {
        List<SubscriptionDTO> all = subscriptionDAO.getAllSubscriptions();
        if (all == null) {
            return new ArrayList<>();
        }
        List<SubscriptionDTO> visible = new ArrayList<>();
        for (SubscriptionDTO s : all) {
            if (s.getHidden() == null || !s.getHidden()) {
                visible.add(s);
            }
        }
        return visible;
    }

    // admin list: trả tất cả (kể cả hidden)
    public List<SubscriptionDTO> getAllForAdmin() {
        List<SubscriptionDTO> all = subscriptionDAO.getAllSubscriptions();
        return all == null ? new ArrayList<>() : all;
    }

    public SubscriptionDTO getById(int id) {
        return subscriptionDAO.getById(id);
    }

    public boolean addSubscription(String name, int price, int durationDay, String description) {
        SubscriptionDTO sub = new SubscriptionDTO(name, price, durationDay, description);
        return subscriptionDAO.addSubscription(sub);
    }

    public boolean updateSubscription(SubscriptionDTO sub) {
        return subscriptionDAO.updateSubscription(sub);
    }

    /* ----- Hide / Delete helpers ----- */
    // Toggle hidden flag (ẩn <-> hiện)
    public boolean toggleHide(int id) {
        try {
            SubscriptionDTO s = subscriptionDAO.getById(id);
            if (s == null) {
                return false;
            }
            Boolean cur = s.getHidden();
            s.setHidden(cur == null ? Boolean.TRUE : !cur);
            return subscriptionDAO.updateSubscription(s);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Soft delete (mặc định): mark hidden = true
    // Nếu bạn muốn hard delete, call subscriptionDAO.deleteSubscription(id) thay vì hideSubscription.
    public boolean deleteById(int id) {
        try {
            // dùng soft-delete để an toàn
            return subscriptionDAO.hideSubscription(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hard delete (nếu cần)
    public boolean hardDelete(int id) {
        try {
            return subscriptionDAO.deleteSubscription(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public SubscriptionDTO getByName(String name) {
        return subscriptionDAO.getByName(name);
    }
}
