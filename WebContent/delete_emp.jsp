<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>HRM</title>
<%@page
	import="java.util.*,dbc.Employee_DAO,dbc.Employee_Post_DAO,dbc.Role_DAO,logic.PostFR,logic.FR,logic.GroupFR,logic.Department,logic.Post"%>
</head>
<body><%
	Integer id = Integer.parseInt(request.getParameter("emp"));

	Employee_DAO e_dao = (Employee_DAO)request.getSession().getAttribute("Employee_DAO");
	Employee_Post_DAO ep_dao = (Employee_Post_DAO)request.getSession().getAttribute("Employee_Post_DAO");
	Role_DAO r_dao = (Role_DAO)request.getSession().getAttribute("Role_DAO");
	
	if(e_dao != null && ep_dao != null && r_dao != null){
	
	e_dao.deleteEmployee(id);
	ep_dao.deleteEmployeeRate(id);
	r_dao.deleteEmployeeRole(id);
	
	out.println("<p style='color:Red'><b>Информация о сотруднике удалена</b></p>");
	
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
%>

</body>
</html>