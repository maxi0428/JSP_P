<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="prob.ProbDAO" %>
<%@ page import="prob.Prob" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("history.back()");
			script.println("</script>");
		}

		int probID = 0;
		if (request.getParameter("probID") != null) {
			probID = Integer.parseInt(request.getParameter("probID"));
		}
		if (probID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않는 글입니다.')");
			script.println("location.href = 'proB.jsp'");
			script.println("history.back()");
			script.println("</script>");
		}
		Prob prob = new ProbDAO().getProb(probID);
		if (!userID.equals(prob.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'proB.jsp'");
			script.println("history.back()");
			script.println("</script>");
		} else {
			ProbDAO probDAO = new ProbDAO();
			int result = probDAO.delete(probID);
			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글 삭제에 실패 했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'proB.jsp'");
				script.println("</script>");
			}				
		}		
	%>
</body>
</html>