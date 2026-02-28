package Controller;

import Model.DAO.NotificationDAO;
import Model.DTO.NotificationDTO;
import Model.DTO.UserDTO;
import Service.NotificationService;
import Util.HibernateUtil;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.SessionFactory;

@WebServlet(name = "NotificationController", urlPatterns = {"/notification"})
public class NotificationController extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        SessionFactory factory = HibernateUtil.getSessionFactory();
        notificationService = new NotificationService(new NotificationDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                handleListNotifications(request, response);
                break;
            case "read":
                handleMarkAsRead(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("hide".equals(action)) {
            handleHideNotification(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid POST action!");
        }
    }

    // =========================================
    // 🔹 DANH SÁCH THÔNG BÁO
    // =========================================
    private void handleListNotifications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDTO currentUser = (UserDTO) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ 1. Lấy tất cả thông báo chưa ẩn
        List<NotificationDTO> notifications
                = notificationService.getUnreadNotificationsByUserId(currentUser.getUserID());

        // ✅ 2. Đếm số chưa đọc (chỉ để hiển thị)
        int unreadCount
                = notificationService.countUnreadNotificationsByUserId(currentUser.getUserID());

        // ✅ 3. Truyền xuống JSP (chỉ truyền 2 giá trị)
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/notification.jsp").forward(request, response);
    }

    // =========================================
    // 🔹 ĐÁNH DẤU ĐÃ ĐỌC + CHUYỂN TỚI COMMENT
    // =========================================
    private void handleMarkAsRead(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            notificationService.markNotificationAsRead(id);

            NotificationDTO notification = notificationService.getNotificationById(id);

            if (notification != null && notification.getSong() != null) {
                int songId = notification.getSong().getSongId();
                // ✅ Chuyển đến bài hát và phần comment
                response.sendRedirect("SongController?txtAction=play&songId=" + songId + "#comment-section");
            } else {
                response.sendRedirect("notification");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("notification");
        }
    }

    // =========================================
    // 🔹 ẨN THÔNG BÁO (XÓA MỀM)
    // =========================================
    private void handleHideNotification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = notificationService.hideNotification(id);

            if (success) {
                // 🔄 Cập nhật lại session sau khi xóa mềm
                UserDTO currentUser = (UserDTO) request.getSession().getAttribute("user");
                if (currentUser != null) {
                    List<NotificationDTO> updated
                            = notificationService.getUnreadNotificationsByUserId(currentUser.getUserID());
                    int unreadCount = updated != null ? updated.size() : 0;

                    // ✅ Cập nhật sessionScope (dùng trong HomePage.jsp)
                    request.getSession().setAttribute("unreadNotifications", updated);
                    request.getSession().setAttribute("unreadCount", unreadCount);
                }
            } else {
                System.err.println("❌ Lỗi khi ẩn thông báo ID: " + id);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Quay về lại homepage (hoặc notification tùy bạn muốn)
        response.sendRedirect(request.getContextPath() + "SongController?txtAction=viewSongs");
    }

}
