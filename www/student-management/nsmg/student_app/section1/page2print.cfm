<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "nsmg/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [02] - Siblings</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_siblings" datasource="MySql">
	SELECT childid, name, birthdate, sex, liveathome
	FROM smg_student_siblings
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY childid
</cfquery>

<cfoutput query="get_student_info">

<cfif not IsDefined('url.curdoc')>
<table align="center" width=90% cellpadding=0 cellspacing=0 border=0> 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [02] - Siblings</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page2print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="660" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr><td colspan="5"><b>BROTHERS and/or SISTERS</b></td></tr>
	<tr>
		<td width="210"><em>Name</em></td>
		<td width="160"><em>Date of Birth</em></td>
		<td width="150"><em>Sex</em></td>
		<td width="150"><em>Living at home?</em></td>
	</tr>

	<cfif get_siblings.recordcount NEQ 0>	<!--- load siblings ---> 
		<cfloop query="get_siblings">
		<tr>
			<td valign="top">#name#
				<br><img src="#path#pics/line.gif" width="200" height="1" border="0" align="absmiddle"><br><br></td>
			<td valign="top">#DateFormat(birthdate, 'mm/dd/yyyy')#
				<br><img src="#path#pics/line.gif" width="150" height="1" border="0" align="absmiddle"><br><br></td>
			<td valign="top">
				<cfif sex is 'male'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Male<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Male</cfif>&nbsp; &nbsp;
				<cfif sex is 'female'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Female<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Female</cfif>
				<br><img src="#path#pics/line.gif" width="150" height="1" border="0" align="absmiddle"><br><br>
			</td>
			<td valign="top">
				<cfif liveathome is 'yes'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
				<cfif liveathome is 'no'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
				<br><img src="#path#pics/line.gif" width="140" height="1" border="0" align="absmiddle"><br><br>
			</td>
		</tr>
		</cfloop>
	</cfif>
	
	<!--- new siblings --->
	<cfset newsiblings = 5 - get_siblings.recordcount>
	<cfloop from="1" to="#newsiblings#" index="i">
	<tr>
		<td valign="top"><br><img src="#path#pics/line.gif" width="200" height="1" border="0" align="absmiddle"><br><br></td>
		<td valign="top"><br><img src="#path#pics/line.gif" width="150" height="1" border="0" align="absmiddle"><br><br></td>
		<td valign="top">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Male &nbsp; &nbsp;
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Female
			<br><img src="#path#pics/line.gif" width="150" height="1" border="0" align="absmiddle"><br><br></td>
		<td valign="top">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<br><img src="#path#pics/line.gif" width="140" height="1" border="0" align="absmiddle"><br><br></td>	
	</tr>
	</cfloop>		
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

</cfoutput>

<cfif not IsDefined('url.curdoc')>
</td></tr>
</table>
</cfif>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="#path#/error_message.cfm">
</cfcatch>
</cftry>