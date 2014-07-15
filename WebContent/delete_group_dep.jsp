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
	String flag = new String(request.getParameter("flag"));

	GroupFR_DAO gr_dao = (GroupFR_DAO)request.getSession().getAttribute("GroupFR_DAO");
	Department_DAO d_dao = (Department_DAO)request.getSession().getAttribute("Department_DAO");
	
	if(gr_dao != null && d_dao != null){
	if(flag.equals("group")){
		int n = gr_dao.deleteGroupFR(id);
		
		if(n == 1){
			out.println("<p style='color:Red'><b>Группа удалена</b></p>");
		} else if(n == 3){
			out.println("<p style='color:Red'><b>Группа не может быть удалена! Существуют ФО, которые к ней относятся</b></p>");
		} else {
			out.println("<p style='color:Red'><b>Группа не может быть удалена!</b></p>");
		}
	}
	if(flag.equals("dep")){
		int n = d_dao.deleteDepartment(id);
		
		if(n == 1){
			out.println("<p style='color:Red'><b>Подразделение удалено</b></p>");
		} else if(n == 3){
			out.println("<p style='color:Red'><b>Подразделение не может быть удалено! Существуют должности, которые к нему относятся</b></p>");
		} else {
			out.println("<p style='color:Red'><b>Подразделение не может быть удалено!</b></p>");
		}
	}
	} else {
  	request.getRequestDispatcher("/login.jsp").forward(request,response);
  	}
%>
</body>
</html>