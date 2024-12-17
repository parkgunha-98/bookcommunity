<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>옹기종기 책방</title>
</head>
<body>
    <%-- 로그인 상태 확인 --%>
    <%
	    String userID = null;
	    Integer userAuth = 0;
	    if (session.getAttribute("userID") != null) {
	        userID = (String) session.getAttribute("userID");
	    }
	    if (session.getAttribute("userAuth") != null) {
	        userAuth = (Integer) session.getAttribute("userAuth");
	    }

        // userAuth 값 출력 (Sysprint처럼 서버 로그에 출력)
        System.out.println("userAuth: " + userAuth);
    %>

    <%-- 로그인 상태가 아니면 로그인 페이지로 리디렉션 --%>
    <% if (userID == null) { %>
    <script type="text/javascript">
        alert("로그인 후 글을 작성할 수 있습니다.");
        location.href = "login.jsp";
    </script>
    <% } %>

    <%-- userAuth가 0일 경우 글 작성 권한이 없다는 메시지를 띄우고 리디렉션 --%>
    <% if (userAuth == 0) { %>
    <script type="text/javascript">
        alert("글 작성 권한이 없습니다.");
        location.href = "bbs.jsp"; // 리디렉션할 페이지 설정
    </script>
    <% } %>

    <!-- 웹 사이트 메뉴 영역 -->
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <a class="navbar-brand" href="main.jsp">옹기종기 책방</a>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
                <li><a href="bbs.jsp">공지사항</a></li>
                <li><a href="freebbs.jsp">자유 게시판</a></li>
            </ul>
            <% if(userID == null){ %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown"><a href="#" class="dropdown-toggle"
                    data-toggle="dropdown">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    </ul></li>
            </ul>
            <% } else { %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown"><a href="#" class="dropdown-toggle"
                    data-toggle="dropdown">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp">로그아웃</a></li>
                    </ul></li>
            </ul>
            <% } %>
        </div>
    </nav>

    <%-- 글쓰기 폼 --%>
    <% if (userAuth != 0) { %>
    <div class="container">
        <div class="row">
            <form method="post" action="writeAction.jsp" enctype="multipart/form-data">
                <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                    <thead>
                        <tr>
                            <th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" required></td>
                        </tr>
                        <tr>
                            <td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;" required></textarea></td>
                        </tr>
                        <tr>
                            <td><input type="file" name="fileName"></td>
                        </tr>
                    </tbody>
                </table>
                <input type="submit" class="btn btn-primary pull-right" value="글쓰기">
            </form>
        </div>
    </div>
    <% } %>

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
