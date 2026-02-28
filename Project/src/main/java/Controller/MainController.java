package Controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import javax.servlet.annotation.MultipartConfig;

@MultipartConfig
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String HOME_PAGE = "login.jsp";

    // USER
    private static final String[] USER_ACTIONS = {
        "login", "register", "verifyOTP", "resendOTP",
        "logout", "forgotPassword", "verifyForgotOTP", "resetPassword",
        "updateProfile", "viewProfile"
    };

    // SONG
    private static final String[] SONG_ACTIONS = {
        "addSong", "updateSong", "callAdd", "callUpdate",
        "hideSong", "restoreSong", "viewSongs", "viewHiddenSongs",
        "topSongs", "randomHome", "play", "search"
    };

    // ARTIST
    private static final String[] ARTIST_ACTIONS = {
        "addArtist", "updateArtist", "callAdd", "callUpdate",
        "hideArtist", "restoreArtist", "viewArtist",
        "viewHiddenArtist", "artistInfo", "top10", "search", "follow"
    };

    // ALBUM
    private static final String[] ALBUM_ACTIONS = {
        "addAlbum", "updateAlbum", "callAdd", "callUpdate",
        "hideAlbum", "restoreAlbum", "viewAlbum", "viewHidden",
        "topAlbum", "sorted", "byArtist", "byGenre", "search", "viewSongs"
    };

    // GENRE
    private static final String[] GENRE_ACTIONS = {
        "addGenre", "updateGenre", "callAdd", "callUpdate",
        "hideGenre", "restoreGenre", "viewGenre", "featured", "searchGenre"
    };

    // PLAYLIST
    private static final String[] PLAYLIST_ACTIONS = {
        "list", "view", "create", "callAddSong",
        "addSong", "removeSong", "delete"
    };

    // SUBSCRIPTION
    private static final String[] SUBSCRIPTION_ACTIONS = {
        "list", "details", "buy", "my", "cancel",
        "create", "createSubmit", "manage", "toggleHide", "delete"
    };

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

        response.setContentType("text/html;charset=UTF-8");

        // Có thể dùng txtAction hoặc action
        String action = request.getParameter("txtAction");
        if (action == null) {
            action = request.getParameter("action");
            // ở MainController khi action == null
            request.setAttribute("action", "viewSongs");
            request.getRequestDispatcher("SongController").forward(request, response);
            return;

        }

        String url = HOME_PAGE;
        if (action != null) {
            if (Arrays.asList(USER_ACTIONS).contains(action)) {
                url = "UserController";
            } else if (Arrays.asList(SONG_ACTIONS).contains(action)) {
                url = "SongController";
            } else if (Arrays.asList(ARTIST_ACTIONS).contains(action)) {
                url = "ArtistController";
            } else if (Arrays.asList(ALBUM_ACTIONS).contains(action)) {
                url = "AlbumController";
            } else if (Arrays.asList(GENRE_ACTIONS).contains(action)) {
                url = "GenreController";
            } else if (Arrays.asList(PLAYLIST_ACTIONS).contains(action)) {
                url = "PlaylistController";
            } else if (Arrays.asList(SUBSCRIPTION_ACTIONS).contains(action)) {
                url = "SubscriptionController";
            }
        }

        // chuyển tiếp
        request.getRequestDispatcher(url).forward(request, response);
    }
}
