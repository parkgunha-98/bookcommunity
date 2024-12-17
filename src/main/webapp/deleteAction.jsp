<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>옹기종기 책방</title>
</head>
<body>
	<%
    // 현재 세션 상태를 체크
    String userID = null;
    if(session.getAttribute("userID") != null){
        userID = (String)session.getAttribute("userID");
    }

    // 로그인한 사람만 글을 쓸 수 있도록 코드를 수정
    if(userID == null){
        out.println("<script>");
        out.println("alert('로그인을 하세요');");
        out.println("location.href='login.jsp';");
        out.println("</script>");
        return; // 로그인하지 않은 경우 더 이상 처리하지 않도록 반환
    }

    int bbsID = 0;
    if(request.getParameter("bbsID") != null){
        bbsID = Integer.parseInt(request.getParameter("bbsID"));
    }

    // 유효하지 않은 게시글일 경우 처리
    if(bbsID == 0){
        out.println("<script>");
        out.println("alert('유효하지 않은 글입니다.');");
        out.println("location.href='bbs.jsp';");
        out.println("</script>");
        return; // 유효하지 않은 게시글일 경우 더 이상 처리하지 않도록 반환
    }

    // 해당 bbsID에 대한 글을 가져온 다음 세션을 통해 작성자 본인이 맞는지 체크
    Bbs bbs = new BbsDAO().getBbs(bbsID);

    // 게시글이 존재하지 않는 경우
    if (bbs == null) {
        out.println("<script>");
        out.println("alert('존재하지 않는 게시글입니다.');");
        out.println("location.href='bbs.jsp';");
        out.println("</script>");
        return;
    }

    // 권한이 없는 경우
    if(!userID.equals(bbs.getUserID())){
        out.println("<script>");
        out.println("alert('권한이 없습니다');");
        out.println("location.href='bbs.jsp';");
        out.println("</script>");
        return; // 권한이 없는 경우 더 이상 처리하지 않도록 반환
    }

    // 글 삭제 로직 수행
    BbsDAO bbsDAO = new BbsDAO();
    int result = bbsDAO.delete(bbsID);
    if(result == -1){
        // 데이터베이스 오류인 경우
        out.println("<script>");
        out.println("alert('글 수정하기에 실패했습니다.');");
        out.println("history.back();");
        out.println("</script>");
    }else{ 
        // 글 수정이 정상적으로 실행되면 알림창을 띄우고 게시판으로 이동
        out.println("<script>");
        out.println("alert('글 삭제하기 성공');");
        out.println("location.href='bbs.jsp';");
        out.println("</script>");
    }
%>
</body>
</html>