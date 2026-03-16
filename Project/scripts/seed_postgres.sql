BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    oid_value oid;
BEGIN
    FOR oid_value IN
        SELECT content FROM comment WHERE content IS NOT NULL
        UNION
        SELECT bio FROM artist WHERE bio IS NOT NULL
        UNION
        SELECT lyric FROM song WHERE lyric IS NOT NULL
    LOOP
        PERFORM lo_unlink(oid_value);
    END LOOP;
END $$;

TRUNCATE TABLE
    userfollowartist,
    artist_genre,
    playlistsong,
    songartist,
    songlikes,
    comment,
    notification,
    tblusersubscription,
    tblplaylist,
    song,
    album,
    artist,
    genre,
    tblsubscription,
    tbluser
RESTART IDENTITY CASCADE;

INSERT INTO tbluser (user_id, username, password, email, role, avatar_url, create_time, update_time, hidden)
VALUES
    (1, 'admin', crypt('Admin12345music@project_PRJ301', gen_salt('bf', 12)), 'admin@gmail.com', 'Admin', 'avatar/avatar-default.png', NOW() - INTERVAL '30 days', NOW() - INTERVAL '1 day', FALSE),
    (2, 'lan', crypt('Lan12345music@project_PRJ301', gen_salt('bf', 12)), 'lan@gmail.com', 'Member', 'avatar/avatar-default.png', NOW() - INTERVAL '20 days', NOW() - INTERVAL '3 days', FALSE),
    (3, 'minh', crypt('Minh12345music@project_PRJ301', gen_salt('bf', 12)), 'minh@gmail.com', 'Member', 'avatar/avatar-default.png', NOW() - INTERVAL '18 days', NOW() - INTERVAL '5 days', FALSE),
    (4, 'thao', crypt('Thao12345music@project_PRJ301', gen_salt('bf', 12)), 'thao@gmail.com', 'Member', 'avatar/avatar-default.png', NOW() - INTERVAL '12 days', NOW() - INTERVAL '2 days', FALSE),
    (5, 'nam', crypt('Nam12345music@project_PRJ301', gen_salt('bf', 12)), 'nam@email.com', 'Member', 'avatar/avatar-default.png', NOW() - INTERVAL '9 days', NOW() - INTERVAL '1 day', FALSE);

INSERT INTO tblsubscription (plan_id, name_subscription, price, duration_in_days, description, hidden)
VALUES
    (1, 'Plus', 59000, 30, 'Nghe nhac khong quang cao, mo khoa playlist va thong bao uu tien.', FALSE),
    (2, 'Premium', 149000, 90, 'Mo toan bo tinh nang, theo doi nghe si va thong ke ca nhan.', FALSE),
    (3, 'Family', 249000, 180, 'Phu hop cho nhom ban hoac gia dinh voi thoi han dai.', FALSE);

INSERT INTO genre (genre_id, name, is_featured, is_hidden, image)
VALUES
    (1, 'Pop', TRUE, FALSE, '/musicweb/Image/logo.png'),
    (2, 'Ballad', TRUE, FALSE, '/musicweb/Image/logo.png'),
    (3, 'Indie', TRUE, FALSE, '/musicweb/Image/logo.png'),
    (4, 'Lo-fi', FALSE, FALSE, '/musicweb/Image/logo.png'),
    (5, 'Rap', TRUE, FALSE, '/musicweb/Image/logo.png'),
    (6, 'Acoustic', FALSE, FALSE, '/musicweb/Image/logo.png');

INSERT INTO artist (artist_id, name, bio, image, created_at, updated_at, is_hidden, is_popular, follower_count, genre_id)
VALUES
    (1, 'Hoang Dung', lo_from_bytea(0, convert_to('Ca si theo duoi mau pop ballad voi nhieu ban hit nhe nhang.', 'UTF8')), '/musicweb/Image/avatar/avatar-default.png', NOW() - INTERVAL '180 days', NOW() - INTERVAL '2 days', FALSE, TRUE, 12500, 2),
    (2, 'Vu.', lo_from_bytea(0, convert_to('Nghe si indie pop noi bat voi mau am nhac tinh te va day cam xuc.', 'UTF8')), '/musicweb/Image/avatar/avatar-default.png', NOW() - INTERVAL '170 days', NOW() - INTERVAL '5 days', FALSE, TRUE, 11800, 3),
    (3, 'Da LAB', lo_from_bytea(0, convert_to('Nhom nhac pho bien voi mau sac rap pop gan gui va de tiep can.', 'UTF8')), '/musicweb/Image/avatar/avatar-default.png', NOW() - INTERVAL '200 days', NOW() - INTERVAL '7 days', FALSE, TRUE, 15400, 5),
    (4, 'Low G', lo_from_bytea(0, convert_to('Rapper tre so huu nhieu track co nang luong va mau sac hien dai.', 'UTF8')), '/musicweb/Image/avatar/avatar-default.png', NOW() - INTERVAL '160 days', NOW() - INTERVAL '4 days', FALSE, TRUE, 9800, 5),
    (5, 'Chillies', lo_from_bytea(0, convert_to('Ban nhac indie mang am thanh acoustic va pop rock de nghe.', 'UTF8')), '/musicweb/Image/avatar/avatar-default.png', NOW() - INTERVAL '150 days', NOW() - INTERVAL '1 day', FALSE, TRUE, 8700, 6),
    (6, 'MCK', lo_from_bytea(0, convert_to('Nghe si rap melody voi kha nang bien hoa tren nhieu track khac nhau.', 'UTF8')), '/musicweb/Image/avatar/avatar-default.png', NOW() - INTERVAL '140 days', NOW() - INTERVAL '3 days', FALSE, TRUE, 11200, 5);

INSERT INTO artist_genre (artist_id, genre_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (3, 1),
    (3, 5),
    (4, 5),
    (5, 3),
    (5, 6),
    (6, 1),
    (6, 5);

INSERT INTO album (album_id, title, release_date, artist_id, genre_id, cover_image, created_date, updated_date, is_hidden, is_featured)
VALUES
    (1, 'Cham Mua He', NOW() - INTERVAL '420 days', 1, 2, '/musicweb/Image/logo.png', NOW() - INTERVAL '420 days', NOW() - INTERVAL '10 days', FALSE, TRUE),
    (2, 'Pho Dem Lang Yen', NOW() - INTERVAL '365 days', 2, 3, '/musicweb/Image/logo.png', NOW() - INTERVAL '365 days', NOW() - INTERVAL '7 days', FALSE, TRUE),
    (3, 'Thanh Pho Va Giac Mo', NOW() - INTERVAL '300 days', 3, 5, '/musicweb/Image/logo.png', NOW() - INTERVAL '300 days', NOW() - INTERVAL '6 days', FALSE, FALSE),
    (4, 'On The Mic', NOW() - INTERVAL '240 days', 4, 5, '/musicweb/Image/logo.png', NOW() - INTERVAL '240 days', NOW() - INTERVAL '5 days', FALSE, TRUE),
    (5, 'Acoustic Stories', NOW() - INTERVAL '180 days', 5, 6, '/musicweb/Image/logo.png', NOW() - INTERVAL '180 days', NOW() - INTERVAL '4 days', FALSE, FALSE),
    (6, 'Noi Bat Dem Nay', NOW() - INTERVAL '120 days', 6, 5, '/musicweb/Image/logo.png', NOW() - INTERVAL '120 days', NOW() - INTERVAL '2 days', FALSE, TRUE);

INSERT INTO song (song_id, title, file_path, image, lyric, duration, album_id, genre_id, created_at, updated_at, is_hidden, is_featured, image_path, play_count)
VALUES
    (1, 'Em Trong Cay', 'Em Trồng Cây.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Dem nhe tenh va gan gui nhu mot loi dong vien nho.', 'UTF8')), 248, 1, 2, NOW() - INTERVAL '90 days', NOW() - INTERVAL '2 days', FALSE, TRUE, '/musicweb/Image/logo.png', 152),
    (2, 'Hoang Hon', 'Hoàng Hôn.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Khuc hat cuoi ngay mang sac mau mem mai va am ap.', 'UTF8')), 261, 1, 2, NOW() - INTERVAL '88 days', NOW() - INTERVAL '2 days', FALSE, TRUE, '/musicweb/Image/logo.png', 185),
    (3, 'Ta Se Tro Lai', 'Ta Sẽ Trở Lại.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Tinh than tro lai va bat dau lai sau nhung lan do vo.', 'UTF8')), 233, 3, 5, NOW() - INTERVAL '80 days', NOW() - INTERVAL '3 days', FALSE, FALSE, '/musicweb/Image/logo.png', 95),
    (4, 'Cities Intro', 'Cities (Intro).mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Doan mo dau ngan gon cho mot dem nhac day nang luong.', 'UTF8')), 112, 4, 5, NOW() - INTERVAL '76 days', NOW() - INTERVAL '3 days', FALSE, FALSE, '/musicweb/Image/logo.png', 64),
    (5, 'Vo Dieu Kien', 'Vô Điều Kiện.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Tinh cam khong dieu kien duoc ke bang giai dieu mem mai.', 'UTF8')), 274, 2, 3, NOW() - INTERVAL '70 days', NOW() - INTERVAL '4 days', FALSE, TRUE, '/musicweb/Image/logo.png', 204),
    (6, 'Khong The Say', 'Không Thể Say.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Track mang mau sac rap melody de gay nghien va de nho.', 'UTF8')), 221, 6, 5, NOW() - INTERVAL '66 days', NOW() - INTERVAL '4 days', FALSE, TRUE, '/musicweb/Image/logo.png', 233),
    (7, 'Sai Gon Oi', 'Sài Gòn ơi.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Ca khuc viet ve thanh pho voi nhip song nhanh va nhieu ky niem.', 'UTF8')), 245, 3, 1, NOW() - INTERVAL '61 days', NOW() - INTERVAL '5 days', FALSE, FALSE, '/musicweb/Image/logo.png', 121),
    (8, 'Champion', 'Champion.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Tinh than chien thang va tu tin trong tung cau rap.', 'UTF8')), 219, 4, 5, NOW() - INTERVAL '55 days', NOW() - INTERVAL '5 days', FALSE, TRUE, '/musicweb/Image/logo.png', 267),
    (9, 'Everything Will Be Okay', 'Everything Will Be Okay.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Ban acoustic nhe nhang danh cho nhung ngay can duoc an ui.', 'UTF8')), 258, 5, 6, NOW() - INTERVAL '48 days', NOW() - INTERVAL '6 days', FALSE, FALSE, '/musicweb/Image/logo.png', 82),
    (10, 'Khieu Vu Trong Dem', 'Khiêu Vũ Trong Đêm.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Track pop rap voi tiet tau nhanh phu hop playlist buoi toi.', 'UTF8')), 231, 6, 1, NOW() - INTERVAL '42 days', NOW() - INTERVAL '6 days', FALSE, TRUE, '/musicweb/Image/logo.png', 176),
    (11, 'Con Ke Ba Nghe', 'Con kể Ba nghe.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Khuc hat tinh cam voi ca tu gian di va gan gui.', 'UTF8')), 286, 1, 2, NOW() - INTERVAL '35 days', NOW() - INTERVAL '7 days', FALSE, FALSE, '/musicweb/Image/logo.png', 140),
    (12, 'Noi Do Co Chung Ta Thuoc Ve Nhau', 'Nơi Đó Có Chúng Ta Thuộc Về Nhau.mp3', '/musicweb/Image/logo.png', lo_from_bytea(0, convert_to('Ban tinh ca de nghe trong nhung playlist cham va tinh.', 'UTF8')), 301, 2, 3, NOW() - INTERVAL '28 days', NOW() - INTERVAL '7 days', FALSE, TRUE, '/musicweb/Image/logo.png', 193);

INSERT INTO songartist (song_id, artist_id)
VALUES
    (1, 1),
    (2, 1),
    (3, 3),
    (4, 4),
    (5, 2),
    (6, 6),
    (7, 3),
    (8, 4),
    (9, 5),
    (10, 6),
    (11, 1),
    (12, 2);

INSERT INTO tblplaylist (playlist_id, name, user_id, is_favorite_list, created_at, updated_at, hidden)
VALUES
    (1, 'Admin Picks', 1, TRUE, NOW() - INTERVAL '15 days', NOW() - INTERVAL '1 day', FALSE),
    (2, 'Lan Chill Mix', 2, TRUE, NOW() - INTERVAL '10 days', NOW() - INTERVAL '1 day', FALSE),
    (3, 'Minh Rap Night', 3, FALSE, NOW() - INTERVAL '9 days', NOW() - INTERVAL '2 days', FALSE),
    (4, 'Thao Ballad Corner', 4, TRUE, NOW() - INTERVAL '7 days', NOW() - INTERVAL '2 days', FALSE),
    (5, 'Nam Roadtrip', 5, FALSE, NOW() - INTERVAL '6 days', NOW() - INTERVAL '1 day', FALSE);

INSERT INTO playlistsong (playlist_id, song_id)
VALUES
    (1, 1),
    (1, 5),
    (1, 8),
    (1, 10),
    (2, 2),
    (2, 5),
    (2, 9),
    (2, 12),
    (3, 3),
    (3, 6),
    (3, 8),
    (3, 10),
    (4, 1),
    (4, 2),
    (4, 11),
    (4, 12),
    (5, 4),
    (5, 7),
    (5, 8),
    (5, 9);

INSERT INTO songlikes (like_id, user_id, song_id, is_hidden)
VALUES
    (1, 2, 1, FALSE),
    (2, 2, 5, FALSE),
    (3, 3, 8, FALSE),
    (4, 3, 6, FALSE),
    (5, 4, 2, FALSE),
    (6, 4, 12, FALSE),
    (7, 5, 7, FALSE),
    (8, 5, 9, FALSE),
    (9, 1, 10, FALSE);

INSERT INTO comment (comment_id, content, created_at, is_hidden, parent_comment_id, song_id, user_id)
VALUES
    (1, lo_from_bytea(0, convert_to('Bai nay nghe cuon that su, doan hook rat hay.', 'UTF8')), NOW() - INTERVAL '5 days', FALSE, NULL, 5, 2),
    (2, lo_from_bytea(0, convert_to('Dong y, minh da repeat ca buoi sang.', 'UTF8')), NOW() - INTERVAL '4 days 20 hours', FALSE, 1, 5, 3),
    (3, lo_from_bytea(0, convert_to('Track nay hop nghe luc lam viec, rat de tap trung.', 'UTF8')), NOW() - INTERVAL '4 days', FALSE, NULL, 9, 4),
    (4, lo_from_bytea(0, convert_to('Phan rap va melody can bang rat on.', 'UTF8')), NOW() - INTERVAL '3 days', FALSE, NULL, 6, 5),
    (5, lo_from_bytea(0, convert_to('Playlist nay nen co them vai bai ballad nua.', 'UTF8')), NOW() - INTERVAL '2 days', FALSE, NULL, 2, 1),
    (6, lo_from_bytea(0, convert_to('Cam on goi y, admin se cap nhat them.', 'UTF8')), NOW() - INTERVAL '1 day 18 hours', FALSE, 5, 2, 1);

INSERT INTO notification (notification_id, message, is_read, is_hidden, created_at, user_id, song_id)
VALUES
    (1, 'Admin vua them bai hat Champion vao thu vien.', FALSE, FALSE, NOW() - INTERVAL '2 days', 2, 8),
    (2, 'Playlist Lan Chill Mix vua duoc cap nhat them bai moi.', TRUE, FALSE, NOW() - INTERVAL '36 hours', 2, 9),
    (3, 'Ban vua nhan mot phan hoi moi cho binh luan cua minh.', FALSE, FALSE, NOW() - INTERVAL '30 hours', 3, 5),
    (4, 'Goi Premium cua ban se het han trong 7 ngay toi.', FALSE, FALSE, NOW() - INTERVAL '20 hours', 4, NULL),
    (5, 'Nghe si ban theo doi vua co bai hat duoc de xuat.', TRUE, FALSE, NOW() - INTERVAL '12 hours', 5, 10),
    (6, 'Admin Picks vua dat moc 4 bai hat noi bat.', FALSE, FALSE, NOW() - INTERVAL '6 hours', 1, 10);

INSERT INTO tblusersubscription (subscription_id, user_id, plan_id, start_date, end_date, is_active, hidden)
VALUES
    (1, 1, 2, NOW() - INTERVAL '25 days', NOW() + INTERVAL '65 days', TRUE, FALSE),
    (2, 2, 3, NOW() - INTERVAL '20 days', NOW() + INTERVAL '160 days', TRUE, FALSE),
    (3, 3, 1, NOW() - INTERVAL '50 days', NOW() - INTERVAL '20 days', FALSE, FALSE),
    (4, 4, 2, NOW() - INTERVAL '10 days', NOW() + INTERVAL '80 days', TRUE, FALSE),
    (5, 5, 1, NOW() - INTERVAL '5 days', NOW() + INTERVAL '25 days', TRUE, FALSE);

INSERT INTO userfollowartist (user_id, artist_id, follow_time)
VALUES
    (2, 1, NOW() - INTERVAL '15 days'),
    (2, 2, NOW() - INTERVAL '10 days'),
    (3, 4, NOW() - INTERVAL '9 days'),
    (3, 6, NOW() - INTERVAL '8 days'),
    (4, 5, NOW() - INTERVAL '7 days'),
    (4, 1, NOW() - INTERVAL '6 days'),
    (5, 3, NOW() - INTERVAL '5 days'),
    (5, 4, NOW() - INTERVAL '4 days'),
    (1, 2, NOW() - INTERVAL '3 days');

SELECT setval(pg_get_serial_sequence('tbluser', 'user_id'), COALESCE((SELECT MAX(user_id) FROM tbluser), 1), TRUE);
SELECT setval(pg_get_serial_sequence('tblsubscription', 'plan_id'), COALESCE((SELECT MAX(plan_id) FROM tblsubscription), 1), TRUE);
SELECT setval(pg_get_serial_sequence('genre', 'genre_id'), COALESCE((SELECT MAX(genre_id) FROM genre), 1), TRUE);
SELECT setval(pg_get_serial_sequence('artist', 'artist_id'), COALESCE((SELECT MAX(artist_id) FROM artist), 1), TRUE);
SELECT setval(pg_get_serial_sequence('album', 'album_id'), COALESCE((SELECT MAX(album_id) FROM album), 1), TRUE);
SELECT setval(pg_get_serial_sequence('song', 'song_id'), COALESCE((SELECT MAX(song_id) FROM song), 1), TRUE);
SELECT setval(pg_get_serial_sequence('comment', 'comment_id'), COALESCE((SELECT MAX(comment_id) FROM comment), 1), TRUE);
SELECT setval(pg_get_serial_sequence('notification', 'notification_id'), COALESCE((SELECT MAX(notification_id) FROM notification), 1), TRUE);
SELECT setval(pg_get_serial_sequence('songlikes', 'like_id'), COALESCE((SELECT MAX(like_id) FROM songlikes), 1), TRUE);
SELECT setval(pg_get_serial_sequence('tblplaylist', 'playlist_id'), COALESCE((SELECT MAX(playlist_id) FROM tblplaylist), 1), TRUE);
SELECT setval(pg_get_serial_sequence('tblusersubscription', 'subscription_id'), COALESCE((SELECT MAX(subscription_id) FROM tblusersubscription), 1), TRUE);

COMMIT;
