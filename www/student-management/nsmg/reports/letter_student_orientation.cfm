<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../reports.css">
	<title>Student Orientation Sign Off</title>
</head>
<body onLoad="print()">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_letter_info" datasource="mysql">
	SELECT 	stu.studentid, stu.familylastname, stu.firstname, stu.arearepid, stu.regionassigned, stu.hostid, stu.schoolid,
			h.hostid, h.familylastname AS h_lastname, h.address AS h_address, h.address2 AS h_address2, h.city AS h_city, h.state AS h_state, h.zip AS h_zip, h.phone as h_phone,
			ar.userid, ar.lastname AS ar_lastname, ar.firstname AS ar_firstname, ar.address AS ar_address, ar.address2 AS ar_address2, ar.city AS ar_city, 
			ar.state AS ar_state, ar.zip AS ar_zip, ar.phone AS ar_phone,
			c.countryname
	FROM smg_students stu
	LEFT JOIN smg_hosts h ON stu.hostid = h.hostid
	LEFT JOIN smg_users ar ON stu.arearepid = ar.userid
	INNER JOIN smg_countrylist c ON c.countryid = stu.countryresident
	WHERE stu.studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>

<cfoutput>

<table width=650 align="center" border=0 bgcolor="FFFFFF" cellpadding="4" cellspacing="1">
	<tr><th><i>STUDENT ORIENTATION SIGN-OFF</i></th></tr>
</table><br><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF" cellpadding="4" cellspacing="1"> 
	<tr class="style1">
		<td width="110">Student Name:</td>
		<td width="190">#get_letter_info.firstname# #get_letter_info.familylastname#<br><img src="../pics/line.gif" width="188" height="1" border="0" align="absmiddle"></td>		
		<td width="40">ID ##:</td>
		<td width="50">#get_letter_info.studentid#<br><img src="../pics/line.gif" width="48" height="1" border="0" align="absmiddle"></td>
		<td width="110">Home Country:</td>
		<td width="150">#get_letter_info.countryname#<br><img src="../pics/line.gif" width="148" height="1" border="0" align="absmiddle"></td>
	</tr>
</table>

<table width=650 align="center" border=0 bgcolor="FFFFFF" cellpadding="4" cellspacing="1">
	<tr class="style1">
		<td width="100">Host Family:</td>
		<td width="200">#get_letter_info.h_lastname#<br><img src="../pics/line.gif" width="208" height="1" border="0" align="absmiddle"></td>		
		<td width="140">Area Representative:</td>
		<td width="210">#get_letter_info.ar_firstname# #get_letter_info.ar_lastname#<br><img src="../pics/line.gif" width="208" height="1" border="0" align="absmiddle"></td>
	</tr>
</table>

<table width=650 align="center" border=0 bgcolor="FFFFFF" cellpadding="4" cellspacing="1">
	<tr class="style1">
		<td width="125">US Organization:</td>
		<td width="513">#companyshort.companyname#<br><img src="../pics/line.gif" width="513" height="1" border="0" align="absmiddle"></td>		
	</tr>
</table><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF" cellpadding="4" cellspacing="1">
	<tr class="style1">
		<td width="180">I attended this orientation on</td>
		<td width="120">&nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; .<br><img src="../pics/line.gif" width="115" height="1" border="0" align="absmiddle"></td>		
		<td width="350">I was told and I understood the following: </td>
	</tr>
	<tr class="style1"><td>&nbsp;</td><td align="center">Date</td><td>&nbsp;</td></tr>
</table><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF" cellpadding="3" cellspacing="0">
	<tr class="style1">
		<td>
			<div align="justify">
				As an exchange student, I am a representative of my country and I know I am expected to conduct myself in a respectable manner, 
				obeying the laws and rules of the United States, my community, my school and the rules as set down for me by my host family.  
				I further understand that if I violate any of the guidelines listed below or in the Student Handbook, 
				I could be released from the program. 	
				<br><br>
				<ul>
					<li>This is a non-smoking program.  Smoking is not permitted.</li>
					<li>The use/possession of alcohol or other illicit drugs is forbidden.</li>
					<li>American friendships are encouraged.  Intimate relationships that include sexual involvement are not allowed.</li>
					<li>Program participants are expected to maintain a C average or above and attend all classes as scheduled unless 
						permission to be absent is approved by both the school and your host parents.</li>
					<li>Program participants are not guaranteed graduation, high school diplomas, or participation in school sports.</li>
					<li>Driving of motor vehicles is strictly prohibited unless it is contracted with a driving school or driver's education program. </li>
					<li>Visits from family and friends from your home country are strongly discouraged.  The exchange organization does not assume any 
						responsibility for placements compromised by such visits.</li>
					<li>Overnight travel is only allowed with a host parent, school approved chaperone, church group, exchange program representative, 
						or a tour guide approved by the exchange program.</li>
					<li>Independent travel is not permitted while on the exchange program.</li>
					<li>Host families set limits and expectations for living within the family.  They are to be followed.</li>
					<li>Program participants are expected to take part in family activities and follow rules with regards to respect, chores, 
						curfews, and social activities.</li>
					<li>Program participants are expected to pay their own phone bill and other expenses of a personal nature.</li>
					<li>Use of the phone, cell phones and the Internet are privileges. Guidelines for use will be determined by the host family.</li>
					<li>Program participants are expected to depart five days from the last day of school.</li>
					<li>Program participants must follow all program rules and regulations as outlined in the Student Handbook.</li>
				</ul>
				By signing below, I acknowledge that I understand each of the points covered above and I agree to abide by each of the rules
				as listed and discussed at the orientation meeting.  I know that violation of any of these guidelines can result in probationary
				action and could result in termination of my exchange program.
				<br><br>
				I further acknowledge that I have been provided with a copy of the U.S. Department of State Exchange Visitor Program
Welcome Brochure, the U.S. Department of State letter to students, and that I agree to follow all U.S. Department of State
Rules and Regulations. The exchange program has fulfilled its obligation to provide me with an orientation session upon
arrival by a designated representative to explain the rules governing the program.
				<br>
			</div>
		</td>
	</tr>
</table><br>

<table width="650" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr class="style1">
		<td width="255"><br><img src="../pics/line.gif" width="255" height="1" border="0" align="absmiddle"></td>
		<td width="20"></td>
		<td width="120"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="../pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>		
		<td width="255">&nbsp;</td>
	</tr>
	<tr class="style1">
		<td>Student Signature</td>
		<td>&nbsp;</td>
		<td>Date</td>
		<td>&nbsp;</td>		
	</tr>
</table><br>

</cfoutput>

</body>
</html>