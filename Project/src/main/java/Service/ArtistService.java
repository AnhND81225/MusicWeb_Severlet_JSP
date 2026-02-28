package Service;

import Model.DAO.ArtistDao;
import Model.DTO.ArtistDTO;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;

public class ArtistService {

    private final ArtistDao artistDao = new ArtistDao();

    public boolean addArtist(ArtistDTO artist) {
        artist.setCreatedAt(LocalDateTime.now());
        artist.setUpdatedAt(LocalDateTime.now());
        return artistDao.insert(artist);
    }

    public boolean updateArtist(ArtistDTO artist) {
        artist.setUpdatedAt(LocalDateTime.now());
        return artistDao.update(artist);
    }

    public boolean hideArtist(int id) {
        return artistDao.hide(id);
    }

    public ArtistDTO getById(int id) {
        return artistDao.getById(id);
    }

    public List<ArtistDTO> getTopArtistsByFollowerCount(int limit) {
        return artistDao.getTopArtistsByFollowerCount(limit);
    }

    public ArtistDTO getByIdWithDetails(int id) {
        return artistDao.getByIdWithDetails(id);
    }

    public ArtistDTO getByIdEvenIfHidden(int id) {
        return artistDao.getByIdIncludingHidden(id);
    }

    public List<ArtistDTO> getAllArtists() {
        return artistDao.getAll();
    }

    public List<ArtistDTO> getAllWithAlbums() {
        return artistDao.getAllWithAlbums();
    }

    public List<ArtistDTO> getPopularWithAlbums() {
        return artistDao.getPopularWithAlbums();
    }

    public List<ArtistDTO> searchArtistsByName(String name) {
        return artistDao.searchByName(name);
    }

    public boolean restoreArtist(int artistId) {
        return artistDao.restore(artistId);
    }

    public List<ArtistDTO> getHiddenArtists() {
        return artistDao.getAllHidden();
    }

    public boolean followArtist(int artistId) {
        return artistDao.incrementFollower(artistId);
    }

    public ArtistDTO findOrCreateByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }

        String trimmed = name.trim();
        List<ArtistDTO> all = artistDao.getAll();
        for (ArtistDTO a : all) {
            if (a.getName() != null && a.getName().equalsIgnoreCase(trimmed)) {
                return a;
            }
        }

        ArtistDTO newArtist = new ArtistDTO();
        newArtist.setName(trimmed);
        newArtist.setCreatedAt(LocalDateTime.now());
        newArtist.setUpdatedAt(LocalDateTime.now());
        artistDao.insert(newArtist);
        return newArtist;
    }

    public boolean hasUserFollowedArtist(int userId, int artistId) {
        return artistDao.hasUserFollowedArtist(userId, artistId);
    }

    public boolean followArtist(int userId, int artistId) {
        return artistDao.followArtist(userId, artistId);
    }

    public ArtistDTO extractArtistFromRequest(HttpServletRequest request) {
        ArtistDTO artist = new ArtistDTO();

        try {
            String idStr = request.getParameter("artistID");
            if (idStr != null && !idStr.trim().isEmpty()) {
                artist.setArtistId(Integer.parseInt(idStr));
            }
        } catch (Exception ignored) {
        }

        artist.setName(request.getParameter("name"));
        artist.setBio(request.getParameter("bio"));
        artist.setImage(request.getParameter("image"));

        try {
            String followerStr = request.getParameter("followerCount");
            artist.setFollowerCount(followerStr != null ? Integer.parseInt(followerStr) : 0);
        } catch (Exception e) {
            artist.setFollowerCount(0);
        }

        artist.setPopular(request.getParameter("isPopular") != null);
        return artist;
    }
}
