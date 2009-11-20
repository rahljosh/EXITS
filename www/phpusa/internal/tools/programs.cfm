<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" type="text/css" href="../php.css">
<title>PHP - Programs</title>
</head>

<body>

<cfif client.usertype GTE '5'>
	You do not have sufficient rights to edit programs.
	<cfabort>
</cfif>

<cfif NOT IsDefined('url.status')>
	<cfset url.status = '1'>
</cfif>

<cfif NOT IsDefined('url.order')>
	<cfset url.order = 'programname'>
</cfif>

<Cfquery name="programs" datasource="MySQL">
	SELECT programid, programname, type, startdate, enddate, insurance_startdate, insurance_enddate, smg_programs.companyid, programfee,
			smg_programs.active,
			smg_companies.companyshort,
			smg_program_type.programtype,
			smg_seasons.season
	FROM smg_programs
	INNER JOIN smg_companies ON smg_companies.companyid = smg_programs.companyid
	LEFT JOIN smg_program_type ON smg_program_type.programtypeid = smg_programs.type
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_programs.seasonid
	WHERE smg_programs.active = <cfqueryparam value="#url.status#" cfsqltype="cf_sql_integer">
		AND smg_programs.companyid = '#client.companyid#'
	ORDER BY #url.order#
</Cfquery>

<cfoutput>

<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td width="57%" valign="middle" bgcolor="e9ecf1"><h3 class="style1">&nbsp; P r o g r a m s</h3></td>
		<td width="42%" align="right" valign="top" bgcolor="e9ecf1">
			Filter: &nbsp; [ &nbsp; 
			<cfif url.status EQ '1'><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif>
				<a href="?curdoc=tools/programs&status=1">Active</a></span> &middot; 
			<cfif url.status EQ '0'><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif>
				<a href="?curdoc=tools/programs&status=0">Inactive</a> </span> &nbsp; ] </font>
		</td>
		<td width="1%"></td>
	</tr>
</table>

<table border=0 cellpadding=3 cellspacing=0 align="center" width=90%>
	<tr>
		<td background="images/back_menu2.gif"><a href="?curdoc=tools/programs&status=#url.status#&order=programid"><b>ID</b></a></td>
		<td background="images/back_menu2.gif"><a href="?curdoc=tools/programs&status=#url.status#&order=programname"><b>Program Name</b></a></td>
		<td background="images/back_menu2.gif"><a href="?curdoc=tools/programs&status=#url.status#&order=programtype"><b>Type</b></a></td>
		<td background="images/back_menu2.gif"><a href="?curdoc=tools/programs&status=#url.status#&order=startdate"><b>Start Date</b></a></td>
		<td background="images/back_menu2.gif"><a href="?curdoc=tools/programs&status=#url.status#&order=enddate"><b>End Date</b></a></td>
		<td background="images/back_menu2.gif"><a href="?curdoc=tools/programs&status=#url.status#&order=companyshort"><b>Company</b></a></td>
		<td background="images/back_menu2.gif"><a href="?curdoc=tools/programs&status=#url.status#&order=season"><b>Season</b></a></td>
	</tr>
	<cfloop query="programs">
	<tr bgcolor="#iif(programs.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
		<td><a href="?curdoc=tools/edit_program&programid=#programid#">#programid#</a></td>
		<td><a href="?curdoc=tools/edit_program&programid=#programid#">#programname#</a></td>
		<td><a href="?curdoc=tools/edit_program&programid=#programid#">#programtype#</a></td>
		<td>#DateFormat(startdate, 'mm-dd-yyyy')#</td>
		<td>#DateFormat(enddate, 'mm-dd-yyyy')#</td>
		<td>#companyshort#</td>
		<td>#season#</td>
	</tr>
	</cfloop>

	<Tr>
		<td colspan=8 align="center">
		<cfform method="post" name="new_program" action="?curdoc=tools/new_program">
			<cfinput name="Submit" type="image" src="pics/new.gif" border=0>
		</cfform>
		</td>
	</Tr>
	<tr><td colspan=7>&nbsp;</td></tr>
	<Tr>
		<td colspan=7><p>Click on program name to edit the details of that program. <br> Changes are affective immediatly and will affect all students assigned to that program.<br><br></td>
	</Tr>
</table>
</cfoutput>

</body>
</html>