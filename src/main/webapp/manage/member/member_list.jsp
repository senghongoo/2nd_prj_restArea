<%@ page import="kr.co.sist.member.MemberService"%>
<%@ page import="kr.co.sist.member.MemberManageDTO"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%-- <c:if test="${empty date}">
  <c:redirect url="http://192.168.10.89/team_second_prj/admin/login/login_main.jsp"/>
</c:if> --%>

<!DOCTYPE html>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>회원 관리</title>

<!-- bootstrap CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
	crossorigin="anonymous"></script>

<link
	href="https://getbootstrap.com/docs/5.3/examples/dashboard/dashboard.css"
	rel="stylesheet">

<!-- jQuery CDN -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<jsp:include page="../template/admin_style_css.jsp" />

<style type="text/css">
th, td {
	text-align: center;
	vertical-align: middle;
}

.pagination {
	justify-content: center;
}

.page-item.active a {
	border-color: gray;
	background-color: gray;
	color: white;
	box-shadow: none;
}

.page-link, nav span {
	color: #333;
}

.page-link {
	border: 1px solid #ccc !important;
}

.page-item-hover a {
	color: rgb(51, 51, 51) !important;
}
</style>

<script type="text/javascript">
	$(function() {
		$("#pagination-ul").on("mouseover", ".page-item", function() {
			$(this).addClass("page-item-hover");
		}).on("mouseout", ".page-item", function() {
			$(this).removeClass("page-item-hover");
		});// on
	});// ready

	function rmMember(id, currentPage, totalCnt) {
		if (confirm(id+" 회원을 삭제하시겠습니까?")) {
			$("#id").val(id);
			$("#currentPage").val(currentPage);
			$("#totalCnt").val(totalCnt);

			$("#frm")[0].action = "removeMemberProcess.jsp";
			$("#frm").submit();
		}// end if
	};// rmMember
</script>
</head>
<body>
	<header class="navbar sticky-top bg-dark flex-md-nowrap p-0"
		data-bs-theme="dark">
		<jsp:include page="../template/admin_header.jsp" />
	</header>
	<div class="container-fluid">
		<div class="row">
			<jsp:include page="../template/admin_sidebar.jsp" />
			<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
				<div
					class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
					<h1 class="h2">
						<!-- 선택한 사이드바 이름 -->
						<span>회원 관리</span>
					</h1>
				</div>
				<jsp:useBean id="rDTO" class="kr.co.sist.member.RangeDTO"
					scope="page"></jsp:useBean>
				<jsp:setProperty property="*" name="rDTO" />
				<%
				MemberService ms = MemberService.getInstance();

				int totalCnt = ms.searchTotalCnt();

				int pageScale = ms.pageScale();

				int totalPage = ms.totalPage(totalCnt, pageScale);

				String tempPage = request.getParameter("currentPage");

				int currentPage = 1;
				if (tempPage != null) {
					try {
						currentPage = Integer.parseInt(tempPage);
					} catch (NumberFormatException nfe) {
						nfe.printStackTrace();
					} // end catch
				} // end if

				int startNum = ms.startNum(currentPage, pageScale);

				int endNum = ms.endNum(startNum, pageScale);

				rDTO.setStartNum(startNum);
				rDTO.setEndNum(endNum);
				rDTO.setUrl("member_list.jsp");
				rDTO.setTotalPage(totalPage);

				List<MemberManageDTO> memberList = ms.searchMemberList(rDTO);

				String pagination = ms.pagination(rDTO);

				pageContext.setAttribute("totalCnt", totalCnt);
				pageContext.setAttribute("pageScale", pageScale);
				pageContext.setAttribute("totalPage", totalPage);
				pageContext.setAttribute("currentPage", currentPage);
				pageContext.setAttribute("startNum", startNum);
				pageContext.setAttribute("endNum", endNum);
				pageContext.setAttribute("memberList", memberList);
				pageContext.setAttribute("pagination", pagination);
				%>
				<div id="wrap">
					<div id="top"></div>
					<div id="middle">
						<table class="table table-striped">
							<thead>
								<tr>
									<th scope="row" style="width: 10%">번호</th>
									<th scope="row" style="width: 20%">아이디</th>
									<th scope="row" style="width: 30%">이메일</th>
									<th scope="row" style="width: 20%">가입일</th>
									<th scope="row" style="width: 20%">계정 삭제</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${ empty memberList }">
									<tr>
										<td colspan="5" style="text-align: center;">가입한 회원이 없습니다.</td>
									</tr>
								</c:if>
								<c:forEach var="mmDTO" items="${ memberList }" varStatus="i">
									<tr style="cursor: pointer;" onclick="location.href='member_detail.jsp?currentPage=${ currentPage }&id=${ mmDTO.id }'">
										<td><c:out
												value="${ totalCnt - (currentPage-1) * pageScale - i.index }"></c:out></td>
										<td><c:out value="${ mmDTO.id }"></c:out></td>
										<td><c:out value="${ mmDTO.email }"></c:out></td>
										<td><c:out value="${ mmDTO.joinDate }"></c:out></td>
										<td><input type="button" value="삭제하기" id="btnDelete"
											class="btn btn-danger" onclick="event.stopPropagation(); rmMember('${ mmDTO.id }', ${ currentPage }, ${ totalCnt })" /></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<form action="removeMemberProcess.jsp" id="frm">
							<input type="hidden" name="id" id="id" style="display: none" />
							<input type="hidden" name="currentPage" id="currentPage" style="display: none" />
							<input type="hidden" name="totalCnt" id="totalCnt" style="display: none" />
						</form>
					</div>
					<div id="bottom">
						<nav aria-label="Page navigation example">
							<ul class="pagination" id="pagination-ul">
								<c:out value="${ pagination }" escapeXml="false"></c:out>
							</ul>
						</nav>
					</div>
				</div>
			</main>
		</div>
	</div>
</body>
</html>