package file;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class FileDAO {

    private Connection conn;

    public FileDAO() {
        try {
            String dbURL = "jdbc:mariadb://localhost:3306/bbs"; // DB 연결 주소
            String dbID = "root"; // DB 사용자 ID
            String dbPassword = "admin"; // DB 사용자 비밀번호
            Class.forName("org.mariadb.jdbc.Driver"); // JDBC 드라이버 로드
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword); // DB 연결 시도
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int upload(String fileName, String fileRealName, int bbsID) {
        String SQL = "INSERT INTO bbs_file (file_name, file_real_name, bbs_id) VALUES (?,?,?)"; // DB에 파일정보를 삽입할 쿼리문
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, fileName);
            pstmt.setString(2, fileRealName);
            pstmt.setInt(3, bbsID);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return -1; // 예외 발생 시 -1 반환
        } finally {
            try {
                if (conn != null)
				 {
					conn.close();  // 커넥션 닫기
				}
                if (pstmt != null)
				 {
					pstmt.close(); // PreparedStatement 닫기
				}
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
