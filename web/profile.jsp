<%@ page import="com.chatconn.servlets.ProfileServlet" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profile</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link href='http://fonts.googleapis.com/css?family=Oswald:400,300,700' rel='stylesheet' type='text/css'>
    </head>
    <body>
        <div class="container">
            <div class="row my-4">
                <div class="col-md-3"></div>

                <div class="col-md-6 text-center">
                    <h4 class="my-4 display-6" style="font-family: 'Oswald', sans-serif;">Welcome, <%= request.getAttribute("username")%></h4>
                    <a href="./home" style="font-family: 'Oswald', sans-serif;" class="btn btn-secondary">Conversations</a>
                    <a href="./profile" style="font-family: 'Oswald', sans-serif;" class="btn btn-success">Profile</a>
                    <a href="login.html" style="font-family: 'Oswald', sans-serif;" class="btn btn-secondary">Log out</a>
                    <div class="mt-5">
                        <h4 style="font-family: 'Oswald', sans-serif;" class="display-6">Your profile:</h4>

                        <%
                            String success = request.getParameter("success");
                            String error = request.getParameter("error");

                            if (success != null) {
                                out.println("<div  class='alert alert-success'>" + success + "</div>");
                            }
                            if (error != null) {
                                out.println("<div class='alert alert-danger'>" + error + "</div>");
                            }
                        %>

                        <form method="post" action="profile">
                            <div class="form-group">
                                <label for="username" style="font-family: 'Oswald', sans-serif;">Username:</label>
                                <input type="text" class="form-control" id="username" name="username" value="<%= request.getAttribute("username")%>" required>
                            </div>
                            <div class="form-group">
                                <label for="password" style="font-family: 'Oswald', sans-serif;">Password:</label>
                                <input type="password" class="form-control" id="password" name="password" value="<%= request.getAttribute("password")%>" required>
                            </div>
                            <button type="submit" style="font-family: 'Oswald', sans-serif;" class="btn btn-success">Update Profile</button>
                        </form>
                    </div>
                </div>

                <div class="col-md-3"></div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>