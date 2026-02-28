/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import Model.DAO.UserDAO;
import Model.DTO.UserDTO;
import java.util.regex.Pattern;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author phant
 */
public class UserService {

    private final UserDAO userDAO = new UserDAO();
    private static final int BCRYPT_COST = 12;
    private static final String PEPPER = "music@project_PRJ301";
    private static final String USERNAME_PATTERN = "^[A-Za-z0-9]{3,20}$";
    private static final String EMAIL_PATTERN = "^[A-Za-z0-9._%+-]{5,64}@(gmail\\.com|email\\.com)$";

    public UserService() {
    }

    public static String applyPepper(String rawPassword) {
        return rawPassword + PEPPER;
    }

    public String hashPassword(String rawPassword) {
        String applyPepper = applyPepper(rawPassword);
        return BCrypt.hashpw(applyPepper, BCrypt.gensalt(BCRYPT_COST));
    }

    public static boolean verifyPassword(String rawPassword, String dbPassword) {
        try {
            return BCrypt.checkpw(applyPepper(rawPassword), dbPassword);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    public boolean login(String username, String password) {
        UserDTO user = userDAO.getUserByUsername(username);
        if (user != null && !user.isHidden() && user.getUsername() != null && !user.getUsername().isEmpty()) {
            boolean verify = verifyPassword(password, user.getPassword());
            System.out.println(verify);
            if (verify) {
                System.out.println("Login success.");
                return true;
            }

        }
        return false;
    }

    public String register(String email, String username, String password) {
        String normalizedEmail = email.trim().toLowerCase();
        if (!normalizedEmail.matches(EMAIL_PATTERN)) {
            return "Email không hợp lệ (định dạng sai).";
        }

        String u = username.trim();
        if (!u.matches(USERNAME_PATTERN)) {
            return "Username chỉ gồm chữ và số (3–20 ký tự), không ký tự đặc biệt.";
        }
        // --- TODO: validate password, băm bcrypt, lưu DB ---
        UserDTO userDTO = new UserDTO();
        userDTO.setUsername(username);
        userDTO.setEmail(normalizedEmail);
        userDTO.setHidden(false);
        userDTO.setPassword(hashPassword(password));
        userDTO.setAvatarUrl(null); // hoặc set đường dẫn default: "/Image/avatar-default.png"
        userDAO.addUser(userDTO);
        return "OK";
    }

    public UserDTO getUserByUserName(String username) {
        return userDAO.getUserByUsername(username);
    }
    // ✅ Lấy user bằng email

    public UserDTO getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }

// ✅ Cập nhật mật khẩu mới (sau khi hash)
    public boolean resetPassword(String email, String newPassword) {
        UserDTO user = userDAO.getUserByEmail(email);
        if (user == null) {
            return false;
        }
        user.setPassword(hashPassword(newPassword)); // Băm lại bằng BCrypt
        return userDAO.updateUser(user);
    }

}
