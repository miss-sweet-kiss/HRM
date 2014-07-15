<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<%@page import="java.util.*,dbc.GroupFR_DAO,dbc.Department_DAO,logic.GroupFR,logic.Department"%>

</head>
<body>
<%
	GroupFR_DAO gr_dao = (GroupFR_DAO)request.getSession().getAttribute("GroupFR_DAO");
	Department_DAO d_dao = (Department_DAO)request.getSession().getAttribute("Department_DAO");
	
	if(gr_dao != null && d_dao != null){
	//флаг определяет добавляем подразделение или группу ФО
 	String flag = new String(request.getParameter("flag").getBytes("ISO-8859-1"),"utf-8");
	//название группы/подразделения
	String name = new String(request.getParameter("name").getBytes("ISO-8859-1"),"utf-8");

	//если флаг = группа
	if(flag.equals("group")) {
		GroupFR group = new GroupFR();
		group.setName(name);
		int n = gr_dao.addGroupFR(group);
		if(n ==1)
			out.println("<center><p style='color:Red'><b>Группа добавлена</b></p></center>");
		if(n == 2)
			out.println("<center><p style='color:Red'><b>Группа не может быть добавлена</b></p></center>");
		if(n == 3)
			out.println("<center><p style='color:Red'><b>Такая группа уже существует</b></p></center>");
	}
	//если флаг = подразделение
	else if(flag.equals("dep")) {
		Department dep = new Department();
		dep.setName(name);
		int n = d_dao.addDepartment(dep);
		if(n == 1)
			out.println("<center><p style='color:Red'><b>Подразделение добавлено</b></p></center>");
		else if(n == 2)
			out.println("<center><p style='color:Red'><b>Подразделение не может быть добавлено</b></p></center>");
		else if(n == 3)
			out.println("<center><p style='color:Red'><b>Такое подразделение уже существует</b></p></center>");
	}
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}

%>
</body>
</html>