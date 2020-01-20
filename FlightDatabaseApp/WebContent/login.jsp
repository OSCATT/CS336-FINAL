<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="Calendar.css">
<meta charset="ISO-8859-1">
<title>HOME LOGIN</title>
</head>
<body>


<font color="red">
WELCOME 
</font>


<% 
char ch = '"';





session = request.getSession(false);
if (session.getAttribute("user") == null) {    
    out.print("you are not logged in,please log in to use the service");   
} else {
 	out.print(  session.getAttribute("user") +  " you are logged in");
 	%>
    	<form action="/CS336/logout.jsp">
    	<input type="submit" value="logout" />
		</form>
	<% 
}
%>


<br>

<% if(session.getAttribute("user")== null) 
{%>
	Enter account info here

	<br>
	<form method="post" action="LoginCheck.jsp">
		<table>
			<tr>
				<td>username</td>
				<td><input type="text" name="uname"></td>
			</tr>
			<tr>
				<td>password</td>
				<td><input type="password" name="pword"></td>
			</tr>
		</table>
		<input type="submit" value="LOGIN">
	</form>
	<br>
	<a href="/CS336/register.jsp">no account? register here!</a>	
<%}
else{ %>

<form method="post" action="Searchflights.jsp">
<br>
Select Airport






<table>
<td>Date</td>
<pre>Depart date:         Return date:</pre>

<tr><input type="date" name="trip-start" value="2019-09-18"
       min="2019-01-01" max="2030-12-31"/>


<input type="date" name="trip-return" value="2019-09-22"
       min="2019-01-01" max="2030-12-31"/></tr>

			<td>Type</td>
				<td><select name="type">
  <option value="oneWay">One Way</option>
  <option value="roundTrip">Round Trip</option>
					</select>
			<tr>
				<td>Flexible on Date (+-3days)</td>
				<td><input type="checkbox" name="flexibleDate" value="yes" />
			</tr>
			<tr>
			
			<tr>
				<td>Allow Stops</td>
				<td><input type="checkbox" name="allowStops" value="yes" />
			</tr>
			
						<td>Preferred Class</td>
				<td><select name="fclass">
  <option value="1">Economy</option>
   <option value="2">Business</option>
  <option value="3">First</option>
					</select>
			<tr>
			
				<td>From :</td>
				<td><select name="DepartFrom">
  <option value="LGA">Laguardia</option>
  <option value="JFK">John F. Kennedy International Airport</option>
  <option value="EWR">Newark International</option>
  <option value="ATL">Hartsfield–Jackson Atlanta International Airport</option>
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
  <option value="SEA">Seattle–Tacoma International Airport</option>
  <option value="SFO">San Francisco International Airport</option>
					</select>
			</tr>
						<tr>
			
				<td>To :</td>
				<td><select name="ArriveAt">
<option value="LGA">Laguardia</option>
  <option value="JFK">John F. Kennedy International Airport</option>
  <option value="EWR">Newark International</option>
  <option value="ATL">Hartsfield–Jackson Atlanta International Airport</option>
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
  <option value="SEA">Seattle–Tacoma International Airport</option>
  <option value="SFO">San Francisco International Airport</option>
					</select>
			</tr>
</table>



<input type="submit" value="Search">
</form>

<form method="post" action="userportfolio.jsp">
		
		 <input type="submit" value="go to portfolio" />
	</form>
</body>
</html>

<% }%>	
		<form method="post" action="Show.jsp">
		<input type="radio" name="command" value="Accounts" /> display
		accounts (see account in database) <input type="submit" value="submit" />
	</form>
	
