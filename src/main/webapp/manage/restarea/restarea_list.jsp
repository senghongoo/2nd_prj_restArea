<%@ page import="kr.co.sist.restarea.RestareaManageService"%>
<%@ page import="kr.co.sist.restarea.RestareaManageDTO"%>
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

<title>휴게소 관리</title>

<!-- font-awesome CDN 시작 -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

<!-- bootstrap CDN 시작 -->
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

<!-- jQuery -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<jsp:include page="../template/admin_style_css.jsp" />

<style type="text/css">
#top {
	width: 100%;
	margin-bottom: 30px;
	display: flex;
	justify-content: space-between;
}

.top-right {
	display: flex;
}

#search {
	border: 1px solid rgb(222, 226, 230);
	padding-top: 5px;
	padding-left: 10px;
	border-radius: 5px;
	margin-right: 5px;
}

#search i {
	color: gray;
}

#search input {
	width: 250px;
	border: none;
}

#search input:focus {
	outline: none !important;
}

th, td {
	text-align: center;
	vertical-align: middle;
}

td {
	height: 55px;
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

		$("#btnSearch").click(function() {
			searchRestarea();
		});// click

		$("#keyword").keyup(function(evt) {
			if (evt.which == 13) {
				searchRestarea();
			}// end if
		});// keyup

		<c:if test="${ not empty param.keyword }">
		$("#keyword").val("${ param.keyword }")
		</c:if>
	});// ready

	function searchRestarea() {
		if ($("#keyword").val().trim() != null && $("#keyword").val().trim() != "") {
			$("#restareaSearchFrm").submit();
		}// end if
	}// searchRestarea
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
						<span>휴게소 관리</span>
					</h1>
				</div>
				<jsp:useBean id="rDTO" class="kr.co.sist.restarea.RangeDTO"
					scope="page"></jsp:useBean>
				<jsp:setProperty property="*" name="rDTO" />
				<%
				RestareaManageService rms = RestareaManageService.getInstance();

				int totalCnt = rms.searchTotalCnt(rDTO);

				int pageScale = rms.pageScale();

				int totalPage = rms.totalPage(totalCnt, pageScale);

				String tempPage = request.getParameter("currentPage");

				int currentPage = 1;
				if (tempPage != null) {
					try {
						currentPage = Integer.parseInt(tempPage);
					} catch (NumberFormatException nfe) {
						nfe.printStackTrace();
					} // end catch
				} // end if

				int startNum = rms.startNum(currentPage, pageScale);

				int endNum = rms.endNum(startNum, pageScale);

				rDTO.setStartNum(startNum);
				rDTO.setEndNum(endNum);
				rDTO.setUrl("restarea_list.jsp");
				rDTO.setTotalPage(totalPage);

				List<RestareaManageDTO> restareaList = rms.searchRestareaList(rDTO);

				String pagination = rms.pagination(rDTO);

				pageContext.setAttribute("totalCnt", totalCnt);
				pageContext.setAttribute("pageScale", pageScale);
				pageContext.setAttribute("totalPage", totalPage);
				pageContext.setAttribute("currentPage", currentPage);
				pageContext.setAttribute("startNum", startNum);
				pageContext.setAttribute("endNum", endNum);
				pageContext.setAttribute("restareaList", restareaList);
				pageContext.setAttribute("pagination", pagination);
				%>
				<div id="wrap">
					<div id="top">
						<div id="top-left">
							<button
								onclick="location.href='restarea_write.jsp?currentPage=${ currentPage }&keyword=${ param.keyword }'"
								class="btn btn-primary">휴게소 추가</button>
						</div>
							<form action="restarea_list.jsp" id="restareaSearchFrm" class="top-right">
								<div id="search">
									<i class="fa-solid fa-magnifying-glass"></i> <input type="text"
										placeholder="휴게소명" name="keyword" id="keyword">
								</div>
								<input type="text" style="display: none"> <input
									type="button" value="검색" id="btnSearch" class="btn btn-primary">
							</form>
					</div>
					<div id="middle">
						<table class="table table-bordered">
							<thead>
								<tr>
									<th scope="col" style="width: 20%">휴게소명</th>
									<th scope="col" style="width: 15%">노선</th>
									<th scope="col" style="width: 15%">전화번호</th>
									<th scope="col" style="width: 25%">주소</th>
									<th scope="col" style="width: 12.5%">생성일</th>
									<th scope="col" style="width: 12.5%">최근 수정일</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${ empty restareaList }">
									<tr>
										<td colspan="5" style="text-align: center;">등록된 휴게소가
											없습니다.</td>
									</tr>
								</c:if>
								<c:forEach var="rmDTO" items="${ restareaList }" varStatus="i">
									<tr style="cursor: pointer;"
										onclick="location.href='restarea_modify.jsp?currentPage=${ currentPage }&code=${ rmDTO.restareaCode }'">
										<td><c:out value="${ rmDTO.name }"></c:out></td>
										<td><c:out value="${ rmDTO.line }"></c:out></td>
										<td><c:out value="${ rmDTO.restareaTel }"></c:out></td>
										<td><c:out value="${ rmDTO.address }"></c:out></td>
										<td><c:out value="${ rmDTO.addDate }"></c:out></td>
										<td><c:out value="${ rmDTO.updateDate }"></c:out></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
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