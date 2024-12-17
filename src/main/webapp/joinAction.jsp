<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:useBean id="user" class="user.User" scope="page" />
<!-- 객체를 가져오기 위한 기법 -->
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userAddress" />
<jsp:setProperty name="user" property="userRrn" />
<jsp:setProperty name="user" property="userPhoneNumber" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>옹기종기 책방</title>
</head>
<body>
<%
    // 현재 세션 상태를 체크한다.
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    // 현재 로그인 상태라면 회원가입이 불가능하도록 설정한다.
    if (userID != null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 로그인이 되어 있습니다')");
        script.println("location.href='main.jsp'");
        script.println("</script>");
    }

    // 입력 필드 체크
    if (user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null 
        || user.getUserAddress() == null || user.getUserRrn() == null || user.getUserPhoneNumber() == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('입력 안 된 사항이 있습니다!')");
        script.println("history.back()");
        script.println("</script>");
    } else {
        UserDAO userDAO = new UserDAO();

        // 중복 검사
        if (userDAO.isUserIdDuplicated(user.getUserID())) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 존재하는 아이디입니다')");
            script.println("history.back()");
            script.println("</script>");
        } else if (userDAO.isUserRrnDuplicated(user.getUserRrn())) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 사용 중인 주민등록번호입니다')");
            script.println("history.back()");
            script.println("</script>");
        } else if (userDAO.isUserPhoneNumberDuplicated(user.getUserPhoneNumber())) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 사용 중인 휴대폰 번호입니다')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            // 회원가입 진행
            int result = userDAO.join(user);
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('회원가입에 실패했습니다')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                session.setAttribute("userID", user.getUserID()); // 회원가입 성공 시 세션 부여
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('회원가입 성공')");
                script.println("location.href='main.jsp'");
                script.println("</script>");
            }
        }
    }
%>
</body>
</html>