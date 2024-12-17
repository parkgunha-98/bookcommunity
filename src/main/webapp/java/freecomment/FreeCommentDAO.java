package freecomment;

import java.sql.*;
import java.util.ArrayList;

public class FreeCommentDAO {
    private Connection conn;
    private ResultSet rs;

    public FreeCommentDAO() {
        try {
            String dbURL = "jdbc:mariadb://localhost:3306/bbs";
            String dbID = "root";
            String dbPassword = "admin";
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getDate() {
        String SQL = "SELECT NOW()";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public int getNext() {
        String SQL = "SELECT freecommentID FROM freecomment ORDER BY freecommentID DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1;
    }

    public int write(int freeboardID, int freebbsID, String userID, String freecommentText) {
        String SQL = "INSERT INTO freecomment VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, freeboardID);
            pstmt.setInt(2, getNext());
            pstmt.setInt(3, freebbsID);
            pstmt.setString(4, userID);
            pstmt.setString(5, getDate());
            pstmt.setString(6, freecommentText);
            pstmt.setInt(7, 1);
            pstmt.executeUpdate();
            return getNext();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public ArrayList<FreeComment> getList(int freeboardID, int freebbsID) {
        String SQL = "SELECT * FROM freecomment WHERE freeboardID = ? AND freebbsID = ? AND freecommentAvailable = 1 ORDER BY freecommentID DESC";
        ArrayList<FreeComment> list = new ArrayList<>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, freeboardID);
            pstmt.setInt(2, freebbsID);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                FreeComment comment = new FreeComment();
                comment.setFreeboardID(rs.getInt(1));
                comment.setFreecommentID(rs.getInt(2));
                comment.setFreebbsID(rs.getInt(3));
                comment.setUserID(rs.getString(4));
                comment.setFreecommentDate(rs.getString(5));
                comment.setFreecommentText(rs.getString(6));
                comment.setFreecommentAvailable(rs.getInt(7));
                list.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int update(int freecommentID, String freecommentText) {
        String SQL = "UPDATE freecomment SET freecommentText = ? WHERE freecommentID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, freecommentText);
            pstmt.setInt(2, freecommentID);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
	public String getUpdateComment(int freecommentID) {
		String SQL = "SELECT freecommentText FROM freecomment WHERE freecommentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, freecommentID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //오류
	}
    public FreeComment getFreecomment(int freecommentID) {
        String SQL = "SELECT * FROM freecomment WHERE freecommentID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, freecommentID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                FreeComment comment = new FreeComment();
                comment.setFreeboardID(rs.getInt(1));
                comment.setFreecommentID(rs.getInt(2));
                comment.setFreebbsID(rs.getInt(3));
                comment.setUserID(rs.getString(4));
                comment.setFreecommentDate(rs.getString(5));
                comment.setFreecommentText(rs.getString(6));
                comment.setFreecommentAvailable(rs.getInt(7));
                return comment;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public int delete(int freecommentID) {
        String SQL = "DELETE FROM freecomment WHERE freecommentID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, freecommentID);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}
