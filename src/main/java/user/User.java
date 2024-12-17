package user;

public class User {

	private String userID; //아이디
	private String userPassword; //비밀번호
	private String userName; //이름
	private String userAddress; //주소
	private String userRrn; //주민등록번호
	private String userPhoneNumber; //휴대폰번호
	private int userAuth = 0; // 유저 권한

	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserAddress() {
		return userAddress;
	}
	public void setUserAddress(String userAddress) {
		this.userAddress = userAddress;
	}
	public String getUserRrn() {
		return userRrn;
	}
	public void setUserRrn(String userRrn) {
		this.userRrn = userRrn;
	}
	public String getUserPhoneNumber() {
		return userPhoneNumber;
	}
	public void setUserPhoneNumber(String userPhoneNumber) {
		this.userPhoneNumber = userPhoneNumber;
	}
	public int getUserAuth() {
		return userAuth;
	}
	public void setUserAuth(int userAuth) {
		this.userAuth = userAuth;
	}



}
