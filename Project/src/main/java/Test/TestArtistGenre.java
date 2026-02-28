package Test;

import Model.DTO.ArtistDTO;
import Model.DTO.GenreDTO;
import org.hibernate.Session;
import org.hibernate.Transaction;
import Util.HibernateUtil;

import java.time.LocalDateTime;
import java.util.HashSet;

public class TestArtistGenre {

    public static void main(String[] args) {

        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;

        try {
            tx = session.beginTransaction();

            // Tạo 2 Genre
            GenreDTO pop = new GenreDTO("Pop", true, false, "pop.png");
            GenreDTO rock = new GenreDTO("Rock", false, false, "rock.png");

            session.save(pop);
            session.save(rock);

            // Tạo Artist
            ArtistDTO artist = new ArtistDTO();
            artist.setName("Nguyen Van A");
            artist.setBio("Ca sĩ nổi tiếng Việt Nam");
            artist.setImage("artist.png");
            artist.setCreatedAt(LocalDateTime.now());
            artist.setUpdatedAt(LocalDateTime.now());
            artist.setHidden(false);
            artist.setPopular(true);

            // Gắn N:N
            HashSet<GenreDTO> genres = new HashSet<>();
            genres.add(pop);
            genres.add(rock);

            artist.setGenres(genres);  // nhớ trong ArtistDTO phải có Set<GenreDTO> genres và @ManyToMany

            session.save(artist);

            tx.commit();
            System.out.println("✅ Lưu N:N Artist <-> Genre thành công!");

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }
}
