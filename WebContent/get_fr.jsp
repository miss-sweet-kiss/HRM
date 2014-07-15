<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<%@page import="java.util.*,dbc.FR_DAO,dbc.GroupFR_DAO,logic.FR,logic.GroupFR"%>
<link rel="icon" type="image/png" href="img.png" />

<script>
function SendGet(link, fr) {

	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');

	cont.innerHTML = loading.innerHTML;
	
	var linkparam = link + "?fr="+fr;	

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

function Delete(link, flag, id) {
	
	var text;
	
	if(flag == "group"){
		text = 'Вы уверены, что хотите удалить эту группу?';
	}
	if(flag == "fr"){
		text = 'Вы уверены, что хотите удалить эту ФО?';
	}
	if(confirm(text)){
		var cont = document.getElementById('contentBody');
		var loading = document.getElementById('loading');

		cont.innerHTML = loading.innerHTML;
		
		var linkparam = link + "?id="+id+"&flag="+flag;
		
		var http = createRequestObject();
		if (http) {
			http.open('get', linkparam, true);
			
			http.onreadystatechange = function f() {
				if (http.readyState == 4) {
					var ans = http.responseText;
					if(ans.indexOf('Функциональная обязанность удалена') + 1) {
						location.reload();
					} else if(ans.indexOf('Группа удалена') + 1) {
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
function Update(idFR,param,val,idP) {
	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');	

	cont.innerHTML = loading.innerHTML;
	
	var linkparam = "updating_fr.jsp?idFR=" + idFR + "&param=" + param + "&val=" + val + "&idP=" + idP;	

	var http = createRequestObject();
	if (http) {
		http.open('get', linkparam, true);
		
		http.onreadystatechange = function f() {
			if (http.readyState == 4) {
				cont.innerHTML = http.responseText;
				var ans = http.responseText;
				if(ans.indexOf('Изменения сохранены') + 1) {
					location.reload();//
				} else {
					cont.innerHTML = http.responseText;
				}
			}
		}
		http.send(null);
	} else {
		document.location = "updating_fr.jsp";
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
          <li><a href="#" class="current"><span>Классификатор функций</span></a></li>
          <li><a href="get_staffList.jsp"><span>Штатное расписание</span></a></li>
          <li><a href="standart.jsp"><span>Корпоративные стандарты</span></a></li>
          <li><a href="login.jsp"><span>Выход</span></a></li>
        </ul>
      </div>
      <div id="menunav">
      	<ul>
      		<li><a href="#" class="current"><span>Просмотр ФО</span></a></li>
      		<li><a href="add_fr.jsp"><span>Создать ФО</span></a></li>
      		<li><a href="add_group_fr.jsp"><span>Создать группу ФО</span></a></li>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
   <table border = 0 width = 100%><tr><td valign="top">
  <%
	
	FR_DAO fr_dao = (FR_DAO)request.getSession().getAttribute("FR_DAO");
	GroupFR_DAO gr_dao = (GroupFR_DAO)request.getSession().getAttribute("GroupFR_DAO");
 	if(fr_dao != null && gr_dao != null){ 	 
  	
  	Vector<FR> vFR = new Vector<FR>();
  	Vector<GroupFR> vGr = new Vector<GroupFR>();
 
  	vGr = gr_dao.getAllGroups();
  	
  	out.println("<table border=1 cellspacing=0>	<CAPTION ALIGN=top>Список функциональных обязанностей:</CAPTION> ");
   	out.println("<tr><th width=250>Функциональные обязанности</th><th></th><th></th></tr>");
   	for(int i = 0;i < vGr.size();i++){
   		out.println("<tr><td>" + vGr.get(i).getName() + "</td><td></td>");
   		out.println("<td><img src=images/bin_empty.png onclick=Delete('delete_group_dep.jsp','group',"+ vGr.get(i).getIdGroup() +")></td></tr>");//Вывод групп ФО
   		vFR = fr_dao.getFRByGroup(vGr.get(i).getIdGroup());
   		for(int j = 0;j < vFR.size();j++){
   			out.println("<tr><td>" + vFR.get(j).getName() + "</td>");
   			out.println("<td><img src=images/pen_ballpoint.png onclick=SendGet('update_fr.jsp',"+ vFR.get(j).getIdFR() +")></td>");
   			out.println("<td><img src=images/bin_empty.png onclick=Delete('delete_fr.jsp','fr',"+ vFR.get(j).getIdFR() +")></td></tr>");
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