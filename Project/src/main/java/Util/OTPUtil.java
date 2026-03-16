package Util;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class OTPUtil {
    private static final String DEFAULT_FROM_EMAIL = "alexithymia8125@gmail.com";
    private static final String DEFAULT_FROM_NAME = "miniZing";
    private static final String DEFAULT_SMTP_HOST = "smtp.gmail.com";
    private static final String DEFAULT_SMTP_PORT = "587";

    public static String generateOTP() {
        return String.format("%06d", new Random().nextInt(1000000));
    }

    public static void sendEmail(String toEmail, String subject, String body) throws MessagingException {
        final String fromEmail = getConfig("OTP_MAIL_FROM", DEFAULT_FROM_EMAIL);
        final String fromName = getConfig("OTP_MAIL_FROM_NAME", DEFAULT_FROM_NAME);
        final String password = getConfig("OTP_MAIL_APP_PASSWORD", "ahva efkb dzfc hemx");

        Properties props = new Properties();
        props.put("mail.smtp.host", getConfig("OTP_MAIL_SMTP_HOST", DEFAULT_SMTP_HOST));
        props.put("mail.smtp.port", getConfig("OTP_MAIL_SMTP_PORT", DEFAULT_SMTP_PORT));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail, fromName));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setText(body);
            Transport.send(msg);
            System.out.println("Email sent successfully from " + fromEmail);
        } catch (MessagingException e) {
            throw e;
        } catch (Exception e) {
            throw new MessagingException("Khong the gui email OTP.", e);
        }
    }

    public static String verifyOTP(String otpOriginal, String otpInput, LocalDateTime sendAt, LocalDateTime confirmAt) {
        if (otpOriginal == null || otpInput == null || sendAt == null || confirmAt == null) return "OTP empty";

        Duration duration = Duration.between(sendAt, confirmAt);
        if (duration.toMinutes() > 5) return "OTP expired";

        if (!otpOriginal.equals(otpInput)) return "Wrong OTP";

        return "OK";
    }

    private static String getConfig(String key, String fallbackValue) {
        String value = System.getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(key);
        }
        if (value == null || value.trim().isEmpty()) {
            return fallbackValue;
        }
        return value.trim();
    }
}
