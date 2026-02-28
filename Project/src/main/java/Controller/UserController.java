package Controller;

import Model.DTO.UserDTO;
import Model.DTO.SubscriptionDTO;
import Model.Service.UserSubscriptionService;
import Model.Service.SubscriptionService;
import Service.UserService;
import Util.OTPUtil;
import java.io.IOException;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import javax.servlet.ServletContext;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024) // 10MB
@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    // ✅ LOGIN
    protected void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("txtUsername");
        String password = request.getParameter("txtPassword");

        UserService userService = new UserService();
        HttpSession session = request.getSession();

        UserDTO user = userService.getUserByUserName(username);

        if (user != null && !user.isHidden() && userService.login(username, password)) {
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserID()); // ✅ thêm dòng này
            session.setAttribute("role", user.getRole());

            try {
                Service.NotificationService ns = new Service.NotificationService(new Model.DAO.NotificationDAO());
                java.util.List<Model.DTO.NotificationDTO> unread = ns.getUnreadNotificationsByUserId(user.getUserID());
                int unreadCount = ns.countUnreadNotificationsByUserId(user.getUserID());

                session.setAttribute("unreadNotifications", unread);
                session.setAttribute("unreadCount", unreadCount);
            } catch (Exception e) {
                System.err.println("⚠️ Lỗi khi tải thông báo cho user: " + e.getMessage());
                e.printStackTrace();
            }

            // optional: nếu bạn muốn hiển thị avatar URL đầy đủ (ví dụ base path)
            // nếu avatarUrl trong DB là relative (ví dụ 'avatar.jpg'), bạn có thể set:
            // String avatar = user.getAvatarUrl();
            // if (avatar == null || avatar.isEmpty()) {
            //     avatar = request.getContextPath() + "/Image/avatar-default.png";
            // } else if (!avatar.startsWith("http")) {
            //     avatar = request.getContextPath() + "/Image/" + avatar;
            // }
            // session.setAttribute("avatarUrl", avatar);
            UserSubscriptionService userSubService = new UserSubscriptionService();
            userSubService.checkAndUpdateStatus();

            session.setAttribute("userSubscription", userSubService.getCurrentSubscription(user));

            response.sendRedirect("SongController?action=viewSongs");

        } else {
            request.setAttribute("msg", "Invalid Username or Password!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // ✅ REGISTER → SEND OTP
    // REGISTER → SAVE AVATAR (unique filename) → START OTP FLOW
    protected void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("txtEmail");
        String username = request.getParameter("txtUsername");
        String password = request.getParameter("txtPassword");

        UserService userService = new UserService();
        // duplicate username
        if (userService.getUserByUserName(username) != null) {
            request.setAttribute("txtUsername", username);
            request.setAttribute("txtEmail", email);
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // duplicate email
        if (userService.getUserByEmail(email) != null) {
            request.setAttribute("txtUsername", username);
            request.setAttribute("txtEmail", email);
            request.setAttribute("error", "Email đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // tiếp tục phần upload avatar, gửi OTP như cũ
        HttpSession session = request.getSession();
        String savedAvatarRelative = null;
        try {
            Part avatarPart = request.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String submittedName = avatarPart.getSubmittedFileName();
                String contentType = avatarPart.getContentType();

                if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                    request.setAttribute("error", "File tải lên không phải ảnh.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                String ext = submittedName.substring(submittedName.lastIndexOf('.')).toLowerCase();
                if (!(ext.equals(".png") || ext.equals(".jpg") || ext.equals(".jpeg"))) {
                    request.setAttribute("error", "Chỉ chấp nhận ảnh .png / .jpg / .jpeg");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                if (avatarPart.getSize() > 3L * 1024 * 1024) {
                    request.setAttribute("error", "Kích thước ảnh tối đa 3MB.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                String unique = System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + ext;
                ServletContext ctx = getServletContext();
                //luu server
                String imagesPath = ctx.getRealPath("/Image/avatar");
//
//                if (imagesPath == null) {
//                    imagesPath = Paths.get(System.getProperty("user.dir"), "PRJ301", "Music_Web", "src", "main", "webapp", "Image", "avatar").toString();
//                }
                //luu local
//                String imagesPath = "C:\\Users\\ASUS\\OneDrive\\Desktop\\ky4\\MusicWeb_ASM_PRJ301_ducanh\\src\\main\\webapp\\Image\\avatar";

                File uploadDir = new File(imagesPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                File file = new File(uploadDir, unique);
                try ( InputStream in = avatarPart.getInputStream()) {
                    Files.copy(in, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }

                savedAvatarRelative = "avatar/" + unique;
                session.setAttribute("register_avatar", savedAvatarRelative);
            } else {
                session.removeAttribute("register_avatar");
            }
        } catch (Exception ex) {
            request.setAttribute("error", "Lỗi upload ảnh: " + ex.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // --- continue OTP flow ---
        String otp = OTPUtil.generateOTP();
        session.setAttribute("otp", otp);
        session.setAttribute("otpSend", LocalDateTime.now());
        session.setAttribute("register_email", email);
        session.setAttribute("register_username", username);
        session.setAttribute("register_password", password);
        session.setAttribute("otpAttempts", 0);
        OTPUtil.sendEmail(email, "OTP Authentication", "Your OTP is: " + otp);
        request.setAttribute("message", "OTP đã được gửi! Vui lòng kiểm tra email của bạn.");
        request.getRequestDispatcher("otpAuthenticator.jsp").forward(request, response);
    }

    // ✅ VERIFY OTP
    // VERIFY OTP → CREATE USER → ASSIGN AVATAR IF ANY
    protected void processVerifyOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String otpInput = request.getParameter("txtOTP");
        String otpOriginal = (String) session.getAttribute("otp");
        LocalDateTime sendAt = (LocalDateTime) session.getAttribute("otpSend");

        String email = (String) session.getAttribute("register_email");
        String username = (String) session.getAttribute("register_username");
        String password = (String) session.getAttribute("register_password");

        String result = OTPUtil.verifyOTP(otpOriginal, otpInput, sendAt, LocalDateTime.now());

        if (!result.equals("OK")) {
            request.setAttribute("error", result);
            request.getRequestDispatcher("otpAuthenticator.jsp").forward(request, response);
            return;
        }

        UserService service = new UserService();
        String status = service.register(email, username, password); // create user

        if (!status.equals("OK")) {
            request.setAttribute("error", status);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Nếu có avatar được upload trong lúc register, gán vào user vừa tạo
        String avatarFile = (String) session.getAttribute("register_avatar"); // e.g. "avatar/1234_uuid.png"
        if (avatarFile != null && !avatarFile.isEmpty()) {
            Model.DAO.UserDAO userDao = new Model.DAO.UserDAO();
            UserDTO newUser = service.getUserByUserName(username);
            if (newUser != null) {
                newUser.setAvatarUrl(avatarFile); // lưu giá trị relative như "avatar/xxx.png"
                userDao.updateUser(newUser);
            }
        }

        // ✅ Create Free Plan (giữ nguyên luồng của bạn)
        SubscriptionService subService = new SubscriptionService();
        UserSubscriptionService userSubService = new UserSubscriptionService();

        SubscriptionDTO freePlan = subService.getByName("Free Plan");
        if (freePlan != null) {
            UserDTO newUser = service.getUserByUserName(username);
            userSubService.createSubscription(newUser, freePlan);
        }

        // Clear OTP session (lưu ý: avatar đã lưu trong DB nếu có)
        session.invalidate();

        request.setAttribute("msg", "Register success! Please login.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // ✅ RESEND OTP
    protected void processResendOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer attempts = (Integer) session.getAttribute("otpAttempts");
        attempts = attempts == null ? 0 : attempts;

        if (attempts >= 5) {
            request.setAttribute("error", "Too many requests! Try again in 30 minutes.");
            request.getRequestDispatcher("otpAuthenticator.jsp").forward(request, response);
            return;
        }

        LocalDateTime last = (LocalDateTime) session.getAttribute("otpSend");
        if (last != null && last.plusMinutes(2).isAfter(LocalDateTime.now())) {
            request.setAttribute("error", "Wait 2 minutes to resend OTP.");
            request.getRequestDispatcher("otpAuthenticator.jsp").forward(request, response);
            return;
        }

        String email = (String) session.getAttribute("register_email");
        String otp = OTPUtil.generateOTP();

        session.setAttribute("otp", otp);
        session.setAttribute("otpSend", LocalDateTime.now());
        session.setAttribute("otpAttempts", attempts + 1);

        OTPUtil.sendEmail(email, "Resend OTP", "Your OTP is: " + otp);

        request.setAttribute("message", "OTP resent! Check your email.");
        request.getRequestDispatcher("otpAuthenticator.jsp").forward(request, response);
    }

    // ✅ LOGOUT
    protected void processLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.getSession().invalidate();
        response.sendRedirect("login.jsp");
    }

    // ✅ FORGOT PASSWORD → SEND OTP
    protected void processForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("txtEmail");
        UserService userService = new UserService();

        if (userService.getUserByEmail(email) == null) {
            request.setAttribute("error", "Email not found!");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        String otp = OTPUtil.generateOTP();
        session.setAttribute("fp_otp", otp);
        session.setAttribute("fp_email", email);
        session.setAttribute("fp_send", LocalDateTime.now());

        OTPUtil.sendEmail(email, "Password Reset OTP", "Your OTP is: " + otp);

        request.setAttribute("message", "OTP sent! Please check your email.");
        request.getRequestDispatcher("verifyForgotOTP.jsp").forward(request, response);
    }

    // ✅ VERIFY FORGOT PASSWORD OTP
    protected void processVerifyForgotOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String otpInput = request.getParameter("txtOTP");
        String otpOriginal = (String) session.getAttribute("fp_otp");
        LocalDateTime sendAt = (LocalDateTime) session.getAttribute("fp_send");

        String result = OTPUtil.verifyOTP(otpOriginal, otpInput, sendAt, LocalDateTime.now());

        if (!result.equals("OK")) {
            request.setAttribute("error", result);
            request.getRequestDispatcher("verifyForgotOTP.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
    }

    // ✅ RESET PASSWORD (dùng UserService)
    protected void processResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("fp_email");
        String newPassword = request.getParameter("txtNewPassword");

        UserService userService = new UserService();
        boolean success = userService.resetPassword(email, newPassword);

        if (!success) {
            request.setAttribute("error", "Failed to reset password!");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }

        session.invalidate();

        request.setAttribute("msg", "Password reset successfully! Please login.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // ✅ ROUTER
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("txtAction");

        switch (action) {
            case "login":
                processLogin(request, response);
                break;
            case "register":
                processRegister(request, response);
                break;
            case "verifyOTP":
                processVerifyOTP(request, response);
                break;
            case "resendOTP":
                processResendOTP(request, response);
                break;
            case "logout":
                processLogout(request, response);
                break;
            case "forgotPassword":
                processForgotPassword(request, response);
                break;
            case "verifyForgotOTP":
                processVerifyForgotOTP(request, response);
                break;
            case "resetPassword":
                processResetPassword(request, response);
                break;
            default:
                response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
}
