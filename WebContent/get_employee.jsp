<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<link rel="icon" type="image/png" href="img.png" />
<%@page import="java.util.*,dbc.Employee_DAO,dbc.Role_DAO,logic.Employee,logic.PersonnelDepartment"%>
<script>	
//Получить список должностей (get_posts.jsp)
function SendGet(link, emp) {

	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');

	cont.innerHTML = loading.innerHTML;
	
	var linkparam = link + "?emp="+emp;	

	var http = createRequestObject();
	if (http) {
		http.open('get', linkparam, true);
		
		http.onreadystatechange = function f() {
			if (http.readyState == 4) {
				cont.innerHTML = http.responseText;
			}
		}
		http.send(null);
	} else {
		document.location = link;
	}
}

// создание ajax объекта  
function createRequestObject() {
	return new XMLHttpRequest();
}
//Удалить информацию о сотруднике (delete_emp.jsp)
function Delete(link, emp) {

	if(confirm('Вы уверены, что хотите удалить информацию об этом сотруднике?')){
		var cont = document.getElementById('contentBody');
		var loading = document.getElementById('loading');

		cont.innerHTML = loading.innerHTML;
		
		var linkparam = link + "?emp="+emp;
		
		var http = createRequestObject();
		if (http) {
			http.open('get', linkparam, true);
			
			http.onreadystatechange = function f() {
				if (http.readyState == 4) {
					var ans = http.responseText;
					if(ans.indexOf('Информация о сотруднике удалена') + 1) {
						location.reload();
					} else {
						cont.innerHTML = http.responseText;
					}
				}
			}
			http.send(null);
		} else {
			document.location = link;
		}
	}
	else { 
	}
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
          <li><a href=#><span>Классификатор функций</span></a></li>
          <li><a href=#><span>Штатное расписание</span></a></li>
          <li><a href="#" class="current"><span>Корпоративные стандарты</span></a></li>
          <li><a href="login.jsp"><span>Выход</span></a></li>
        </ul>
      </div>
      <div id="menunav">
      	<ul>
      		<li><a href="#" class="current"><span>Просмотр даннных сотрудника</span></a></li>
      		<%Role_DAO r_dao = (Role_DAO)request.getSession().getAttribute("Role_DAO");
  			Integer idEmp = (Integer)request.getSession().getAttribute("idEmp"); 
  			PersonnelDepartment pd = new PersonnelDepartment();
  			pd = r_dao.getRights(idEmp);
  			if(pd.getEditing() == 1){
      			out.println("<li><a href='add_employee.jsp'><span>Добавить сотрудника</span></a></li>");
  			} else {
  				out.println("<li><a href='#'><span>Добавить сотрудника</span></a></li>");
  			}%>
      		<li><a href="standart.jsp"><span>Должностная инструкция</span></a></li>
      		<li><a href='#'><span>Распределение прав доступа</span></a></li>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
   <table border = 0 width = 100%><tr><td valign="top">
  <% Employee_DAO e_dao = (Employee_DAO)request.getSession().getAttribute("Employee_DAO");
  	
  	if(e_dao != null && r_dao != null){
  		Vector<Employee> vEmp = new Vector<Employee>();
  
  		vEmp = e_dao.getEmployee();
  		
  		out.println("<table border=1 cellspacing=0>	<CAPTION ALIGN=top>Список сотрудников:</CAPTION> ");
   		out.println("<tr><th>Сотрудники</th></tr>");
   		for(int i = 0;i < vEmp.size();i++){
   			out.println("<tr><td width=250>" + vEmp.get(i).getName() + " " + vEmp.get(i).getSurname() +"</td>");
   			if(pd.getReading() == 1){
   				out.println("<td><img src=images/list1.png onclick=SendGet('get_posts.jsp',"+ vEmp.get(i).getIdEmployee() +")></td>");//
   			}
   			if(pd.getEditing() == 1){
   				out.println("<td><a href='add_emp_post.jsp?emp="+vEmp.get(i).getIdEmployee()+"'><img src=images/list-add.png></a></td>");// 
   				out.println("<td><img src=images/bin_empty.png onclick=Delete('delete_emp.jsp',"+ vEmp.get(i).getIdEmployee() +")></td></tr>");
   			}
   			}
   		out.println("</table>");
  %>
  
   </td><td valign="top">
  <div id="contentBody"></div>
  <div id="loading" style="display: none">Загрузка...</div>
  <div id="content"></div>
  </td></tr></table>
  <%} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	} %>
  
  
  </div>
</div>
</body>
</html>