<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<link rel="icon" type="image/png" href="img.png" />
<%@page
	import="java.util.*,dbc.Post_DAO,dbc.Department_DAO,logic.Post,logic.Department"%>
</head>
<body>
<script>
function SendGet(link, post) {

	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');

	cont.innerHTML = loading.innerHTML;
	
	var linkparam = link + "?post="+post;	

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

function Update(idP,param,val,idFR) {
	var cont = document.getElementById('contentBody');
	var loading = document.getElementById('loading');	

	cont.innerHTML = loading.innerHTML;
	
	var linkparam = "updating_fr.jsp?idP=" + idP + "&param=" + param + "&val=" + val + "&idFR=" + idFR;	

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
function Delete(link, flag, id) {
	
	var text;
	
	if(flag == "dep"){
		text = 'Вы уверены, что хотите удалить это подразделение?';
	}
	if(flag == "post"){
		text = 'Вы уверены, что хотите удалить эту должность?';
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
					if(ans.indexOf('Должность удалена') + 1) {
						location.reload();
					} else if(ans.indexOf('Подразделение удалено') + 1) {
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

<div id="wrap">
  <div id="masthead">
    <h1><img src="images/hrm.jpg"></h1>
    <div id="menucontainer">
      <div id="menunav">
        <ul>
          <li><a href="index.jsp"><span>Главная</span></a></li>
          <li><a href="get_fr.jsp"><span>Классификатор функций</span></a></li>
          <li><a href="#" class="current"><span>Штатное расписание</span></a></li>
          <li><a href="standart.jsp"><span>Корпоративные стандарты</span></a></li>
          <li><a href="login.jsp"><span>Выход</span></a></li>
        </ul>        
      </div>
      <div id="menunav">
      	<ul>
      		<li><a href="#" class="current"><span>Просмотр расписания</span></a></li>
      		<li><a href="add_post.jsp"><span>Создать должность</span></a></li>
      		<li><a href="add_dep.jsp"><span>Создать подразделение</span></a></li>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
  <table border = 0 width = 100%><tr><td valign="top">
  <%
  	Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");
	Department_DAO d_dao = (Department_DAO)request.getSession().getAttribute("Department_DAO");
 	if(p_dao != null && d_dao != null){ 	
  	
  	Vector<Post> vPost = new Vector<Post>();
  	Vector<Department> vDep = new Vector<Department>();
 
  	vDep = d_dao.getDepartments();
  	
  	out.println("<table border=1 cellspacing=0>	<CAPTION ALIGN=top>Список подразделений:</CAPTION> ");
   	out.println("<tr><th>Подразделения</th>");
   	for(int i = 0;i < vDep.size();i++){
   		out.println("<tr><td width=250>" + vDep.get(i).getName() + "</td><td></td>");
   		out.println("<td><img src=images/bin_empty.png onclick=Delete('delete_group_dep.jsp','dep',"+ vDep.get(i).getIdDepartment() +")></td></tr>");
   		vPost = p_dao.getPostsByDep(vDep.get(i).getIdDepartment());
   		for(int j = 0;j < vPost.size();j++){
   			out.println("<tr><td>" + vPost.get(j).getName() + "</td>");
   			out.println("<td><img src=images/pen_ballpoint.png onclick=SendGet('update_post.jsp',"+ vPost.get(j).getIdPost() +")></td>");
   			out.println("<td><img src=images/bin_empty.png onclick=Delete('delete_post.jsp','post',"+ vPost.get(j).getIdPost() +")></td></tr>");
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
<!-- <div id="footer"> HRM <p> СИСТЕМА УПРАВЛЕНИЯ ОРГАНИЗАЦИОННО-ФУНКЦИОНАЛЬНОЙ СТРУКТУРОЙ ПРЕДПРИЯТИЯ </div> -->
  
</body>
</html>