package Controller;

import Model.DTO.SubscriptionDTO;
import Model.DTO.UserDTO;
import Model.DTO.UserSubscriptionDTO;
import Model.Service.SubscriptionService;
import Model.Service.UserSubscriptionService;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "SubscriptionController", urlPatterns = {"/SubscriptionController"})
public class SubscriptionController extends HttpServlet {

    private final SubscriptionService subscriptionService = new SubscriptionService();
    private final UserSubscriptionService userSubscriptionService = new UserSubscriptionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("txtAction");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listPlans(request, response);
                break;
            case "details":
                viewPlanDetails(request, response);
                break;
            case "buy":
                buyPlan(request, response);
                break;
            case "my":
                viewMySubscription(request, response);
                break;
            case "cancel":
                cancelSubscription(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "createSubmit":
                createSubmit(request, response);
                break;
            case "manage":
                managePlans(request, response);
                break;
            case "toggleHide":
                toggleHide(request, response);
                break;
            case "delete":
                deletePlan(request, response);
                break;
            default:
                listPlans(request, response);
                break;
        }
    }

    // Hiển thị danh sách tất cả gói
    private void listPlans(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ thay getAllSubscriptions() → getAll()
        List<SubscriptionDTO> plans = subscriptionService.getAll();
        request.setAttribute("plans", plans);
        request.getRequestDispatcher("/subscription/subscriptionList.jsp").forward(request, response);
    }

    // Xem chi tiết 1 gói
    private void viewPlanDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int planId = Integer.parseInt(request.getParameter("id"));
        // ✅ thay getSubscriptionById() → getById()
        SubscriptionDTO plan = subscriptionService.getById(planId);

        if (plan == null) {
            request.setAttribute("error", "Plan not found!");
            request.getRequestDispatcher("/subscription/subscriptionList.jsp").forward(request, response);
            return;
        }

        request.setAttribute("plan", plan);
        request.getRequestDispatcher("subscriptionDetail.jsp").forward(request, response);
    }

    // Hiển thị trang quản lý gói (ADMIN)
    private void managePlans(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Kiểm tra quyền: bạn đang dùng 'admin' (lowercase) ở nhiều nơi — thống nhất dùng 'admin'
        if (session == null || session.getAttribute("role") == null || !"Admin".equals(session.getAttribute("role"))) {
            // nếu không phải admin thì redirect về trang login hoặc thông báo
            response.sendRedirect(request.getContextPath() + "/SubscriptionController?txtAction=manage");
            return;
        }

        // Lấy danh sách gói từ service
        List<SubscriptionDTO> plans = subscriptionService.getAllForAdmin();


        // Debug (tùy chọn)
        System.out.println("managePlans -> plans size = " + (plans == null ? 0 : plans.size()));

        // Đặt attribute và forward tới JSP quản lý
        request.setAttribute("plans", plans);
        request.getRequestDispatcher("/subscription/subscriptionManage.jsp").forward(request, response);
    }

    // Mua gói
    private void buyPlan(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            // nếu chưa login → chuyển tới login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // đọc planId: chấp nhận param "planId" (JS P/ form) hoặc fallback "id"
        String planIdStr = request.getParameter("planId");
        if (planIdStr == null) {
            planIdStr = request.getParameter("id");
        }

        if (planIdStr == null) {
            request.setAttribute("error", "Missing plan id.");
            listPlans(request, response);
            return;
        }

        try {
            int planId = Integer.parseInt(planIdStr);
            boolean success = userSubscriptionService.subscribeUserToPlan(user.getUserID(), planId);

            if (success) {
                // Cập nhật session userSubscription để header + các trang khác hiển thị đúng
                UserSubscriptionDTO current = userSubscriptionService.getActiveSubscriptionByUser(user.getUserID());
                session.setAttribute("userSubscription", current);

                // Redirect về trang "my subscription"
                response.sendRedirect(request.getContextPath() + "/SubscriptionController?txtAction=my");
                return;
            } else {
                request.setAttribute("error", "Subscription failed! Try again later.");
                listPlans(request, response);
                return;
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Invalid plan id.");
            listPlans(request, response);
            return;
        }
    }

    // Xem gói hiện tại của user
    private void viewMySubscription(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserSubscriptionDTO userSub = userSubscriptionService.getActiveSubscriptionByUser(user.getUserID());
        request.setAttribute("userSub", userSub);
        request.getRequestDispatcher("/subscription/subscriptionDetail.jsp").forward(request, response);
    }

    // Hủy gói hiện tại
    private void cancelSubscription(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        boolean success = userSubscriptionService.cancelSubscription(user.getUserID());
        if (success) {
            // Sau khi hủy, cập nhật session userSubscription (thường là null)
            UserSubscriptionDTO current = userSubscriptionService.getActiveSubscriptionByUser(user.getUserID());
            session.setAttribute("userSubscription", current);

            // Redirect sang trang my subscription (sẽ hiển thị "chưa có gói")
            response.sendRedirect(request.getContextPath() + "/SubscriptionController?txtAction=my");
            return;
        } else {
            request.setAttribute("error", "Failed to cancel subscription.");
            // đảm bảo view hiển thị hiện trạng mới nhất
            viewMySubscription(request, response);
            return;
        }
    }

    // Mở form tạo gói (GET)
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu bạn đặt file ở subscriptionCreate.jsp
        request.getRequestDispatcher("subscriptionCreate.jsp").forward(request, response);
    }

// Nhận form và lưu DB (POST)
    private void createSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String durationStr = request.getParameter("duration");
        String description = request.getParameter("description");

        // Validate đơn giản
        if (name == null || name.isEmpty() || priceStr == null || durationStr == null) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Name, Price, Duration.");
            request.getRequestDispatcher("subscriptionCreate.jsp").forward(request, response);
            return;
        }

        try {
            int price = Integer.parseInt(priceStr.trim());
            int duration = Integer.parseInt(durationStr.trim());

            boolean ok = subscriptionService.addSubscription(name.trim(), price, duration, description);
            if (ok) {
                // Sau khi tạo xong, quay về trang quản lý hoặc danh sách
                // Nếu bạn có action=manage:
                response.sendRedirect("SubscriptionController?action=manage");
            } else {
                request.setAttribute("error", "Tạo gói thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher("subscriptionCreate.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá hoặc số ngày không hợp lệ.");
            request.getRequestDispatcher("subscriptionCreate.jsp").forward(request, response);
        }
    }
    // Toggle hide/unhide

    private void toggleHide(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                boolean ok = subscriptionService.toggleHide(id); // implement ở service
                // redirect về trang manage để load lại dữ liệu
                response.sendRedirect(request.getContextPath() + "/SubscriptionController?txtAction=manage");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        // fallback
        response.sendRedirect(request.getContextPath() + "/SubscriptionController?txtAction=manage");
    }

// Delete (soft delete)
    private void deletePlan(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                boolean ok = subscriptionService.deleteById(id); // implement ở service -> DAO
                response.sendRedirect(request.getContextPath() + "/SubscriptionController?txtAction=manage");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/SubscriptionController?txtAction=manage");
    }
}
