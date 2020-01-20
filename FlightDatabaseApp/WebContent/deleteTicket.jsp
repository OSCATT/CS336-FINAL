<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connec.*"%>
	
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>verification</title>
</head>
<body>
<a href='login.jsp'>main menu</a>
	<%
	try {


		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		Statement stmt = con.createStatement();

		String index = request.getParameter("param");
		String Flightclass = request.getParameter("param1");
		
		char ch = '"';
		String command = "DELETE FROM Tickets WHERE (ticket_no =" + index +")";
		if(Flightclass.equals("economy")){
			out.print("you need to pay a fee for economy class flights");
			out.print(" <button onclick="+ch+"deleteTicket"+"("+index+")"+ch+">Cancel this flight</button> ");
		}
		else{
			stmt.executeUpdate(command);
			out.print("sucessfully cancelled");
		}
    
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("cant sorry");
	}
%>
<script>
			var x,y;
			function deleteTicket(index) {
				x = index;
				y = "FEE PAID"
				//var s= document.getElementById("id");
				//s.value = x;
				//alert(x);
				window.location="/CS336/deleteTicket.jsp?param="+x+"&param1="+y;
				}
</script>	    
		

</body>
</html>