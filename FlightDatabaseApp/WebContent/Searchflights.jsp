<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
	
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<style>
table, td {
  border: 1px solid black;
}
</style>
<style>
Button {
	background-color:#768d87;
	-moz-border-radius:8px;
	-webkit-border-radius:8px;
	border-radius:8px;
	border:1px solid #566963;
	display:inline-block;
	cursor:pointer;
	color:#ffffff;
	font-family:Arial;
	font-size:18px;
	font-weight:bold;
	padding:7px 14px;
	text-decoration:none;
}
Button:hover {
	background-color:#6c7c7c;
}
Button:active {
	position:relative;
	top:1px;
}
</style>
<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(odd) {
  background-color: #dddddd;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search results</title>
</head>
<body>

<br>

<%



	try {


		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		Statement stmt = con.createStatement();

		String numStops = request.getParameter("numStops");
		String startDate = request.getParameter("trip-start");
		String endDate = request.getParameter("trip-return");
		
		String departure = request.getParameter("DepartFrom");
		String destination = request.getParameter("ArriveAt");
		
		String type = request.getParameter("type");
		String flexible = request.getParameter("flexibleDate");	
		String allowStops = request.getParameter("allowStops");
		//out.println(" START DATE: " + startDate + " RETURN DATE: " +  endDate + " TYPE: " + type + " DATE FLEXIBILITY: " + flexible + " Airport- from:" + departure + " Airport- To:" + destination);
		String command = "temp";
		ResultSet result;
		char ch='"';
		String temp = null;
		
		
		
		if(type.equals("oneWay")){
			//sorting options for one way flights
		%>
			<p>Click the button to sort the table by price:</p>
			<p><button onclick="sortTable1(6)">Price Low-High</button><button onclick="sortTable1(4)">Depart Low-High</button></p>
			<p><button onclick="sortTable2(6)">Price High-Low</button><button onclick="sortTable1(5)">Depart High-Low</button></p>
		<% 
			
			//STATEMENTS FOR flight oneway, no stops
			if(allowStops == null){
				if(flexible == null){
				command = "SELECT depart_time, (d.airport_id) dID, arrive_time, (a.airport_id) aID, airlineid, d.flight_no, f.price"
				+ " FROM departsFrom d, arrivesAt a, operatesFlight o,Flight f"
				+ " WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no  and f.flight_no = d.flight_no"
				+ " and DATE(depart_time) ='" + startDate + "'"
				+ " and d.airport_id ='" + departure + "'"
				+ " and a.airport_id ='" + destination + "'";
				}
				else{		
				command = "SELECT depart_time, (d.airport_id) dID, arrive_time, (a.airport_id) aID, airlineid, d.flight_no, f.price"
					+ " FROM departsFrom d, arrivesAt a, operatesFlight o,Flight f"
					+ " WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no"
					+ " and d.airport_id ='" + departure + "'"
					+ " and a.airport_id ='" + destination + "'"
					+ " and depart_time >= DATE_ADD( '" + startDate + "'"+", INTERVAL -3 DAY)"
					+ " and depart_time <= DATE_ADD('" + startDate + "'" +", INTERVAL 3 DAY)";
				}
				result = stmt.executeQuery(command);
				
				out.print("<table id="+"Flightdata"+">");
				out.print("<th>FlightNumber</th>");
				out.print("<th>FROM</th>");
				out.print("<th>TO</th>");
				out.print("<th>AIRLINE</th>");
				out.print("<th>DepartDate</th>");
				out.print("<th>ArriveDate</th>");
				out.print("<th>Price</th>");
				out.print("<th>SELECT FLIGHT</th>");
				
				//parse out the results
				int i = 1;
				while (result.next()) {
					//make a row
					out.print("<tr>");
					//make a column
					out.print("<td id ="+"flightnum"+i+">");
						out.print(result.getInt("flight_no"));
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("dID"));				
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("aID"));			
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("airlineid"));		
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("depart_time"));		
					out.print("</td>");
					out.print("<td>");			
					out.print(result.getString("arrive_time"));		
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("price"));		
					out.print("</td>");
					out.print("<td>");			
						out.print(" <button onclick="+ch+"myFunction1"+"("+i+")"+ch+">---BOOK---</button> ");
					out.print("</td>");	
					out.print("</tr>");
					
					i++;

				}
				out.print("</table>");
			}
		
		//command for flight oneway, stops allowed
		else{
			out.print("stops allowed");
			
			if(flexible == null){
				command = 	" SELECT (d.flight_no) flight1 , (null) flight2, (d.airport_id) dID1, (a.airport_id)aID1 ,(depart_time) depart1,(arrive_time) arrive1, (f.price) price1,(null) aID2,(null) dID2,(null) depart2,(null) arrive2,(f.price) totalprice"
						+	" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
						+   " and DATE(depart_time) ='" + startDate + "'"
						+	" and d.airport_id ='" + departure + "'"
						+	" and a.airport_id ='" + destination + "'"
						+	" UNION "
						+	" SELECT DISTINCT (x.flight_no) flight1, (d.flight_no) flight_no, x.dID , x.aID, x.d_t1, x.a_t1, x.price, (d.airport_id) dID,  (a.airport_id) aID, (d.depart_time) depart, (a.arrive_time) arrive, (f.price + x.price) price "
						+	" FROM(SELECT (d.airport_id) dID, (a.airport_id) aID,  (arrive_time) a_t1, (depart_time) d_t1, (d.flight_no) flight_no,(f.price) price "
						+	" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
						+   " and DATE(depart_time) ='" + startDate + "'"
						+	" and d.airport_id = '" + departure + "') x , departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and f.flight_no = d.flight_no and x.aID = d.airport_id "
						+	" and x.dID != a.airport_id "
						+	" and a.airport_id ='" + destination + "'"
						+	" and depart_time <= DATE_ADD('" + startDate + "' , INTERVAL 1 DAY) "
						+   " and depart_time > x.a_t1";
			}
			else{
			
			
		command = 	" SELECT (d.flight_no) flight1 , (null) flight2, (d.airport_id) dID1, (a.airport_id)aID1 ,(depart_time) depart1,(arrive_time) arrive1, (f.price) price1,(null) aID2,(null) dID2,(null) depart2,(null) arrive2,(f.price) totalprice"
				+	" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
				+	" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
				+	" and depart_time >= DATE_ADD( '" + startDate + "'"+", INTERVAL -3 DAY) "
				+	" and depart_time <= DATE_ADD('" + startDate + "'"+", INTERVAL 3 DAY) "
				+	" and d.airport_id ='" + departure + "'"
				+	" and a.airport_id ='" + destination + "'"
				+	" UNION "
				+	" SELECT DISTINCT (x.flight_no) flight1, (d.flight_no) flight_no, x.dID , x.aID, x.d_t1, x.a_t1, x.price, (d.airport_id) dID,  (a.airport_id) aID, (d.depart_time) depart, (a.arrive_time) arrive, (f.price + x.price) price "
				+	" FROM(SELECT (d.airport_id) dID, (a.airport_id) aID,  (arrive_time) a_t1, (depart_time) d_t1, (d.flight_no) flight_no,(f.price) price "
				+	" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
				+	" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
				+	" and depart_time >= DATE_ADD( '" + startDate + "' , INTERVAL -3 DAY) "
				+	" and depart_time <= DATE_ADD('" + startDate + "' , INTERVAL 3 DAY)"
				+	" and d.airport_id = '" + departure + "') x , departsFrom d, arrivesAt a, operatesFlight o, Flight f"
				+	" WHERE d.flight_no = a.flight_no and f.flight_no = d.flight_no and x.aID = d.airport_id "
				+	" and x.dID != a.airport_id "
				+	" and a.airport_id ='" + destination + "'"
				+	" and depart_time <= DATE_ADD('" + startDate + "' , INTERVAL 1 DAY) "
				+   " and depart_time > x.a_t1";
					
				}
			result = stmt.executeQuery(command);
			
			out.print("<table id="+"Flightdata"+">");
			out.print("<th>Flight1</th>");
			out.print("<th>Flight2</th>");
			out.print("<th>FROM</th>");
			out.print("<th>TO</th>");
			out.print("<th>DepartDate</th>");
			out.print("<th>ArriveDate</th>");
			out.print("<th>Price</th>");
			out.print("<th>FROM</th>");
			out.print("<th>TO</th>");
			out.print("<th>DepartDate</th>");
			out.print("<th>ArriveDate</th>");
			out.print("<th>Price</th>");
			out.print("<th>TOTAL</th>");
			out.print("<th>SELECT FLIGHT</th>");
			
			int i = 1;
			while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
					out.print(result.getInt("flight1"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getInt("flight2"));
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("dID1"));					
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("aID1"));				
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("depart1"));			
				out.print("</td>");	
				out.print("<td>");			
				out.print(result.getString("arrive1"));		
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("price1"));
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("dID2"));	
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("aID2"));				
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("depart2"));				
				out.print("</td>");
				out.print("<td>");			
				out.print(result.getString("arrive2"));		
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("totalprice"));
				out.print("</td>");	
				out.print("<td>");
					out.print(" <button onclick="+ch+"myFunction3"+"("+i+")"+ch+">---BOOK---</button> ");
				out.print("</td>");				
				out.print("</tr>");
				i++;

			}
			out.print("</table>");
		}
		
				//out.println(command);	
		
		
		
	}
		
		
		else{
			
			//Sorting options for roundtrip flights
			%> 
			
			<p>Click the button to sort</p>
			<p><button onclick="sortTable1(14)">Price Low-High</button><button onclick="sortTable1(4)">Depart Date</button><button onclick="sortTable1(5)">Arrival Date</button></p>
			<p><button onclick="sortTable2(14)">Price High-Low</button><button onclick="sortTable1(11)">Depart_return</button><button onclick="sortTable1(12)">Arrival_return</button></p>
			<br>			
			<% 
			if(allowStops == null){
			if(flexible == null){
				command = "SELECT *,(price1 + price2) total FROM"					
						+ "(SELECT (depart_time) depart_time_1, (d.airport_id) dID_1, (arrive_time) arrive_time_1, (a.airport_id) aID_1, (airlineid) airlineid_1, (d.flight_no) flight_no_1, (f.price) price1"
						+ " FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+ " WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
						+ " and DATE(depart_time) ='" + startDate + "'"
						+ " and d.airport_id ='" + departure + "'"
						+ " and a.airport_id ='" + destination + "')a"
						+ " CROSS JOIN "
						+ "(SELECT (depart_time) depart_time_2, (d.airport_id) dID_2, (arrive_time) arrive_time_2, (a.airport_id) aID_2, (airlineid) airlineid_2, (d.flight_no) flight_no_2, (f.price) price2"
						+ " FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+ " WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no"
						+ " and DATE(depart_time) ='" + endDate + "'"
						+ " and a.airport_id ='" + departure + "'"
						+ " and d.airport_id ='" + destination + "')b";
				}			
			else{		
				command = "SELECT *,(price1 + price2) total FROM"					
						+ "(SELECT (depart_time) depart_time_1, (d.airport_id) dID_1, (arrive_time) arrive_time_1, (a.airport_id) aID_1, (airlineid) airlineid_1 , (d.flight_no) flight_no_1, (f.price) price1"
						+ " FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+ " WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
						+ " and depart_time >= DATE_ADD( '" + startDate + "'"+", INTERVAL -3 DAY)"
						+ " and depart_time <= DATE_ADD('" + startDate + "'" +", INTERVAL 3 DAY)"
						+ " and d.airport_id ='" + departure + "'"
						+ " and a.airport_id ='" + destination + "')a"
						+ " CROSS JOIN "
						+ "(SELECT (depart_time) depart_time_2, (d.airport_id) dID_2, (arrive_time) arrive_time_2, (a.airport_id) aID_2, (airlineid) airlineid_2, (d.flight_no) flight_no_2, (f.price) price2"
						+ " FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+ " WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no"
						+ " and depart_time >= DATE_ADD( '" + endDate + "'"+", INTERVAL -3 DAY)"
						+ " and depart_time <= DATE_ADD('" + endDate + "'" +", INTERVAL 3 DAY)"
						+ " and a.airport_id ='" + departure + "'"
						+ " and d.airport_id ='" + destination + "')b";
				}
					result = stmt.executeQuery(command);
			
			out.print("<table id="+"Flightdata"+">");
			out.print("<th>FlightNumber</th>");
			out.print("<th>FROM</th>");
			out.print("<th>TO</th>");
			out.print("<th>AIRLINE</th>");
			out.print("<th>DepartDate</th>");
			out.print("<th>ArriveDate</th>");
			out.print("<th>Price</th>");
			out.print("<th>FlightNumber</th>");
			out.print("<th>FROM</th>");
			out.print("<th>TO</th>");
			out.print("<th>AIRLINE</th>");
			out.print("<th>DepartDate</th>");
			out.print("<th>ArriveDate</th>");
			out.print("<th>Price</th>");
			out.print("<th>TOTAL</th>");
			out.print("<th>SELECT FLIGHT</th>");
			
			//parse out the results
				int i = 1;
			while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
					out.print(result.getInt("flight_no_1"));
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("dID_1"));					
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("aID_1"));				
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("airlineid_1"));
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("depart_time_1"));			
				out.print("</td>");	
				out.print("<td>");			
				out.print(result.getString("arrive_time_1"));		
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("price1"));
				out.print("</td>");
				
				//out.print("<tr>");
				out.print("<td>");
					out.print(result.getInt("flight_no_2"));
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("dID_2"));	
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("aID_2"));				
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("airlineid_2"));				
				out.print("</td>");
				out.print("<td>");			
					out.print(result.getString("depart_time_2"));				
				out.print("</td>");
				out.print("<td>");			
				out.print(result.getString("arrive_time_2"));		
				out.print("</td>");
				out.print("<td>");				
					out.print(result.getString("price2"));
				out.print("</td>");	
				out.print("<td>");			
					out.print(result.getString("total"));
				out.print("</td>");	
				out.print("<td>");
					out.print(" <button onclick="+ch+"myFunction2"+"("+i+")"+ch+">---BOOK---</button> ");
				out.print("</td>");				
				out.print("</tr>");
				i++;

			}
			out.print("</table>");
			
			}
			
			else{
				out.print("stops allowed");
				
				command = 	" SELECT (d.flight_no) flight1 , (null) flight2, (d.airport_id) dID1, (a.airport_id)aID1 ,(depart_time) depart1,(arrive_time) arrive1, (f.price) price1,(null) aID2,(null) dID2,(null) depart2,(null) arrive2,(f.price) totalprice"
						+	" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
						+	" and depart_time >= DATE_ADD( '" + startDate + "'"+", INTERVAL -3 DAY) "
						+	" and depart_time <= DATE_ADD('" + startDate + "'"+", INTERVAL 3 DAY) "
						+	" and d.airport_id ='" + departure + "'"
						+	" and a.airport_id ='" + destination + "'"
						+	" UNION "
						+	" SELECT DISTINCT (x.flight_no) flight1, (d.flight_no) flight_no, x.dID , x.aID, x.d_t1, x.a_t1, x.price, (d.airport_id) dID,  (a.airport_id) aID, (d.depart_time) depart, (a.arrive_time) arrive, (f.price + x.price) price "
						+	" FROM(SELECT (d.airport_id) dID, (a.airport_id) aID,  (arrive_time) a_t1, (depart_time) d_t1, (d.flight_no) flight_no,(f.price) price "
						+	" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
						+	" and depart_time >= DATE_ADD( '" + startDate + "' , INTERVAL -3 DAY) "
						+	" and depart_time <= DATE_ADD('" + startDate + "' , INTERVAL 3 DAY)"
						+	" and d.airport_id = '" + departure + "') x , departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and f.flight_no = d.flight_no and x.aID = d.airport_id "
						+	" and x.dID != a.airport_id "
						+	" and a.airport_id ='" + destination + "'"
						+	" and depart_time <= DATE_ADD('" + startDate + "' , INTERVAL 1 DAY) "
						+   " and depart_time > x.a_t1";
				result = stmt.executeQuery(command);
				
				out.print("<table id="+"Flightdata"+">");
				out.print("<th>Flight1</th>");
				out.print("<th>Flight2</th>");
				out.print("<th>FROM</th>");
				out.print("<th>TO</th>");
				out.print("<th>DepartDate</th>");
				out.print("<th>ArriveDate</th>");
				out.print("<th>Price</th>");
				out.print("<th>FROM</th>");
				out.print("<th>TO</th>");
				out.print("<th>DepartDate</th>");
				out.print("<th>ArriveDate</th>");
				out.print("<th>Price</th>");
				out.print("<th>TOTAL</th>");
				out.print("<th>SELECT FLIGHT</th>");
				
				int i = 1;
				while (result.next()) {
					out.print("<tr>");
					out.print("<td>");
						out.print(result.getInt("flight1"));
					out.print("</td>");
					out.print("<td>");
					out.print(result.getInt("flight2"));
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("dID1"));					
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("aID1"));				
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("depart1"));			
					out.print("</td>");	
					out.print("<td>");			
					out.print(result.getString("arrive1"));		
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("price1"));
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("dID2"));	
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("aID2"));				
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("depart2"));				
					out.print("</td>");
					out.print("<td>");			
					out.print(result.getString("arrive2"));		
					out.print("</td>");
					out.print("<td>");			
						out.print(result.getString("totalprice"));
					out.print("</td>");	
					out.print("<td>");
						out.print(" <button onclick="+ch+"myFunction3"+"("+i+")"+ch+">---BOOK---</button> ");
					out.print("</td>");				
					out.print("</tr>");
					i++;

				}
				out.print("</table>");
				
				command = 	" SELECT (d.flight_no) flight1 , (null) flight2, (d.airport_id) dID1, (a.airport_id)aID1 ,(depart_time) depart1,(arrive_time) arrive1, (f.price) price1,(null) aID2,(null) dID2,(null) depart2,(null) arrive2,(f.price) totalprice"
						+	" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
						+	" and depart_time >= DATE_ADD( '" + endDate + "'"+", INTERVAL -3 DAY) "
						+	" and depart_time <= DATE_ADD('" + endDate + "'"+", INTERVAL 3 DAY) "
						+	" and d.airport_id ='" + destination + "'"
						+	" and a.airport_id ='" + departure + "'"
						+	" UNION "
						+	" SELECT DISTINCT (x.flight_no) flight1, (d.flight_no) flight_no, x.dID , x.aID, x.d_t1, x.a_t1, x.price, (d.airport_id) dID,  (a.airport_id) aID, (d.depart_time) depart, (a.arrive_time) arrive, (f.price + x.price) price "
						+	" FROM(SELECT (d.airport_id) dID, (a.airport_id) aID,  (arrive_time) a_t1, (depart_time) d_t1, (d.flight_no) flight_no,(f.price) price "
						+	" FROM departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and a.flight_no = o.flight_no and f.flight_no = d.flight_no "
						+	" and depart_time >= DATE_ADD( '" + endDate + "' , INTERVAL -3 DAY) "
						+	" and depart_time <= DATE_ADD('" + endDate + "' , INTERVAL 3 DAY)"
						+	" and d.airport_id = '" + destination + "') x , departsFrom d, arrivesAt a, operatesFlight o, Flight f"
						+	" WHERE d.flight_no = a.flight_no and f.flight_no = d.flight_no and x.aID = d.airport_id "
						+	" and x.dID != a.airport_id "
						+	" and a.airport_id ='" + departure + "'"
						+	" and depart_time <= DATE_ADD('" + endDate + "' , INTERVAL 1 DAY) "
						+   " and depart_time > x.a_t1";
						
						i = 0;
						while (result.next()) {
							out.print("<tr>");
							out.print("<td>");
								out.print(result.getInt("flight1"));
							out.print("</td>");
							out.print("<td>");
							out.print(result.getInt("flight2"));
							out.print("</td>");
							out.print("<td>");			
								out.print(result.getString("dID1"));					
							out.print("</td>");
							out.print("<td>");			
								out.print(result.getString("aID1"));				
							out.print("</td>");
							out.print("<td>");			
								out.print(result.getString("depart1"));			
							out.print("</td>");	
							out.print("<td>");			
							out.print(result.getString("arrive1"));		
							out.print("</td>");
							out.print("<td>");			
								out.print(result.getString("price1"));
							out.print("</td>");
							out.print("<td>");			
								out.print(result.getString("dID2"));	
							out.print("</td>");
							out.print("<td>");			
								out.print(result.getString("aID2"));				
							out.print("</td>");
							out.print("<td>");			
								out.print(result.getString("depart2"));				
							out.print("</td>");
							out.print("<td>");			
							out.print(result.getString("arrive2"));		
							out.print("</td>");
							out.print("<td>");			
								out.print(result.getString("totalprice"));
							out.print("</td>");	
							out.print("<td>");
								out.print(" <button onclick="+ch+"myFunction3"+"("+i+")"+ch+">---BOOK---</button> ");
							out.print("</td>");				
							out.print("</tr>");
							i++;

						}
						}
					
					
					
								
							
			}									

		//}
	} catch (Exception e) {
		out.print(e);
	}		
		
%>
<script>
function sortTable1(j) {
	  var table, rows, switching, i, x, y,shouldSwitch;
	  table = document.getElementById("Flightdata");
	  switching = true;
	  /*Make a loop that will continue until
	  no switching has been done:*/
	  while (switching) {
	    //start by saying: no switching is done:
	    switching = false;
	    rows = table.rows;
	    /*Loop through all table rows (except the
	    first, which contains table headers):*/
	    for (i = 1; i < (rows.length - 1); i++) {
	      //start by saying there should be no switching:
	      shouldSwitch = false;
	      /*Get the two elements you want to compare,
	      one from current row and one from the next:*/
	      x = rows[i].getElementsByTagName("TD")[j];
	      y = rows[i + 1].getElementsByTagName("TD")[j];
	      //check if the two rows should switch place:
	      if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
	        //if so, mark as a switch and break the loop:
	        shouldSwitch = true;
	        break;
	      }
	    }
	    if (shouldSwitch) {
	      /*If a switch has been marked, make the switch
	      and mark that a switch has been done:*/
	      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
	      switching = true;
	    }
	  }
	}
function sortTable2(j) {
	  var table, rows, switching, i, x, y,shouldSwitch;
	  table = document.getElementById("Flightdata");
	  switching = true;
	  /*Make a loop that will continue until
	  no switching has been done:*/
	  while (switching) {
	    //start by saying: no switching is done:
	    switching = false;
	    rows = table.rows;
	    /*Loop through all table rows (except the
	    first, which contains table headers):*/
	    for (i = 1; i < (rows.length - 1); i++) {
	      //start by saying there should be no switching:
	      shouldSwitch = false;
	      /*Get the two elements you want to compare,
	      one from current row and one from the next:*/
	      x = rows[i].getElementsByTagName("TD")[j];
	      y = rows[i + 1].getElementsByTagName("TD")[j];
	      //check if the two rows should switch place:
	      if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
	        //if so, mark as a switch and break the loop:
	        shouldSwitch = true;
	        break;
	      }
	    }
	    if (shouldSwitch) {
	      /*If a switch has been marked, make the switch
	      and mark that a switch has been done:*/
	      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
	      switching = true;
	    }
	  }
	}
</script>

<script>
			var x,y;
			function myFunction1(i) {
				x = document.getElementById("Flightdata").rows[i].cells[0].innerHTML;
				//var s= document.getElementById("id");
				//s.value = x;
				//alert(x)
				window.location="/CS336/flightTicketOptions.jsp?param="+x;
				}
		
			function myFunction2(i) {
				x = document.getElementById("Flightdata").rows[i].cells[0].innerHTML;
				y = document.getElementById("Flightdata").rows[i].cells[7].innerHTML;
				//alert(x + "and" + y);
				window.location="/CS336/flightTicketOptions.jsp?param="+x+"&param1="+y;
				}
			function myFunction3(i) {
				x = document.getElementById("Flightdata").rows[i].cells[0].innerHTML;
				y = document.getElementById("Flightdata").rows[i].cells[1].innerHTML;
				//alert(x + "and" + y);
				//if y  = 0 then only one flight
				if (y == 0){
					window.location="/CS336/flightTicketOptions.jsp?param="+x;
				}
				else{
					window.location="/CS336/flightTicketOptions.jsp?param="+x+"&param1="+y;
				}
				}
			
			function goToFTO() {
				window.location = '/CS336/flightTicketOptions.jsp';				
				}	
			function rnd(i){
				myFunction2(i);
				goToFTO();
			}
</script>

</body>
</html>









