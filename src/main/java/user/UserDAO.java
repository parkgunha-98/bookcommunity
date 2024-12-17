package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

	private Connection conn; // 자바와 DB 연결
	private PreparedStatement pstmt; // 쿼리문 대기 및 설정
	private ResultSet rs; // DB 결과 저장

	public UserDAO() {
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

	// 로그인 영역
	public int login(String userID, String userPassword) {
		String sql = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
				pstmt = conn.prepareStatement(sql); // 쿼리문 대기
				pstmt.setString(1, userID); // 받아온 변수를 userID에 대입
				rs = pstmt.executeQuery(); // 쿼리문을 rs에 저장
				if(rs.next()) {
					if(rs.getString(1).equals(userPassword)) {
					//if(userPassword.equals(rs.getString("userPassword"))) {
						return 1; // 로그인 성공
					}
					else {
						return 0; // 로그인 실패
					}
				}
				return -1; // 틀린 비밀번호
	} catch(Exception e) {
		e.printStackTrace();
			return -2; // 오류
	}
		

	}
	// 회원가입 영역
    public int join(User user) {
        String sql = "INSERT INTO user (userID, userPassword, userName, userAddress, userRrn, userPhoneNumber, userAuth) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUserID());
            pstmt.setString(2, user.getUserPassword());
            pstmt.setString(3, user.getUserName());
            pstmt.setString(4, user.getUserAddress());
            pstmt.setString(5, user.getUserRrn());
            pstmt.setString(6, user.getUserPhoneNumber());
            pstmt.setInt(7, user.getUserAuth());  // userAuth 값을 0으로 설정

            return pstmt.executeUpdate();  // 성공하면 1 반환
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;  // 실패 시
    }
	   // 아이디 중복 검사
    public boolean isUserIdDuplicated(String userID) {
        String sql = "SELECT COUNT(*) FROM user WHERE userID = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // 중복된 아이디가 있으면 true
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // 오류 시 false 반환
    }

    // 주민등록번호 중복 검사
    public boolean isUserRrnDuplicated(String userRrn) {
        String sql = "SELECT COUNT(*) FROM user WHERE userRrn = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userRrn);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // 중복된 주민등록번호가 있으면 true
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // 오류 시 false 반환
    }

    // 휴대폰 번호 중복 검사
    public boolean isUserPhoneNumberDuplicated(String userPhoneNumber) {
        String sql = "SELECT COUNT(*) FROM user WHERE userPhoneNumber = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userPhoneNumber);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // 중복된 휴대폰 번호가 있으면 true
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // 오류 시 false 반환
    }
}
