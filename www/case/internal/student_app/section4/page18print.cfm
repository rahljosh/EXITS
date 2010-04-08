<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "internal/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [18] - Private School</title>	
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="private_schools" datasource="caseusa">
	SELECT privateschoolid, privateschoolprice, type
	FROM smg_private_schools
</cfquery>

<cfset doc = 'page18'>

<cfoutput query="get_student_info">

<!--- check attached file --->
<cfif NOT IsDefined('url.curdoc')>
	<cfinclude template="../print_include_file.cfm">
<cfelse>
	<cfset printpage = 'yes'>	
</cfif>

<!--- if file is attached do not print this --->
<cfif printpage EQ 'yes'>

<cfif not IsDefined('url.curdoc')>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [18] - Private School</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page18print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<!--- CHECK IF FILE HAS BEEN UPLOADED --->
<cfif IsDefined('url.curdoc')>
	<cfinclude template="../check_upl_print_file.cfm">
</cfif>

<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr>
		<td width="110"><em>Student's Name</em></td>
		<td width="560">#get_student_info.firstname# #get_student_info.familylastname#<br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br>
	
<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="2"><div align="justify"><cfinclude template="page18text.cfm"></div></td></tr>
</table>

<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td>
			<table>
				<tr><td><cfif privateschool EQ '0'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse> <img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>
					<td><em>Do not consider my child for J-1 Private Schools</em></td></tr>
			</table>
		</td>
	</tr>
	<tr><td align="center"><br><h2>- OR -</h2><br></td></tr>
	<tr>
		<td>
			<table>
				<tr><td><cfif privateschool GTE '1' AND privateschool LTE '4'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse> <img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif></td>
					<td><em>Consider my child for any school in the following tuition range: (select one)</em></td></tr>
					<tr><td></td><td>Tuition Range: (select one)</td></tr>
					<cfloop query="private_schools">
					<tr><td></td><td>	
						<cfif get_student_info.privateschool EQ privateschoolid>
							<img src="#path#pics/checkY.gif" width="13" height="13" border="0">
						<cfelse>
							<img src="#path#pics/checkN.gif" width="13" height="13" border="0">
						</cfif>
						&nbsp; #privateschoolprice#<br><img src="#path#pics/line.gif" width="300" height="1" border="0" align="absmiddle"></td></tr>
					</cfloop>
			</table>
		</td>
	</tr>
	<tr><td align="center"><br><h2>- OR -</h2><br></td></tr>
	<tr>
		<td>
			<table>
				<tr><td><cfif privateschool GT 4><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse> <img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> </cfif></td>
					<td><em>Consider my child for the following 3 choices from the J-1 Private Schools List:</em></td></tr>
				<tr><td></td><td><br><img src="#path#pics/line.gif" width="300" height="1" border="0" align="absmiddle"></td></tr>
				<tr><td></td><td><br><img src="#path#pics/line.gif" width="300" height="1" border="0" align="absmiddle"></td></tr>
				<tr><td></td><td><br><img src="#path#pics/line.gif" width="300" height="1" border="0" align="absmiddle"></td></tr>
			</table>
		</td>
	</tr>
</table><br><br><br>

<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
		<td width="5"></td>
		<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>		
		<td width="40"></td>
		<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Parent's Signature</td>
		<td></td>
		<td>Date</td>
		<td></td>
		<td>Student's Name (print clearly)</td>
	</tr>
</table><br><br>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

<cfif NOT IsDefined('url.curdoc')>
</td></tr>
</table>
</cfif>

</cfif>

</cfoutput>
</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>