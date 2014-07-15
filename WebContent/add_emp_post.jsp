<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<%@page import="java.util.*,dbc.Employee_DAO,dbc.Post_DAO,logic.Employee,logic.Post"%>
<script>
//Добавление должности (adding_emp_post.jsp)
 function Adding(link, emp) {
	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');	
	
	var rate = document.getElementById("rate").value;
	
	if(rate == ""){
		alert("Введите ставку!");
	} else { 
	cont.innerHTML = loading.innerHTML;
	
	var linkparam = link + "?emp="+emp+"&post="+document.getElementById("Posts").value+"&rate="+rate;
	var http = createRequestObject();
	if (http) {
		http.open('get', linkparam, true);
		
		http.onreadystatechange = function f() {
			if (http.readyState == 4) {
				cont.innerHTML = http.responseText;
				var ans = http.responseText;
				if(ans.indexOf('Сотрудник уже состоит на данной должности') + 1) {
					location.reload();
				} else if(ans.indexOf('Должность добавлена') + 1) {
					location.href = "get_employee.jsp";
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
	
} 
// создание ajax объекта  
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
          <li><a href=#><span>Классификатор функций</span></a></li>
          <li><a href=#><span>Штатное расписание</span></a></li>
          <li><a href="#" class="current"><span>Корпоративные стандарты</span></a></li>
          <li><a href="login.jsp"><span>Выход</span></a></li>
        </ul>
      </div>
      <div id="menunav">
      	<ul>
      		<li><a href="get_employee.jsp" class="current"><span>Просмотр даннных сотрудника</span></a></li>
      		<li><a href="add_employee.jsp"><span>Добавить сотрудника</span></a></li>
      		<li><a href="standart.jsp"><span>Должностная инструкция</span></a></li>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
<%	Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");
	Employee_DAO e_dao = (Employee_DAO)request.getSession().getAttribute("Employee_DAO");

	if(p_dao != null && e_dao != null) {
	Integer id = Integer.parseInt(request.getParameter("emp"));

	Vector<Post> vPost = new Vector<Post>();
	Employee emp = new Employee();
	
	vPost = p_dao.getPosts();
	emp = e_dao.getEmployeeById(id);

	out.println("<p align = 'center'>Добавление должности сотруднику:"+emp.getName()+" "+emp.getSurname()+"</p>");
%>
	<p align = "center">Укажите должность:
	<select name='Posts' id='Posts'>
	<%for(int i = 0;i < vPost.size();i++){
  		out.println("<option value = '" +vPost.get(i).getIdPost()+ "'>" +vPost.get(i).getName()+ "</option>");
  	}
	%>
	</select>
	Введите ставку: <input type="text" id="rate" name="rate" />
	<%
	out.println("<p align = 'center'><button onclick=Adding('adding_emp_post.jsp',"+id+")> Добавить </button></p>");
	%>
	<div id="contentBody"></div>
  	<div id="loading" style="display: none">Загрузка...</div>
  
  <%} else {
	  request.getRequestDispatcher("/login.jsp").forward(request,response);
  }
	  %>
</div>
</div>
</body>
</html>