<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<link rel="icon" type="image/png" href="img.png" />
<%@page import="java.util.*,dbc.Post_DAO,dbc.Department_DAO,logic.Post,logic.Department"%>
<script type="text/javascript">
function Add() {
	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');	

	var empName = document.getElementById("name").value;
	var empSurn = document.getElementById("surn").value;
	var login = document.getElementById("login").value;
	var pass = document.getElementById("pass").value;
	var rate = document.getElementById("rate").value;
	
	if(empName == "" || empSurn == "" || login == "" || pass == "" || rate == "") {
		alert("Необходимо заполнить все поля!");
	} else {
		
	cont.innerHTML = loading.innerHTML;
	
	var linkparam = "adding_employee.jsp"+"?empName="+empName+"&empSurn="+empSurn+"&login="+login+"&pass="+pass+"&post="+document.getElementById("Posts").value+"&rate="+rate;	
	
	var http = createRequestObject();
	if (http) {
		http.open('get', linkparam, true);
		
		http.onreadystatechange = function f() {
			if (http.readyState == 4) {
				var ans = http.responseText;
				cont.innerHTML = http.responseText;
				if(ans.indexOf('Информация о сотруднике добавлена') + 1) {
					location.reload();
				} else {
					cont.innerHTML = http.responseText;
				}
			}
		}
		http.send(null);
	} else {
		document.location = "adding_employee.jsp";
	}
	}
	
}
function createRequestObject() {
	return new XMLHttpRequest();
}</script>
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
      		<li><a href="get_employee.jsp"><span>Просмотр даннных сотрудника</span></a></li>
      		<li><a href="#" class="current"><span>Добавить сотрудника</span></a></li>
      		<li><a href="standart.jsp"><span>Должностная инструкция</span></a></li>
      		<li><a href='#'><span>Распределение прав доступа</span></a></li>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
  <%
  	Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");
  	Department_DAO d_dao = (Department_DAO)request.getSession().getAttribute("Department_DAO");
  	
  	if(p_dao != null && d_dao != null){
  	
  		Vector<Post> vPost = new Vector<Post>();
  		Vector<Department> vDep = new Vector<Department>();
  	
  		vDep = d_dao.getDepartments();
  		vPost = p_dao.getPosts();
  		%>
		<p align = "center" style = "font-size:15px">Добавление данных о сотруднике</p>
		<table align = "center" border = 0>
  		<tr><td> Имя сотрудника:</td><td> <input type="text" id="name" name="name" /></td></tr>
  		<tr><td> Фамилия сотрудника:</td><td> <input type="text" id="surn" name="surn" /></td></tr>
  		<tr><td> Логин: </td><td><input type="text" id="login" name="login" /></td></tr>
  		<tr><td> Пароль: </td><td><input type="password" id="pass" name="pass" /></td></tr>
  		</table>

		<p align = "center">Укажите должность:
		<select name='Posts' id='Posts'>
		<%for(int i = 0;i < vPost.size();i++){
  			out.println("<option value = '" +vPost.get(i).getIdPost()+ "'>" +vPost.get(i).getName()+ "</option>");
  		}
		%>
		</select>
		Введите ставку: <input type="text" id="rate" name="rate" />
		<p align = "center"><button onclick="Add()"> Добавить </button></p>
	  	<div id="contentBody"></div>
  		<div id="loading" style="display: none">Загрузка...</div>
  		<%} else {
  			request.getRequestDispatcher("/login.jsp").forward(request,response);
 		 }%>
	</div>
</body>
</html>