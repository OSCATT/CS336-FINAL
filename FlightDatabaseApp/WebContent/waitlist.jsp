<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>waitlist</title>
</head>
<style>
table {
  font: 12pt verdana;
  width: 100%;
}
th { background: #eeeeee}

td, th {
  border: 1px solid #dddddd;
  text-align: center;
  padding:8px;
}
a {
	font-family: 'Comic Sans MS';
	font-size: 20px;
	color: white;
	background: blue;
	border: 4px dashed red;
	width:200px;
	padding: 5px;
	}
</style>
<body>
<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		Statement stmt = con.createStatement();
		String command;
		
		String username = (String)session.getAttribute("user");

		
		String flight_no = request.getParameter("param");
		//out.println(flight_no);
	
		String flight_no1 = request.getParameter("param1");
		//out.println(flight_no1);
		
		int waitlistid=0;

	
		

		
 		command = ("INSERT INTO isOnWaitlist (username) VALUES ('" + username + "');");
		stmt.executeUpdate(command);
		
		command = ("INSERT INTO hasWaitlist (flight_no, waitlistid) VALUES (" + flight_no + ", LAST_INSERT_ID());");
		stmt.executeUpdate(command);
		
		//get generated waitlist id
		command = ("SELECT LAST_INSERT_ID()");
		ResultSet result = stmt.executeQuery(command);
		if (result.next()){
			waitlistid = result.getInt("LAST_INSERT_ID()");
			out.println("Your waitlist number is " + waitlistid); 
		} 
		
		//there's a second flight to be waitlisted for
		if(flight_no1 != null){
			//waitlists both flights under one waitlist entry
			command = ("INSERT INTO hasWaitlist (flight_no, waitlistid) VALUES (" + flight_no1 + ", " + waitlistid);
			stmt.executeUpdate(command);	
		}
		

		
		
		out.println("You have been entered into the waiting list for the following flight(s): ");
		


		//show details of flights on this ticket
		command = ("SELECT df.flight_no, df.depart_time, df.airport_id as oairport, aa.arrive_time, aa.airport_id as dairport, op.airlineid " +
		"FROM departsFrom df, arrivesAt aa, operatesFlight op, hasWaitlist hw WHERE hw.waitlistid = " + waitlistid +  
				" and df.flight_no = hw.flight_no and df.flight_no = aa.flight_no and aa.flight_no = op.flight_no");
		result = stmt.executeQuery(command);
		//out.print(command);
		
		out.print("<table id = 'flightdetails'>");
		out.print("<th>Flight ID</th>");
		out.print("<th>Departure Time</th>");
		out.print("<th>Origin</th>");
		out.print("<th>Arrival Time</th>");
		out.print("<th>Destination</th>");
		out.print("<th>Airline</th>");
		while(result.next()){
			out.print("<tr>");
			
			out.print("<td>");			
			out.print(result.getString("flight_no"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("depart_time"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("oairport"));
			out.print("</td>");

			out.print("<td>");			
			out.print(result.getString("arrive_time"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("dairport"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("airlineid"));
			out.print("</td>");
			
			out.print("</tr>");
			


		} 
		out.print("</table>");
		%>
		
		<br><br>
		<center>
		<a href="login.jsp" title="graphic design is my passion">Back to main page</a>
		
		
		</center>
		
		
		
		<% 
		/*
		String redirectURL = "login.jsp";
	    response.sendRedirect(redirectURL);
		*/
	} catch (Exception e) {
		out.print(e);
	}

%>
</body>
</html>