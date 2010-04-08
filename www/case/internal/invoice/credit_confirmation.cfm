<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<link rel="stylesheet" href="../../smg.css" type="text/css">
<head>
<title>Credit Account</title>
<div class="application_section_header">Credit Account</div><br>
</head>
<table width=100% cellpadding =4 cellspacing =0>
	<tr bgcolor="#FFFFCC">
		<td ><b><span class="edit_link">Enter Credit Info</b></td><td bgcolor="#FF8080"><span class="edit_link">Confirmation</td>
	</tr>

</table><br><br>
<body onLoad="opener.location.reload()"> 
<h2>Credit has been succesfully recorded.</h2>

<br><br>
<input type="image" value="close window" src="../../pics/close.gif" onClick="javascript:window.close()">