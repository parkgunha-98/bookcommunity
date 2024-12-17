<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="freecomment.FreeCommentDAO"%>
<%@ page import="freecomment.FreeComment"%>
<%@ page import="java.io.PrintWriter"%>
<%
    request.setCharacterEncoding("UTF-8");

    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    int freeboardID = request.getParameter("freeboardID") != null ? Integer.parseInt(request.getParameter("freeboardID")) : 0;
    int freecommentID = request.getParameter("freecommentID") != null ? Integer.parseInt(request.getParameter("freecommentID")) : 0;
    int freebbsID = request.getParameter("freebbsID") != null ? Integer.parseInt(request.getParameter("freebbsID")) : 0;
    String freecommentText = request.getParameter("freecommentText");

    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 하세요.');");
        script.println("location.href = 'login.jsp';");
        script.println("</script>");
        return;
    }

    if (freebbsID == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.');");
        script.println("location.href = 'bbs.jsp';");
        script.println("</script>");
        return;
    }

    FreeComment freecomment = new FreeCommentDAO().getFreecomment(freecommentID);

    if (freecomment == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('댓글 정보를 불러오지 못했습니다. 다시 시도해주세요.');");
        script.println("history.back();");
        script.println("</script>");
        return;
    }

    if (!userID.equals(freecomment.getUserID())) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.');");
        script.println("location.href = 'bbs.jsp';");
        script.println("</script>");
        return;
    }

    if (freecommentText == null || freecommentText.trim().equals("")) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('입력이 안된 사항이 있습니다.');");
        script.println("history.back();");
        script.println("</script>");
        return;
    }

    FreeCommentDAO commentDAO = new FreeCommentDAO();
    int result = commentDAO.update(freecommentID, freecommentText);

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
        script.println("window.opener.location.href = 'freeview.jsp?freeboardID=" + freeboardID + "&freebbsID=" + freebbsID + "';");
        script.println("window.close();");
        script.println("</script>");
    }
%>
