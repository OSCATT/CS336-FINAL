<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<a href="/CS336/login.jsp">main menu</a>
<br>
	<%
	    
		try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT * FROM " + entity;
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			if (entity.equals("Accounts"))
				out.print("Account information");
			
			
			out.print("<table>");
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");


				out.print(result.getString("first_name"));
				out.print("---");	
				out.print(result.getString("last_name"));
				out.print("---");
				out.print(result.getString("username"));
				out.print("---");
				out.print(result.getString("password"));
				out.print("</td>");
				out.print("<td>");


				if (entity.equals("Accounts"))
					out.print(result.getString("accountID"));
				else
					out.print("not account");
				out.print("</td>");
				out.print("</tr>");
			}
			//Make an HTML table to show the results in:
			out.print("</table>");

			//close the connection.
			db.closeConnection(con);
		} catch (Exception e) {
			out.print(e);
		}
	
	%>

</body>
</html>