<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.UUID"%>

<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판</title>
</head>
<body>
    <%
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }

        // 업로드 경로 변경
        String realFolder = "C:\\Users\\박건하\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp5\\wtpwebapps\\com\\bbsUpload";  // 원하는 경로로 설정
        String encType = "utf-8";
        int maxSize = 5 * 1024 * 1024;  // 5MB로 설정
        
        // MultipartRequest 객체 생성
        MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

        // 폼으로 전달받은 값들
        String fileName = multi.getFilesystemName("fileName");  // 업로드된 파일 이름
        String bbsTitle = multi.getParameter("bbsTitle");
        String bbsContent = multi.getParameter("bbsContent");

        bbs.setBbsTitle(bbsTitle);
        bbs.setBbsContent(bbsContent);

        // 로그인 여부 확인
        if (userID == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인을 하세요.')");
            script.println("location.href = 'login.jsp'");
            script.println("</script>");
        } else {
            // 필수 항목 체크
            if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('입력이 안 된 사항이 있습니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                // 데이터베이스에 글 작성
                BbsDAO bbsDAO = new BbsDAO();
                int bbsID = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent(), fileName);  // 파일명도 함께 저장
                
                System.out.println("Generated bbs: " + bbsID); // 이 부분에서 bbsID 확인
                
                if (bbsID == -1) {
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("alert('글쓰기에 실패했습니다.')");
                        script.println("history.back()");
                        script.println("</script>");
                    } else {
                        // bbsID에 맞춰 파일명 변경
                        if (fileName != null) {
                            File oldFile = new File(realFolder + "\\" + fileName);
                            File newFile = new File(realFolder + "\\" + bbsID + "photo.jpg"); // freebbsID를 파일명 앞에 붙임
                            oldFile.renameTo(newFile);
                        }
                    }
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('글쓰기에 성공했습니다.')");
                    script.println("location.href='bbs.jsp'"); // 게시판 페이지로 리디렉션
                    script.println("</script>");
                }
            }
    %>
</body>
</html>
