package freebbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class FreebbsDAO {
    private Connection conn;
    private ResultSet rs;

    // 기본 생성자
    public FreebbsDAO() {
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

    // 작성일 메소드
    public String getDate() {
        String sql = "select now()";
        try {
            PreparedStatement psmt = conn.prepareStatement(sql);
            rs = psmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ""; // 데이터베이스 오류
    }

    // 게시글 번호 부여 메소드
    public int getNext() {
        String sql = "select freebbsID from freebbs order by freebbsID desc";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1; // 가장 상위의 게시글번호를 구해서 그 게시글 번호에 +1을 더해서 게시글의 새 번호를 부여
            }
            return 1; // 첫번째 게시물인 경우
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터베이스 오류
    }

    // 글쓰기 메소드
    public int write(String freebbsTitle, String userID, String freebbsContent, String freefileName, int freebbsLock) {
        String sql = "insert into freebbs (freebbsID, freebbsTitle, userID, freebbsDate, freebbsContent, freebbsAvailable, freefileName, freebbsLock) values (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, getNext()); // 새로운 게시글 번호
            pstmt.setString(2, freebbsTitle); // 게시글 제목
            pstmt.setString(3, userID); // 사용자 ID
            pstmt.setString(4, getDate()); // 작성일자
            pstmt.setString(5, freebbsContent); // 게시글 내용
            pstmt.setInt(6, 1); // 글의 유효 번호 (1은 유효)
            pstmt.setString(7, freefileName); // 파일명 저장
            pstmt.setInt(8, freebbsLock); // 비공개/공개 설정 (int로 변경)
            return pstmt.executeUpdate(); // 데이터베이스에 삽입
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터베이스 오류
    }

    // 게시글 리스트 메소드
    public ArrayList<Freebbs> getList(int pageNumber) {
        String sql = "select * from freebbs where freebbsID < ? and freebbsAvailable = 1 order by freebbsID desc limit 10";
        ArrayList<Freebbs> list = new ArrayList<>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); // 게시글 번호 설정
            rs = pstmt.executeQuery();
            while (rs.next()) { // 각각의 요소를 담아 하나의 리스트로 반환
                Freebbs freebbs = new Freebbs();
                freebbs.setFreebbsID(rs.getInt(1));
                freebbs.setFreebbsTitle(rs.getString(2));
                freebbs.setUserID(rs.getString(3));
                freebbs.setFreebbsDate(rs.getString(4));
                freebbs.setFreebbsContent(rs.getString(5));
                freebbs.setFreebbsAvailable(rs.getInt(6));
                freebbs.setFreebbsLock(rs.getInt(8)); // freebbsLock 값을 제대로 설정
                list.add(freebbs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 하나의 게시글을 보는 메소드
    public Freebbs getFreebbs(int freebbsID) {
        String sql = "select * from freebbs where freebbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, freebbsID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Freebbs freebbs = new Freebbs();
                freebbs.setFreebbsID(rs.getInt(1));
                freebbs.setFreebbsTitle(rs.getString(2));
                freebbs.setUserID(rs.getString(3));
                freebbs.setFreebbsDate(rs.getString(4));
                freebbs.setFreebbsContent(rs.getString(5));
                freebbs.setFreebbsAvailable(rs.getInt(6));
                freebbs.setFreebbsLock(rs.getInt(8)); // 게시글의 freebbsLock 값을 설정
                return freebbs; // 해당 게시글의 내용을 불러와서 리턴해줌
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 게시글 수정 메소드
    public int update(int freebbsID, String freebbsTitle, String freebbsContent, String freefileName, int freebbsLock) {
        String sql = "update freebbs set freebbsTitle = ?, freebbsContent = ?, freefileName = ?, freebbsLock = ? where freebbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, freebbsTitle);  // 제목 수정
            pstmt.setString(2, freebbsContent);  // 내용 수정
            pstmt.setString(3, freefileName);  // 새로운 파일명 저장 (수정된 이미지가 있다면)
            pstmt.setInt(4, freebbsLock);  // 비공개/공개 설정
            pstmt.setInt(5, freebbsID);  // 수정할 게시글 ID

            int result = pstmt.executeUpdate();  // 업데이트된 행의 수 반환
            return result;  // 성공 시 1 반환, 실패 시 0 반환
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;  // 데이터베이스 오류 시
    }

    // 게시글 삭제 메소드
    public int delete(int freebbsID) { // 실제 데이터를 삭제하는 것이 아니라 유효숫자를 '0'으로 변경
        String sql = "update freebbs set freebbsAvailable = 0 where freebbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, freebbsID);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터베이스 오류
    }

    // 게시글 검색 메소드
    public ArrayList<Freebbs> getSearch(String searchField, String searchText) {
        ArrayList<Freebbs> list = new ArrayList<>();
        String SQL = "select * from freebbs WHERE " + searchField.trim();
        try {
            if (searchText != null && !searchText.equals("")) {
                SQL += " LIKE '%" + searchText.trim() + "%' order by freebbsID desc limit 10";
            }
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery(); // select
            while (rs.next()) {
                Freebbs freebbs = new Freebbs();
                freebbs.setFreebbsID(rs.getInt(1));
                freebbs.setFreebbsTitle(rs.getString(2));
                freebbs.setUserID(rs.getString(3));
                freebbs.setFreebbsDate(rs.getString(4));
                freebbs.setFreebbsContent(rs.getString(5));
                freebbs.setFreebbsAvailable(rs.getInt(6));
                freebbs.setFreebbsLock(rs.getInt(8)); // 검색된 결과에서 freebbsLock 값 설정
                list.add(freebbs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; // 게시글 리스트 반환
    }

    // 다음 페이지가 있는지 확인하는 메소드
    public boolean nextPage(int pageNumber) {
        String sql = "select * from freebbs where freebbsID < ? and freebbsAvailable = 1 order by freebbsID desc limit 1";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); // 페이지 번호에 맞는 게시글 조회
            rs = pstmt.executeQuery();
            return rs.next(); // 다음 페이지가 있으면 true 반환
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // 오류 발생 시 false 반환
    }
}
