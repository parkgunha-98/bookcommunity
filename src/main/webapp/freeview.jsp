<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="freebbs.FreebbsDAO" %>
<%@ page import="freebbs.Freebbs" %>
<%@ page import="freecomment.FreeCommentDAO" %>
<%@ page import="freecomment.FreeComment" %>
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
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }

        int freeboardID = 0;
        if (request.getParameter("freeboardID") != null) {
            freeboardID = Integer.parseInt(request.getParameter("freeboardID"));
        }

        int freebbsID = 0;
        if (request.getParameter("freebbsID") != null) {
            freebbsID = Integer.parseInt(request.getParameter("freebbsID"));
        }

        if (freebbsID == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 글입니다.');");
            script.println("location.href='bbs.jsp';");
            script.println("</script>");
        }

        Freebbs freebbs = new FreebbsDAO().getFreebbs(freebbsID);

        // 비공개 글인지 확인
        if (freebbs.getFreebbsLock() == 1) {
            // 비공개 글일 경우
            if (userID == null || !userID.equals(freebbs.getUserID())) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('비공개 게시글입니다.');");
                script.println("location.href='freebbs.jsp';");
                script.println("</script>");
                return;
            }
        }
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
            <% if (userID == null) { %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    </ul>
                </li>
            </ul>
            <% } else { %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
            <% } %>
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
                        <td colspan="2"><%= freebbs.getFreebbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
                    </tr>
                    <tr>
                        <td>작성자</td>
                        <td colspan="2"><%= freebbs.getUserID() %></td>
                    </tr>
                    <tr>
                        <td>작성일자</td>
                        <td colspan="2"><%= freebbs.getFreebbsDate().substring(0, 11) + freebbs.getFreebbsDate().substring(11, 13) + "시" + freebbs.getFreebbsDate().substring(14, 16) + "분" %></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left;">
                            <div>
                                <% String realPath ="C:\\Users\\박건하\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp5\\wtpwebapps\\com\\freebbsUpload";
                                   File imageFile = new File(realPath + "\\" + freebbsID + "photo.jpg");

                                   if (imageFile.exists()) {
                                %>
                                <img src="freebbsUpload/<%=freebbsID%>photo.jpg" alt="게시글 이미지" style="max-width: 300px; max-height: 300px; border: 1px solid #ddd; object-fit: cover;">
                                <% } %>
                                <p style="text-align: left; word-wrap: break-word;">
                                    <%= freebbs.getFreebbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <a href="freebbs.jsp" class="btn btn-primary">목록</a>
            <% if (userID != null && userID.equals(freebbs.getUserID())) { %>
            <a href="freeupdate.jsp?freebbsID=<%= freebbsID %>" class="btn btn-primary">수정</a>
            <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="freedeleteAction.jsp?freebbsID=<%= freebbsID %>" class="btn btn-primary">삭제</a>
            <% } %>
            <br><br>

            <!-- 댓글 작성 -->
            <div class="form-group">
                <form method="post" action="freecommentAction.jsp?freebbsID=<%= freebbsID %>">
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
	                    FreeCommentDAO freeCommentDAO = new FreeCommentDAO();
	                    ArrayList<FreeComment> list = freeCommentDAO.getList(freeboardID, freebbsID);
	                    for (int i = 0; i < list.size(); i++) {
                    %>
                    <div class="container">
                        <div class="row">
                            <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                                <tbody>
                                    <tr>
                                        <td align="left">
                                            <%= list.get(i).getUserID() %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <%= list.get(i).getFreecommentDate().substring(0, 11) + 
                                                list.get(i).getFreecommentDate().substring(11, 13) + "시" + 
                                                list.get(i).getFreecommentDate().substring(14, 16) + "분" %>
                                        </td>
                                        <td colspan="2"></td>
                                        <td align="right">
                                            <%
                                                if (list.get(i).getUserID() != null && list.get(i).getUserID().equals(userID)) {
                                            %>
                                            <!-- 수정 버튼 -->
											<button 
											    class="btn btn-warning" 
											    onclick="openfreecommentPopup(<%= freebbsID %>, <%= list.get(i).getFreecommentID() %>)">
											    수정
											</button>
                                            <a 
                                                onclick="return confirm('정말로 삭제하시겠습니까?')" 
                                                href="freecommentDeleteAction.jsp?bbsID=<%= freebbsID %>&freecommentID=<%= list.get(i).getFreecommentID() %>" 
                                                class="btn btn-danger">
                                                삭제
                                            </a>
                                            <%
                                                }
                                            %>    
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" align="left"><%= list.get(i).getFreecommentText() %></td>
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
        function openfreecommentPopup(freebbsID, freecommentID) {
            var url = "freecommentUpdatePopup.jsp?freebbsID=" + freebbsID + "&freecommentID=" + freecommentID;
            var options = "width=500,height=300,scrollbars=no,resizable=no";
            window.open(url, "댓글 수정", options);
        }
    </script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
