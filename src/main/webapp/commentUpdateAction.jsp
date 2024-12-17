<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="comment.CommentDAO"%>
<%@ page import="comment.Comment"%>
<%@ page import="java.io.PrintWriter"%>
<%
    request.setCharacterEncoding("UTF-8");

    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    int boardID = request.getParameter("boardID") != null ? Integer.parseInt(request.getParameter("boardID")) : 0;
    int commentID = request.getParameter("commentID") != null ? Integer.parseInt(request.getParameter("commentID")) : 0;
    int bbsID = request.getParameter("bbsID") != null ? Integer.parseInt(request.getParameter("bbsID")) : 0;
    String commentText = request.getParameter("commentText");

    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 하세요.');");
        script.println("location.href = 'login.jsp';");
        script.println("</script>");
        return;
    }

    if (bbsID == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.');");
        script.println("location.href = 'bbs.jsp';");
        script.println("</script>");
        return;
    }

    Comment comment = new CommentDAO().getComment(commentID);

    if (comment == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('댓글 정보를 불러오지 못했습니다. 다시 시도해주세요.');");
        script.println("history.back();");
        script.println("</script>");
        return;
    }

    if (!userID.equals(comment.getUserID())) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.');");
        script.println("location.href = 'bbs.jsp';");
        script.println("</script>");
        return;
    }

    if (commentText == null || commentText.trim().equals("")) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('입력이 안된 사항이 있습니다.');");
        script.println("history.back();");
        script.println("</script>");
        return;
    }

    CommentDAO commentDAO = new CommentDAO();
    int result = commentDAO.update(commentID, commentText);

    if (result == -1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('글 수정에 실패했습니다. 다시 시도해주세요.');");
        script.println("history.back();");
        script.println("</script>");
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('댓글이 성공적으로 수정되었습니다.');");
        script.println("window.opener.location.href = 'view.jsp?boardID=" + boardID + "&bbsID=" + bbsID + "';");
        script.println("window.close();");
        script.println("</script>");
    }
%>
