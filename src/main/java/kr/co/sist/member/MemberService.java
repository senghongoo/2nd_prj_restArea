package kr.co.sist.member;

import java.sql.SQLException;
import java.util.List;

import kr.co.sist.chipher.DataDecryption;
import kr.co.sist.siteProperty.SiteProperty;

public class MemberService {

	private static MemberService ms;

	private MemberService() {

	}// MemberService

	public static MemberService getInstance() {
		if (ms == null) {
			ms = new MemberService();
		} // end if

		return ms;
	}// getInstance

	public int searchTotalCnt() {
		int totalCnt = 0;

		MemberDAO mDAO = MemberDAO.getInstance();

		try {
			totalCnt = mDAO.selectTotalCnt();
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch

		return totalCnt;
	}// searchTotalCnt

	public int pageScale() {
		return 10;
	}// pageScale

	public int totalPage(int totalCnt, int pageScale) {
		return (int) Math.ceil((double) totalCnt / pageScale);
	}// totalPage

	public int startNum(int currentPage, int pageScale) {
		return (currentPage - 1) * pageScale + 1;
	}// startNum

	public int endNum(int startNum, int pageScale) {
		return startNum + pageScale - 1;
	}// endNum

	public String pagination(RangeDTO rDTO) {
		StringBuilder pagination = new StringBuilder();

		int pageNumber = 3;

		int startPage = ((rDTO.getCurrentPage() - 1) / pageNumber) * pageNumber + 1;

		int endPage = (((startPage - 1) + pageNumber) / pageNumber) * pageNumber;

		if (rDTO.getTotalPage() <= endPage) {
			endPage = rDTO.getTotalPage();
		} // end if

		int movePage = 0;
		StringBuilder prevMark = new StringBuilder();

		prevMark.append("<li class='page-item disabled'><a class='page-link' href='#' aria-label='Previous'>"
				+ "<span aria-hidden='true'>&laquo;</span>" + "</a></li>");

		if (rDTO.getCurrentPage() > pageNumber) {
			movePage = startPage - 1;
			prevMark.delete(0, prevMark.length());
			prevMark.append("<li class='page-item'><a class='page-link' href='").append(rDTO.getUrl())
					.append("?currentPage=").append(movePage)
					.append("' aria-label='Previous'><span aria-hidden='true'>&laquo;</span></a></li>");
		} // end if

		StringBuilder pageLink = new StringBuilder();
		movePage = startPage;

		while (movePage <= endPage) {
			if (movePage == rDTO.getCurrentPage()) {
				pageLink.append("<li class='page-item'><a class='page-link' href='#'>").append(movePage)
						.append("</a></li>");
			} else {
				pageLink.append("<li class='page-item'><a class='page-link' href='").append(rDTO.getUrl())
						.append("?currentPage=").append(movePage).append("'>").append(movePage).append("</a></li>");
			} // end else

			movePage++;
		} // end while

		StringBuilder nextMark = new StringBuilder(
				"<li class='page-item disabled'><a class='page-link' aria-label='Next'><span aria-hidden='true'>&raquo;</span></a></li>");
		if (rDTO.getTotalPage() > endPage) {
			movePage = endPage + 1;
			nextMark.delete(0, nextMark.length());
			nextMark.append("<li class='page-item'><a class='page-link' href='").append(rDTO.getUrl())
					.append("?currentPage=").append(movePage)
					.append("'><span aria-hidden='true'>&raquo;</span></a></li>");
		} // end if

		pagination.append(prevMark).append(pageLink).append(nextMark);

		return pagination.toString();
	}// pagination

	public List<MemberManageDTO> searchMemberList(RangeDTO rDTO) {
		List<MemberManageDTO> list = null;

		MemberDAO mDAO = MemberDAO.getInstance();

		try {
			list = mDAO.selectRangeMember(rDTO);
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch

		if (list != null && SiteProperty.spVO != null) {
			DataDecryption dd = new DataDecryption(SiteProperty.spVO.getKey());

			for (MemberManageDTO mmDTO : list) {
				String encryptedEmail = mmDTO.getEmail();

				try {
					mmDTO.setEmail(dd.decrypt(encryptedEmail));
				} catch (Exception e) {
					e.printStackTrace();
				} // end catch
			} // end for
		} // end if

		return list;
	}// searchMemberList

	public MemberDetailDTO searchOneMember(String id) {
		MemberDetailDTO mdDTO = null;

		MemberDAO mDAO = MemberDAO.getInstance();

		try {
			mdDTO = mDAO.selectOneMember(id);
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch

		if (mdDTO != null && SiteProperty.spVO != null) {
			DataDecryption dd = new DataDecryption(SiteProperty.spVO.getKey());

			String encryptedName = mdDTO.getName();
			String encryptedTel = mdDTO.getTel();
			String encryptedPhone = mdDTO.getPhone();
			String encryptedEmail = mdDTO.getEmail();
			String encryptedPostcode = mdDTO.getPostcode().trim();
			String encryptedAddress = mdDTO.getAddress();
			String encryptedAddressDetail = mdDTO.getAddressDetail();
			

			try {
				mdDTO.setName(dd.decrypt(encryptedName));
				mdDTO.setTel(dd.decrypt(encryptedTel));
				mdDTO.setPhone(dd.decrypt(encryptedPhone));
				mdDTO.setEmail(dd.decrypt(encryptedEmail));
				
				System.out.println(dd.decrypt(encryptedPostcode));
				System.out.println(dd.decrypt(encryptedAddress));
				System.out.println(dd.decrypt(encryptedAddressDetail));
				
				mdDTO.setPostcode(dd.decrypt(encryptedPostcode));
				mdDTO.setAddress(dd.decrypt(encryptedAddress));
				mdDTO.setAddressDetail(dd.decrypt(encryptedAddressDetail));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if

		return mdDTO;
	}// searchOneMember

	public boolean removeMember(String id) {
		boolean flag = false;

		MemberDAO mDAO = MemberDAO.getInstance();

		try {
			int result = mDAO.deleteMember(id);
			flag = (result == 1) ? true : false;
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch

		return flag;
	}// removeMember

}// class
