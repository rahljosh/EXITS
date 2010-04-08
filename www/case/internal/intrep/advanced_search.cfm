<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Advanced Search</title>
</head>

<body>

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #666666; }
</style>

<!--- COUNTRY LIST --->
<cfinclude template="../querys/get_countries.cfm">

<!--- INTERESTS LIST --->
<cfinclude template="../querys/get_interests.cfm">

<!--- RELIGIOUS LIST --->
<cfinclude template="../querys/get_religious.cfm">

<!--- STATES --->
<cfinclude template="../querys/get_states.cfm">

<cfquery name="get_program" datasource="caseusa">
	SELECT	*
	FROM smg_programs p
	LEFT JOIN smg_program_type ON type = programtypeid
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE enddate > '#DateFormat(now(), 'yyyy-mm-dd')#'
		AND p.companyid != '6'
	ORDER BY companyshort, startdate DESC, programname
</cfquery>

<cfoutput>

<cfform action="?curdoc=intrep/advanced_search_list" method="POST"><br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td background="pics/header_background.gif"><h2>Advanced Search</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>::</b></span> You can combine the following criteria</td></tr>
		<tr><td class="label">Active : </td>
			<td><select name="active" size="1">
					<option value="1">Yes</option>
					<option value="0">No</option>
					<option value="2">All</option>
				</select></td></tr>
		<tr><td class="label">Placement Status : </td>
			<td><select name="status" size="1">
					<option value="0"></option>
					<option value="placed">Placed</option>
					<option value="unplaced">Unplaced</option>
				</select></td></tr>
		<tr><td class="label">Pre-AYP :</td>
			<td><select name="preayp" size="1">
				<option value='none'></option>
				<option value="english">English Camp</option>
				<option value="orient">Orientation Camp</option>
				</select></td></tr>		
		<tr><td class="label">Direct Placement :</td>
			<td><select name="direct" size="1">
				<option value='all' selected></option>
				<option value="yes">Yes</option>
				<option value="no">No</option>
				</select></td></tr>		
		<tr><td class="label">Age : </td>
			<td><select name="age" size="1">
					<option value="0"></option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
				</select></td></tr>
		<tr><td class="label">Gender : </td>
			<td><select name="gender" size="1">
					<option value="0"></option>
					<option value="male">Male</option>
					<option value="female">Female</option>
				</select></td></tr>
		<tr><td class="label">Graduated in Home Country : </td>
			<td><select name="graduate" size="1">
					<option value=""></option>
					<option value="1">Yes</option>
				</select></td>
		</tr>
		<tr><td class="label">Religion :</td>
			<td><select name="religion" size="1">			
					<option value="0"></option>
					<cfloop query="get_religious"><option value="#religionid#">#religionname#</option></cfloop>
				</select></td></tr>
		<tr><td class="label">Center of Interests :</td>
			<td><select name="interests" size="1">			
					<option value="0"></option>
					<cfloop query="get_interests"><option value="#interestid#">#interest#</option></cfloop>
				</select></td></tr>
		<tr><td class="label">Play in competitive sports :</td>
			<td><select name="sports" size="1">			
					<option value="0"></option>
					<option value="yes">Yes</option>
					<option value="no">No</option>
				</select></td></tr>
		<tr><td class="label">Text in the narrative :</td>
			<td><input type="text" name="interests_other" size="25" maxlength="25"></td></tr>
		<tr><td class="label">State Guarantee :</td>
			<td><select name="stateid" size="1">
				<option value="0">None</option>
						<cfloop query="get_states"><option value="#id#">#statename#</option></cfloop>
				</select></td></tr>								
		<tr><td class="label">Program :</td>
			<td><select name="programid" multiple  size="5">
				<option value="0" selected>All</option>
					<cfloop query="get_program"><option value="#ProgramID#">#companyshort# &nbsp; #programname#</option></cfloop>
				</select></td></tr>
		<tr><td class="label">Student ID :</td>
			<td><input type="text" name="studentid" size="5" maxlength="5"></td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input type="Submit" value="Search">&nbsp; &nbsp; &nbsp; &nbsp;<input type="Reset"></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfform><br><br>

</cfoutput>

</body>
</html>
