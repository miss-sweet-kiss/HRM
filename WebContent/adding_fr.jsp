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
<body>
<%
	FR_DAO fr_dao = (FR_DAO)request.getSession().getAttribute("FR_DAO");
	Post_DAO p_dao = (Post_DAO)request.getSession().getAttribute("Post_DAO");
	Post_FR_DAO pf_dao = (Post_FR_DAO)request.getSession().getAttribute("Post_FR_DAO");
	
	if(fr_dao != null && p_dao != null && pf_dao != null){
	Integer count = Integer.parseInt(request.getParameter("count"));
 	String frName = new String(request.getParameter("frName").getBytes("ISO-8859-1"),"utf-8");
	String group = new String(request.getParameter("group").getBytes("ISO-8859-1"),"utf-8");
	String stand = new String(request.getParameter("standart").getBytes("ISO-8859-1"),"utf-8");
	
	//Добавление ФО
	FR fr = new FR();
	fr.setName(frName);
	fr.setGroup(group);
	fr.setStandart(stand);
	
	Integer n = fr_dao.addFR(fr);
	if(n == 1)
		out.println("<center><p style='color:Red'><b>Функциональная обязанность добавлена</b></p></center>");
	else if(n == 2)
		out.println("<center><p style='color:Red'><b>ФО не может быть добавлена</b></p></center>");
	else if(n == 3)
		out.println("<center><p style='color:Red'><b>ФО с таким названием уже существует в данной группе</b></p></center>");
	
	//Добавление отношений между ФО и должностями
	Vector<PostFR> vPF = new Vector<PostFR>();
	Vector<Post> vPost = new Vector<Post>();
	
	vPost = p_dao.getPosts();
	
	for(int i = 0;i < count;i++){
		Integer x = Integer.parseInt(request.getParameter("X"+vPost.get(i).getIdPost()));
		Integer o = Integer.parseInt(request.getParameter("O"+vPost.get(i).getIdPost()));
		Integer r1 = Integer.parseInt(request.getParameter("1"+vPost.get(i).getIdPost()));
		Integer y = Integer.parseInt(request.getParameter("Y"+vPost.get(i).getIdPost()));
		Integer k = Integer.parseInt(request.getParameter("K"+vPost.get(i).getIdPost()));
		if(x == 0 && o == 0 && r1 == 0 && y == 0 && k == 0) {
			
		} else {
			PostFR pf = new PostFR();
			pf.setFR(fr_dao.getIdFR(fr));
			pf.setPost(vPost.get(i).getIdPost());
			pf.setX(x);
			pf.setO(o);
			pf.set1(r1);
			pf.setY(y);
			pf.setK(k);
			pf_dao.addRelation(pf);
		}			
	}
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
%>
</body>
</html>