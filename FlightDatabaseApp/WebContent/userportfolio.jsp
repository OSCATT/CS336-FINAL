<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Your Past/Upcoming Flights</title>
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
	
h1 { width: 100%;
text-align: center;
background: black;
color: white;
padding: 9px;
}
</style>
<body>

<%
	try {


		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		Statement stmt = con.createStatement();
		String command;
		int accountID = 0;
		char ch = '"';
		//get accountID of user
		String un = (String)request.getSession().getAttribute("user");
		command = ("SELECT accountID FROM Accounts WHERE username = " + "'" + un + "'");
		ResultSet result = stmt.executeQuery(command);
		if (result.next()){
			accountID  = result.getInt("accountID");
			session.setAttribute("accountID", accountID);
		}
		
		
		//upcoming flights
		command=("SELECT ft.flight_no, df.airport_id as origin, df.depart_time, aa.airport_id as destination, aa.arrive_time, op.airlineid," + 
				" t.ticket_no, t.seat, t.class, t.fare " + 
				"FROM buysTicket bt, flightsOnTicket ft, departsFrom df, arrivesAt aa, Tickets t, operatesFlight op " + 
				"WHERE bt.accountID = " + accountID +  " AND bt.ticket_no = ft.ticket_no AND ft.flight_no = df.flight_no and ft.flight_no = aa.flight_no and ft.ticket_no = t.ticket_no and ft.flight_no = op.flight_no" +
				" and df.depart_time >= NOW();");
		result = stmt.executeQuery(command);
		//out.println(command);
		
		out.print("<h1>Upcoming Flights</h1>");
		out.print("<table id =upcomingFlights>");
		int i = 1;
		while(result.next()){
			
			out.print("<th colspan='5' style='background:#aaaaaa; height:25px;'></th>");

			
			out.print("<tr>");
			
			out.print("<th>Airline</th>");
			out.print("<th>Flight ID</th>");
			out.print("<th>Origin</th>");
			out.print("<th>Destination</th>");
			out.print("<th>Class</th>");


			
			out.print("</tr>");
			
			out.print("<tr>");
			
			out.print("<td>");			
			out.print(result.getString("airlineid"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("flight_no"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("origin"));
			out.print("</td>");
		
			out.print("<td>");			
			out.print(result.getString("destination"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("class"));
			out.print("</td>");
			
			out.print("</tr>");
			
			
			
			
			
			out.print("<tr>");
		
			out.print("<th>Ticket ID</th>");
			out.print("<th>Seat Number</th>");
			out.print("<th>Departure Time</th>");
			out.print("<th>Arrival Time</th>");
			out.print("<th>Fare</th>");
			out.print("</tr>");
			
			
			
			out.print("<tr>");
			
			out.print("<td>");			
			out.print(result.getString("ticket_no"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("seat"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("depart_time"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("arrive_time"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("fare"));
			out.print("</td>");
			
			out.print("</tr>");
			
			out.print("<th colspan='5' style='background:#aaaaaa; height:25px;'>");
						
			out.print(" <button onclick="+ch+"deleteTicket"+"("+i+")"+ch+">Cancel this flight</button> ");
			out.print("</th>");	
			i++;
			
		}
		
	%>
		</table>
		<%
		
		
		//past flights
		command=("SELECT ft.flight_no, df.airport_id as origin, df.depart_time, aa.airport_id as destination, aa.arrive_time, op.airlineid," + 
				" t.ticket_no, t.seat, t.class, t.fare " + 
				"FROM buysTicket bt, flightsOnTicket ft, departsFrom df, arrivesAt aa, Tickets t, operatesFlight op " + 
				"WHERE bt.accountID = " + accountID +  " AND bt.ticket_no = ft.ticket_no AND ft.flight_no = df.flight_no and ft.flight_no = aa.flight_no and ft.ticket_no = t.ticket_no and ft.flight_no = op.flight_no" +
				" and df.depart_time < NOW();");
		result = stmt.executeQuery(command);
		//out.println(command);
		
		out.print("<h1>Past Flights</h1>");
		out.print("<table>");
	
		while(result.next()){
			
			out.print("<th colspan='5' style='background:#aaaaaa; height:25px;'></th>");

			
			out.print("<tr>");
			
			out.print("<th>Airline</th>");
			out.print("<th>Flight ID</th>");
			out.print("<th>Origin</th>");
			out.print("<th>Destination</th>");
			out.print("<th>Class</th>");


			
			out.print("</tr>");
			
			out.print("<tr>");
			
			out.print("<td>");			
			out.print(result.getString("airlineid"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("flight_no"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("origin"));
			out.print("</td>");
		
			out.print("<td>");			
			out.print(result.getString("destination"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("class"));
			out.print("</td>");
			
			out.print("</tr>");
			
			
			
			
			
			out.print("<tr>");
		
			out.print("<th>Ticket ID</th>");
			out.print("<th>Seat Number</th>");
			out.print("<th>Departure Time</th>");
			out.print("<th>Arrival Time</th>");
			out.print("<th>Fare</th>");
			out.print("</tr>");
			
			
			
			out.print("<tr>");
			
			out.print("<td>");			
			out.print(result.getString("ticket_no"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("seat"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("depart_time"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("arrive_time"));
			out.print("</td>");
			
			out.print("<td>");			
			out.print(result.getString("fare"));
			out.print("</td>");
			
			out.print("</tr>");
			
			
			out.print("<th colspan='5' style='background:#aaaaaa; height:25px;'></th>");

			
		}
		
		
	} catch (Exception e) {
		out.print(e);
	}
		
		
		

%>
<script>
			var x,y;
			function deleteTicket(i) {
				a = (5*i)-1;
				x = document.getElementById("upcomingFlights").rows[a].cells[0].innerHTML;
				a = (5*i)-3;
				y = document.getElementById("upcomingFlights").rows[a].cells[4].innerHTML;
				//var s= document.getElementById("id");
				//s.value = x;
				//alert(x);
				window.location="/CS336/deleteTicket.jsp?param="+x+"&param1="+y;
				}
</script>
</body>
</html>