<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
	
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Hub</title>
<link href="StyleSheet.css" rel="stylesheet" type="text/css">
</head>
<body>

<h1 class= "text-shadow">Admin Hub</h1>
<img src="pic_trulli.jpg" alt="Trulli" width="500" height="333">



<form method="post" action="adminCommands.jsp?param=listfromAirport">
<br>
GET list of all flights at an airport
<table>
				<td>From :</td>
				<td><select name="airport">
  <option value="LGA">Laguardia</option>
  <option value="JFK">John F. Kennedy International Airport</option>
  <option value="EWR">Newark International</option>
  <option value="ATL">Hartsfield Jackson Atlanta International Airport</option>
  <option value="CDG">Charles de Gaulle Airport</option>
  <option value="DEN">Denver International Airport</option>
  <option value="DFW">Dallas/Fort Worth International Airport</option>
  <option value="FRA">Frankfurt am Main Airport</option>
  <option value="HNL">Honolulu International Airport</option>
  <option value="LAS">McCarran International Airport</option>
  <option value="LAX">Los Angeles International Airport</option>
  <option value="MIA">Miami International Airport</option>
  <option value="ORD">OHare International Airport</option>
  <option value="PHL">Philadelphia International Airport</option>
  <option value="PHX">Phoenix Sky Harbor International Airport</option>
  <option value="SEA">Seattle Tacoma International Airport</option>
  <option value="SFO">San Francisco International Airport</option>
					</select>
			</td>
			<tr><td><input type="submit" value = "submit"></td></tr>
</table>
</form>

<br>
	
	<form method="post" action="adminCommands.jsp?param=reservationByFlight">
		<table>
			<tr>
				<td>Find all reservations by flight number</td>
				<td><input type="text" name="flightNumber"></td>
			</tr>
		</table>
		<input type="submit" value="submit">
	</form>

<br>
	
	<form method="post" action="adminCommands.jsp?param=reservationByName">
		<table>
			<tr>
				<td>Find all reservations by first and last name</td>
				
			</tr>
			<tr>	
			    <td>first name <input type="text" name="fname"></td>			
				<td>last name <input type="text" name="lname"></td>
			</tr>
		</table>
		<input type="submit" value="submit">
	</form>

<br>
	
	<form method="post" action="adminCommands.jsp?param=findMostActive">
		<table>
			<tr>
				<td>Find most active flight(most active flights)</td>
				
			</tr>
		</table>
		<input type="submit" value="FIND">
	</form>
	
<br>
	
	<form method="post" action="adminCommands.jsp?param=findMostRevenue">
		<table>
			<tr>
				<td>List of revenue by customer ( and most revenue generated )</td>
				
			</tr>
		</table>
		<input type="submit" value="FIND">
	</form>
	
	<br>
	
	<form method="post" action="adminCommands.jsp?param=revenueByAirline">
		<table>
			<tr>
				<td>Total revenue generated at an airline</td>
				<td><select name="airlineID">
  <option value="AA">American Airlines</option>
  <option value="B6">B6</option>
  <option value="UA">United Airlines</option>
					</select>
			</td>
			</tr>
		</table>
		<input type="submit" value="submit">
	</form>
	
	<br>
	
		<form method="post" action="adminCommands.jsp?param=revenueByFlight">
		<table>
			<tr>
				<td>Find revenue for flights</td>
				
			</tr>
		</table>
		<input type="submit" value="FIND">
	</form>
	
<%
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();

Statement stmt = con.createStatement();
String command = "SELECT * FROM Accounts";
ResultSet result = stmt.executeQuery(command);
%>



<h1>Edit an Account's Information</h1>
Choose an account to edit:<br>

<table id= userInfo >
<tr>
    <th>Account Number</th>
    <th>First Name</th>
    <th>Last Name</th>
    <th>Username</th>
    <th>Password</th>
    </tr>


    <%
    try {
        int i = 1;
        char ch = '"';
        while (result.next()){

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

            out.print("<td>");
            if(result.getString("username").equals("ADMIN")){
            }
            else{
            out.print(" <button onclick="+ch+"getID"+"("+i+")"+ch+">edit</button> ");
            }
            out.print("</tr>");
            i++;
        }

    } catch (Exception ex) {
        out.print(ex);
        out.print("insert failed");
    }

    con.close();

    %>
</table>



<script>
var x;

function getID(i) {
        x = document.getElementById("userInfo").rows[i].cells[0].innerHTML;
         window.location="editUserInfo.jsp?param="+x;
} 

</script>	
	

	<%

	
	
	//[] Obtain a sales report for a particular month
	
	
	//[] Produce a summary listing of revenue generated by a particular flight, airline, or customer
	
	
	
	
%>
	    
		

</body>
</html>