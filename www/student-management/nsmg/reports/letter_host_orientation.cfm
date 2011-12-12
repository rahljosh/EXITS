<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../reports.css">
	<title>Host Family Orientation Sign Off</title>
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
	<tr><th><i>HOST FAMILY ORIENTATION SIGN-OFF</i></th></tr>
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
</table><br><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF" cellpadding="4" cellspacing="1">
	<tr class="style1">
		<td width="180">I attended this orientation on</td>
		<td width="120">&nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; .<br><img src="../pics/line.gif" width="115" height="1" border="0" align="absmiddle"></td>		
		<td width="350">&nbsp;</td>
	</tr>
	<tr class="style1"><td>&nbsp;</td><td align="center">Date</td><td>&nbsp;</td></tr>
</table><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF" cellpadding="3" cellspacing="0">
	<tr class="style1">
		<td>
			<div align="justify">
				By signing this form, you verifiy that the rules of the exchange program have been explained and you agree to comply with all policies, 
				particularly: 	
				<br><br>
				<ul>
					<li>Independent travel is not permitted while on the exchange program.</li>
					<li>Overnight travel is only allowed with a host parent, representative of the company, church group, school sanctioned chaperone 
						or a tour guide approved by the exchange organization.</li>
					<li>Students are only allowed to operate motor vehicle in the presence a certified driving instructor.</li>
					<li>Program participants are not guaranteed diplomas.</li>
					<li>Visits from the natural family are strongly discouraged and require approval from the national office.</li>
					<li>Students are expected to depart five days from the last day of school.</li>
				</ul>
				In addition, this document serves as an acknowledgement that a designated representative of the exchange organization
performed an in-home interview, that you have received a host family handbook<cfif client.companyid NEQ 14>, and that you received a copy of the U.S.
Department of State letter to host families</cfif>. Your signature also confirms you have been provided the name and contact
information of a supervising representative who will be available to objectively assist you and the student during the
program.
				<br><br>
			</div>
		</td>
	</tr>
</table><br>

<table width="650" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr style="style1 ">
		<td width="100">Host Parent:</td>
		<td width="330"><br><img src="../pics/line.gif" width="328" height="1" border="0" align="absmiddle"></td>
		<td width="20">&nbsp;</td>
		<td width="140"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="../pics/line.gif" width="138" height="1" border="0" align="absmiddle"></td>
		<td width="60">&nbsp;</td>
	</tr>
	<tr style="style1 ">
		<td>&nbsp;</td>
		<td>(signature)</td>
		<td>&nbsp;</td>
		<td>date</td>		
		<td>&nbsp;</td>
	</tr>
	<tr><td colspan="5">&nbsp; <br></td></tr>
	<tr style="style1 ">
		<td width="100">&nbsp;</td>
		<td width="330"><br><img src="../pics/line.gif" width="328" height="1" border="0" align="absmiddle"></td>
		<td width="20">&nbsp;</td>
		<td width="140">&nbsp;</td>
		<td width="60">&nbsp;</td>
	</tr>
	<tr style="style1 ">
		<td>&nbsp;</td>
		<td>(print name)</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>		
		<td>&nbsp;</td>
	</tr>
</table><br>

<table width="650" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr style="style1 ">
		<td width="100">Host Parent:</td>
		<td width="330"><br><img src="../pics/line.gif" width="328" height="1" border="0" align="absmiddle"></td>
		<td width="20">&nbsp;</td>
		<td width="140"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="../pics/line.gif" width="138" height="1" border="0" align="absmiddle"></td>
		<td width="60">&nbsp;</td>
	</tr>
	<tr style="style1 ">
		<td>&nbsp;</td>
		<td>(signature)</td>
		<td>&nbsp;</td>
		<td>(date)</td>		
		<td>&nbsp;</td>
	</tr>
	<tr><td colspan="5">&nbsp; <br></td></tr>
	<tr style="style1 ">
		<td width="100">&nbsp;</td>
		<td width="330"><br><img src="../pics/line.gif" width="328" height="1" border="0" align="absmiddle"></td>
		<td width="20">&nbsp;</td>
		<td width="140">&nbsp;</td>
		<td width="60">&nbsp;</td>
	</tr>
	<tr style="style1 ">
		<td>&nbsp;</td>
		<td>(print name)</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>		
		<td>&nbsp;</td>
	</tr>
</table><br>

</cfoutput>

</body>
</html>