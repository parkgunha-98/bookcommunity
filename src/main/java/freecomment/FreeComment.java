package freecomment;

public class FreeComment {
    private int freeboardID;
    private int freecommentID;
    private int freebbsID;
    private String userID;
    private String freecommentDate;
    private String freecommentText;
    private int freecommentAvailable; // 수정: 이름을 올바르게 변경

    public int getFreeboardID() {
        return freeboardID;
    }

    public void setFreeboardID(int freeboardID) {
        this.freeboardID = freeboardID;
    }

    public int getFreecommentID() {
        return freecommentID;
    }

    public void setFreecommentID(int freecommentID) {
        this.freecommentID = freecommentID;
    }

    public int getFreebbsID() {
        return freebbsID;
    }

    public void setFreebbsID(int freebbsID) {
        this.freebbsID = freebbsID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getFreecommentDate() {
        return freecommentDate;
    }

    public void setFreecommentDate(String freecommentDate) {
        this.freecommentDate = freecommentDate;
    }

    public String getFreecommentText() {
        return freecommentText;
    }

    public void setFreecommentText(String freecommentText) {
        this.freecommentText = freecommentText;
    }

    public int getFreecommentAvailable() {
        return freecommentAvailable; // 수정: getter 메서드 이름 변경
    }

    public void setFreecommentAvailable(int freecommentAvailable) {
        this.freecommentAvailable = freecommentAvailable; // 수정: setter 메서드 이름 변경
    }
}
