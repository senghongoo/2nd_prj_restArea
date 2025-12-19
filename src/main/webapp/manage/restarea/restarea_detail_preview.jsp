<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.sql.SQLException"%>
<%@page import="kr.co.sist.restarea.ExtraFacilitiesDTO"%>
<%@page import="kr.co.sist.restarea.RestareaDetailDTO"%>
<%@page import="kr.co.sist.restarea.AmenitiesDTO"%>
<%@page import="kr.co.sist.restarea.RestareaCreateService"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*"%>

<%
request.setCharacterEncoding("UTF-8");
%>

<%!
private String moveFile(MultipartRequest mr, String paramName, String baseDir, String subDir) {
		String fileName = mr.getFilesystemName(paramName);

		if (fileName != null) {
			File srcFile = mr.getFile(paramName);
			File destDir = new File(baseDir + subDir);

			if (!destDir.exists()) {
				destDir.mkdirs();
			}

			File destFile = new File(destDir, fileName);

			try {
				Files.move(srcFile.toPath(), destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
				return subDir + fileName;
			} catch (Exception e) {
				e.printStackTrace();
				if (srcFile.exists())
					srcFile.delete();
			}
		}
		return "";
	}
%>

<%
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

String titleImgPath = moveFile(mr, "titleImg", baseDir, "title/");

if(titleImgPath == "") {
	titleImgPath = "title/" + mr.getParameter("titleImgTxt");
}// end if

// AmenitiesDTO 처리
String[] amenityNames = {"sleepingRoom", "showerRoom", "restHub", "nursingRoom", "pharmacy", "agricultureMarket",
		"carWash", "carRepair"};
Map<String, String> aMap = new HashMap<>();

for (String name : amenityNames) {
	aMap.put(name, (mr.getParameter(name) == null) ? "N" : "Y");
} // end for

AmenitiesDTO aDTO = new AmenitiesDTO(restareaCode, aMap.get("sleepingRoom"), aMap.get("showerRoom"),
		aMap.get("restHub"), aMap.get("nursingRoom"), aMap.get("pharmacy"), aMap.get("agricultureMarket"),
		aMap.get("carWash"), aMap.get("carRepair"));

// RestareaDetailDTO 처리
double lat = 0.0;
double lng = 0.0;

try {
	lat = Double.parseDouble(mr.getParameter("latitude"));
	lng = Double.parseDouble(mr.getParameter("longitude"));
} catch (NumberFormatException e) {
	e.printStackTrace();
} // end catch

RestareaDetailDTO rdDTO = new RestareaDetailDTO(restareaCode, mr.getParameter("titleName"), line, titleImgPath,
		mr.getParameter("titlePhrase"), mr.getParameter("address"), mr.getParameter("restareaTel"),
		mr.getParameter("gasstationTel"), mr.getParameter("famousFood"), mr.getParameter("parkingScale"), lat, lng);

// List<ExtraFacilitiesDTO> 처리
List<ExtraFacilitiesDTO> efDTOList = new ArrayList<>();
Enumeration params = mr.getParameterNames();

while (params.hasMoreElements()) {
	String nameParam = (String) params.nextElement();

	if (nameParam.startsWith("fac") && nameParam.contains("Name_")) {
		String facilityCode = nameParam.substring(3, 4);
		String idx = nameParam.substring(nameParam.lastIndexOf("_") + 1);

		String nameValue = mr.getParameter(nameParam);
		String imgTxtParam = "fac" + facilityCode + "ImgTxt_" + idx;
		String imgParam = "fac" + facilityCode + "Img_" + idx;
		String phraseParam = "fac" + facilityCode + "Phrase_" + idx;

		String subDirPath = "fac_" + facilityCode + "/";
		String facilityImgPath = moveFile(mr, imgParam, baseDir, subDirPath);
		
		if(facilityImgPath == "") {
			facilityImgPath = "fac_"+ facilityCode + "/" + mr.getParameter(imgTxtParam);
		}// end if

		efDTOList.add(new ExtraFacilitiesDTO(restareaCode, facilityCode, nameValue, facilityImgPath,
		mr.getParameter(phraseParam)));
	} // end if
} // end while
	
Collections.reverse(efDTOList);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>휴게소 상세 미리보기</title>

<link rel="stylesheet" type="text/css"
	href="http://211.63.89.149/2nd_prj_restArea/resource/css/a_base.css" />
<link rel="stylesheet" type="text/css"
	href="http://211.63.89.149/2nd_prj_restArea/resource/css/a_common.css" />
<link rel="stylesheet" type="text/css"
	href="http://211.63.89.149/2nd_prj_restArea/resource/css/a_sub.css" />
<link rel="stylesheet" type="text/css"
	href="http://211.63.89.149/2nd_prj_restArea/resource/css/a_detail_rest.css" />
<link rel="shortcut icon" type="image/x-icon"
	href="http://211.63.89.149/2nd_prj_restArea/resource/images/favicon.ico" />

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style type="text/css">
/* 미리보기 알림 바 */
.preview-mode-bar {
	background: #ff5722;
	color: white;
	text-align: center;
	padding: 10px;
	font-weight: bold;
	position: sticky;
	top: 0;
	z-index: 9999;
}

.tour_list {
	display: none;
}

.tour_list.on {
	display: block;
}

.close-btn-wrap {
	text-align: center;
	margin: 50px 0;
}

.close-btn {
	padding: 15px 40px;
	background: #333;
	color: #fff;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	font-size: 16px;
}
</style>

<script type="text/javascript">
	$(function() {
		// 탭 이동 로직
		window.tabMove = function(tabIndex) {
			$('.tour_wrap h3 a').removeClass('active');
			$('.tour_list').removeClass('on').hide();
			$('#tabMove' + tabIndex).addClass('active');
			$('#info' + tabIndex).addClass('on').show();
		};
		tabMove(1); // 초기 로딩 시 1번 탭(볼거리) 활성화
	});
</script>
</head>

<body>
	<div class="preview-mode-bar">현재 화면은 [미리보기] 모드입니다. 데이터는 저장되지 않은
		상태입니다.</div>

	<main class="inner"
		style="margin-top: 50px; padding-bottom: 10px !important">
		<div class="cont" id="cont" style="width: 100%; float: none;">
			<h3 class="pageTitleH3">휴게소 상세</h3>
			<div class="hr">&nbsp;</div>
			<h3 class="subTitleH3"><%=rdDTO.getName()%>
				전경
			</h3>
			<p>
				<img class="img100" src="../../resource/images/<%=rdDTO.getImg()%>">
			</p>
			<h3 class="subTitleH3">정보</h3>
			<ul class="comfortable">
				<li class="comfor1">
					<p class="tit">위치</p>
					<div class="con">
						<ul>
							<li>대지위치
								<p><%=rdDTO.getAddress()%></p>
							</li>
						</ul>
					</div>
				</li>
				<li class="comfor2">
					<p class="tit">연락처</p>
					<div class="con">
						<ul>
							<li>휴게소
								<p>
									<span class="ff_NB">TEL </span><%=rdDTO.getRestareaTel()%></p>
							</li>
							<li>주유소
								<p>
									<span class="ff_NB">TEL </span><%=rdDTO.getGasstationTel()%></p>
							</li>
						</ul>
					</div>
				</li>
				<li class="comfor3">
					<p class="tit">주요시설</p>
					<div class="con">
						<ul>
							<li>주차장규모
								<p><%=rdDTO.getScale()%></p>
							</li>
						</ul>
					</div>
				</li>
			</ul>

			<div class="tblTy01 mgt40">
				<h3 class="subTitleH3">휴게소 특징</h3>
				<table>
					<colgroup>
						<col style="width: 25%" span="4" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">고속도로 노선</th>
							<th scope="col">대표 음식</th>
							<th scope="col">등록 예정일</th>
							<th scope="col">상태</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><%=rdDTO.getLine()%></td>
							<td><%=rdDTO.getFood()%></td>
							<td>미정</td>
							<td>미리보기</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="mgt40">
				<h3 class="subTitleH3">위치 안내</h3>
				<div
					style="position: relative; width: 100%; height: 400px; border: 2px solid #ddd; border-radius: 8px; overflow: hidden;">
					<iframe
						src="https://map.kakao.com/link/map/<%=rdDTO.getName()%>,<%=rdDTO.getLatitude()%>,<%=rdDTO.getLongitude()%>"
						width="100%" height="400" style="border: 0;" allowfullscreen>
					</iframe>
				</div>
			</div>

			<div class="tour_wrap mgt40">
				<h3 class="tit1" style="display: inline-block;">
					<a class="active" id="tabMove1" href="javascript:tabMove(1);">볼거리</a>
				</h3>
				<h3 class="tit2" style="display: inline-block;">
					<a id="tabMove2" href="javascript:tabMove(2);">먹거리</a>
				</h3>
				<h3 class="tit3" style="display: inline-block;">
					<a id="tabMove3" href="javascript:tabMove(3);">편의시설</a>
				</h3>
			</div>
			<%
			List<ExtraFacilitiesDTO> fac1List = new ArrayList<>();
			List<ExtraFacilitiesDTO> fac2List = new ArrayList<>();
			List<ExtraFacilitiesDTO> fac3List = new ArrayList<>();

			for (ExtraFacilitiesDTO efDTO : efDTOList) {
				if ("1".equals(efDTO.getFacilityCode())) {
					fac1List.add(efDTO);
				} // end if

				if ("2".equals(efDTO.getFacilityCode())) {
					fac2List.add(efDTO);
				} // end if

				if ("3".equals(efDTO.getFacilityCode())) {
					fac3List.add(efDTO);
				} // end if
			} // end for
			%>
			<div class="tour_list on" id="info1">
				<h4 class="tit_02">볼거리</h4>
				<ul>
					<%
					for (ExtraFacilitiesDTO fac1DTO : fac1List) {
					%>
					<li>
						<p class="img">
							<img src="../../resource/images/<%=fac1DTO.getImg()%>"
								class="img100" alt="<%=fac1DTO.getName()%>" />
						</p>
						<dl>
							<dt><%=fac1DTO.getName()%></dt>
							<dd><%=fac1DTO.getPhrase()%></dd>
						</dl>
					</li>
					<%
					}
					%>
				</ul>
			</div>
			<div class="tour_list" id="info2">
				<h4 class="tit_02">먹거리</h4>
				<ul>
					<%
					for (ExtraFacilitiesDTO fac2DTO : fac2List) {
					%>
					<li>
						<p class="img">
							<img src="../../resource/images/<%=fac2DTO.getImg()%>"
								class="img100" alt="<%=fac2DTO.getName()%>" />
						</p>
						<dl>
							<dt><%=fac2DTO.getName()%></dt>
							<dd><%=fac2DTO.getPhrase()%></dd>
						</dl>
					</li>
					<%
					}
					%>
				</ul>
			</div>
			<div class="tour_list" id="info3">
				<h4 class="tit_02">편의시설</h4>
				<ul>
					<%
					for (ExtraFacilitiesDTO fac3DTO : fac3List) {
					%>
					<li>
						<p class="img">
							<img src="../../resource/images/<%=fac3DTO.getImg()%>"
								class="img100" alt="<%=fac3DTO.getName()%>" />
						</p>
						<dl>
							<dt><%=fac3DTO.getName()%></dt>
							<dd><%=fac3DTO.getPhrase()%></dd>
						</dl>
					</li>
					<%
					}
					%>
				</ul>
			</div>
			<div class="close-btn-wrap">
				<button type="button" class="close-btn" onclick="window.close();">미리보기
					닫기</button>
			</div>
	</main>
</body>
</html>