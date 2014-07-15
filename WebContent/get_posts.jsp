<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<%@page
	import="java.util.*,dbc.Employee_Post_DAO,dbc.Employee_DAO,dbc.GroupFR_DAO,dbc.Department_DAO,dbc.Post_DAO,logic.EmployeePost,logic.Employee,logic.GroupFR,logic.Department,logic.Post"%>

</head>
<body>
<%
	Employee_Post_DAO ep_dao = (Employee_Post_DAO)request.getSession().getAttribute("Employee_Post_DAO");
	Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");
	Employee_DAO e_dao = (Employee_DAO)request.getSession().getAttribute("Employee_DAO");
	
	if(ep_dao != null && e_dao != null && p_dao != null){

 		Integer idEmp = Integer.parseInt(request.getParameter("emp"));
		
		Post post;
		Vector<Post> vPost = new Vector<Post>();
		
		Vector<Vector<Object>> data = new Vector<Vector<Object>>();
		
		data = ep_dao.getPostsByEmp(idEmp);
		
		Employee emp = e_dao.getEmployeeById(idEmp);

		out.println("<table border=1 cellspacing=0>	<CAPTION ALIGN=top>Список должностей: "+emp+"</CAPTION> ");
		out.println("<tr><th>Должность</th><th>Ставка</th></tr>");
		for(int i = 0;i < data.size();i++){
			post = (Post)data.get(i).get(0);
   			out.println("<tr><td width=200>" + post.getName() + "</td><td>" + data.get(i).get(1) +"</td></tr>");
   		} 
		out.println("</table>");
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
%>	
</body>
</html>