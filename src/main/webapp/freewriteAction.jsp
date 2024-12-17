<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="freebbs.FreebbsDAO"%>
<%@ page import="freebbs.Freebbs"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.UUID"%>

<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="freebbs" class="freebbs.Freebbs" scope="page" />
<jsp:setProperty name="freebbs" property="freebbsTitle" />
<jsp:setProperty name="freebbs" property="freebbsContent" />
<jsp:setProperty name="freebbs" property="freebbsID" />

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

    String realFolder = "C:\\Users\\박건하\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp5\\wtpwebapps\\com\\freebbsUpload";
    String encType = "utf-8";
    int maxSize = 5 * 1024 * 1024;  // 5MB로 설정
    
    MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

    String fileName = multi.getFilesystemName("freefileName");
    String freebbsTitle = multi.getParameter("freebbsTitle");
    String freebbsContent = multi.getParameter("freebbsContent");

    // 공개/비공개 값 처리
    String freebbsLockStr = multi.getParameter("freebbsLock"); // 0: 공개, 1: 비공개
    int freebbsLock = -1;

    freebbs.setFreebbsTitle(freebbsTitle);
    freebbs.setFreebbsContent(freebbsContent);

    // fileName 값을 freefileName 변수에 할당
    String freefileName = fileName;

    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 하세요.')");
        script.println("location.href = 'login.jsp'");
        script.println("</script>");
    } else {
        if (freebbs.getFreebbsTitle() == null || freebbs.getFreebbsContent() == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('입력이 안 된 사항이 있습니다.')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            FreebbsDAO freebbsDAO = new FreebbsDAO();
            int freebbsID = freebbsDAO.write(freebbs.getFreebbsTitle(), userID, freebbs.getFreebbsContent(), freefileName, freebbsLock);
            
            // freebbsID 값 확인용 로그 출력
            System.out.println("Generated freebbsID: " + freebbsID); // 이 부분에서 freebbsID 확인

            if (freebbsID == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('글쓰기에 실패했습니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                // freebbsID에 맞춰 파일명 변경
                if (fileName != null) {
                    File oldFile = new File(realFolder + "\\" + fileName);
                    File newFile = new File(realFolder + "\\" + freebbsID + "photo.jpg"); // freebbsID를 파일명 앞에 붙임
                    oldFile.renameTo(newFile);
                }
                
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('글쓰기에 성공했습니다.')");
                script.println("location.href='freebbs.jsp'");
                script.println("</script>");
            }
        }
    }
%>
</body>
</html>
