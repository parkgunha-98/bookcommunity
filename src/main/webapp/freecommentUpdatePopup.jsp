<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="freecomment.FreeCommentDAO"%>
<%@ page import="freecomment.FreeComment"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>댓글 수정</title>
</head>
<body>
    <%
        // boardID, bbsID, commentID가 null이나 빈 문자열이 아니면 파싱
        int freeboardID = 0;
        int freebbsID = 0;
        int freecommentID = 0;

        String freeboardIDStr = request.getParameter("freeboardID");
        String freebbsIDStr = request.getParameter("freebbsID");
        String freecommentIDStr = request.getParameter("freecommentID");

        // 각 ID 값이 null이 아니고 빈 값이 아닌지 확인 후 파싱
        if (freeboardIDStr != null && !freeboardIDStr.isEmpty()) {
            freeboardID = Integer.parseInt(freeboardIDStr);
        }

        if (freebbsIDStr != null && !freebbsIDStr.isEmpty()) {
            freebbsID = Integer.parseInt(freebbsIDStr);
        }

        if (freecommentIDStr != null && !freecommentIDStr.isEmpty()) {
            freecommentID = Integer.parseInt(freecommentIDStr);
        }

        // CommentDAO를 사용하여 수정할 댓글 가져오기
        FreeCommentDAO commentDAO = new FreeCommentDAO();
        String freecommentText = commentDAO.getUpdateComment(freecommentID);
    %>
    <form name="freecommentUpdateForm" method="post" action="freecommentUpdateAction.jsp">
        <h3>댓글 수정</h3>
        <!-- 전달할 데이터 -->
        <input type="hidden" name="freeboardID" value="<%= freeboardID %>">
        <input type="hidden" name="freebbsID" value="<%= freebbsID %>">
        <input type="hidden" name="freecommentID" value="<%= freecommentID %>">
        <textarea name="freecommentText" style="width: 400px; height: 100px;"><%= freecommentText %></textarea><br>
        <input type="submit" value="수정">
    </form>
</body>
</html>
