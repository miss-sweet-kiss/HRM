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
 	String postName = new String(request.getParameter("postName").getBytes("ISO-8859-1"),"utf-8");
	String dep = new String(request.getParameter("dep").getBytes("ISO-8859-1"),"utf-8");
	
	//Добавление должности
	Post post = new Post();
	post.setName(postName);
	post.setDepartment(dep);
	
	int n = p_dao.addPost(post);
	if(n ==1)
		out.println("<center><p style='color:Red'><b>Должность добавлена</b></p></center>");
	if(n == 2)
		out.println("<center><p style='color:Red'><b>Должность не может быть добавлена</b></p></center>");
	if(n == 3)
		out.println("<center><p style='color:Red'><b>Должность с таким названием уже существует в данном подразделении</b></p></center>");
	
	//Добавление отношений между ФО и должностями
	Vector<PostFR> vPF = new Vector<PostFR>();
	Vector<FR> vFR = new Vector<FR>();	
	
	vFR = fr_dao.getAllFR();
	
	for(int i = 0;i < count;i++){
		Integer x = Integer.parseInt(request.getParameter("X"+vFR.get(i).getIdFR()));
		Integer o = Integer.parseInt(request.getParameter("O"+vFR.get(i).getIdFR()));
		Integer r1 = Integer.parseInt(request.getParameter("1"+vFR.get(i).getIdFR()));
		Integer y = Integer.parseInt(request.getParameter("Y"+vFR.get(i).getIdFR()));
		Integer rk = Integer.parseInt(request.getParameter("K"+vFR.get(i).getIdFR()));
		if(x == 0 && o == 0 && r1 == 0 && y == 0 && rk == 0) {
			
		} else {
			PostFR pf = new PostFR();
			pf.setPost(p_dao.getIdPost(post));
			pf.setFR(vFR.get(i).getIdFR());
			pf.setX(x);
			pf.setO(o);
			pf.set1(r1);
			pf.setY(y);
			pf.setK(rk);
			pf_dao.addRelation(pf);
		}
	}
	} else {
	  	request.getRequestDispatcher("/login.jsp").forward(request,response);
	}

%>
</body>
</html>