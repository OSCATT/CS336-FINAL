<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
	
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>account update</title>
</head>
<body>
	<%
	try {


 		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();


		Statement stmt = con.createStatement(); 

		String accountID = request.getParameter("accountID");
		String firstname = request.getParameter("fname");
		String lastname = request.getParameter("lname");
		String username = request.getParameter("uname");
		String password = request.getParameter("pword");
	if (username.equals("ADMIN")){
		out.print(" cant change admin info");
		out.print("<br>");		
	}
	else{
		String command = ("UPDATE Accounts SET first_name = '" + firstname + "', last_name = '" + lastname + "', username = '" + username + "', password = '"
				+ password + "' WHERE accountID = " + accountID);
		
		stmt.executeUpdate(command);
		out.print("update successful");
	}
		con.close(); 
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("update failed");
	}
%>
	    <br>
		<a href="adminPage.jsp">Go back to admin page</a>

</body>
</html>