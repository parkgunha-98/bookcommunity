<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="freecomment.FreeCommentDAO" %>
<%@ page import="freecomment.FreeComment" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/custom.css">
    <title>옹기종기 책방</title>
</head>
<body>
    <%
        int freeboardID = 0;
        if (request.getParameter("freeboardID") != null) {
            freeboardID = Integer.parseInt(request.getParameter("freeboardID"));
        }

        int freebbsID = 0;
        if (request.getParameter("freebbsID") != null) {
            freebbsID = Integer.parseInt(request.getParameter("freebbsID"));
        }

        int freecommentID = 0;
        if (request.getParameter("freecommentID") != null) {
            freecommentID = Integer.parseInt(request.getParameter("freecommentID"));
        }

        FreeCommentDAO freecommentDAO = new FreeCommentDAO();
        String commentText = freecommentDAO.getUpdateComment(freecommentID);
    %>
    

    <div class="container" align="center">
        <div class="col-lg-10">
            <div class="jumbotron" style="padding-top: 1px;">
                <h3><br>댓글수정창</h3>
                <form name="c_commentUpdate">
                    <input type="text" id="update" style="width:400px;height:50px;" maxlength="1024" value="<%= commentText %>">
                    <input type="button" onclick="send(<%= freeboardID %>, <%= freebbsID %>, <%= freecommentID %>)" value="수정">
                    <br><br>
                </form>
            </div>
        </div>
    </div>

    <script>
        function send(boardID, bbsID, commentID) {
            var commentText = document.c_commentUpdate.update.value;
            var sb = "freecommentUpdateAction.jsp?freeboardID=" + freeboardID + "&freebbsID=" + freebbsID + "&freecommentID=" + freecommentID + "&freecommentText=" + freecommentText;
            window.opener.location.href = sb;
            window.close();
        }
    </script>
</body>
</html>
