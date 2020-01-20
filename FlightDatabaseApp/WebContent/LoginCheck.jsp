<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
	
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>verification</title>
</head>
<body>
	<%
	try {


		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		Statement stmt = con.createStatement();

		String username = request.getParameter("uname");
		String password = request.getParameter("pword");				
		char ch = '"';
		if(username.equals("ADMIN")&password.equals("ADMIN")){
			%>
			    	<form action="/CS336/adminPage.jsp">
    	<input type="submit" value="logout" />
		</form>
			<%
		}
		else{
			Statement st = con.createStatement();
    ResultSet rs;
    rs = st.executeQuery("select * from Accounts where username='" + username + "' and password='" + password + "'");
    if (rs.next()) {
        session.setAttribute("user", username);
        out.println("welcome " + username);
        out.println("<a href='logout.jsp'>Log out</a>");
        response.sendRedirect("login.jsp");
    } else {
        out.println("Invalid password <a href='login.jsp'>try again</a>");
    }
		}		
	
				
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
%>
	    
		

</body>
</html>