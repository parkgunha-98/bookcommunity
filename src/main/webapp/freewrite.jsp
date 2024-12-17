<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="freebbs.FreebbsDAO"%>
<%@ page import="freebbs.Freebbs"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>옹기종기 책방</title>
    <style>
        .visibility-container {
            display: flex;
            align-items: center;
            justify-content: flex-start;
        }
        .visibility-label {
            margin-right: 10px;
        }
        .radio-group {
            display: inline-block;
        }
    </style>
</head>
<body>
    <%-- 로그인 상태 확인 --%>
    <%
        String userID = null;
        if(session.getAttribute("userID") != null){
            userID = (String)session.getAttribute("userID");
        }
    %>

    <%-- 로그인 상태가 아닌 경우 로그인 페이지로 리디렉션 --%>
    <% if (userID == null) { %>
    <script type="text/javascript">
        alert("로그인 후 글을 작성할 수 있습니다.");
        location.href = "login.jsp";
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

    <!-- 게시판 글쓰기 영역 -->
    <div class="container">
        <div class="row">
            <form method="post" action="freewriteAction.jsp" enctype="multipart/form-data">
                <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                    <thead>
                        <tr>
                            <th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><input type="text" class="form-control" placeholder="글 제목" name="freebbsTitle" maxlength="50" required></td>
                        </tr>

                        <%-- 공개/비공개 선택 폼 추가 --%>
                        <tr>
                            <td>
                                <div class="visibility-container">
                                    <label class="visibility-label">글 공개 여부</label>
                                    <div class="radio-group">
                                        <input type="radio" name="freebbsLock" value="0" checked> 공개
                                        <input type="radio" name="freebbsLock" value="1"> 비공개
                                    </div>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td><textarea class="form-control" placeholder="글 내용" name="freebbsContent" maxlength="2048" style="height: 350px;" required></textarea></td>
                        </tr>
                        <tr>
                            <td><input type="file" name="freefileName"></td>
                        </tr>
                    </tbody>
                </table>
                <input type="submit" class="btn btn-primary pull-right" value="글쓰기">
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
