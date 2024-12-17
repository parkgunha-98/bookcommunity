<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/custom.css">
    <title>옹기종기 책방</title>
</head>
<body>
    <%
        String userID = null;
        if(session.getAttribute("userID") != null){
            userID = (String)session.getAttribute("userID");
        }
        
        if(userID == null){
            out.println("<script>");
            out.println("alert('로그인을 하세요');");
            out.println("location.href='login.jsp';");
            out.println("</script>");
            return;
        }

        int bbsID = 0;
        if(request.getParameter("bbsID") != null){
            try {
                bbsID = Integer.parseInt(request.getParameter("bbsID"));
            } catch (NumberFormatException e) {
                out.println("<script>");
                out.println("alert('잘못된 게시글 ID입니다.');");
                out.println("location.href='bbs.jsp';");
                out.println("</script>");
                return;
            }
        }

        if(bbsID == 0){
            out.println("<script>");
            out.println("alert('유효하지 않은 글입니다.');");
            out.println("location.href='bbs.jsp';");
            out.println("</script>");
            return;
        }

        // 해당 글을 가져오기
        Bbs bbs = new BbsDAO().getBbs(bbsID);
        if(bbs == null){
            out.println("<script>");
            out.println("alert('존재하지 않는 게시글입니다.');");
            out.println("location.href='bbs.jsp';");
            out.println("</script>");
            return;
        }

        // 작성자가 본인인지 확인
        if(!userID.equals(bbs.getUserID())){
            out.println("<script>");
            out.println("alert('권한이 없습니다.');");
            out.println("location.href='bbs.jsp';");
            out.println("</script>");
            return;
        }
    %>
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

    <!-- 수정 폼 -->
<div class="container">
    <div class="row">
        <!-- 폼에서 enctype="multipart/form-data" 속성 추가 -->
        <form method="post" action="updateAction.jsp" enctype="multipart/form-data">
            <!-- bbsID를 hidden input 태그로 전달 -->
            <input type="hidden" name="bbsID" value="<%= bbsID %>">
            
            <table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
                <thead>
                    <tr>
                        <th colspan="2" style="background-color:#eeeeee; text-align:center;">게시판 글 수정 양식</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- 글 제목 -->
                    <tr>
                        <td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" value="<%= bbs.getBbsTitle() %>" maxlength="50" required></td>
                    </tr>
                    <!-- 글 내용 -->
                    <tr>
                        <td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height:350px;" required><%= bbs.getBbsContent() %></textarea></td>
                    </tr>
                    <!-- 파일 업로드 -->
                    <tr>
                        <td><input type="file" name="fileName"></td>
                    </tr>
                </tbody>
            </table>
            <!-- 제출 버튼 -->
            <input type="submit" class="btn btn-primary pull-right" value="수정하기">
        </form>
    </div>
</div>

    <!-- 부트스트랩 참조 -->
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
