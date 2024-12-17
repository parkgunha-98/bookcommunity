package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;

	//기본 생성자
	public BbsDAO() {
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

	//작성일 메소드
	public String getDate() {
		String sql = "select now()";
		try {
			PreparedStatement psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}

	//게시글 번호 부여 메소드
	public int getNext() {
		//현재 게시글을 내림차순으로 조회하여 가장 마지막 글의 번호를 구한다
		String sql = "select bbsID from bbs order by bbsID desc";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1; //가장 상위의 게시글번호를 구해서 그 게시글 번호에 +1을 더해서 게시글의 새 번호를 부여
			}
			return 1; // 첫번째 게시물인 경우
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}

	//글쓰기 메소드
	public int write(String bbsTitle, String userID, String bbsContent, String fileName) {
	    String sql = "insert into bbs (bbsID, bbsTitle, userID, bbsDate, bbsContent, bbsAvailable, fileName) values (?, ?, ?, ?, ?, ?, ?)";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, getNext()); // 새로운 게시글 번호
	        pstmt.setString(2, bbsTitle); // 게시글 제목
	        pstmt.setString(3, userID); // 사용자 ID
	        pstmt.setString(4, getDate()); // 작성일자
	        pstmt.setString(5, bbsContent); // 게시글 내용
	        pstmt.setInt(6, 1); // 글의 유효 번호 (1은 유효)
	        pstmt.setString(7, fileName); // 파일명 저장
	        return pstmt.executeUpdate(); // 데이터베이스에 삽입
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1; // 데이터베이스 오류
	}

	//게시글 리스트 메소드
	public ArrayList<Bbs> getList(int pageNumber){
		String sql = "select * from bbs where bbsID < ? and bbsAvailable = 1 order by bbsID desc limit 10";
		//모든 게시글을 조회하고 현재 유효번호가 존재하고 새롭게 작성될 게시글 번호보다 작은 모든 게시글번호를 내림차순 정렬로 10개까지 조회
		ArrayList<Bbs> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); // 게시글 번호 설정
			rs = pstmt.executeQuery();
			while(rs.next()) { // 각각의 요소를 담아 하나의 리스트로 반환
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}

			}catch (Exception e) {
				e.printStackTrace();
		}
		return list;
	}

	//페이지 처리 메소드
	public boolean nextPage(int pageNumber) {
		String sql = "select * from bbs where bbsID < ? and bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber -1) * 10); // 게시글을 넘길때 '다음'버튼을 만들어 페이징 처리를 위한 기능
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	//하나의 게시글을 보는 메소드
	public Bbs getBbs(int bbsID) {
		String sql = "select * from bbs where bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs; // 해당 게시글의 내용을 불러와서 리턴해줌
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	//게시글 수정 메소드
	public int update(int bbsID, String bbsTitle, String bbsContent, String fileName) {
	    String sql = "update bbs set bbsTitle = ?, bbsContent = ?, fileName = ? where bbsID = ?";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, bbsTitle);  // 제목 수정
	        pstmt.setString(2, bbsContent);  // 내용 수정
	        pstmt.setString(3, fileName);  // 새로운 파일명 저장 (수정된 이미지가 있다면)
	        pstmt.setInt(4, bbsID);  // 수정할 게시글 ID

	        int result = pstmt.executeUpdate();  // 업데이트된 행의 수 반환
	        return result;  // 성공 시 1 반환, 실패 시 0 반환
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1;  // 데이터베이스 오류 시
	}



	//게시글 삭제 메소드
	public int delete(int bbsID) { //실제로 데이터를 삭제하는것이 아니라 유효숫자를 '0'으로 변경
		String sql = "update bbs set bbsAvailable = 0 where bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	//게시글 검색 메소드
	public ArrayList<Bbs> getSearch(String searchField, String searchText){//특정한 리스트를 받아서 반환
	      ArrayList<Bbs> list = new ArrayList<>();
	      String SQL ="select * from bbs WHERE "+searchField.trim();
	      try {
	            if(searchText != null && !searchText.equals("") ){
	                SQL +=" LIKE '%"+searchText.trim()+"%' order by bbsID desc limit 10";
	            }
	            PreparedStatement pstmt=conn.prepareStatement(SQL);
				rs=pstmt.executeQuery();//select
	         while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
	         }
	      } catch(Exception e) {
	         e.printStackTrace();
	      }
	      return list;//게시글 리스트 반환
	   }

}
