<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conversations</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href='http://fonts.googleapis.com/css?family=Oswald:400,300,700' rel='stylesheet' type='text/css'>
</head>
<body>
    <div class="container">
        <div class="row my-4">
            <div class="col-md-3"></div>
            <div class="col-md-6 text-center">
                <h4 class="my-4 display-6" style="font-family: 'Oswald', sans-serif;">Welcome, <%= request.getAttribute("username")%></h4>
                <a href="./conversations" style="font-family: 'Oswald', sans-serif;" class="btn btn-success">Conversations</a>
                <a href="./profile" style="font-family: 'Oswald', sans-serif;" class="btn btn-secondary">Profile</a>
                <a href="login.html" style="font-family: 'Oswald', sans-serif;" class="btn btn-secondary">Log out</a>
                <div class="mt-5">
                    <h4 class="display-6" style="font-family: 'Oswald', sans-serif;">Available Chat Groups</h4>
                    <ul class="list-group" style="font-family: 'Oswald', sans-serif;">
                        <%
                            List<String> chatGroups = (List<String>) request.getAttribute("chatGroups");
                            if (chatGroups != null && !chatGroups.isEmpty()) {
                                for (String group : chatGroups) {
                        %>
                        <li class="list-group-item">
                            <a href="chat.jsp?chatGroup=<%= group%>"> <%= group%> </a>
                        </li>
                        <%
                                }
                            } else {
                        %>
                        <li class="list-group-item display-6" style="font-family: 'Oswald', sans-serif;">No groups found.</li>
                        <%
                            }
                        %>
                    </ul>
                    <form action="conversations" method="post" class="mt-4">
                        <div class="form-group">
                            <input type="text" name="groupName" class="form-control" placeholder="Enter new group name">
                        </div>
                        <button type="submit" class="btn btn-primary">Create Group</button>
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