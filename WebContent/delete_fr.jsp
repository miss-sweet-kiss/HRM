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
<body><%
	Integer id = Integer.parseInt(request.getParameter("id"));

	FR_DAO fr_dao = (FR_DAO)request.getSession().getAttribute("FR_DAO");
	
	if(fr_dao != null){
	
		fr_dao.deleteFR(id);
		out.println("<p style='color:Red'><b>Функциональная обязанность удалена</b></p>");
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
	
%>


</body>
</html>