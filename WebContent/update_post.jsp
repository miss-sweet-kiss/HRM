<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>HRM</title>
<%@page
	import="java.util.*,dbc.FR_DAO,dbc.Post_FR_DAO,dbc.GroupFR_DAO,dbc.Department_DAO,dbc.Post_DAO,logic.PostFR,logic.FR,logic.GroupFR,logic.Department,logic.Post"%>

</head>
<body><%
	FR_DAO fr_dao = (FR_DAO)request.getSession().getAttribute("FR_DAO");
	Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");
	Post_FR_DAO pf_dao = (Post_FR_DAO)request.getSession().getAttribute("Post_FR_DAO");
	GroupFR_DAO gr_dao = (GroupFR_DAO)request.getSession().getAttribute("GroupFR_DAO"); 
	Department_DAO d_dao = (Department_DAO)request.getSession().getAttribute("Department_DAO");
	
	if(fr_dao != null && gr_dao != null && p_dao != null && d_dao != null && pf_dao != null){

 		Integer id = Integer.parseInt(request.getParameter("post"));
		
		PostFR pf;
		Vector<Post> vPost = new Vector<Post>();
		Vector<Department> vDep = new Vector<Department>();
		Vector<GroupFR> vGr = new Vector<GroupFR>();
		Vector<FR> vFR = new Vector<FR>();
		
		vGr = gr_dao.getAllGroups();
		vDep = d_dao.getDepartments();

		out.println("<table border=1 cellspacing=0>	<CAPTION ALIGN=top>Формуляр должности: "+p_dao.getPostById(id).getName()+"</CAPTION> ");
		out.println("<tr><th>Функциональные обязанности</th><th>X</th><th>O</th><th>1</th><th>Y</th><th>K</th></tr>");
		for(int i = 0;i < vGr.size();i++){
   			out.println("<tr><td>" + vGr.get(i).getName() + "</td></tr>");
   			vFR = fr_dao.getFRByGroup(vGr.get(i).getIdGroup());
   			for(int j = 0;j < vFR.size();j++){
   				pf = pf_dao.getRelationByPostFR(id,vFR.get(j).getIdFR());
   				System.out.println(pf);
   				out.println("<tr><td width=250>" + vFR.get(j).getName() + "</td>");
   				if(pf == null) {
   					out.println("<td><input type=\"checkbox\" name=X onclick=\"Update("+id+",'X','1',"+vFR.get(j).getIdFR()+");\"></td>");
   					out.println("<td><input type=\"checkbox\" name=O onclick=\"Update("+id+",'O','1',"+vFR.get(j).getIdFR()+");\"></td>");
   					out.println("<td><input type=\"checkbox\" name=1 onclick=\"Update("+id+",'1','1',"+vFR.get(j).getIdFR()+");\"></td>");
   					out.println("<td><input type=\"checkbox\" name=Y onclick=\"Update("+id+",'Y','1',"+vFR.get(j).getIdFR()+");\"></td>");
   					out.println("<td><input type=\"checkbox\" name=K onclick=\"Update("+id+",'K','1',"+vFR.get(j).getIdFR()+");\"></td> </tr>");

   				} else {
   				if(pf.getX() == 1) {
   					out.println("<td><input type=\"checkbox\" name=X checked onclick=\"Update("+id+",'X','0',"+vFR.get(j).getIdFR()+");\"></td>");
   				} else {
   					out.println("<td><input type=\"checkbox\" name=X onclick=\"Update("+id+",'X','1',"+vFR.get(j).getIdFR()+");\"></td>");
   				}
   				if(pf.getO() == 1) {
   					out.println("<td><input type=\"checkbox\" name=O checked onclick=\"Update("+id+",'O','0',"+vFR.get(j).getIdFR()+");\"></td>");
   				} else {
   					out.println("<td><input type=\"checkbox\" name=O onclick=\"Update("+id+",'O','1',"+vFR.get(j).getIdFR()+");\"></td>");
   				}
   				if(pf.get1() == 1) {
   					out.println("<td><input type=\"checkbox\" name=1 checked onclick=\"Update("+id+",'1','0',"+vFR.get(j).getIdFR()+");\"></td>");
   				} else {
   					out.println("<td><input type=\"checkbox\" name=1 onclick=\"Update("+id+",'1','1',"+vFR.get(j).getIdFR()+");\"></td>");
   				}
   				if(pf.getY() == 1) {
   					out.println("<td><input type=\"checkbox\" name=Y checked onclick=\"Update("+id+",'Y','0',"+vFR.get(j).getIdFR()+");\"></td>");
   				} else {
   					out.println("<td><input type=\"checkbox\" name=Y onclick=\"Update("+id+",'Y','1',"+vFR.get(j).getIdFR()+");\"></td>");
   				}
   				if(pf.getK() == 1) {
   					out.println("<td><input type=\"checkbox\" name=K checked onclick=\"Update("+id+",'K','0',"+vFR.get(j).getIdFR()+");\"></td> </tr>");
   				} else {
   					out.println("<td><input type=\"checkbox\" name=K onclick=\"Update("+id+",'K','1',"+vFR.get(j).getIdFR()+");\"></td> </tr>");
   				}
   				}
   			}
   		} 
		out.println("</table>");
%>
<div id="contentBody"></div>
<div id="loading" style="display: none">Загрузка...</div>
<div id="content"></div>
<%} else {
  	request.getRequestDispatcher("/login.jsp").forward(request,response);
} %>	
</body>
</html>