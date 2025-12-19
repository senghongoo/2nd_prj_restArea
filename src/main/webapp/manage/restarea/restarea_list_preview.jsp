<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.sist.restarea.ExtraFacilitiesDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.sist.restarea.RestareaDetailDTO"%>
<%@page import="kr.co.sist.restarea.AmenitiesDTO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.sist.restarea.RestareaCreateService"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@page import="kr.co.sist.user.restarea.RestAreaRangeDTO"%>
<%@page import="kr.co.sist.user.bookmark.BookmarkService"%>
<%@page import="kr.co.sist.user.restarea.RestAreaDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.sist.user.restarea.RestAreaService"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%
// 1. 요청 파라미터 처리 (MultipartRequest)
request.setCharacterEncoding("UTF-8");

// 이미지 저장 임시 경로 (실제 경로에 맞게 수정 필요)
String baseDir = "C:/dev/workspace/2nd_prj_restArea/src/main/webapp/resource/images/";
File tempDir = new File(baseDir);
if (!tempDir.exists()) {
	tempDir.mkdirs();
} // end if

int maxSize = 1024 * 1024 * 10;
MultipartRequest mr = new MultipartRequest(request, tempDir.getAbsolutePath(), maxSize, "UTF-8", new DefaultFileRenamePolicy());

RestareaCreateService rcs = RestareaCreateService.getInstance();
String line = mr.getParameter("line");
int restareaCode = rcs.searchRestareaCode(line) + 1;

// 2. AmenitiesDTO 처리 (부가시설)
String[] amenityNames = {"sleepingRoom", "showerRoom", "restHub", "nursingRoom", "pharmacy", "agricultureMarket", "carWash", "carRepair"};
Map<String, String> aMap = new HashMap<>();

for (String name : amenityNames) {
	aMap.put(name, (mr.getParameter(name) == null) ? "N" : "Y");
}

AmenitiesDTO aDTO = new AmenitiesDTO(restareaCode, aMap.get("sleepingRoom"), aMap.get("showerRoom"),
		aMap.get("restHub"), aMap.get("nursingRoom"), aMap.get("pharmacy"), aMap.get("agricultureMarket"),
		aMap.get("carWash"), aMap.get("carRepair"));

// 3. RestareaDetailDTO 처리 (상세 정보)
double lat = 0.0;
double lng = 0.0;
try {
	lat = Double.parseDouble(mr.getParameter("latitude"));
	lng = Double.parseDouble(mr.getParameter("longitude"));
} catch (NumberFormatException e) {
	e.printStackTrace();
}

RestareaDetailDTO rdDTO = new RestareaDetailDTO(restareaCode, mr.getParameter("titleName"), line, null,
		mr.getParameter("titlePhrase"), mr.getParameter("address"), mr.getParameter("restareaTel"),
		mr.getParameter("gasstationTel"), mr.getParameter("famousFood"), mr.getParameter("parkingScale"), lat, lng);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>휴게소 상세 미리보기</title>
<link rel="stylesheet" type="text/css" href="http://211.63.89.149/2nd_prj_restArea/resource/css/a_base.css" />
<link rel="stylesheet" type="text/css" href="http://211.63.89.149/2nd_prj_restArea/resource/css/a_common.css" />
<link rel="stylesheet" type="text/css" href="http://211.63.89.149/2nd_prj_restArea/resource/css/a_sub.css" />
<link rel="stylesheet" type="text/css" href="http://211.63.89.149/2nd_prj_restArea/resource/css/b_common.css">
<link rel="stylesheet" type="text/css" href="http://211.63.89.149/2nd_prj_restArea/resource/css/b_sub.css" />
<link rel="stylesheet" type="text/css" href="http://211.63.89.149/2nd_prj_restArea/resource/css/b_reaction.css" />
<link rel="shortcut icon" type="image/x-icon" href="http://211.63.89.149/2nd_prj_restArea/resource/images/favicon.ico" />

<style type="text/css">
/* 상단 미리보기 고정 바 스타일 (detail_rest.jsp 피드백 반영) */
.preview-mode-bar {
    background: #ff5722;
    color: white;
    text-align: center;
    padding: 10px; /* 적절한 크기 조절 */
    font-weight: bold;
    position: sticky;
    top: 0;
    z-index: 9999;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

/* 아코디언 관련 스타일 */
.accordion-header {
   display: flex;
   justify-content: space-between;
   align-items: center;
   cursor: pointer;
}
.accordion-header .toggle-icon {
   font-size: 18px;
   font-weight: bold;
   transition: 0.25s ease;
}
.accordion-content {
   display: none;
}

/* 테이블 레이아웃 및 아이콘 정리 */
table { width: 100%; border-collapse: collapse; }
.convi_iconA {
   display: flex; flex-wrap: wrap; gap: 10px; list-style: none; padding: 0;
}
.convi_iconA li, .convenient ul li {
   display: inline-flex; align-items: center; gap: 6px; padding-left: 28px; 
   height: 24px; background-size: 20px 20px; background-position: left center; 
   background-repeat: no-repeat;
}

/* 하단 닫기 버튼 영역 */
.close-btn-wrap { text-align: center; margin: 50px 0; }
.btn-close { 
    padding: 12px 35px; background: #333; color: #fff; border: none; 
    border-radius: 5px; cursor: pointer; font-size: 15px;
}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript">
   $(function() {
      $(".accordion-header").on("click", function() {
         const currentHeader = $(this);
         const currentContent = currentHeader.next(".accordion-content");
         const currentIcon = currentHeader.find(".toggle-icon");

         currentContent.slideToggle(200);
         currentHeader.toggleClass("active");
         currentIcon.text(currentIcon.text() === "+" ? "-" : "+");

         $(".accordion-header").not(currentHeader).each(function() {
            const otherHeader = $(this);
            const otherContent = otherHeader.next(".accordion-content");
            if (otherContent.is(":visible")) {
               otherContent.slideUp(200);
               otherHeader.removeClass("active");
               otherHeader.find(".toggle-icon").text("+");
            }
         });
      });
   });
</script>
</head>

<body>
   <div class="preview-mode-bar">현재 화면은 [미리보기] 모드입니다. 데이터는 저장되지 않은 상태입니다.</div>

   <header>
      <c:if test="${ empty sessionScope.id }">
         <jsp:include page="../../fragments/header_login.jsp" />
      </c:if>
      <c:if test="${ not empty sessionScope.id }">
         <jsp:include page="../../fragments/header_logout.jsp" />
      </c:if>
   </header>

   <main>
      <div class="topVis tour">
         <div class="inner">
            <p>고속도로 <span>휴게소의</span> <span>모든것</span> <br />쌍용 휴게소 허브</p>
            <div class="location">
               <ul>
                  <li>메인</li>
                  <li>휴게소 관리</li>
                  <li>휴게소 추가 미리보기</li>
               </ul>
            </div>
         </div>
      </div>
      <section class="inner" style="padding-bottom: 0">
         <aside>
            <h2 id="leftTitle">휴게소 목록</h2>
            <ul id="leftMenu">
               <li class="on"><a>휴게소 전체목록(미리보기)</a></li>
               <li class="accordion">
                  <div class="accordion-header"><%=line%><span class="toggle-icon">+</span></div>
                  <ul class="lnb_sub accordion-content">
                     <li><a><%=rdDTO.getName()%></a></li>
                  </ul>
               </li>
            </ul>
         </aside>

         <div id="contents" class="cont">
            <h3 style="color: #333">휴게소 목록</h3>
            
            <div class="rest_wrap2 mb30" style="margin-top:20px;">
               <h4 class="list_rest">편의시설 구분</h4>
               <ul class="convi_iconA">
                  <li class="sleep2">수면실</li>
                  <li class="shower2">샤워실</li>
                  <li class="rest2">쉼터</li>
                  <li class="nursing2">수유실</li>
                  <li class="phar2">약국</li>
                  <li class="espe2">농산물판매장</li>
               </ul>
            </div>

            <div class="manage_list mt-30">
               <table>
                  <caption>휴게소 편의시설 안내 미리보기</caption>
                  <colgroup>
                     <col style="">
                     <col style="width: 4%">
                     <col style="width: 14%">
                     <col style="width: 14%">
                     <col style="width: 22%">
                     <col style="width: 7%">
                     <col style="width: 9%">
                     <col style="width: 9%">
                  </colgroup>
                  <thead>
                     <tr>
                        <th colspan="2" scope="col">휴게소명</th>
                        <th scope="col">노선</th>
                        <th scope="col">전화번호</th>
                        <th scope="col">편의시설</th>
                        <th scope="col">세차장</th>
                        <th scope="col">경정비소</th>
                        <th scope="col">상태</th>
                     </tr>
                  </thead>
                  <tbody>
                     <tr>
                        <th scope="row"><%=rdDTO.getName()%></th>
                        <td class="cen"><span style="color:#ccc;">♡</span></td>
                        <td><%=rdDTO.getLine()%></td>
                        <td class="cen"><%=rdDTO.getRestareaTel()%></td>
                        <td class="convenient" valign="top">
                           <ul>
                              <% if ("Y".equals(aDTO.getSleepingRoom())) { %><li class="sleep2">수면실</li><% } %>
                              <% if ("Y".equals(aDTO.getShowerRoom())) { %><li class="shower2">샤워실</li><% } %>
                              <% if ("Y".equals(aDTO.getRestHub())) { %><li class="rest2">쉼터</li><% } %>
                              <% if ("Y".equals(aDTO.getNursingRoom())) { %><li class="nursing2">수유실</li><% } %>
                              <% if ("Y".equals(aDTO.getPharmacy())) { %><li class="phar2">약국</li><% } %>
                              <% if ("Y".equals(aDTO.getAgricultureMarket())) { %><li class="espe2">농산물판매장</li><% } %>
                           </ul>
                        </td>
                        <td class="cen"><%=aDTO.getCarWash()%></td>
                        <td class="cen"><%=aDTO.getCarRepair()%></td>
                        <td class="cen"><span style="color:#ff5722; font-weight:bold;">등록예정</span></td>
                     </tr>
                  </tbody>
               </table>
            </div>
         </div>
      </section>
			<div class="close-btn-wrap" style="margin-top: -50px">
                <button type="button" class="btn-close" onclick="window.close();">미리보기 닫기</button>
            </div>
   </main>
</body>
</html>