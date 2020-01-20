<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
	
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Edit User Info</title>
</head>
<body>

<%	

	String accountID = request.getParameter("param");
			
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();

	Statement stmt = con.createStatement();


	
%>

Current account information:<br>

<table>
<tr>
	<th>Account Number</th>
	<th>First Name</th>
	<th>Last Name</th>
	<th>Username</th>
	<th>Password</th>
	</tr>
<%

String command = ("SELECT * FROM Accounts WHERE accountID = " + accountID);
ResultSet result = stmt.executeQuery(command);

try {
	
	while (result.next()) {
		out.print("<tr>");
		
		out.print("<td>");		
		out.print(result.getString("accountID"));
		out.print("</td>");	
		
		out.print("<td>");		
		out.print(result.getString("first_name"));
		out.print("</td>");	
		
		out.print("<td>");		
		out.print(result.getString("last_name"));
		out.print("</td>");	
		
		out.print("<td>");		
		out.print(result.getString("username"));
		out.print("</td>");	

		out.print("<td>");		
		out.print(result.getString("password"));
		out.print("</td>");		
	

	} 
	
	
} catch (Exception e) {
	out.print(e);
}
	




%>
</table>







Enter new information:<br>
<form method="post" action="updateAccount.jsp">
	<table>
<%
	out.print("<input type='hidden' name='accountID' value ='" + accountID + "'>");
%>
	
		<tr>
			<td>first name</td>
			<td><input type="text" name="fname" ></td>
		</tr>
		<tr>
			<td>last name</td>
			<td><input type="text" name="lname"></td>
		</tr>
		<tr>
			<td>username</td>
			<td><input type="text" name="uname"></td>
		</tr>
		<tr>
			<td>password</td>
			<td><input type="text" name="pword"></td>
		</tr>
	</table>
	<input type="submit" value="Update">
</form>




</body>
</html>