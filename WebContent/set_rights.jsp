<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<%@page
	import="java.util.*,dbc.Employee_DAO,dbc.Role_DAO,logic.Employee,logic.PersonnelDepartment"%>
<link rel="icon" type="image/png" href="img.png" />
<script type="text/javascript" src="jExpand.js"></script>  
<script src="jquery-1.7.1.min.js" type="text/javascript" ></script> 
<script src="jquery-1.3.1.min.js" type="text/javascript" ></script> 
<script>
function Add() {
	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');	
	
	cont.innerHTML = loading.innerHTML;
	
	var linkparam = "update_rights.jsp" + "?count="+document.getElementsByName("R").length;	
	
	for(var i = 0;i < document.getElementsByName("R").length;i++) {
		if (document.getElementsByName("R")[i].checked) {
			linkparam += "&R"+document.getElementsByName("R")[i].value+"=1";
		} else {
			linkparam += "&R"+document.getElementsByName("R")[i].value+"=0";
		}
		if (document.getElementsByName("U")[i].checked) {
			linkparam += "&U"+document.getElementsByName("U")[i].value+"=1";
		} else {
			linkparam += "&U"+document.getElementsByName("U")[i].value+"=0";
		}

	var http = createRequestObject();
	if (http) {
		http.open('get', linkparam, true);
		
		http.onreadystatechange = function f() {
			if (http.readyState == 4) {
				var ans = http.responseText;
				cont.innerHTML = http.responseText;
				if(ans.indexOf('Права перераспределены') + 1) {
					location.reload();
				} else {
					cont.innerHTML = http.responseText;
				}
			}
		}
		http.send(null);
	} else {
		document.location = "adding_fr.jsp";
	}
	}
	
}
function createRequestObject() {
	return new XMLHttpRequest();
}
</script>

</head>
<body>
<div id="wrap">
  <div id="masthead">
    <h1><img src="images/hrm.jpg"></h1>
    <div id="menucontainer">
      <div id="menunav">
        <ul>
          <li><a href="index.jsp"><span>Главная</span></a></li>
           <%String roleName = (String)request.getSession().getAttribute("roleName");
  			 Integer idEmp = (Integer)request.getSession().getAttribute("idEmp"); 
  			 
  			if(roleName.equals("директор по персоналу")) {
  				out.println("<li><a href='get_fr.jsp'><span>Классификатор функций</span></a></li>");
  				out.println("<li><a href='get_staffList.jsp'><span>Штатное расписание</span></a></li>");
  			} else {
  				out.println("<li><a href=#><span>Классификатор функций</span></a></li>");
  				out.println("<li><a href=#><span>Штатное расписание</span></a></li>");
  			}
  			%>
          <li><a href="#" class="current"><span>Корпоративные стандарты</span></a></li>
          <li><a href="login.jsp"><span>Выход</span></a></li>
        </ul>
      </div>
      <div id="menunav">
      	<ul><%
      		if(roleName.equals("сотрудник ОК")) {
      			out.println("<li><a href='get_employee.jsp'><span>Просмотр даннных сотрудника</span></a></li>");
      			out.println("<li><a href='add_employee.jsp'><span>Добавить сотрудника</span></a></li>");
      		} else {
      			out.println("<li><a href=#><span>Просмотр даннных сотрудника</span></a></li>");
      			out.println("<li><a href=#><span>Добавить сотрудника</span></a></li>");
      		}
      	%>
      		<li><a href="standart.jsp"><span>Должностная инструкция</span></a></li>
      		<li><a href="#" class="current"><span>Распределение прав доступа</span></a>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
  <%
  	Employee_DAO e_dao = (Employee_DAO)request.getSession().getAttribute("Employee_DAO");
  	Role_DAO r_dao = (Role_DAO)request.getSession().getAttribute("Role_DAO");
	if(e_dao != null && r_dao != null){
	Vector<Employee> vEmp = new Vector<Employee>();
	PersonnelDepartment pd = new PersonnelDepartment();

	vEmp = e_dao.getEmployeeOK();
	
	out.println("<p align = 'center' style = 'font-size:15px'>Распределение прав доступа</p>");
	out.println("<table border=1 cellspacing=0 align='center'>");
 	out.println("<tr><th>Сотрудники отдела кадров</th><th>Ч</th><th>Р</th></tr>");
 	for(int i = 0;i < vEmp.size();i++){
 		pd = r_dao.getRights(vEmp.get(i).getIdEmployee());
 		out.println("<tr><td width=250>" + vEmp.get(i).getName() + " " + vEmp.get(i).getSurname() +"</td>");
 		if(pd == null){
			out.println("<td><input type=checkbox name=R value=" + vEmp.get(i).getIdEmployee() + "></td>");
			out.println("<td><input type=checkbox name=U value=" + vEmp.get(i).getIdEmployee() + "></td>"); 
 		} else {
 			if(pd.getReading() == 1){
 				out.println("<td><input type=checkbox name=R checked value=" + vEmp.get(i).getIdEmployee() + "></td>");
 			} else {
 				out.println("<td><input type=checkbox name=R value=" + vEmp.get(i).getIdEmployee() + "></td>");
 			}
 			if(pd.getEditing() == 1){
 				out.println("<td><input type=checkbox name=U checked value=" + vEmp.get(i).getIdEmployee() + "></td>");
 			} else {
 				out.println("<td><input type=checkbox name=U value=" + vEmp.get(i).getIdEmployee() + "></td>");
 			}
 		}
 		}
 	out.println("</table>");
  	%>
  	<p align = "center"><button onclick="Add()"> Изменить </button></p>
  	<div id="contentBody"></div>
  <div id="loading" style="display: none">Загрузка...</div>
  <div id="content"></div>
<%} else {
  	request.getRequestDispatcher("/login.jsp").forward(request,response);
} %>

  </div>
</div>
</body>
</html>