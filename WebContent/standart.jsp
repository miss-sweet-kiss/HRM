<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<%@page
	import="java.util.*,dbc.FR_DAO,dbc.GroupFR_DAO,dbc.Role_DAO,logic.PersonnelDepartment,logic.FR,logic.GroupFR"%>
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
      		Role_DAO r_dao = (Role_DAO)request.getSession().getAttribute("Role_DAO");
			PersonnelDepartment pd = new PersonnelDepartment();
			pd = r_dao.getRights(idEmp);
      		if(roleName.equals("сотрудник ОК")) {
      			out.println("<li><a href='get_employee.jsp'><span>Просмотр даннных сотрудника</span></a></li>");
      			if(pd.getEditing() == 1){
      	  			out.println("<li><a href='add_employee.jsp'><span>Добавить сотрудника</span></a></li>");
      			} else {
      				out.println("<li><a href='#'><span>Добавить сотрудника</span></a></li>");
      			}
      		} else {
      			out.println("<li><a href=#><span>Просмотр даннных сотрудника</span></a></li>");
      			out.println("<li><a href=#><span>Добавить сотрудника</span></a></li>");
      		}
      	%>
      		<li><a href="#" class="current"><span>Должностная инструкция</span></a></li>
      	<%
      		if(roleName.equals("директор по персоналу")){
      			out.println("<li><a href='set_rights.jsp'><span>Распределение прав доступа</span></a></li>");
      		} else {
      			out.println("<li><a href='#'><span>Распределение прав доступа</span></a></li>");
      		}
      		%>
      	</ul>
      </div>
    </div>
  </div>
  <div id="container">
  <%
  	FR_DAO fr_dao = (FR_DAO)request.getSession().getAttribute("FR_DAO");
  	GroupFR_DAO gr_dao = (GroupFR_DAO)request.getSession().getAttribute("GroupFR_DAO");
  	
  	if(fr_dao != null && gr_dao != null){ 	
	  	
  		Vector<GroupFR> vGr = new Vector<GroupFR>();
	  	Vector<FR> vFR = new Vector<FR>();
	  	
	  	if(roleName.equals("сотрудник")) {
	  		vGr = gr_dao.getGroupsByEmp(idEmp);
	  	} else {
	  		vGr = gr_dao.getAllGroups();
	  	}
	  	
	  	out.println("<table border=1 cellspacing=0>	<CAPTION ALIGN=top>Список функциональных обязанностей:</CAPTION> ");
	   	out.println("<tr><th width=250>Функциональные обязанности</th><th></th></tr>");
	   	for(int i = 0;i < vGr.size();i++){
	   		out.println("<tbody><tr class='tr_mark'><td class='menu'><div class='arrow'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + vGr.get(i).getName() + "</div></td><td></td></tr>");//Вывод групп ФО
	   		if(roleName.equals("сотрудник")) {
	   			vFR = fr_dao.getFRByGroupEmp(vGr.get(i).getIdGroup(), idEmp);
	   		} else {
	   			vFR = fr_dao.getFRByGroup(vGr.get(i).getIdGroup());
	   		}
	   		for(int j = 0;j < vFR.size();j++){
	   			out.println("<tr class='tr_task'><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + vFR.get(j).getName() + "</td>");
	   			out.println("<td><a href='http://localhost/System/ExportPDF?fr="+vFR.get(j).getIdFR()+"'><img src=images/document-pdf-text.png></a></td></tr>");//get_standart.jsp
	   		}
	   		out.println("</tbody>");
	   	}
	   	out.println("</table>"); 

  	%>
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