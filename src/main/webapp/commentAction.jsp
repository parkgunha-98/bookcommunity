<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.File" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="comment" class="comment.Comment" scope="page" />
<jsp:setProperty name="comment" property="commentText" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>옹기종기 책방</title>
</head>
<body>
	<%
		// 사용자 ID 확인
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}

		// 게시판 ID 확인
		int boardID = 0;
		if (request.getParameter("boardID") != null) {
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}

		// 로그인 체크
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
			script.close();
			return;
		} 

		// 게시글 ID 확인
		int bbsID = 0;
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}

		// 유효하지 않은 게시글 ID인 경우
		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
			script.close();
			return;
		} 

		// 댓글 내용 확인
		String commentText = request.getParameter("commentText");
		if (commentText == null || commentText.trim().isEmpty()) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
			script.close();
			return;
		} 

		// 댓글 작성
		CommentDAO commentDAO = new CommentDAO();
		int commentID = commentDAO.write(boardID, bbsID, userID, commentText);
		if (commentID == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('댓글 쓰기에 실패했습니다.')");
			script.println("history.back()");
			script.println("</script>");
			script.close();
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('댓글이 작성되었습니다.')");
			script.println("location.href=document.referrer;");
			script.println("</script>");
			script.close();
		}
	%>
</body>
</html>
