<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<%@page import="java.util.*,dbc.GroupFR_DAO,dbc.Department_DAO,dbc.Post_DAO,logic.GroupFR,logic.Department,logic.Post"%>
<link rel="icon" type="image/png" href="img.png" />
<script type="text/javascript" src="jExpand.js"></script>  
<script src="jquery-1.7.1.min.js" type="text/javascript" ></script> 
<script src="jquery-1.3.1.min.js" type="text/javascript" ></script> 

<style type="text/css">
.tr_task {
	display: none;
	cursor: pointer;
}

</style>
<script type="text/javascript">
$(document).ready(function (){
	$('.menu').click(function (){
		$(this).parents('tbody').find('.tr_task').toggle();
		$(this).find(".arrow").toggleClass("up");
	});
});
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
      		<li><a href="#" class="current"><span>Создать ФО</span></a></li>
      		<li><a href="add_group_fr.jsp"><span>Создать группу ФО</span></a></li>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
  <div id="contentBody"></div>
  <div id="loading" style="display: none">Загрузка...</div>
  <div id="content"></div>
  <%
  	GroupFR_DAO gr_dao = (GroupFR_DAO)request.getSession().getAttribute("GroupFR_DAO");
  	Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");
	Department_DAO d_dao = (Department_DAO)request.getSession().getAttribute("Department_DAO");
	
	if(gr_dao != null && p_dao != null && d_dao != null){
	Vector<Post> vPost = new Vector<Post>();
	Vector<Department> vDep = new Vector<Department>();
  	Vector<GroupFR> vGr = new Vector<GroupFR>();
  	
  	vGr = gr_dao.getAllGroups();
  	vDep = d_dao.getDepartments();%>
  
  <p align = "center" style = "font-size:15px">Создание функциональной обязанности</p>
  <p align = "center"> Название обязанности: <input type="text" id="frName" name="frName" /></p>
  <p align = "center">Укажите группу ФО:
  <select name="Groups" id="Groups">
  <%for(int i = 0;i < vGr.size();i++){
  		out.println("<option value = '" +vGr.get(i).getName()+ "'>" +vGr.get(i).getName()+ "</option>");
  	}
	%>
	</select>
	<table border=1 cellspacing=0 align = "center">
	<tr><th width=250>Формуляр функциональной обязанности</th><th width=20>X</th><th width=20>O</th><th width=20>1</th><th width=20>Y</th><th width=20>K</th></tr>
	<%for(int i = 0;i < vDep.size();i++){
   		out.println("<tbody><tr class='tr_mark'><td class='menu'><div class='arrow'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + vDep.get(i).getName() + "</div></td><td></td><td></td><td></td><td></td><td></td></tr>");
   		vPost = p_dao.getPostsByDep(vDep.get(i).getIdDepartment());
   		for(int j = 0;j < vPost.size();j++){
   			out.println("<tr class='tr_task'><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + vPost.get(j).getName() + "</td>");
   			out.println("<td><input type=checkbox name=X value=" + vPost.get(j).getIdPost() + "></td>");
   			out.println("<td><input type=checkbox name=O value=" + vPost.get(j).getIdPost() + "></td>");
   			out.println("<td><input type=checkbox name=1 value=" + vPost.get(j).getIdPost() + "></td>");
   			out.println("<td><input type=checkbox name=Y value=" + vPost.get(j).getIdPost() + "></td>");
   			out.println("<td><input type=checkbox name=K value=" + vPost.get(j).getIdPost() + "></td> </tr>");
   		}
   		out.println("</tbody>");
   	} %>
   
	</table>
	<p align = "center"><textarea rows="15" cols="50" id="standart" placeholder="Введтите текст стандарта"></textarea></p>
  <p align = "center"><button onclick="Add()"> Создать </button></p>
  
  <div id="content"></div>
  <%} else {
	  request.getRequestDispatcher("/login.jsp").forward(request,response);
  }
 %>
  </div>
</div>
  
</body>
<script>
function Add() {
	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');	
	
	var frName = document.getElementById("frName").value;
	var standart = document.getElementById("standart").value;
	
	if(frName == "" || standart == "") {
		alert("Заполните все поля!");
	} else {
		cont.innerHTML = loading.innerHTML;
	
	var linkparam = "adding_fr.jsp" + "?frName=" + frName + "&group="+document.getElementById("Groups").value+"&standart='"+standart+"'";	
	
	for(var i = 0;i < document.getElementsByName("X").length;i++) {
		if (document.getElementsByName("X")[i].checked) {
			linkparam += "&X"+document.getElementsByName("X")[i].value+"=1";
		} else {
			linkparam += "&X"+document.getElementsByName("X")[i].value+"=0";
		}
		if (document.getElementsByName("O")[i].checked) {
			linkparam += "&O"+document.getElementsByName("O")[i].value+"=1";
		} else {
			linkparam += "&O"+document.getElementsByName("O")[i].value+"=0";
		}
		if (document.getElementsByName("1")[i].checked) {
			linkparam += "&1"+document.getElementsByName("1")[i].value+"=1";
		} else {
			linkparam += "&1"+document.getElementsByName("1")[i].value+"=0";
		}
		if (document.getElementsByName("Y")[i].checked) {
			linkparam += "&Y"+document.getElementsByName("Y")[i].value+"=1";
		} else {
			linkparam += "&Y"+document.getElementsByName("Y")[i].value+"=0";
		}
		if (document.getElementsByName("K")[i].checked) {
			linkparam += "&K"+document.getElementsByName("K")[i].value+"=1";
		} else {
			linkparam += "&K"+document.getElementsByName("K")[i].value+"=0";
		}
	}
	linkparam += "&count="+document.getElementsByName("X").length;

	var http = createRequestObject();
	if (http) {
		http.open('get', linkparam, true);
		
		http.onreadystatechange = function f() {
			if (http.readyState == 4) {
				var ans = http.responseText;
				cont.innerHTML = http.responseText;
				if(ans.indexOf('Функциональная обязанность добавлена') + 1) {
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
</html>