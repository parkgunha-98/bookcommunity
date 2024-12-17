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

    // 공개/비공개 값 처리 (값이 null일 경우 0으로 처리)
    String freebbsLockStr = multi.getParameter("freebbsLock");
    int freebbsLock = 0; // 기본값 0 (공개)
    if (freebbsLockStr != null) {
        try {
            freebbsLock = Integer.parseInt(freebbsLockStr);
        } catch (NumberFormatException e) {
            freebbsLock = 0; // 값이 잘못된 경우 기본값으로 설정
        }
    }

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
            int freebbsID = Integer.parseInt(multi.getParameter("freebbsID")); // 수정할 게시글 ID 가져오기
            boolean result = (freebbsDAO.update(freebbsID, freebbs.getFreebbsTitle(), freebbs.getFreebbsContent(), freefileName, freebbsLock) == 1);
            if (!result) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('수정에 실패했습니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else {
				PrintWriter script = response.getWriter();
				if(fileName != null){
					String real = "C:\\Users\\박건하\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp5\\wtpwebapps\\com\\freebbsUpload";
					File delFile = new File(real+"\\"+freebbsID+"photo.jpg");
					if(delFile.exists()){
						delFile.delete();
					}

                    File oldFile = new File(realFolder + "\\" + fileName);
                    File newFile = new File(realFolder + "\\" + freebbsID +"photo.jpg" );
                    
                    if (oldFile.exists()) {
                        oldFile.renameTo(newFile);
                    }
                }
                script.println("<script>");
                out.println("alert('글 수정하기 성공');");
                script.println("location.href='freebbs.jsp'");
                script.println("</script>");
            }
        }
    }
%>
</body>
</html>
