<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
	
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>account creation</title>
</head>
<body>
	<%
	try {


		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();


		Statement stmt = con.createStatement();

	
		String firstname = request.getParameter("fname");
		String lastname = request.getParameter("lname");
		String username = request.getParameter("uname");
		String password = request.getParameter("pword");


		String insert = "INSERT INTO Accounts(first_name, last_name, username, password)"
				+ "VALUES (?,?,?,?)";
		
		PreparedStatement ps = con.prepareStatement(insert);

		
		ps.setString(1, firstname);
		ps.setString(2, lastname);
		ps.setString(3, username);
		ps.setString(4, password);
		
		ps.executeUpdate();
				
		con.close();
		out.print("insert succeeded");
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
%>
	    
		

</body>
</html>