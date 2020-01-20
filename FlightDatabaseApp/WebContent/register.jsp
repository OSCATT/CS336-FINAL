<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>REGISTER ACCOUNT</title>
</head>
<body>
	Enter account info here

	<br>
	<form method="post" action="newAccount.jsp">
		<table>
			<tr>
				<td>first name</td>
				<td><input type="text" name="fname"></td>
			</tr>
			<tr>
				<td>last name</td>
				<td><input type="text" name="lname"></td>
			</tr>
			<tr>
				<td>user name</td>
				<td><input type="text" name="uname"></td>
			</tr>
			<tr>
				<td>pass word</td>
				<td><input type="text" name="pword"></td>
			</tr>
		</table>
		<input type="submit" value="REGISTER">
	</form>
	<br>
	<a href="/CS336/login.jsp">main menu</a>
</body>
</html>