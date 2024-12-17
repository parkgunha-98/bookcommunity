<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>옹기종기 책방</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/custom.css">
</head>
<body>
    <%
        // JSP에서 한글 처리
        request.setCharacterEncoding("UTF-8"); // 폼 데이터 한글 처리

        // 메인 페이지로 이동 시 세션 값이 담겨있는지 체크
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }

        int pageNumber = 1; // 기본은 1페이지를 할당
        // 만약 파라미터로 넘어온 오프젝트 타입 'pageNumber'가 존재한다면
        // int타입으로 바꿔서 pageNumber에 저장
        if (request.getParameter("pageNumber") != null) {
            pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
        }
    %>

    <!-- 웹 사이트 메뉴 영역 -->
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapse" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
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

    <!-- 검색 폼 영역 -->
    <div class="container" style="margin-bottom: 20px;">
        <div class="row">
            <form method="post" name="search" action="searchbbs.jsp">
                <table class="pull-right">
                    <tr>
                        <td>
                            <select class="form-control" name="searchField">
                                <option value="BbsTitle">제목</option>
                                <option value="userID">작성자</option>
                                <option value="Bbscontent">내용</option>
                            </select>
                        </td>
                        <td><input type="text" class="form-control" placeholder="검색어 입력" name="searchText" maxlength="100"></td>
                        <td><button type="submit" class="btn btn-success">검색</button></td>
                    </tr>
                </table>
            </form>
        </div>
    </div>

    <!-- 검색 결과 영역 -->
    <div class="container">
        <div class="row">
            <table class="table table-striped" style="text-align: center; border: 1px solid #dddd">
                <thead>
                    <tr>
                        <th style="background-color: #eeeeee; text-align: center;">번호</th>
                        <th style="background-color: #eeeeee; text-align: center;">제목</th>
                        <th style="background-color: #eeeeee; text-align: center;">작성자</th>
                        <th style="background-color: #eeeeee; text-align: center;">작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        BbsDAO bbsDAO = new BbsDAO();
                        String searchField = request.getParameter("searchField");
                        String searchText = request.getParameter("searchText");

                        // 검색 결과 가져오기
                        ArrayList<Bbs> list = bbsDAO.getSearch(searchField, searchText);

                        if (list.size() == 0) {
                            PrintWriter script = response.getWriter();
                            script.println("<script>");
                            script.println("alert('검색결과가 없습니다.')");
                            script.println("history.back()");
                            script.println("</script>");
                        } else {
                            for (int i = 0; i < list.size(); i++) {
                    %>
                    <tr>
                        <td><%= list.get(i).getBbsID() %></td>
                        <td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>">
                            <%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;")
                                 .replaceAll("<", "&lt;").replaceAll(">", "&gt;")
                                 .replaceAll("\n", "<br>") %>
                        </a></td>
                        <td><%= list.get(i).getUserID() %></td>
                        <td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시"
                            + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- 페이지 처리 영역 -->
        <%
            if (pageNumber != 1) {
        %>
        <a href="bbs.jsp?pageNumber=<%= pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전</a>
        <%
            }
            if (bbsDAO.nextPage(pageNumber + 1)) {
        %>
        <a href="bbs.jsp?pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arrow-right">다음</a>
        <%
            }
        %>

        <!-- 글쓰기 버튼 생성 -->
        <a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
    </div>

    <!-- 부트스트랩 스크립트 참조 -->
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
