<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<%@page import="java.util.*,dbc.Role_DAO,dbc.Employee_DAO,logic.PersonnelDepartment,logic.Employee,logic.GroupFR,logic.Department,logic.Post"%>

</head>
<body>
<%
	Role_DAO r_dao = (Role_DAO)request.getSession().getAttribute("Role_DAO");
	Employee_DAO e_dao = (Employee_DAO)request.getSession().getAttribute("Employee_DAO");
	
	if(r_dao != null){
	Integer count = Integer.parseInt(request.getParameter("count"));
	
	Vector<Employee> vEmp = new Vector<Employee>();

	vEmp = e_dao.getEmployeeOK();
		
	//Добавление отношений между ФО и должностями
	
	for(int i = 0;i < count;i++){
		Integer u = Integer.parseInt(request.getParameter("U"+vEmp.get(i).getIdEmployee()));
		Integer r = Integer.parseInt(request.getParameter("R"+vEmp.get(i).getIdEmployee()));
		
		PersonnelDepartment pd = new PersonnelDepartment();
		pd.setEmployee(vEmp.get(i).getIdEmployee());
		pd.setEditing(u);
		pd.setReading(r);
		r_dao.setRights(pd);
					
	}
	out.println("<center><p style='color:Red'><b>Права перераспределены</b></p></center>");
	
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
%>
</body>
</html>