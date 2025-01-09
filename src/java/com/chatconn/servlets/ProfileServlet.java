package com.chatconn.servlets;

import com.chatconn.utils.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Get the current user's session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            // Redirect to login page if no user is logged in
            response.sendRedirect("login.jsp");
            return;
        }
        String username = (String) session.getAttribute("username");
        request.setAttribute("username", username);

        
        // Connect to the database
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM users WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Store user details in request attributes
                request.setAttribute("username", rs.getString("username"));
                request.setAttribute("password", rs.getString("password"));
            }

            // Forward to the profile page
            request.getRequestDispatcher("profile.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

        }
    }
    
     @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user's session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            // Redirect to login page if no user is logged in
            response.sendRedirect("login.jsp");
            return;
        }

        String currentUsername = (String) session.getAttribute("username");
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");

        // Connect to the database
        try (Connection conn = DatabaseConnection.getConnection()) {
            String updateQuery = "UPDATE users SET username = ?, password = ? WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, newUsername);
            stmt.setString(2, newPassword);
            stmt.setString(3, currentUsername);

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                // Update session with new username
                session.setAttribute("username", newUsername);

                // Redirect to the profile page with a success message
                response.sendRedirect("profile.jsp?success=Profile%20updated%20successfully");
            } else {
                // Redirect to the profile page with an error message
                response.sendRedirect("profile.jsp?error=Failed%20to%20update%20profile");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Database%20error");
        }
    }
}