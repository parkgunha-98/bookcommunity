<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="freecomment.FreeCommentDAO" %>
<%@ page import="freecomment.FreeComment" %>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>옹기종기 책방</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
			script.close();
			return;
		} 

		int freebbsID = 0;
		if (request.getParameter("freebbsID") != null){
			freebbsID = Integer.parseInt(request.getParameter("freebbsID"));
		}
		
		int freecommentID = 0;
		if (request.getParameter("freecommentID") != null) {
			freecommentID = Integer.parseInt(request.getParameter("freecommentID"));
		}
		if (freecommentID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 댓글 입니다.')");
			script.println("history.back()");
			script.println("</script>");
			script.close();
			return;
		}
		
		FreeComment freecomment = new FreeCommentDAO().getFreecomment(freecommentID);
		if (freecomment == null || !userID.equals(freecomment.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("history.back()");
			script.println("</script>");
			script.close();
			return;
		}

		FreeCommentDAO commentDAO = new FreeCommentDAO();
		int result = commentDAO.delete(freecommentID);
		if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('댓글 삭제에 실패했습니다')");
			script.println("history.back()");
			script.println("</script>");
			script.close();
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('댓글이 삭제되었습니다.')");
			script.println("location.href=document.referrer;");
			script.println("</script>");
			script.close();
		}
		%>
</body>
</html>
