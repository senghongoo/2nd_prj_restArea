<%@page import="kr.co.sist.restarea.RestareaUpdateService"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.sist.restarea.ExtraFacilitiesDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.sist.restarea.RestareaDetailDTO"%>
<%@page import="kr.co.sist.restarea.AmenitiesDTO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="kr.co.sist.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
            if(srcFile.exists()) srcFile.delete();
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

String currentPage = mr.getParameter("currentPage");
String keyword = mr.getParameter("keyword");
int code = Integer.parseInt(mr.getParameter("code"));

RestareaUpdateService rus = RestareaUpdateService.getInstance();

String titleImgPath = moveFile(mr, "titleImg", baseDir, "title/");

if(titleImgPath == "") {
	titleImgPath = "title/" + mr.getParameter("titleImgTxt");
}// end if

// AmenitiesDTO 처리
String[] amenityNames = {"sleepingRoom", "showerRoom", "restHub", "nursingRoom", "pharmacy", "agricultureMarket", "carWash", "carRepair"};
Map<String, String> aMap = new HashMap<>();

for (String name : amenityNames) {
	aMap.put(name, (mr.getParameter(name) == null) ? "N" : "Y");
}// end for

AmenitiesDTO aDTO = new AmenitiesDTO(code, aMap.get("sleepingRoom"), aMap.get("showerRoom"),
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
}// end catch

RestareaDetailDTO rdDTO = new RestareaDetailDTO(code, mr.getParameter("titleName"), mr.getParameter("line"), titleImgPath,
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

		efDTOList.add(new ExtraFacilitiesDTO(code, facilityCode, nameValue, facilityImgPath, mr.getParameter(phraseParam)));
	}// end if
}// end while

boolean flag = false;

try {
    flag = rus.modifyRestarea(code, aDTO, rdDTO, efDTOList);
} catch (SQLException e) {
    e.printStackTrace();
}// end catch

if (!flag) {
    if (titleImgPath != null && !titleImgPath.isEmpty()) {
        File f = new File(baseDir + titleImgPath);
        if (f.exists()) {
        	f.delete();
        }// end if
    }// end if
    
    for (ExtraFacilitiesDTO ef : efDTOList) {
        if (ef.getImg() != null && !ef.getImg().isEmpty()) {
            File f = new File(baseDir + ef.getImg());
            if (f.exists()) {
            	f.delete();
            }// end if
        }// end if
    }// end for
}// end if

pageContext.setAttribute("currentPage", currentPage);
pageContext.setAttribute("keyword", keyword);
pageContext.setAttribute("code", code);
pageContext.setAttribute("flag", flag);
%>

<script type="text/javascript">
	<c:choose>
	<c:when test="${ flag }">
		alert("휴게소를 수정했습니다.");
		location.href = "restarea_list.jsp?currentPage=${ currentPage }&keyword=${ keyword }";
	</c:when>
	<c:otherwise>
		alert("휴게소 수정 중 문제가 발생했습니다.");
		location.href = "restarea_detail.jsp?currentPage=${ currentPage }&keyword=${ keyword }&code=${ code }";
	</c:otherwise>
	</c:choose>
</script>






