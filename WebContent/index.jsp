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
<script type="text/javascript" src="jExpand.js"></script>  
<script src="jquery-1.7.1.min.js" type="text/javascript" ></script> 
<script src="jquery-1.3.1.min.js" type="text/javascript" ></script> 

<script type="text/javascript">
  function go(addr) {
    window.open(addr,"MyWin", "top=200,left=500,menubar=no,toolbar=no,location=no,status=no,width=300,height=300");
  }
</script>

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
          <li><a href="#" class="current"><span>Главная</span></a></li>
          <%String roleName = (String)request.getSession().getAttribute("roleName");
  			Integer idEmp = (Integer)request.getSession().getAttribute("idEmp"); 
  			
  			if(roleName.equals("директор по персоналу")) {
  				out.println("<li><a href='get_fr.jsp'><span>Классификатор функций</span></a></li>");
  				out.println("<li><a href='get_staffList.jsp'><span>Штатное расписание</span></a></li>");
  			} else {
  				out.println("<li><a href=#><span>Классификатор функций</span></a></li>");
  				out.println(" <li><a href=#><span>Штатное расписание</span></a></li>");
  			}
  			if(roleName.equals("сотрудник ОК")) {
  				out.println("<li><a href='get_employee.jsp'><span>Корпоративные стандарты</span></a></li>");
  			} else {
  				out.println("<li><a href='standart.jsp'><span>Корпоративные стандарты</span></a></li>");
  			}
  			%>
          <li><a href="login.jsp"><span>Выход</span></a></li>
        </ul>
      </div>
    </div>
  </div>
  <div id="container">
	<% /**************************Подключение к базе данных**************************************/
	
		FR_DAO fr_dao = (FR_DAO)request.getSession().getAttribute("FR_DAO");
		GroupFR_DAO gr_dao = (GroupFR_DAO)request.getSession().getAttribute("GroupFR_DAO");
		Department_DAO dep_dao = (Department_DAO)request.getSession().getAttribute("Department_DAO");
		Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");
		Post_FR_DAO pf_dao = (Post_FR_DAO)request.getSession().getAttribute("Post_FR_DAO");
		Employee_DAO e_dao = (Employee_DAO)request.getSession().getAttribute("Employee_DAO");
		Employee_Post_DAO ep_dao = (Employee_Post_DAO)request.getSession().getAttribute("Employee_Post_DAO");
		Role_DAO r_dao = (Role_DAO)request.getSession().getAttribute("Role_DAO");
		
		if (dep_dao != null && p_dao != null && fr_dao != null && pf_dao != null && e_dao != null && ep_dao != null) {
		
		Vector<Department> vDep = new Vector<Department>();
		Vector<Post> vPost = new Vector<Post>();
		Vector<FR> vFR = new Vector<FR>();
		Vector<GroupFR> vGr = new Vector<GroupFR>();
		Vector<Post> vP = new Vector<Post>();
		
		if(roleName.equals("сотрудник") || roleName.equals("сотрудник ОК")){
			vGr = gr_dao.getGroupsByEmp(idEmp);
			vDep = dep_dao.getDepartmentsByEmp(idEmp);
			vP = p_dao.getPostsByEmp(idEmp);
		} else {
			vDep = dep_dao.getDepartments();
			vGr = gr_dao.getAllGroups();
			vP = p_dao.getPosts();
		}
		
		PostFR pfr = null;%>
		
		<!-- <button name = "Deps" onclick = "go('setDeps.jsp')"> Настройка отображаемых подразделений </button>
		<button name = "FRs" onclick = "go('setFRs.jsp')"> Настройка отображаемых функциональных обязанностей </button>
		 -->
	<%/*****************************************Таблица*****************************************************/

	
		out.println("<table id='celebTree' border=1 cellspacing=0><tbody><tr><td></td>");
		for(int i = 0;i < vDep.size();i++){
			if(roleName.equals("сотрудник") || roleName.equals("сотрудник ОК")) {
				out.println("<td colspan= "+p_dao.getCountPostsInDepByEmp(vDep.get(i).getName(), idEmp)+">" + vDep.get(i).getName() + "</td>");
			} else {
				out.println("<td colspan= "+p_dao.getCountPostsInDep(vDep.get(i).getName())+">" + vDep.get(i).getName() + "</td>");//Вывод подразделений
			}
		}
		out.println("</tr><tr><td></td>");
		for(int i = 0;i < vDep.size();i++){
			Integer count = 0;
			if(roleName.equals("сотрудник") || roleName.equals("сотрудник ОК")) {
				vPost = p_dao.getPostsByDepEmp(idEmp, vDep.get(i).getIdDepartment());
				count = p_dao.getCountPostsInDepByEmp(vDep.get(i).getName(), idEmp);
			} else {
				vPost = p_dao.getPostsByDep(vDep.get(i).getIdDepartment());
				count = p_dao.getCountPostsInDep(vDep.get(i).getName());
			}
			if(vPost.isEmpty()) {
				out.println("<td></td>");
			} else {
				for(int j = 0;j < count;j++) {
					out.println("<td width=100>" + vPost.get(j).getName() + "</td>");//Вывод должностей по подразделениям
				}
			}
		}
		out.println("</tr></tbody>");
		for(int k = 0;k < vGr.size();k++){
			out.println("<tbody><tr class='tr_mark'><td class='menu' width=250><div class='arrow'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + vGr.get(k).getName() + "</div></td>");//Вывод групп ФО
			for(int j = 0;j < vP.size();j++){//Вывод отношений между должностью и группой ФО
				out.println("<td></td>");
			}
			out.println("</tr>");
			if(roleName.equals("сотрудник") || roleName.equals("сотрудник ОК")) {
				vFR = fr_dao.getFRByGroupEmp(vGr.get(k).getIdGroup(), idEmp);
			} else {
				vFR = fr_dao.getFRByGroup(vGr.get(k).getIdGroup());
			}		
			for(int i = 0;i < vFR.size();i++){
				out.println("<tr class='tr_task'><td width=250>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + vFR.get(i).getName() + "</td>");//Вывод ФО
				for(int l = 0;l < vDep.size();l++){
					if(roleName.equals("сотрудник") || roleName.equals("сотрудник ОК")) {
						vPost = p_dao.getPostsByDepEmp(idEmp, vDep.get(l).getIdDepartment());
					} else {
						vPost = p_dao.getPostsByDep(vDep.get(l).getIdDepartment());
					}
					if(vPost.isEmpty()){
						out.println("<td></td>");
					} else {
					for(int j = 0;j < vPost.size();j++){//Вывод отношений между должностью и ФО
						if(pf_dao.getRelationByPostFR(vPost.get(j).getIdPost(), vFR.get(i).getIdFR()) == null){
							out.println("<td></td>");
						} else {
							out.println("<td>" + pf_dao.getRelationByPostFR(vPost.get(j).getIdPost(), vFR.get(i).getIdFR()) + "</td>");
				
						}
					}
				}
				}
				out.println("</tr>");
			}
			out.println("</tbody>");
		}
		out.println("</table>");
		}else {
			request.getRequestDispatcher("/login.jsp").forward(request,response);
		}
	
%>
		
  	
  <div id="content">
  </div>
  </div>
</div>
<!-- <div id="footer"> HRM <p> СИСТЕМА УПРАВЛЕНИЯ ОРГАНИЗАЦИОННО-ФУНКЦИОНАЛЬНОЙ СТРУКТУРОЙ ПРЕДПРИЯТИЯ </div> -->

</body>
</html>