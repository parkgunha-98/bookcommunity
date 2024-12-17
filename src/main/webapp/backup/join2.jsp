<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 디자인 변경 웹 메타 태그 -->
<meta name="viewport" content="width=device-width initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<!--  새로 파일을 만들어 작성한 'css' 파일을 참조하는 링크 -->
<link rel="stylesheet" href="css/custom.css">
<title>로그인</title>
</head>
<body>
	<!-- 웹 사이트 메뉴 영역 -->
	<nav class="navar navbar=default">
		<div class="navbar-header">
			<!-- 홈페이지 상단 -->
			<button type="button" class="navbar-toggle collapse"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<!-- 메뉴 영역 -->
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<!-- 헤더 우측에 위치 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a> <!--드롭다운 아이템 영역 -->
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<!-- 로그인 페이지 이동 -->
						<li><a href="join.jsp">회원가입</a></li>
						<!-- 회원가입 페이지 이동 -->
					</ul></li>
			</ul>
		</div>
	</nav>
	<!-- 회원가입 양식 -->
	<div class="container-fluid"
		style="display: flex; justify-content: center; align-items: center; height: 100vh;">
		<div class="col-lg-4" style="margin-top: -300px;">
			<!-- 폼을 살짝 위로 올리기 -->
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="joinAction.jsp">
					<h3 style="text-align: center;">회원가입 화면</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디"
							name="userID" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호"
							name="userPassword" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="이름"
							name="userName" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="주소"
							name="userAddress" maxlength="50">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="주민등록번호"
							name="userRrn" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="휴대폰번호"
							name="userPhoneNumber" maxlength="20">
					</div>
					<input type="submit" class="btn btn-primary form-contorl"
						value="회원가입">
				</form>
			</div>
		</div>
	</div>
	<!-- 부트스트랩 참조 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

</body>
</html>