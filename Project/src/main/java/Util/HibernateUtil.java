package Util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

public class HibernateUtil {

    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            Configuration configuration = new Configuration().configure();
            applyEnvironmentOverrides(configuration);
            return configuration.buildSessionFactory();
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console
            throw new ExceptionInInitializerError(e); // Ném lỗi để dừng chương trình
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        getSessionFactory().close();
    }

    private static void applyEnvironmentOverrides(Configuration configuration) {
        String jdbcUrl = firstNonBlank(
                env("JDBC_DATABASE_URL"),
                env("DB_URL"),
                toJdbcUrl(env("DATABASE_URL")),
                buildJdbcUrlFromPgVars()
        );
        String username = firstNonBlank(
                env("DB_USERNAME"),
                env("PGUSER"),
                usernameFromDatabaseUrl(env("DATABASE_URL"))
        );
        String password = firstNonBlank(
                env("DB_PASSWORD"),
                env("PGPASSWORD"),
                passwordFromDatabaseUrl(env("DATABASE_URL"))
        );

        override(configuration, "hibernate.connection.url", jdbcUrl);
        override(configuration, "hibernate.connection.username", username);
        override(configuration, "hibernate.connection.password", password);
        override(configuration, "hibernate.hbm2ddl.auto", env("HIBERNATE_HBM2DDL_AUTO"));
        override(configuration, "hibernate.show_sql", env("HIBERNATE_SHOW_SQL"));
        override(configuration, "hibernate.format_sql", env("HIBERNATE_FORMAT_SQL"));
    }

    private static void override(Configuration configuration, String key, String value) {
        if (value != null && !value.trim().isEmpty()) {
            configuration.setProperty(key, value.trim());
        }
    }

    private static String env(String key) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        return value == null ? null : value.trim();
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return null;
    }

    private static String buildJdbcUrlFromPgVars() {
        String host = env("PGHOST");
        String port = firstNonBlank(env("PGPORT"), "5432");
        String database = env("PGDATABASE");
        if (host == null || database == null) {
            return null;
        }
        return "jdbc:postgresql://" + host + ":" + port + "/" + database;
    }

    private static String toJdbcUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.trim().isEmpty()) {
            return null;
        }

        String trimmed = rawUrl.trim();
        if (trimmed.startsWith("jdbc:postgresql://")) {
            return trimmed;
        }

        if (trimmed.startsWith("postgres://") || trimmed.startsWith("postgresql://")) {
            URI uri = URI.create(trimmed);
            StringBuilder builder = new StringBuilder("jdbc:postgresql://")
                    .append(uri.getHost());
            if (uri.getPort() > 0) {
                builder.append(":").append(uri.getPort());
            }
            builder.append(uri.getPath());
            if (uri.getQuery() != null && !uri.getQuery().isEmpty()) {
                builder.append("?").append(uri.getQuery());
            }
            return builder.toString();
        }

        return trimmed;
    }

    private static String usernameFromDatabaseUrl(String rawUrl) {
        return userInfoPart(rawUrl, 0);
    }

    private static String passwordFromDatabaseUrl(String rawUrl) {
        return userInfoPart(rawUrl, 1);
    }

    private static String userInfoPart(String rawUrl, int index) {
        if (rawUrl == null || rawUrl.trim().isEmpty()) {
            return null;
        }
        try {
            URI uri = URI.create(rawUrl.trim());
            String userInfo = uri.getUserInfo();
            if (userInfo == null || userInfo.isEmpty()) {
                return null;
            }
            String[] parts = userInfo.split(":", 2);
            if (index >= parts.length) {
                return null;
            }
            return URLDecoder.decode(parts[index], StandardCharsets.UTF_8.name());
        } catch (Exception e) {
            return null;
        }
    }
}
