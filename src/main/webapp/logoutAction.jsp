<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>옹기종기 책방</title>
</head>
<body>
	<%
		session.invalidate(); // 현재 세션을 종료
	%>
	<script>
		alert('로그아웃 되었습니다')
		location.href="main.jsp";
	</script>

</body>
</html>