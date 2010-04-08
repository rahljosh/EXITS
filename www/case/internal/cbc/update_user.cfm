<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfform name="update_user" method="post" action="?curdoc=cbc/qr_update_user">

OLD Rep ID: <cfinput name="repid" required="yes" message="Enter a rep id" size="4"> (the one you want to get rid of)<br><br>

New Rep ID: <cfinput name="newrepid" required="yes" message="Enter a new rep id" size="4"><br><br>

<cfinput type="submit" name="submit" value=" Submit "><br><br>

Assign new ID to students area rep, students place rep and payments.

</cfform>

</body>
</html>
