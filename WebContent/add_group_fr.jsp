<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<link rel="icon" type="image/png" href="img.png" />
<%@page import="java.util.*,dbc.GroupFR_DAO,logic.GroupFR"%>
<script>
function SendGet(flag) {

	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');
	
	var name = document.getElementById("group").value;
	
	if(name == ""){
		alert("Введите название!");
	} else {
		cont.innerHTML = loading.innerHTML;
		
	var linkparam = "adding_gr_dep.jsp" + "?flag="+flag+ "&name=" +name;	

	var http = createRequestObject();
	if (http) {
		http.open('get', linkparam, true);
		
		http.onreadystatechange = function f() {
			if (http.readyState == 4) {
				var ans = http.responseText;
				cont.innerHTML = http.responseText;
				if(ans.indexOf('Группа добавлена') + 1) {
					location.reload();
				} else {
					cont.innerHTML = http.responseText;
				}
			}
		}
		http.send(null);
	} else {
		document.location = "adding_gr_dep.jsp";
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
          <li><a href="#" class="current"><span>Классификатор функций</span></a></li>
          <li><a href="get_staffList.jsp"><span>Штатное расписание</span></a></li>
          <li><a href="standart.jsp"><span>Корпоративные стандарты</span></a></li>
          <li><a href="login.jsp"><span>Выход</span></a></li>
        </ul>
      </div>
      <div id="menunav">
      	<ul>
      		<li><a href="get_fr.jsp"><span>Просмотр ФО</span></a></li>
      		<li><a href="add_fr.jsp"><span>Создать ФО</span></a></li>
      		<li><a href="#" class="current"><span>Создать группу ФО</span></a></li>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
  
  <p align = "center" style = "font-size:15px">Создание группы функциональных обязанностей</p>
  <p align = "center"> Название группы: <input type="text" id="group" name="group" /></p>
  <p align = "center"><button onclick="SendGet('group')"> Создать </button></p>
  
  <div id="contentBody"></div>
  <div id="loading" style="display: none">Загрузка...</div>
  <div id="content"></div>
  </div>
</div>
<!-- <div id="footer"> HRM <p> СИСТЕМА УПРАВЛЕНИЯ ОРГАНИЗАЦИОННО-ФУНКЦИОНАЛЬНОЙ СТРУКТУРОЙ ПРЕДПРИЯТИЯ </div> -->
 
</body>
</html>