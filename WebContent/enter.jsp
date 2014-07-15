<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>HRM</title>
<%@page
	import="java.util.*,dbc.Employee_DAO,dbc.Employee_Post_DAO,dbc.Role_DAO,logic.EmployeePost,logic.FR,logic.GroupFR,logic.Department,logic.Post"%>
</head>
<body><%
	String login = new String(request.getParameter("login").getBytes("ISO-8859-1"),"utf-8");
	String pass = new String(request.getParameter("pass").getBytes("ISO-8859-1"),"utf-8");
	Role_DAO r_dao = (Role_DAO)request.getSession().getAttribute("Role_DAO");
	
	if(r_dao != null){
	Integer n = r_dao.isEmployee(login, pass);
	
	String roleName = new String();
	Integer idEmp;
	if(n == 3)
		out.println("<center><p style='color:Red'><b>Логин введен неверно</b></p></center>");
	else if(n == 2)
		out.println("<center><p style='color:Red'><b>Пароль введен неверно</b></p></center>");
	else if(n == 1) {
		roleName = r_dao.getRoleName(login, pass);
		idEmp = r_dao.getEmployee(login, pass);
		request.getSession().setAttribute("roleName",roleName);
		request.getSession().setAttribute("idEmp",idEmp);
		out.println("<center><p style='color:Red'><b>Добро пожаловать!</b></p></center>");
	}
} else {
  	request.getRequestDispatcher("/login.jsp").forward(request,response);
}
%>

</body>
</html>