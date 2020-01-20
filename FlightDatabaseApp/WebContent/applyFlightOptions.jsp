<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
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
</style>


<body>

<%
	try {	

		char ch='"';

		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		Statement stmt = con.createStatement();
		String command;
	

		//true if meal ordered
		boolean meal = (request.getParameter("specialMeal") != null);
		
		String seatclass = request.getParameter("seatClass");
		String dept_date = "lol", dept_date1 = "oh my god please work";
		int fare = 0, fare1 = 0;
		int ticketid = 0;
		int accountID = 0;
		String un = (String)request.getSession().getAttribute("user");
	
		//get accountID of user
		command = ("SELECT accountID FROM Accounts WHERE username = " + "'" + un + "'");
		ResultSet result = stmt.executeQuery(command);
		if (result.next()){
			accountID  = result.getInt("accountID");
			session.setAttribute("accountID", accountID);
		}
		
		int flight_no = Integer.valueOf((String)session.getAttribute("flightid"));
		
		
		
		//FOR TWO FLIGHTS
		if(session.getAttribute("flightid1") != null){
			int flight_no1 = Integer.valueOf((String)session.getAttribute("flightid1"));

			//find departure date
			command = ("SELECT DATE_FORMAT(depart_time, '%Y-%m-%d %H:%i:%s') AS departdate FROM departsFrom WHERE flight_no = " + flight_no);

			result = stmt.executeQuery(command);
			if (result.next()){
				dept_date = result.getString("departdate");
			}
			
			//dept date for second flight
			command = ("SELECT DATE_FORMAT(depart_time, '%Y-%m-%d %H:%i:%s') AS departdate FROM departsFrom WHERE flight_no = " + flight_no1);
			result = stmt.executeQuery(command);
			if (result.next()){
				dept_date1 = result.getString("departdate");
			}
			
			
			//retrieve base price for flight from database
			command = ("SELECT price FROM Flight WHERE flight_no = " + flight_no);
			result = stmt.executeQuery(command);
			if (result.next()){
				fare = result.getInt("price");
			}
			
			//second flight price
			command = ("SELECT price FROM Flight WHERE flight_no = " + flight_no1);
			result = stmt.executeQuery(command);
			if (result.next()){
				fare1 = result.getInt("price");
			}
			
			//adjust fare for class 
			if (seatclass.equals("first")) {
				fare += 550;
				fare1 += 550;
			}
			if (seatclass.equals("business")) {
				fare += 250;
				fare1 += 250;
			}
			
			
			//check if both flights have available seats
			command = ("SELECT num_passengers FROM Flight WHERE flight_no = " + flight_no + "\nUNION ALL\n" + 
					"SELECT a.num_seats as num_passengers FROM Aircraft a, Flight f WHERE f.flight_no =" + flight_no + " and f.aircraftid = a.aircraftid;");	
			result = stmt.executeQuery(command);
			if (result.next()){
				
				int current_passengers = 0 , max_passengers = 0, current_passengers1 = 0, max_passengers1 = 0;
				current_passengers = result.getInt("num_passengers");
				result.next();
				max_passengers = result.getInt("num_passengers");
				//out.print("why. ");
				command = ("SELECT num_passengers FROM Flight WHERE flight_no = " + flight_no1 + "\nUNION ALL\n" + 
						"SELECT a.num_seats as num_passengers FROM Aircraft a, Flight f WHERE f.flight_no =" + flight_no1 + " and f.aircraftid = a.aircraftid;");
				result = stmt.executeQuery(command);
				if (result.next()){
					current_passengers1 = result.getInt("num_passengers");
					result.next();
					max_passengers1 = result.getInt("num_passengers");
				}
						

				if ((current_passengers < max_passengers) && (current_passengers1 < max_passengers1)){		//BOTH flights have room			
					
					
					out.println("You have purchased your ticket for the following flight: \n");
					
					 //insert flight info into ticket table
					command = ("INSERT INTO Tickets (seat, class, fare, dept_date, meal) VALUES (" + (current_passengers+1) + ", '" + seatclass + 
							"', " + fare + ", STR_TO_DATE('" + dept_date + "', '%Y-%m-%d %H:%i:%s'), " + meal + ");");
					stmt.executeUpdate(command);
					
					
					//get generated ticket id
					command = ("SELECT LAST_INSERT_ID()");
					result = stmt.executeQuery(command);
					if (result.next()){
						ticketid = result.getInt("LAST_INSERT_ID()");
						out.println("Your ticket number is " + ticketid); 
					}				

					//insert ticket_no and both flight_no into flightsOnTicket table	
					command = ("INSERT INTO flightsOnTicket VALUES ((SELECT ticket_no FROM Tickets WHERE ticket_no = LAST_INSERT_ID()), " + flight_no + 
							"), ((SELECT ticket_no FROM Tickets WHERE ticket_no = LAST_INSERT_ID()), " + flight_no1 + ");");
					stmt.executeUpdate(command);
					

					//insert purchase info into buysTicket table
					command = ("INSERT INTO buysTicket VALUES (" + ticketid + ", " + accountID + ", NOW(), 25)"); //25 dollar booking fee ? 
					stmt.executeUpdate(command);
					
					
					
					
					//increment the number of passengers on first flight
					command = ("UPDATE Flight SET num_passengers = " + (current_passengers+1) + " WHERE flight_no = " +  flight_no);
					stmt.executeUpdate(command);

					//increment the number of passengers on second flight
					command = ("UPDATE Flight SET num_passengers = " + (current_passengers1+1) + " WHERE flight_no = " +  flight_no1);
					stmt.executeUpdate(command);


					
				} 
				
				if ((current_passengers < max_passengers) && (current_passengers1 >= max_passengers1)){		//no room on the SECOND flight
					out.println("There are no seats available on your connecting flight."); 
			
		
					
					out.print(" <button onclick="+ch+"sendTwoWaitlist"+"(" + flight_no1 +")"+ch+">Enter the waiting lists for that flight</button>  ");					
							
				
				}
				if ((current_passengers >= max_passengers) && (current_passengers1 < max_passengers1)){		//no room on the FIRST flight
					out.println("There are no seats available on your first flight."); 
			
		
					out.print(" <button onclick="+ch+"sendWaitlist"+"("+flight_no+")"+ch+">Enter waiting list</button>  ");

					
				
				} if ((current_passengers >= max_passengers) && (current_passengers1 >= max_passengers1)) {	//both flights are full
					out.println("Sorry, these flights are full.");
				
				
					out.print(" <button onclick="+ch+"sendTwoWaitlist"+"("+flight_no+", " + flight_no1 +")"+ch+">Enter the waiting lists for these flights</button>  ");

				
				
			
				}
						
			}
			
		} else {	// FOR SINGLE FLIGHTS
			
			//find departure date
			command = ("SELECT DATE_FORMAT(depart_time, '%Y-%m-%d %H:%i:%s') AS departdate FROM departsFrom WHERE flight_no = " + flight_no);

			result = stmt.executeQuery(command);
			if (result.next()){
				dept_date = result.getString("departdate");
			}
			
			
			
			//retrieve base price for flight from database
			command = ("SELECT price FROM Flight WHERE flight_no = " + flight_no);
			result = stmt.executeQuery(command);
			if (result.next()){
				fare = result.getInt("price");
			}

			
			//adjust fare for class 
			if (seatclass.equals("first")) {
				fare += 550;
			}
			if (seatclass.equals("business")) {
				fare += 250;
			}

			
			
			
			//check if selected flight has available seats
			command = ("SELECT num_passengers FROM Flight WHERE flight_no = " + flight_no + "\nUNION ALL\n" + 
					"SELECT a.num_seats as num_passengers FROM Aircraft a, Flight f WHERE f.flight_no =" + flight_no + " and f.aircraftid = a.aircraftid;");	
			result = stmt.executeQuery(command);
			if (result.next()){
				int current_passengers = result.getInt("num_passengers");
				result.next();
				int max_passengers = result.getInt("num_passengers");
						
				//creates new ticket tuple if available seats
				if (current_passengers < max_passengers){
					out.println("You have purchased your ticket for this flight: \n");
							
							
					command = ("INSERT INTO Tickets (seat, class, fare, dept_date, meal) VALUES (" + (current_passengers+1) + ", '" + seatclass + 
									"', " + fare + ", STR_TO_DATE('" + dept_date + "', '%Y-%m-%d %H:%i:%s'), " + meal + ");");
					stmt.executeUpdate(command);
						
							
					//get generated ticket id
					command = ("SELECT LAST_INSERT_ID()");
					result = stmt.executeQuery(command);
					if (result.next()){
						ticketid = result.getInt("LAST_INSERT_ID()");
						out.println("Your ticket number is " + ticketid); 
					}				

					//insert ticket_no and flight_no into flightsOnTicket table	
					command = ("INSERT INTO flightsOnTicket VALUES ((SELECT ticket_no FROM Tickets WHERE ticket_no = LAST_INSERT_ID()), " + flight_no + ")");
					stmt.executeUpdate(command);
							

					//insert purchase info into buysTicket table
					command = ("INSERT INTO buysTicket VALUES (" + ticketid + ", " + accountID + ", NOW(), 25)"); //25 dollar booking fee ? 
					stmt.executeUpdate(command);
					
					//increment the number of passengers on flight
					command = ("UPDATE Flight SET num_passengers = " + (current_passengers+1) + " WHERE flight_no = " +  flight_no);
					stmt.executeUpdate(command);
							
							
				} else {
					out.println("There are no seats available on this flight."); 
					
					out.print(" <button onclick="+ch+"sendWaitlist"+"("+flight_no+")"+ch+">Enter waiting list</button>  ");
	
								
								
						
				}
			}
			
		}
		
		

		
				
		//show details of flight(s) on this ticket

		command = ("SELECT ft.flight_no, df.depart_time, df.airport_id as oairport, aa.arrive_time, aa.airport_id as dairport, op.airlineid FROM flightsOnTicket ft, departsFrom df, arrivesAt aa, operatesFlight op WHERE ft.ticket_no = "
				 + ticketid + " and ft.flight_no = df.flight_no and df.flight_no = aa.flight_no and op.flight_no = df.flight_no");
		//out.println(command);
		result = stmt.executeQuery(command);
		
		out.print("<table id = 'flightdetails'>");
		out.print("<th>Flight ID</th>");
		out.print("<th>Departure Time</th>");
		out.print("<th>Origin</th>");
		out.print("<th>Arrival Time</th>");
		out.print("<th>Destination</th>");
		out.print("<th>Airline</th>");
		out.print("<th>Price</th>");
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
			
			out.print("<td>");			
			out.print(fare);
			out.print("</td>");
			
			out.print("</tr>");
		}
		out.print("</table>");
		
	
		
	} catch (Exception e) {
		out.print(e);
	}
		
%>

<input type="button" value="Back to main page" onclick="window.location.href='login.jsp';"/>
			
			<%	
		
%>
<script>
	var x, y;
	function sendWaitlist(x) {
	
		window.location="waitlist.jsp?param=" + x;
	}
	
	function sendTwoWaitlist(x, y) {
	
		window.location="waitlist.jsp?param=" + x + "&param1=" + y;
	
	}
	
	
	</script>



</body>
</html>