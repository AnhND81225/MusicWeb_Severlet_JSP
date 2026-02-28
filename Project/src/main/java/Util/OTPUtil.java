package Util;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;

public class OTPUtil {

    public static String generateOTP() {
        return String.format("%06d", new Random().nextInt(1000000));
    }

    public static void sendEmail(String toEmail, String subject, String body) {
        final String fromEmail = "phanthanhdat2505@gmail.com";
        final String password = "nvjw dpeb zxxm rqlx"; // App Password Gmail

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail, "LoveMusic"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setText(body);
            Transport.send(msg);
            System.out.println("Email sent successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String verifyOTP(String otpOriginal, String otpInput, LocalDateTime sendAt, LocalDateTime confirmAt) {
        if (otpOriginal == null || otpInput == null) return "OTP empty";

        Duration duration = Duration.between(sendAt, confirmAt);
        if (duration.toMinutes() > 5) return "OTP expired";

        if (!otpOriginal.equals(otpInput)) return "Wrong OTP";

        return "OK";
    }
}
