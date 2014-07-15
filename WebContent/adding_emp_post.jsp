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
	Employee_Post_DAO ep_dao = (Employee_Post_DAO)request.getSession().getAttribute("Employee_Post_DAO");

	if(ep_dao != null){
	Integer id = Integer.parseInt(request.getParameter("emp"));
	Integer post = Integer.parseInt(request.getParameter("post"));
	String rate = new String(request.getParameter("rate").getBytes("ISO-8859-1"),"utf-8");
	
	EmployeePost ep = new EmployeePost();
	ep.setIdEmp(id);
	ep.setIdPost(post);
	ep.setRate(rate);
	
	Integer k = ep_dao.addRate(ep);
	
	if(k == 1)
		out.println("<center><p style='color:Red'><b>Должность добавлена</b></p></center>");
	else if(k == 2)
		out.println("<center><p style='color:Red'><b>Должность не может быть добавлена</b></p></center>");
	else if(k == 3)
		out.println("<center><p style='color:Red'><b>Сотрудник уже состоит на данной должности</b></p></center>");
	} else {
		  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
%>

</body>
</html>