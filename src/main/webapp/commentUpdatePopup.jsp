<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="comment.CommentDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>댓글 수정</title>
</head>
<body>
    <%
        // boardID, bbsID, commentID가 null이나 빈 문자열이 아니면 파싱
        int boardID = 0;
        int bbsID = 0;
        int commentID = 0;

        String boardIDStr = request.getParameter("boardID");
        String bbsIDStr = request.getParameter("bbsID");
        String commentIDStr = request.getParameter("commentID");

        // 각 ID 값이 null이 아니고 빈 값이 아닌지 확인 후 파싱
        if (boardIDStr != null && !boardIDStr.isEmpty()) {
            boardID = Integer.parseInt(boardIDStr);
        }

        if (bbsIDStr != null && !bbsIDStr.isEmpty()) {
            bbsID = Integer.parseInt(bbsIDStr);
        }

        if (commentIDStr != null && !commentIDStr.isEmpty()) {
            commentID = Integer.parseInt(commentIDStr);
        }

        // CommentDAO를 사용하여 수정할 댓글 가져오기
        CommentDAO commentDAO = new CommentDAO();
        String commentText = commentDAO.getUpdateComment(commentID);
    %>
    <form name="commentUpdateForm" method="post" action="commentUpdateAction.jsp">
        <h3>댓글 수정</h3>
        <!-- 전달할 데이터 -->
        <input type="hidden" name="boardID" value="<%= boardID %>">
        <input type="hidden" name="bbsID" value="<%= bbsID %>">
        <input type="hidden" name="commentID" value="<%= commentID %>">
        <textarea name="commentText" style="width: 400px; height: 100px;"><%= commentText %></textarea><br>
        <input type="submit" value="수정">
    </form>
</body>
</html>
