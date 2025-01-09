package com.chatconn.servlets;

import com.chatconn.utils.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpSession;

@WebServlet("/conversations")
public class ConversationsServlet extends HttpServlet {

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
        
        List<String> chatGroups = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Ensure the table name matches your schema
            String sql = "SELECT group_name FROM chat_groups";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        chatGroups.add(rs.getString("group_name"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the exception for debugging
            throw new ServletException("Database access error.", e); // Pass the exception to see the root cause
        }

        request.setAttribute("chatGroups", chatGroups);
        request.getRequestDispatcher("conversations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupName = request.getParameter("groupName");

        if (groupName != null && !groupName.trim().isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                // Ensure the table name matches your schema
                String checkGroupSql = "SELECT group_name FROM chat_groups WHERE group_name = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkGroupSql)) {
                    checkStmt.setString(1, groupName);
                    try (ResultSet rs = checkStmt.executeQuery()) {
                        if (!rs.next()) {
                            // Group does not exist, so create it
                            String insertGroupSql = "INSERT INTO chat_groups (group_name) VALUES (?)";
                            try (PreparedStatement insertStmt = conn.prepareStatement(insertGroupSql)) {
                                insertStmt.setString(1, groupName);
                                insertStmt.executeUpdate();
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException("Database access error.", e);
            }
        }
        response.sendRedirect("conversations");
    }
}