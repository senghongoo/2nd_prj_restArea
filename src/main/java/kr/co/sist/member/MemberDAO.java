package kr.co.sist.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import kr.co.sist.dao.DbConn;

public class MemberDAO {

	private static MemberDAO mDAO;

	private MemberDAO() {
		
	}// MemberDAO

	public static MemberDAO getInstance() {
		if (mDAO == null) {
			mDAO = new MemberDAO();
		} // end if

		return mDAO;
	}// getInstance

	public int selectTotalCnt() throws SQLException {
		int totalCnt = 0;

		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = dbCon.getConn();

			String selectTotal = "select count(*) cnt from user_info where delete_flag = 'N'";
			
			pstmt = con.prepareStatement(selectTotal);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				totalCnt = rs.getInt("cnt");
			} // end if
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return totalCnt;
	}// selectTotalCnt

	public List<MemberManageDTO> selectRangeMember(RangeDTO rDTO) throws SQLException {
		List<MemberManageDTO> list = new ArrayList<MemberManageDTO>();

		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = dbCon.getConn();

			StringBuilder selectRangeMember = new StringBuilder();
			selectRangeMember
			.append("	select user_id, email, join_date 				 ")
			.append("	from (	select user_id, email, join_date, 		 ")
			.append("	row_number() over( order by join_date desc) rnum ")
			.append("	from user_info									 ")
			.append("	where  delete_flag = 'N'						 ")
			.append("	) where rnum between ? and ?					 ");
			
			pstmt = con.prepareStatement(selectRangeMember.toString());
			
			pstmt.setInt(1, rDTO.getStartNum());
			pstmt.setInt(2, rDTO.getEndNum());

			rs = pstmt.executeQuery();

			MemberManageDTO mmDTO = null;

			while (rs.next()) {
				mmDTO = new MemberManageDTO();
				mmDTO.setId(rs.getString("user_id"));
				mmDTO.setEmail(rs.getString("email"));
				mmDTO.setJoinDate(rs.getDate("join_date"));

				list.add(mmDTO);
			} // end while
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return list;
	}// selectRangeMember

	public MemberDetailDTO selectOneMember(String id) throws SQLException {
		MemberDetailDTO mdDTO = null;

		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = dbCon.getConn();

			StringBuilder selectOneMember = new StringBuilder();
			selectOneMember
			.append("	select user_id, name, birth, tel, phone, email,  ")
			.append("	gender, postcode, address, address_detail		 ")
			.append("	from user_info                                   ")
			.append("	where user_id = ?						         ");
			
			pstmt = con.prepareStatement(selectOneMember.toString());

			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();
			
			String user_id, name, tel, phone, email, gender, postcode, address, address_detail  = "";
			Date birth = null;

			if (rs.next()) {
				user_id = rs.getString("user_id");
				name = rs.getString("name");
				tel = rs.getString("tel");
				phone = rs.getString("phone");
				email = rs.getString("email");
				gender = rs.getString("gender");
				postcode = rs.getString("postcode");
				address = rs.getString("address");
				address_detail = rs.getString("address_detail");
				birth = rs.getDate("birth");

				mdDTO = new MemberDetailDTO(user_id, name, tel, phone, email, gender, postcode, address, address_detail, birth);
			} // end if
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally
		
		return mdDTO;
	}// selectOneMember

	public int deleteMember(String id) throws SQLException {
		int result = 0;
		
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = dbCon.getConn();

			StringBuilder updateOneMember = new StringBuilder();
			updateOneMember
			.append("	update user_info      ")
			.append("	set delete_flag = 'y' ")
			.append("	where user_id = ?     ");
			
			pstmt = con.prepareStatement(updateOneMember.toString());

			pstmt.setString(1, id);
			
			result = pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally
		
		return result;
	}// deleteMember

}// class
