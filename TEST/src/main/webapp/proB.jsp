<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="prob.ProbDAO" %>
<%@ page import="prob.Prob" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale"="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<% 
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
				<li class="active"><a href="proB.jsp">P게시판</a></li>
			</ul>
			<% 
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<% 		
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%		
				}
			%>
			
		</div>
	</nav>

	
		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<form method="post" action="pwriteAction.jsp">	
			<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">상태</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">내용</th>
						<th style="background-color: #eeeeee; text-align: center;"></th>
					</tr>
			</thead>
			<thead>
					<tr>
					
				    	<th style="text-align: center;vertical-align: middle;"><select name="probSt">
                    	<option value="진행중">진행중</option>
                    	<option value="완료">완료</option>
                    	</select></th>
                    	<th style="text-align: center;vertical-align: middle;"><textarea name="probTitle" placeholder="제목을 입력해주세요."></textarea></th>
                    	<th style="text-align: center;vertical-align: middle;"><textarea name="probContent" placeholder="내용을 입력해주세요."></textarea></th>
                    	<th style="text-align: center;vertical-align: middle;"><input type="submit" value="입력"></input></th>
                    </tr>
          </thead>
      </form>
        </table>
      


                <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                                   <colgroup>
                        <col width="10%">
                        <col width="20%">
                        <col width="60%">
                        <col width="10%">

                    </colgroup>
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">상태</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">내용</th>
						<th style="background-color: #eeeeee; text-align: center;">시간</th>
						
						
					</tr>
				</thead>
                    <thead>
						<%
						ProbDAO probDAO = new ProbDAO();
						ArrayList<Prob> list = probDAO.getList(pageNumber);
						for (int i = 0; i < list.size(); i++) {
					%>
					<% if ("진행중".equals(list.get(i).getProbSt())){ %>
					<tr>
						<td style="background-color: #eeeeee;"><%= list.get(i).getProbSt() %></td>
						<td style="background-color: #eeeeee;"><a href="pview.jsp?probID=<%= list.get(i).getProbID() %>"><%= list.get(i).getProbTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></a></a></td>
						<td style="background-color: #eeeeee;"><%= list.get(i).getProbContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></td>
						<td style="background-color: #eeeeee;"><%= list.get(i).getProbDate().substring(0, 11) + list.get(i).getProbDate().substring(11, 13) + "시" + list.get(i).getProbDate().substring(14, 16) + "분 " %></td>
					</tr>
				<%	}
					 else { %>	
					<tr>
						<td><%= list.get(i).getProbSt() %></td>
						<td><a href="pview.jsp?probID=<%= list.get(i).getProbID() %>"><%= list.get(i).getProbTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></td>
						<td><%= list.get(i).getProbContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></td>
						<td><%= list.get(i).getProbDate().substring(0, 11) + list.get(i).getProbDate().substring(11, 13) + "시" + list.get(i).getProbDate().substring(14, 16) + "분 " %></td></td>
					</tr>
			<% 		} %>
					<%		
						}
					%>
                    </thead>
                </table>
                
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>