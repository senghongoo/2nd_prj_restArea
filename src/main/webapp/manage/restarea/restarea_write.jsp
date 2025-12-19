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

<title>휴게소 관리 - 휴게소 추가</title>

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
table tr {
	border-left: 1px solid rgb(222, 226, 230);
	border-right: 1px solid rgb(222, 226, 230);
	height: 60px;
}

table tr td:nth-of-type(1) {
	width: 200px;
}

table label {
	color: #171A1F;
	padding-top: 9px;
}

table button {
	margin-bottom: 3px;
}

input:not(span>input) {
	border: 1px solid rgb(222, 226, 230);
	border-radius: 5px;
	height: 38px;
	margin-top: 2px;
}

#table1 {
	border-top: 1px solid rgb(222, 226, 230);
}

.frm2 td:nth-of-type(2) input {
	width: 100%;
}

.form-select {
	margin-top: 2px;
}

.pic>* {
	margin-right: 20px;
}

.pic input {
	width: 571px !important;
	margin-right: 5px;
}

#flag span {
	margin: 0 30px;
}

#flag label {
	margin-right: 10px
}

.extra {
	margin-top: 100px;
}

.extra>div {
	display: flex;
	justify-content: space-between;
	border: 1px solid rgb(222, 226, 230);
	background-color: #f3f4f6;
	height: 60px;
	padding: 10px 8px;
}

.extra>div label {
	padding-top: 7px;
}

.extra>div button {
	border: 1px solid rgb(222, 226, 230);
}

.extra>table tr:nth-of-type(1) td:nth-of-type(3) {
	width: 145px;
	height: 180px;
	border-left: 1px solid rgb(222, 226, 230);
	text-align: center;
	vertical-align: middle;
}

.extra>table tr:nth-of-type(1) td:nth-of-type(3) input {
	width: 30px;
	height: 30px;
}

.frm1 input, .frm1 select {
	width: 80%;
}
</style>

<script type="text/javascript">
	$(function() {
		function applyStyles() {
			$(".frm2 td:nth-of-type(2)").attr("colspan", 3);
			$(".pic > button, #btns > button").addClass("btn btn-primary");
			$(".extra > div button").addClass("btn btn-light");
			$("table").addClass("table");
			$("table").attr("style", "margin-bottom: 0px !important;");
		}// applyStyles

		applyStyles();

		$(document).on("click", ".btnUpload", function() {
			$(this).siblings(".upfile").click();
		});// click

		$(document).on("change", ".upfile", function(evt) {
			var file = evt.target.files[0];

			if (!file) {
				return;
			}// end if

			var reader = new FileReader();
			var inputText = $(this).siblings("input[type='text']");

			reader.onload = function(evt) {
				inputText.val(file.name);
			};

			reader.readAsDataURL(file);
		});// change

		var fac1Index = 1;
		var fac2Index = 1;
		var fac3Index = 1;

		$(document)
				.on(
						"click",
						"#addFac1",
						function() {
							var newTable = '<table>'
									+ '  <tr class="frm2">'
									+ '    <td><label>볼거리명</label></td>'
									+ '    <td><input type="text" name="fac1Name_' + fac1Index + '"></td>'
									+ '    <td rowspan="3"><input type="checkbox" class="removeFlag"></td>'
									+ '  </tr>'
									+

									'  <tr>'
									+ '    <td><label>볼거리 사진</label></td>'
									+ '    <td class="pic">'
									+ '      <label>800x500 / png, jpg 가능</label>'
									+ '      <input type="text" placeholder="첨부 파일" disabled="disabled">'
									+ '      <input type="file" accept="image/*" name="fac1Img_' + fac1Index + '" class="upfile" style="display:none;">'
									+ '      <button type="button" class="btnUpload">파일 첨부</button>'
									+ '    </td>'
									+ '  </tr>'
									+

									'  <tr class="frm2">'
									+ '    <td><label>볼거리 문구</label></td>'
									+ '    <td><input type="text" name="fac1Phrase_' + fac1Index + '"></td>'
									+ '  </tr>' + '</table>';

							$("#fac1").append(newTable);
							applyStyles();
							fac1Index++;
						});// click

		$(document)
				.on(
						"click",
						"#addFac2",
						function() {
							var newTable = '<table>'
									+ '  <tr class="frm2">'
									+ '    <td><label>먹거리명</label></td>'
									+ '    <td><input type="text" name="fac2Name_' + fac2Index + '"></td>'
									+ '    <td rowspan="3"><input type="checkbox" class="removeFlag"></td>'
									+ '  </tr>'
									+

									'  <tr>'
									+ '    <td><label>먹거리 사진</label></td>'
									+ '    <td class="pic">'
									+ '      <label>800x500 / png, jpg 가능</label>'
									+ '      <input type="text" placeholder="첨부 파일" disabled="disabled">'
									+ '      <input type="file" accept="image/*" name="fac2Img_' + fac2Index + '" class="upfile" style="display:none;">'
									+ '      <button type="button" class="btnUpload">파일 첨부</button>'
									+ '    </td>'
									+ '  </tr>'
									+

									'  <tr class="frm2">'
									+ '    <td><label>먹거리 문구</label></td>'
									+ '    <td><input type="text" name="fac2Phrase_' + fac2Index + '"></td>'
									+ '  </tr>' + '</table>';

							$("#fac2").append(newTable);
							applyStyles();
							fac2Index++;
						});// click

		$(document)
				.on(
						"click",
						"#addFac3",
						function() {
							var newTable = '<table>'
									+ '  <tr class="frm2">'
									+ '    <td><label>편의시설명</label></td>'
									+ '    <td><input type="text" name="fac3Name_' + fac3Index + '"></td>'
									+ '    <td rowspan="3"><input type="checkbox" class="removeFlag"></td>'
									+ '  </tr>'
									+

									'  <tr>'
									+ '    <td><label>편의시설 사진</label></td>'
									+ '    <td class="pic">'
									+ '      <label>800x500 / png, jpg 가능</label>'
									+ '      <input type="text" placeholder="첨부 파일" disabled="disabled">'
									+ '      <input type="file" accept="image/*" name="fac3Img_' + fac3Index + '" class="upfile" style="display:none;">'
									+ '      <button type="button" class="btnUpload">파일 첨부</button>'
									+ '    </td>'
									+ '  </tr>'
									+

									'  <tr class="frm2">'
									+ '    <td><label>편의시설 문구</label></td>'
									+ '    <td><input type="text" name="fac3Phrase_' + fac3Index + '"></td>'
									+ '  </tr>' + '</table>';

							$("#fac3").append(newTable);
							applyStyles();
							fac3Index++;
						});// click

		$(document).on("click", ".removeItem", function() {
			var closestDiv = $(this).closest("div");
			var siblingTables = closestDiv.siblings("table");

			if (confirm("선택 항목을 삭제하시겠습니까?")) {
				var checkedCnt = siblingTables.filter(function() {
					return $(this).find(".removeFlag").is(":checked");
				}).length;

				if (checkedCnt >= siblingTables.length) {
					alert("최소 1개의 항목은 필수 입력입니다.");
					siblingTables.find(".removeFlag").prop("checked", false);
					return;
				}// end if

				siblingTables.each(function() {
					var $table = $(this);
					var $checkbox = $table.find(".removeFlag");

					if ($checkbox.is(":checked")) {
						$table.remove();
					}// end if
				});
			}// end if
		});// click
	});// ready

	function previewListRestarea() {
		var isValid = true;

		// 1. text input 유효성 검증
		$("input[type='text']").not(":disabled").each(function() {
			if ($(this).val().trim() === "") {
				alert("모든 항목을 입력해주세요.");
				$(this).focus();
				isValid = false;
				return false;
			}// end if
		});

		if (!isValid) {
			return;
		}// end if

		// 2. 위도, 경도 유효성 검증
		var latLonReg = /^-?(\d{1,3})(\.\d+)?$/;

		var lat = $("input[name='latitude']").val().trim();
		var lon = $("input[name='longitude']").val().trim();

		if (!latLonReg.test(lat)) {
			alert("위도는 숫자 형식으로 입력해주세요. (예: 37.1234)");
			$("input[name='latitude']").focus();
			return;
		}// end if

		if (!latLonReg.test(lon)) {
			alert("경도는 숫자 형식으로 입력해주세요. (예: 127.1234)");
			$("input[name='longitude']").focus();
			return;
		}// end if

		// 3. select 유효성 검증
		if ($("select").val() === "") {
			alert("노선을 선택해주세요.");
			$("select").focus();
			return;
		}// end if

		// 4. 파일 첨부 유효성 검증
		$(".upfile").each(function() {
			if (this.files.length === 0) {
				alert("이미지 파일을 첨부해주세요.");
				$(this).siblings("button").focus();
				isValid = false;
				return false;
			}// end if
		});

		if (!isValid) {
			return;
		}// end if

		$("#amenities input[type='checkbox']:checked").val("Y");

		$("#frm").prop("target", "_blank");
		$("#frm").prop("action", "restarea_list_preview.jsp");
		$("#frm").submit();
	}// previewListRestarea
	
	function previewDetailRestarea() {
		var isValid = true;

		// 1. text input 유효성 검증
		$("input[type='text']").not(":disabled").each(function() {
			if ($(this).val().trim() === "") {
				alert("모든 항목을 입력해주세요.");
				$(this).focus();
				isValid = false;
				return false;
			}// end if
		});

		if (!isValid) {
			return;
		}// end if

		// 2. 위도, 경도 유효성 검증
		var latLonReg = /^-?(\d{1,3})(\.\d+)?$/;

		var lat = $("input[name='latitude']").val().trim();
		var lon = $("input[name='longitude']").val().trim();

		if (!latLonReg.test(lat)) {
			alert("위도는 숫자 형식으로 입력해주세요. (예: 37.1234)");
			$("input[name='latitude']").focus();
			return;
		}// end if

		if (!latLonReg.test(lon)) {
			alert("경도는 숫자 형식으로 입력해주세요. (예: 127.1234)");
			$("input[name='longitude']").focus();
			return;
		}// end if

		// 3. select 유효성 검증
		if ($("select").val() === "") {
			alert("노선을 선택해주세요.");
			$("select").focus();
			return;
		}// end if

		// 4. 파일 첨부 유효성 검증
		$(".upfile").each(function() {
			if (this.files.length === 0) {
				alert("이미지 파일을 첨부해주세요.");
				$(this).siblings("button").focus();
				isValid = false;
				return false;
			}// end if
		});

		if (!isValid) {
			return;
		}// end if

		$("#amenities input[type='checkbox']:checked").val("Y");

		$("#frm").prop("target", "_blank");
		$("#frm").prop("action", "restarea_detail_preview.jsp");
		$("#frm").submit();
	}// previewDetailRestarea

	function addRestarea() {
		if (confirm("휴게소를 추가하시겠습니까?")) {
			var isValid = true;

			// 1. text input 유효성 검증
			$("input[type='text']").not(":disabled").each(function() {
				if ($(this).val().trim() === "") {
					alert("모든 항목을 입력해주세요.");
					$(this).focus();
					isValid = false;
					return false;
				}// end if
			});

			if (!isValid) {
				return;
			}// end if

			// 2. 위도, 경도 유효성 검증
			var latLonReg = /^-?(\d{1,3})(\.\d+)?$/;

			var lat = $("input[name='latitude']").val().trim();
			var lon = $("input[name='longitude']").val().trim();

			if (!latLonReg.test(lat)) {
				alert("위도는 숫자 형식으로 입력해주세요. (예: 37.1234)");
				$("input[name='latitude']").focus();
				return;
			}// end if

			if (!latLonReg.test(lon)) {
				alert("경도는 숫자 형식으로 입력해주세요. (예: 127.1234)");
				$("input[name='longitude']").focus();
				return;
			}// end if

			// 3. select 유효성 검증
			if ($("select").val() === "") {
				alert("노선을 선택해주세요.");
				$("select").focus();
				return;
			}// end if

			// 4. 파일 첨부 유효성 검증
			$(".upfile").each(function() {
				if (this.files.length === 0) {
					alert("이미지 파일을 첨부해주세요.");
					$(this).siblings("button").focus();
					isValid = false;
					return false;
				}// end if
			});

			if (!isValid) {
				return;
			}// end if

			$("#amenities input[type='checkbox']:checked").val("Y");

			$("#frm").prop("target", "_self");
			$("#frm").prop("action", "addRestareaProcess.jsp");
			$("#frm").submit();
		}// end if
	}// addRestarea
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
					class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2">
				</div>
				<div id="wrap">
					<div id="top"></div>
					<form method="post" enctype="multipart/form-data" id="frm">
						<div id="middle">
							<div>
								<div id="table1">
									<table>
										<tr class="frm1">
											<td style="width: 200px;"><label>휴게소명</label></td>
											<td style="width: 300px;"><input type="text"
												name="titleName"></td>
											<td style="width: 200px;"><label>노선</label></td>
											<td style="width: 300px;"><select class="form-select"
												name="line">
													<option value="">노선을 선택해주세요.</option>
													<option value="경부고속도로">경부고속도로</option>
													<option value="서해안고속도로">서해안고속도로</option>
													<option value="영동고속도로">영동고속도로</option>
													<option value="중부고속도로">중부고속도로</option>
													<option value="서울양양고속도로">서울양양고속도로</option>
											</select></td>
										</tr>
										<tr class="frm2">
											<td><label>타이틀 사진</label></td>
											<td class="pic"><label>1440x500 / png, jpg 가능</label> <input
												type="text" placeholder="첨부 파일" disabled="disabled">
												<input type="file" accept="image/*" name="titleImg"
												class="upfile" style="display: none" />
												<button type="button" class="btnUpload">파일 첨부</button></td>
										</tr>
										<tr class="frm2">
											<td><label>타이틀 문구</label></td>
											<td><input type="text" name="titlePhrase"></td>
										</tr>
										<tr class="frm2">
											<td><label>주소</label></td>
											<td><input type="text" name="address"></td>
										</tr>
										<tr class="frm1">
											<td><label>위도</label></td>
											<td><input type="text" name="latitude"></td>
											<td><label>경도</label></td>
											<td><input type="text" name="longitude"></td>
										</tr>
										<tr class="frm1">
											<td><label>휴게소 연락처</label></td>
											<td><input type="text" name="restareaTel"></td>
											<td><label>주유소 연락처</label></td>
											<td><input type="text" name="gasstationTel"></td>
										</tr>
										<tr class="frm1">
											<td><label>대표 음식</label></td>
											<td><input type="text" name="famousFood"></td>
											<td><label>주차장 규모</label></td>
											<td><input type="text" name="parkingScale"></td>
										</tr>
										<tr id="amenities">
											<td><label>부가시설</label></td>
											<td colspan="3" id="flag"><span style="margin-left: 0"><label>수면실</label><input
													type="checkbox" name="sleepingRoom"></span> <span><label>샤워실</label><input
													type="checkbox" name="showerRoom"></span> <span><label>쉼터</label><input
													type="checkbox" name="restHub"></span> <span><label>수유실</label><input
													type="checkbox" name="nursingRoom"></span> <span><label>약국</label><input
													type="checkbox" name="pharmacy"></span> <span><label>농산물판매장</label><input
													type="checkbox" name="agricultureMarket"></span> <span><label>세차장</label><input
													type="checkbox" name="carWash"></span> <span><label>경정비소</label><input
													type="checkbox" name="carRepair"></span></td>
										</tr>
									</table>
								</div>
								<div class="extra" id="fac1">
									<div>
										<label>볼거리 리스트</label> <span>
											<button type="button" class="addItem" id="addFac1">항목
												추가</button>
											<button type="button" class="removeItem">선택 항목 삭제</button>
										</span>
									</div>
									<table>
										<tr class="frm2">
											<td><label>볼거리명</label></td>
											<td><input type="text" name="fac1Name_0"></td>
											<td rowspan="3"><input type="checkbox"
												class="removeFlag"></td>
										</tr>
										<tr>
											<td><label>볼거리 사진</label></td>
											<td class="pic"><label>800x500 / png, jpg 가능</label> <input
												type="text" placeholder="첨부 파일" disabled="disabled">
												<input type="file" accept="image/*" name="fac1Img_0"
												class="upfile" style="display: none" />
												<button type="button" class="btnUpload">파일 첨부</button></td>
										</tr>
										<tr class="frm2">
											<td><label>볼거리 문구</label></td>
											<td><input type="text" name="fac1Phrase_0"></td>
										</tr>
									</table>
								</div>
								<div class="extra" id="fac2">
									<div>
										<label>먹거리 리스트</label> <span>
											<button type="button" class="addItem" id="addFac2">항목
												추가</button>
											<button type="button" class="removeItem">선택 항목 삭제</button>
										</span>
									</div>
									<table>
										<tr class="frm2">
											<td><label>먹거리명</label></td>
											<td><input type="text" name="fac2Name_0"></td>
											<td rowspan="3"><input type="checkbox"
												class="removeFlag"></td>
										</tr>
										<tr>
											<td><label>먹거리 사진</label></td>
											<td class="pic"><label>800x500 / png, jpg 가능</label> <input
												type="text" placeholder="첨부 파일" disabled="disabled">
												<input type="file" accept="image/*" name="fac2Img_0"
												class="upfile" style="display: none" />
												<button type="button" class="btnUpload">파일 첨부</button></td>
										</tr>
										<tr class="frm2">
											<td><label>먹거리 문구</label></td>
											<td><input type="text" name="fac2Phrase_0"></td>
										</tr>
									</table>
								</div>
								<div class="extra" id="fac3">
									<div>
										<label>편의시설 리스트</label> <span>
											<button type="button" class="addItem" id="addFac3">항목
												추가</button>
											<button type="button" class="removeItem">선택 항목 삭제</button>
										</span>
									</div>
									<table>
										<tr class="frm2">
											<td><label>편의시설명</label></td>
											<td><input type="text" name="fac3Name_0"></td>
											<td rowspan="3"><input type="checkbox"
												class="removeFlag"></td>
										</tr>
										<tr>
											<td><label>편의시설 사진</label></td>
											<td class="pic"><label>800x500 / png, jpg 가능</label> <input
												type="text" placeholder="첨부 파일" disabled="disabled">
												<input type="file" accept="image/*" name="fac3Img_0"
												class="upfile" style="display: none" />
												<button type="button" class="btnUpload">파일 첨부</button></td>
										</tr>
										<tr class="frm2">
											<td><label>편의시설 문구</label></td>
											<td><input type="text" name="fac3Phrase_0"></td>
										</tr>
									</table>
								</div>
							</div>
							<div id="bottom">
								<div style="float: right; margin-bottom: 20px; margin-top: 16px"
									id="btns">
									<button type="button"
										onclick="location.href='restarea_list.jsp?currentPage=${ param.currentPage }&keyword=${ param.keyword }'">취소</button>
									<button type="button"
										onclick="event.stopPropagation(); previewListRestarea()">목록 미리보기</button>
									<button type="button"
										onclick="event.stopPropagation(); previewDetailRestarea()">상세 미리보기</button>
									<input type="button" value="추가" id="btnCreate"
										class="btn btn-primary"
										onclick="event.stopPropagation(); addRestarea()" />
								</div>
							</div>
						</div>
						<input type="hidden" name="currentPage" id="currentPage" value="${param.currentPage}" />
						<input type="hidden" name="keyword" id="keyword" value="${param.keyword}" />
					</form>
				</div>
			</main>
		</div>
	</div>
</body>
</html>