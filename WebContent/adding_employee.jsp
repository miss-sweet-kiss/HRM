<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<%@page
	import="java.util.*,dbc.Employee_DAO,dbc.Employee_Post_DAO,dbc.Role_DAO,dbc.GroupFR_DAO,dbc.Department_DAO,dbc.Post_DAO,logic.Employee,logic.EmployeePost,logic.Role,logic.GroupFR,logic.Department,logic.Post"%>

</head>
<body>
<%
	Employee_DAO e_dao = (Employee_DAO)request.getSession().getAttribute("Employee_DAO");
	Employee_Post_DAO ep_dao = (Employee_Post_DAO)request.getSession().getAttribute("Employee_Post_DAO");
	Role_DAO r_dao = (Role_DAO)request.getSession().getAttribute("Role_DAO");
	Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");

	if(e_dao != null && ep_dao != null && r_dao != null && p_dao != null){
 	String empName = new String(request.getParameter("empName").getBytes("ISO-8859-1"),"utf-8");
 	String empSurn = new String(request.getParameter("empSurn").getBytes("ISO-8859-1"),"utf-8");
	String login = new String(request.getParameter("login").getBytes("ISO-8859-1"),"utf-8");
	String pass = new String(request.getParameter("pass").getBytes("ISO-8859-1"),"utf-8");
	Integer post = Integer.parseInt(request.getParameter("post"));
	String rate = new String(request.getParameter("rate").getBytes("ISO-8859-1"),"utf-8");

	//Добавление Сотрудника
	Employee emp = new Employee();
	emp.setName(empName);
	emp.setSurname(empSurn);
	
	Integer n = e_dao.addEmployee(emp);
	
	Integer idEmp = e_dao.getIdEmployee(emp);
	
	EmployeePost ep = new EmployeePost();
	ep.setIdEmp(idEmp);
	ep.setIdPost(post);
	ep.setRate(rate);
	
	Integer k = ep_dao.addRate(ep);
	
	Post postN = new Post();
	postN = p_dao.getPostById(post);
	Role role = new Role();
	if(postN.getName().equals("директор по персоналу")) {
		role.setName("директор по персоналу");
	} else if(postN.getName().equals("сотрудник ОК")) {
		role.setName("сотрудник ОК");
	} else if(postN.getName().equals("генеральный директор")) {
		role.setName("генеральный директор");
	} else {
		role.setName("сотрудник");
	}
	role.setLogin(login);
	role.setPassword(pass);
	role.setPD(0);
	role.setEmployee(idEmp);
	
	Integer m = r_dao.addRole(role);
	
	if(n == 1 && k == 1 && m == 1)
		out.println("<center><p style='color:Red'><b>Информация о сотруднике добавлена</b></p></center>");
	
	else if(n == 1 && k == 3 && m == 1) {
		out.println("<center><p style='color:Red'><b>Сотрудник уже состоит на данной должности</b></p></center>");
		e_dao.deleteEmployee(idEmp);
		r_dao.deleteRole(role);
	}
	
	else if(n == 1 && k == 1 && m == 3) {
		out.println("<center><p style='color:Red'><b>Такой логин уже существует</b></p></center>");
		e_dao.deleteEmployee(idEmp);
		ep_dao.deleteRate(ep);
	}
	
	else if(n == 1 && k == 3 && m == 3) {
		out.println("<center><p style='color:Red'><b>Такой логин уже существует</b></p></center>");
		e_dao.deleteEmployee(idEmp);
	}
	
	else if(n == 3 && k == 1) {
		out.println("<center><p style='color:Red'><b>Информация о сотруднике уже существует</b></p></center>");
		ep_dao.deleteRate(ep);
	}
	
	else if(n == 3 && k == 3 && m == 3)
		out.println("<center><p style='color:Red'><b>Информация о сотруднике уже существует</b></p></center>");
	
	
	else if(n == 3)
		out.println("<center><p style='color:Red'><b>Информация о сотруднике уже существует</b></p></center>");
	
	
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
%>
</body>
</html>