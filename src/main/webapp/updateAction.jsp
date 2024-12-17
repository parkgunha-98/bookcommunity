<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.UUID"%>

<% request.setCharacterEncoding("utf-8"); %> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>옹기종기 책방</title>
</head>
<body>
<%
    // 현재 세션 상태를 체크하여 로그인 여부 확인
    String userID = null;
    if(session.getAttribute("userID") != null){
        userID = (String)session.getAttribute("userID");
    }

    // 파일 업로드를 처리하기 위한 설정
    String realFolder = "C:\\Users\\박건하\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp5\\wtpwebapps\\com\\bbsUpload"; 
    String encType = "utf-8"; // 파일 인코딩 타입
    int maxSize = 5 * 1024 * 1024; // 최대 파일 크기: 5MB

    // MultipartRequest 객체 생성: 파일 업로드 처리
    MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

    // 폼에서 전달받은 데이터
    String fileName = multi.getFilesystemName("fileName"); // 업로드된 파일 이름
    String bbsTitle = multi.getParameter("bbsTitle"); // 게시글 제목
    String bbsContent = multi.getParameter("bbsContent"); // 게시글 내용

    // 로그인 상태 확인
    if(userID == null){
        out.println("<script>");
        out.println("alert('로그인을 하세요');");
        out.println("location.href='login.jsp';"); // 로그인 페이지로 이동
        out.println("</script>");
        return;
    }

    // 게시글 ID 가져오기
    int bbsID = 0;
    if(multi.getParameter("bbsID") != null){
        bbsID = Integer.parseInt(multi.getParameter("bbsID"));
    }

    // 게시글 ID 유효성 체크
    if(bbsID == 0){
        out.println("<script>");
        out.println("alert('유효하지 않은 글입니다.');");
        out.println("location.href='bbs.jsp';"); // 게시판 페이지로 이동
        out.println("</script>");
        return;
    }

    // 게시글 정보 가져오기
    Bbs bbs = new BbsDAO().getBbs(bbsID);

    // 게시글이 존재하지 않는 경우
    if (bbs == null) {
        out.println("<script>");
        out.println("alert('존재하지 않는 게시글입니다.');");
        out.println("location.href='bbs.jsp';"); // 게시판 페이지로 이동
        out.println("</script>");
        return;
    }

    // 작성자 본인 확인
    if(!userID.equals(bbs.getUserID())){
        out.println("<script>");
        out.println("alert('권한이 없습니다');");
        out.println("location.href='bbs.jsp';"); // 게시판 페이지로 이동
        out.println("</script>");
        return;
    }

    // 입력값 유효성 체크
    if(bbsTitle == null || bbsContent == null || bbsTitle.equals("") || bbsContent.equals("")){
        out.println("<script>");
        out.println("alert('입력이 안 된 사항이 있습니다.');");
        out.println("history.back();"); // 이전 페이지로 이동
        out.println("</script>");
        return;
    }

    // 게시글 수정 작업
    BbsDAO bbsDAO = new BbsDAO();
    bbsID = Integer.parseInt(multi.getParameter("bbsID"));  // 수정할 게시글 ID 가져오기
    boolean result = (bbsDAO.update(bbsID, bbs.getBbsTitle(), bbs.getBbsContent(), fileName) == 1);
    if (!result) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('수정에 실패했습니다.')");
        script.println("history.back()");
        script.println("</script>");
    } else { 
        // 수정 성공 및 파일 처리
         PrintWriter script = response.getWriter();
        if(fileName != null){
            String real = "C:\\Users\\박건하\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp5\\wtpwebapps\\com\\bbsUpload";
            String existingFilePath = real + "\\" + bbsID + "photo.jpg"; // 기존 파일 경로
            File delFile = new File(existingFilePath);
			if(delFile.exists()){
				delFile.delete();
			}

            File oldFile = new File(realFolder + "\\" + fileName);
            File newFile = new File(realFolder + "\\" + bbsID +"photo.jpg" );
            
            if (oldFile.exists()) {
                oldFile.renameTo(newFile);
            }
        }
        // 성공 메시지 출력 및 게시판 페이지로 이동
        out.println("<script>");
        out.println("alert('글 수정하기 성공');");
        out.println("location.href='bbs.jsp';"); // 게시판 페이지로 이동
        out.println("</script>");
    }
%>
</body>
</html>
