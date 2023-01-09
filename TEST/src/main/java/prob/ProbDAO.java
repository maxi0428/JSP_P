package prob;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import bbs.Bbs;

public class ProbDAO {
	private Connection conn;
	private ResultSet rs;
	
	public ProbDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "k404";
			Class.forName("com.mysql.jdbc.Driver");
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
		} catch(Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public int getNext() {
		String SQL = "SELECT probID FROM PROB ORDER BY probID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시물인 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int write(String probTitle, String userID, String probContent, String probSt) {
		String SQL = "INSERT INTO PROB VALUES (?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, probTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, probContent);
			pstmt.setString(6, probSt);
			pstmt.setInt(7, 1);
			
			return pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public ArrayList<Prob> getList(int pageNumber) {
		String SQL = "SELECT * FROM PROB WHERE probID < ? AND probAvailable = 1 ORDER BY probID DESC LIMIT 100";
		ArrayList<Prob> list = new ArrayList<Prob>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber -1) * 100);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Prob prob = new Prob();
				prob.setProbID(rs.getInt(1));
				prob.setProbTitle(rs.getString(2));
				prob.setUserID(rs.getString(3));
				prob.setProbDate(rs.getString(4));
				prob.setProbContent(rs.getString(5));
				prob.setProbSt(rs.getString(6));
				prob.setProbAvailable(rs.getInt(1));
				list.add(prob);
			}			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM PROB WHERE probID < ? AND probAvailable = 1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
		

	public Prob getProb(int probID) {
		String SQL = "SELECT * FROM PROB WHERE probID = ?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, probID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Prob prob = new Prob();
				prob.setProbID(rs.getInt(1));
				prob.setProbTitle(rs.getString(2));
				prob.setUserID(rs.getString(3));
				prob.setProbDate(rs.getString(4));
				prob.setProbContent(rs.getString(5));
				prob.setProbSt(rs.getString(6));
				prob.setProbAvailable(rs.getInt(1));
				return prob;
			}			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int update(int probID, String probTitle, String probContent, String probSt) {
		String SQL = "UPDATE PROB SET probSt = ?, probTitle = ?, probContent = ? WHERE probID =?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, probSt);
			pstmt.setString(2, probTitle);
			pstmt.setString(3, probContent);
			pstmt.setInt(4, probID);
			
			return pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int delete(int probID) {
		String SQL = "DELETE FROM PROB WHERE probID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, probID);
			
			return pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int getSearchedNext(String searchWord) {
		String SQL = "select NUM from (select row_number() over (order by probDate desc) NUM, A.* from bbs A where bbsavailable=1 and bbsTitle like '%"+searchWord+"%' order by NUM desc)";
		try {
			//PreparedStatement pstmt = conn.prepareStatement(SQL);
			//rs = pstmt.executeQuery();
			System.out.println("query for searched NEXT : "+SQL);
			Statement stmt = conn.createStatement();
			rs = stmt.executeQuery(SQL);
			if(rs.next()) {
				return rs.getInt(1)+1;
			}
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
public ArrayList<Prob> getSearchedList(int pageNumber, String searchWord){
		
		int no2=0;
		
		if(getNext()>pageNumber*100) {
			no2 = pageNumber*100;
		} else {
		  no2 = getNext();
		}
		
		int no1=(pageNumber -1)*100+1;
		
		String SQL = "select * from (select row_number() over (order by probDate desc) NUM, A.* from bbs A	where bbsavailable=1 and bbstitle like'%"
				+ searchWord
				+ "%' order by probDate desc) where NUM between "
				+ no1
				+ " and "
				+ no2;
				
		ArrayList<Prob> list = new ArrayList<Prob>();
		try {

			System.out.println("sql statement : "+SQL);
			Statement stmt = conn.createStatement();
			rs = stmt.executeQuery(SQL);
			
			while(rs.next()) {
				Prob prob = new Prob();
				prob.setProbID(rs.getInt(2));
				prob.setProbTitle(rs.getString(3));
				prob.setUserID(rs.getString(4));
				prob.setProbDate(rs.getString(5));
				prob.setProbContent(rs.getString(6));
				prob.setProbAvailable(rs.getInt(7));
				list.add(prob);
			}
		}catch(Exception e) {
			System.out.println("Exception:search");
			e.printStackTrace();
		}
		System.out.println(" resultset_return list:search");
		return list;
	}

	/*
	 * //다른 부분은 앞서 게시판을 만들 때 사용한 getList함수와 동일하고 다른 부분인 쿼리를 보면,
	 * 
	 * "select * from (select row_number() over (order by bbsDate desc) NUM, A.* from bbs A	where bbsavailable=1 and bbstitle like'%"
	 * + searchWord + "%' order by bbsDate desc) where NUM between " + no1 + " and "
	 * + no2;
	 */

}
