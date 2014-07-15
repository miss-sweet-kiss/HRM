<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<%@page
	import="java.util.*,dbc.Role_DAO,dbc.Employee_Post_DAO,dbc.Employee_DAO,dbc.Post_FR_DAO,dbc.Department_DAO,dbc.FR_DAO,dbc.GroupFR_DAO,dbc.Post_DAO,logic.PostFR,logic.Department,logic.Post,logic.FR,logic.GroupFR"%>
<link rel="icon" type="image/png" href="img.png" />
<script type="text/javascript">
function Enter(link) {

	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');

	cont.innerHTML = loading.innerHTML;
	
	var linkparam = link + "?login="+document.getElementById("login").value+"&pass="+document.getElementById("pass").value;	

	var http = createRequestObject();
	if (http) {
		http.open('get', linkparam, true);
		
		http.onreadystatechange = function f() {
			if (http.readyState == 4) {
				var text = http.responseText;
				if(text.indexOf('Добро пожаловать!') + 1) {
					location.href = "index.jsp";
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

// создание ajax объекта  
function createRequestObject() {
	 var xmlhttp;
	  try {
	    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
	  } catch (e) {
	    try {
	      xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	    } catch (E) {
	      xmlhttp = false;
	    }
	  }
	  if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
	    xmlhttp = new XMLHttpRequest();
	  }
	  return xmlhttp;
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
          <li><a href="#" class="current"><span>Главная</span></a></li>
          <li><a href="#"><span>Классификатор функций</span></a></li>
          <li><a href="#"><span>Штатное расписание</span></a></li>
          <li><a href="#"><span>Корпоративные стандарты</span></a></li>
        </ul>
      </div>
    </div>
  </div>
  <div id="container">
	<% /**************************Подключение к базе данных**************************************/
	
		Department_DAO dep_dao = Department_DAO.getInstance("localhost", "System");
		Post_DAO p_dao = Post_DAO.getInstance("localhost", "System");
		FR_DAO fr_dao = FR_DAO.getInstance("localhost", "System");
		Post_FR_DAO pf_dao = Post_FR_DAO.getInstance("localhost", "system");
		GroupFR_DAO gr_dao = GroupFR_DAO.getInstance("localhost","system");
		Employee_DAO e_dao = Employee_DAO.getInstance("localhost","system");
		Employee_Post_DAO ep_dao = Employee_Post_DAO.getInstance("localhost","system");
		Role_DAO r_dao = Role_DAO.getInstance("localhost","system");
			
		if (dep_dao != null && p_dao != null && fr_dao != null && pf_dao != null && e_dao != null && ep_dao != null) {
			System.out.println("Connection successful");
			request.getSession().setAttribute("Department_DAO",dep_dao);
			request.getSession().setAttribute("Post_DAO",p_dao);
			request.getSession().setAttribute("FR_DAO",fr_dao);
			request.getSession().setAttribute("Post_FR_DAO",pf_dao);
			request.getSession().setAttribute("GroupFR_DAO",gr_dao);
			request.getSession().setAttribute("Employee_DAO", e_dao);
			request.getSession().setAttribute("Employee_Post_DAO", ep_dao);
			request.getSession().setAttribute("Role_DAO", r_dao);
		} else {

		}
		
		%>
		<table align="center" border=0>
		<tr><td>Введите логин:</td><td> <input type="text" id="login" name="login" /></td></tr>
  		<tr><td>Пароль: </td><td><input type="password" id="pass" name="pass" /></td></tr>
  		
  		<tr><td colspan=2 align="center"><button onclick=Enter('enter.jsp')> Войти </button></td></tr>
  		</table>
  		
  	<div id="contentBody"></div>
  	<div align="center" id="loading" style="display: none">Загрузка...</div>
  <div id="content"></div>
  
  </div>
</div>
<!-- <div id="footer"> HRM <p> СИСТЕМА УПРАВЛЕНИЯ ОРГАНИЗАЦИОННО-ФУНКЦИОНАЛЬНОЙ СТРУКТУРОЙ ПРЕДПРИЯТИЯ </div> -->

</body>
</html>