<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
	
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Secret actions</title>
<link href="StyleSheet.css" rel="stylesheet" type="text/css">
</head>
<body>
<h1 class= "text-shadow">Admin Terminal</h1>

<%
	//---------------------------------------------------
	// add an input to get flight info based off number 
	try {


		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		Statement stmt = con.createStatement();
		Statement st = con.createStatement();
    	ResultSet result;
    	String airport = request.getParameter("airport");
    	String command;
    	String type = request.getParameter("param");
    	String fname = request.getParameter("fname");
    	String lname = request.getParameter("lname");
    	String fnum = request.getParameter("flightNumber");
    	out.print("type of request: "+ type);
    	out.print("<br>");
    	
    	if(type.equals("listfromAirport")){
    		
    		command = "SELECT (d.airport_id) dID, (a.airport_id) aID, (depart_time) dept, arrive_time arrive_time, (d.flight_no) flight_no,(f.price) price"
    		+" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
    		+" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
    		+" and d.flight_no in (SELECT flight_no FROM departsFrom WHERE airport_id = '"+airport+"');";

    		result = stmt.executeQuery(command);
    		out.print("Departing from " + airport);
    		out.print("<br>");
    		
    		while (result.next()) {
    			out.print("FLIGHT NUMBER " + result.getInt("flight_no")+", From "+ result.getString("dID") + " To " + result.getString("aID"));
    			out.print("<br>");
    		}
    		
    		out.print("<br>");
    		out.print("Arriving at " + airport +", ");
    		out.print("<br>");
    		
    		command = "SELECT (d.airport_id) dID, (a.airport_id) aID, (depart_time) dept, arrive_time arrive_time, (d.flight_no) flight_no,(f.price) price"
    	    		+" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
    	    		+" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
    	    		+" and d.flight_no in (SELECT flight_no FROM arrivesAt WHERE airport_id = '"+airport+"');";
    		
    		result = stmt.executeQuery(command);
    		
    		while (result.next()) {
    			out.print("FLIGHT NUMBER " + result.getInt("flight_no")+", From "+ result.getString("dID") + " To " + result.getString("aID"));
    			out.print("<br>");
    		}
    		
    		
    	}
    	
    	if(type.equals("reservationByFlight")){
    		
    		command = "SELECT * FROM flightsOnTicket WHERE flight_no ='"+fnum+"';";
    		result = stmt.executeQuery(command);
    		out.print("tickets reserved for flight "+fnum);
    		out.print("<br>");		
    		out.print("<table>");
        	while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
					out.print(result.getInt("ticket_no"));
				out.print("</td>");
    	}
    	}
    	
    	if(type.equals("reservationByName")){
    		
        	command = "SELECT bt.ticket_no, a.first_name, a.last_name"
        			+ " FROM buysTicket bt, Accounts a"
        			+ " WHERE a.first_name = '"+fname+"' and a.last_name = '"+lname+"' and a.accountid = bt.accountID";
        	result = stmt.executeQuery(command);
        	
        	
        	out.print("tickets reserved for "+fname+ " "+lname);
    		out.print("<br>");	
        	
        	out.print("<table>");
        	while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
					out.print(result.getInt("ticket_no"));
				out.print("</td>");

        	
    	}
        	out.print("</table>");
	
    	}	
    	
    	if(type.equals("findMostActive")){
    		command = "SELECT num_passengers,flight_no FROM Flight,(Select (MAX(num_passengers))b FROM Flight)a WHERE num_passengers = a.b;";
    		result = stmt.executeQuery(command);
    		out.print("<table>");
    		while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
					out.print(" flight " + result.getInt("flight_no") + " has "+ result.getInt("num_passengers") + " tickets purchased");
				out.print("</td>");        	
    	}
        	out.print("</table>");   		
    		
    	}
    	
    	if(type.equals("findMostRevenue")){
    		int x =0;
    		String most = "";
    		command = "SELECT a.accountID , acc.first_name , acc.last_name, (a.fare + b.bftotal) total FROM (SELECT  accountID, SUM(fare) fare FROM buysTicket b, Tickets t WHERE b.ticket_no = t.ticket_no GROUP BY accountID) a , " 
    	+ " (SELECT accountID, SUM(booking_fee) as bftotal FROM buysTicket bt group by accountID) b ,Accounts acc WHERE a.accountID = b.accountID and acc.accountID = a.accountID";
    		result = stmt.executeQuery(command);
    		out.print("<table>");
    		while (result.next()){
    		if(result.getInt("total")>x){
    			x = result.getInt("total");
    			most = result.getString("first_name")+ ", " + result.getString("last_name");
    		}
				out.print("<tr>");
				out.print("<td>");
					out.print(" Account number " + result.getInt("accountID") + "("+result.getString("first_name")+ ", " + result.getString("last_name")+ ")" + " has "+ result.getInt("total") + " revenue Generated");
				out.print("</td>");        	
    	}
        	out.print("</table>");   		
        	out.print(most + " has the most revenue generated with $"+ x);
    	}
    	
    	if(type.equals("revenueByAirline")){
    		String ID = request.getParameter("airlineID");
    		command = "SELECT  x.airlineid , (x.revenue) total FROM (SELECT a.airlineid, a.name, (SUM(t.fare) + bf.bftotal) as revenue FROM Airline a, operatesFlight o, flightsOnTicket f, buysTicket b, Tickets t,"
    						+" (SELECT o.airlineid, SUM(booking_fee) as bftotal FROM buysTicket bt, flightsOnTicket ft, Flight f, operatesFlight o WHERE bt.ticket_no = ft.ticket_no and ft.flight_no = f.flight_no and f.flight_no = o.flight_no"
    						+ " group by o.airlineid) bf WHERE a.airlineid = o.airlineid and o.flight_no = f.flight_no and f.ticket_no = b.ticket_no and b.ticket_no = t.ticket_no and a.airlineid = bf.airlineid GROUP BY a.airlineid) x"
    						+ " WHERE x.airlineID = '"+ID+"'";
    		result = stmt.executeQuery(command);
    		
    		out.print("<table>");
    		while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
					out.print(" airline " + result.getString("airlineid") + " has $"+ result.getInt("total") + " of revenue generated");
				out.print("</td>");        	
    	}
        	out.print("</table>");   		
    		
    	}
    	
    	
    	if(type.equals("revenueByFlight")){
    		String ID = request.getParameter("airlineID");
    		command = "SELECT ft.flight_no, (SUM(fare)+bftotal) as revenue"
    				+" FROM Tickets t, flightsOnTicket ft, buysTicket bt,"
    				+" (SELECT ft.flight_no, SUM(booking_fee) as bftotal FROM buysTicket bt, flightsOnTicket ft"
    				+" WHERE ft.ticket_no = bt.ticket_no group by flight_no) bfee"
    				+" WHERE t.ticket_no = ft.ticket_no and t.ticket_no = bt.ticket_no and ft.flight_no = bfee.flight_no"
    				+" GROUP BY flight_no ";
    		result = stmt.executeQuery(command);
    		
    		out.print("<table>");
    		while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
					out.print(" Flight " + result.getString("flight_no") + " has $"+ result.getInt("revenue") + " of revenue generated");
				out.print("</td>");        	
    	}
        	out.print("</table>");   		
    		
    	}
    	
    	
    	
		con.close();
    		
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
%>

</body>
</html>