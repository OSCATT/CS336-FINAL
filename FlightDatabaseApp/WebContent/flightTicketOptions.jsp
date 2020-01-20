<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Select Flight Options</title>
</head>
<body>

<%


String var = request.getParameter("param");
session.setAttribute("flightid", var);

String var1 = request.getParameter("param1");
session.setAttribute("flightid1", var1);

%>

<form method="post" action="applyFlightOptions.jsp">
<table>
<tr><td><input type="checkbox" name="specialMeal" value="yes" />Order Special Meal
</td></tr>

<tr><td>


<select name="seatClass">
  <option value="economy">Economy</option>
  <option value="business">Business</option>
  <option value="first">First</option>
</select>

</td></tr>

<tr><td>


<input type="submit" value="Book Flight" />


</td></tr>
</table>
</form>


</body>
</html>