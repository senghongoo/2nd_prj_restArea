<%@page import="kr.co.sist.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
request.setCharacterEncoding("UTF-8");
%>

<%
MemberService ms = MemberService.getInstance();

int totalCnt = Integer.parseInt(request.getParameter("totalCnt"));
int currentPage = Integer.parseInt(request.getParameter("currentPage"));
String id = request.getParameter("id");

boolean flag = ms.removeMember(id);

int afterDeleteCnt = totalCnt - 1;

int pageScale = 10;
int totalPageAfterDelete = (int) Math.ceil((double) afterDeleteCnt / pageScale);

int targetPage = (currentPage > totalPageAfterDelete) ? totalPageAfterDelete : currentPage;

if (targetPage < 1) {
	targetPage = 1;
} // end if

pageContext.setAttribute("flag", flag);
pageContext.setAttribute("targetPage", targetPage);
%>

<script type="text/javascript">
	<c:choose>
	<c:when test="${ flag }">
		alert("회원을 삭제했습니다.");
		location.href = "member_list.jsp?currentPage=${ targetPage }";
	</c:when>
	<c:otherwise>
		alert("회원 삭제 중 문제가 발생했습니다.");
		history.back();
	</c:otherwise>
	</c:choose>
</script>






