<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 디자인 변경 웹 메타 태그 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>옹기종기 책방</title>

<!-- CSS 스타일 -->
<style>
    .image-container {
        width: 1150px;  /* 이미지의 가로 크기 설정 */
        height: 500px;  /* 이미지의 세로 크기 설정 */
        margin: 0 auto;  /* 중앙 정렬 */
        background-color: rgb(229, 228, 229);  /* 추출한 배경색 */
        overflow: hidden; /* 이미지가 영역을 넘지 않도록 설정 */
    }

    .image-container img {
        width: 100%;  /* 이미지의 너비를 부모 요소에 맞게 설정 */
        height: 100%;  /* 이미지의 높이를 부모 요소에 맞게 설정 */
        object-fit: contain; /* 비율 유지하면서 크기를 맞춤 */
    }
</style>

</head>
<body>
    <%
        // 메인 페이지로 이동 시 세션 값이 담겨있는지 체크
        String userID = null;
        if(session.getAttribute("userID") != null){
            userID = (String)session.getAttribute("userID");
        }
    %>

    <!-- 웹 사이트 메뉴 영역 -->
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <!-- 홈페이지 상단 -->
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expanded="false">
                <span class="icon-bar"></span> 
                <span class="icon-bar"></span> 
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">옹기종기 책방</a>
        </div>
        <!-- 메뉴 영역 -->
        <div>
			<ul class="nav navbar-nav">
			    <li><a href="main.jsp">메인</a></li>
			    <li><a href="bbs.jsp">공지사항</a></li>
			    <li><a href="freebbs.jsp">자유 게시판</a></li>
			</ul>
            <%
                if(userID == null){
            %>
            <!-- 헤더 우측에 위치 -->
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        접속하기<span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    </ul>
                </li>
            </ul>
            <%
                } else {
            %>
            <!-- 로그인 상태 -->
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        회원관리<span class="caret"></span>
                    </a>
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

    <!-- 메인 페이지 영역 시작 -->
    <div class="container">
        <div class="jumbotron">
            <h1>옹기종기 책방📕</h1>
            <p>
                사람들이 모여 책에 대한 이야기를 나누고, 서로의 독서 경험을 공유하는 따뜻한 공간입니다. 다양한 책들을 소개하고, 서로의 마음을 나누며 독서의 즐거움을 더해가는 작은 커뮤니티입니다.
            </p>
        </div>
    </div>

    <!-- 메인 페이지 이미지 삽입 영역 -->
    <div class="container text-center">
        <div class="image-container">
            <img src="images/1.jpg" alt="Image 1" class="responsive-img">
        </div>
    </div>

    <!-- 부트스트랩 참조 -->
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
