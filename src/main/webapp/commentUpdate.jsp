<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/custom.css">
    <title>옹기종기 책방</title>
</head>
<body>
    <%
        int boardID = 0;
        if (request.getParameter("boardID") != null) {
            boardID = Integer.parseInt(request.getParameter("boardID"));
        }

        int bbsID = 0;
        if (request.getParameter("bbsID") != null) {
            bbsID = Integer.parseInt(request.getParameter("bbsID"));
        }

        int commentID = 0;
        if (request.getParameter("commentID") != null) {
            commentID = Integer.parseInt(request.getParameter("commentID"));
        }

        CommentDAO commentDAO = new CommentDAO();
        String commentText = commentDAO.getUpdateComment(commentID);
    %>

    <div class="container" align="center">
        <div class="col-lg-10">
            <div class="jumbotron" style="padding-top: 1px;">
                <h3><br>댓글수정창</h3>
                <form name="c_commentUpdate">
                    <input type="text" id="update" style="width:400px;height:50px;" maxlength="1024" value="<%= commentText %>">
                    <input type="button" onclick="send(<%= boardID %>, <%= bbsID %>, <%= commentID %>)" value="수정">
                    <br><br>
                </form>
            </div>
        </div>
    </div>

    <script>
        function send(boardID, bbsID, commentID) {
            var commentText = document.c_commentUpdate.update.value;
            var sb = "commentUpdateAction.jsp?boardID=" + boardID + "&bbsID=" + bbsID + "&commentID=" + commentID + "&commentText=" + commentText;
            window.opener.location.href = sb;
            window.close();
        }
    </script>
</body>
</html>
