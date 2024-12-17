<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/custom.css">
    <title>옹기종기 책방</title>
</head>
<body>
    <%
        // 로그인 확인
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }

        int boardID = 0;
        if (request.getParameter("boardID") != null) {
            boardID = Integer.parseInt(request.getParameter("boardID"));
        }

        // bbsID가 요청에 포함되어 있으면 처리
        int bbsID = 0;
        if (request.getParameter("bbsID") != null) {
            bbsID = Integer.parseInt(request.getParameter("bbsID"));
        }

        // 유효하지 않은 bbsID일 경우
        if (bbsID == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 글입니다.')");
            script.println("location.href='bbs.jsp'");
            script.println("</script>");
        }

        // bbsID에 해당하는 게시글 가져오기
        Bbs bbs = new BbsDAO().getBbs(bbsID);
    %>

    <!-- 네비게이션 바 -->
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapse" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">옹기종기 책방</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
   			    <li><a href="bbs.jsp">공지사항</a></li>
   			    <li><a href="freebbs.jsp">자유 게시판</a></li>
            </ul>
            <%
                if (userID == null) {
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    </ul>
                </li>
            </ul>
            <%
                } else {
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
            <%
                }
            %>
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                <thead>
                    <tr>
                        <th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="width: 20%;">글 제목</td>
                        <td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
                    </tr>
                    <tr>
                        <td>작성자</td>
                        <td colspan="2"><%= bbs.getUserID() %></td>
                    </tr>
                    <tr>
                        <td>작성일자</td>
                        <td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left;">
                            <div>
                                <% // 이미지 처리 %>
                                <div style="margin-bottom: 20px;">
                                    <%
                                        String realPath = application.getRealPath("/bbsUpload");
                                        String imagePath = "bbsUpload/" + bbsID + "photo.jpg";
                                        File imageFile = new File(realPath + "\\" + bbsID + "photo.jpg");

                                        if (imageFile.exists()) {
                                    %>
                                    <img src="<%= imagePath %>" alt="게시글 이미지"
                                         style="max-width: 300px; max-height: 300px; border: 1px solid #ddd; object-fit: cover;">
                                    <%
                                        }
                                    %>
                                </div>
                                <p style="text-align: left; word-wrap: break-word;">
                                    <%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <a href="bbs.jsp" class="btn btn-primary">목록</a>
            <%
                // 글 작성자 본인만 수정/삭제 가능
                if (userID != null && userID.equals(bbs.getUserID())) {
            %>
            <a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
            <a onclick="return confirm('정말로 삭제하겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
            <%
                }
            %>
			<br>
			</br>
            <!-- 댓글 작성 -->
            <div class="form-group">
                <form method="post" action="commentAction.jsp?bbsID=<%= bbsID %>">
                    <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                        <tr>
                            <td style="border-bottom:none;" valign="middle"><br><br><%= userID %></td>
                            <td>
                                <input type="text" style="height:100px;" class="form-control" placeholder="상대방을 존중하는 댓글을 남깁시다." name="commentText">
                            </td>
                            <td><br><br><input type="submit" class="btn-primary pull" value="댓글 작성"></td>
                        </tr>
                    </table>
                </form>
            </div>

        </div>
    </div>

   <!-- 댓글 리스트 -->
   <div class="container">
        <div class="row">
            <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                <tbody>
                    <tr>
                        <td align="left" bgcolor="beige">댓글</td>
                    </tr>
                    <tr>
                    <%
                        CommentDAO commentDAO = new CommentDAO();
                        ArrayList<Comment> list = commentDAO.getList(boardID, bbsID);
                        for (int i = 0; i < list.size(); i++) {
                    %>
                    <div class="container">
                        <div class="row">
                            <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                                <tbody>
                                    <tr>
                                        <td align="left">
                                            <%= list.get(i).getUserID() %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <%= list.get(i).getCommentDate().substring(0, 11) + 
                                                list.get(i).getCommentDate().substring(11, 13) + "시" + 
                                                list.get(i).getCommentDate().substring(14, 16) + "분" %>
                                        </td>
                                        <td colspan="2"></td>
                                        <td align="right">
                                            <%
                                                if (list.get(i).getUserID() != null && list.get(i).getUserID().equals(userID)) {
                                            %>
                                            <!-- 수정 버튼 -->
                                            <button 
                                                class="btn btn-warning" 
                                                onclick="openCommentPopup(<%= bbsID %>, <%= list.get(i).getCommentID() %>)">
                                                수정
                                            </button>
                                            <!-- 삭제 버튼 -->
                                            <a 
                                                onclick="return confirm('정말로 삭제하시겠습니까?')" 
                                                href="commentDeleteAction.jsp?bbsID=<%= bbsID %>&commentID=<%= list.get(i).getCommentID() %>" 
                                                class="btn btn-danger">
                                                삭제
                                            </a>
                                            <%
                                                }
                                            %>    
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" align="left"><%= list.get(i).getCommentText() %></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function openCommentPopup(bbsID, commentID) {
            var url = "commentUpdatePopup.jsp?bbsID=" + bbsID + "&commentID=" + commentID;
            var options = "width=500,height=300,scrollbars=no,resizable=no";
            window.open(url, "댓글 수정", options);
        }
    </script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
