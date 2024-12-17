<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="user" class="user.User" scope="page" />
<!-- 객체를 가져오기 위한 기법 -->
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>옹기종기 책방</title>
</head>
<body>
    <%
        // 현재 세션 상태를 확인
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }

        // 로그인이 되어있는 경우
        if (userID != null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 로그인이 되어 있습니다');");
            script.println("location.href='main.jsp';");
            script.println("</script>");
        }

        // 로그인 처리
        UserDAO userDAO = new UserDAO();
        int userAuth = userDAO.login(user.getUserID(), user.getUserPassword());  // 로그인 시 userAuth 값 받기
        
        if (userAuth > 0) {  // 로그인 성공 시
            // userID가 admin인 경우 userAuth를 1로 설정
            if ("admin".equals(user.getUserID())) {
                userAuth = 1;
            } else {
                // userAuth를 0으로 설정 (일반 사용자)
                userAuth = 0;
            }

            // 세션에 userID와 userAuth 저장
            session.setAttribute("userID", user.getUserID());
            session.setAttribute("userAuth", userAuth);  // userAuth 세션에 저장

            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인 성공');");
            script.println("location.href='main.jsp';");
            script.println("</script>");
        } else if (userAuth == 0) {  // 비밀번호 틀림
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('비밀번호가 틀립니다.');");
            script.println("history.back();");
            script.println("</script>");
        } else if (userAuth == -1) {  // 존재하지 않는 아이디
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('존재하지 않는 아이디입니다.');");
            script.println("history.back();");
            script.println("</script>");
        } else if (userAuth == -2) {  // 데이터베이스 오류
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('데이터베이스 오류입니다.');");
            script.println("history.back();");
            script.println("</script>");
        }
    %>
</body>
</html>
