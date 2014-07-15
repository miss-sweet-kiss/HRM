<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<%@page
	import="java.util.*,dbc.FR_DAO,dbc.Post_FR_DAO,dbc.GroupFR_DAO,dbc.Department_DAO,dbc.Post_DAO,logic.PostFR,logic.FR,logic.GroupFR,logic.Department,logic.Post"%>

</head>
<body>
<%
	Post_FR_DAO pf_dao = (Post_FR_DAO)request.getSession().getAttribute("Post_FR_DAO");

	if(pf_dao != null){
	
 	Integer idFR = Integer.parseInt(request.getParameter("idFR"));
 	Integer idP = Integer.parseInt(request.getParameter("idP"));
 	Integer val = Integer.parseInt(request.getParameter("val"));
 	String param = new String(request.getParameter("param"));
 	
 	PostFR pf = pf_dao.getRelationByPostFR(idP, idFR);
 	if(pf == null) {
 		pf = new PostFR();
 		pf.setFR(idFR);
 	 	pf.setPost(idP);
 	}
 	if(param.equals("X")){
 		pf.setX(val);
 	} else if(param.equals("O")) {
 		pf.setO(val);
 	} else if(param.equals("1")) {
 		pf.set1(val);
 	} else if(param.equals("Y")) {
 		pf.setY(val);
 	} else if(param.equals("K")) {
 		pf.setK(val);
 	}
 	
 	pf_dao.updateRelation(pf);
 	
 	out.println("<center><p style='color:Red'><b>Изменения сохранены</b></p></center>");
 	
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
	
%>

</body>
</html>