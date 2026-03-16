package Controller;

import Model.DAO.SongLikesDAO;
import Service.SongLikesService;
import Util.HibernateUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.SessionFactory;

@WebServlet(name = "SongLikesController", urlPatterns = {"/like"})
public class SongLikesController extends HttpServlet {

    private SongLikesService songLikesService;

    @Override
    public void init() throws ServletException {
        SessionFactory factory = HibernateUtil.getSessionFactory();
        this.songLikesService = new SongLikesService(new SongLikesDAO(factory));
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String userIdParam = request.getParameter("userId");
    String songIdParam = request.getParameter("songId");

    if (userIdParam == null || songIdParam == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin userId hoặc songId");
        return;
    }

    int userId = Integer.parseInt(userIdParam);
    int songId = Integer.parseInt(songIdParam);

    songLikesService.toggleLike(userId, songId);

    // 🔹 QUAY VỀ TRANG BÀI HÁT ĐANG PHÁT THAY VÌ TRANG /like
    response.sendRedirect(request.getContextPath() + "/SongController?action=play&songId=" + songId);
}


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int songId = 1;
        String songIdParam = request.getParameter("id");
        if (songIdParam != null) {
            try { songId = Integer.parseInt(songIdParam); } catch (NumberFormatException ignored) {}
        }

        long likeCount = songLikesService.getLikeCountBySongId(songId);

        request.setAttribute("likeCount", likeCount);
        request.setAttribute("songId", songId);

        request.getRequestDispatcher("/like.jsp").forward(request, response);
    }
}
