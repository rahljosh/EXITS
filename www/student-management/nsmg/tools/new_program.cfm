<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="../smg.css">
<title>New Policy Code</title>
</head>

<script type="text/javascript">
<!--
function CheckData() {
if (document.new_program.seasonid.value == '0') {
	alert("You must select an insurance type.");
	document.new_program.seasonid.focus();
	return false; }  	
if (document.new_program.smg_trip.value == '0') {
	alert("You must select an incentive trip for the program.");
	document.new_program.smg_trip.focus();
	return false; }
}
//-->
</script>

<body>

<cfquery name="program_types" datasource="mysql">
	SELECT * 
	FROM smg_program_type
	WHERE systemid = '1'
		AND active = '1'
	ORDER BY programtype
</cfquery>
<cfquery name="student_app_program_types" datasource="mysql">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE  companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
    and isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	ORDER BY app_program
</cfquery>
<cfquery name="smg_trips" datasource="MySql">
	SELECT tripid, trip_place, trip_year  
	FROM smg_incentive_trip
</cfquery>

<cfquery name="smg_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Program Maintenance</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section">

<cfoutput>

<cfform action="index.cfm?curdoc=tools/qr_new_program" method="post" name="new_program" onSubmit="return CheckData();">

<table border=0 cellpadding=2 cellspacing=2 width=800 align="center">
	<tr><td align="center">Please fill out each field for the new program, then click on next.</td></tr>
	<tr>
		<td>
		<table class="nav_bar" align="center">
			<tr>
				<td align="right">Program Name: </td>
				<td><cfinput type="text" name="programname" value="" size=35 required="yes" message="You must enter a program name"></td>
			</tr>
				<tr>
				<td align="right">Program Type: </td>
				<td> <select name="type">
					<option value=00>Select Type</option>
					<cfloop query="program_types">
					<option value="#programtypeid#">#programtype#</option>
					</cfloop>
					</select>
				</td>
			</tr>
           	<tr>
				<td align="right">Student Application: </td>
				<td> <select name="studentAppType">
					<option value=00>Select Type</option>
					<cfloop query="student_app_program_types">
					<option value="#app_programid#">#app_program#</option>
					</cfloop>
					</select>
				</td>
			</tr>
            <tr>
				<td colspan=2><em><font size=-2>Student Application: Description that shows on Student App when selectiong program.</font></td>
			</tr>
			<tr>
				<td align="right">Start Date: </td>
				<td><cfinput type="text" name="startdate" value="" size=10 validate="date" required="yes" message="You must enter a start date"> (mm-dd-yyyy)</td>
			</tr>
			<tr>
				<td align="right">End Date: </td>
				<td><cfinput type="text" name="enddate" value="" size=10 validate="date" required="yes" message="You must enter an end date"> (mm-dd-yyyy)</td>
			</tr>
			<tr><td align="center" colspan="2"><font color="FF6600"><u>Insurance Information</u></font></td></tr>
			<tr>
				<td align="right">Insurance Start Date: </td>
				<td><cfinput type="text" name="insurance_startdate" value="" validate="date" size=10> (mm-dd-yyyy)</td>
			</tr>
			<tr>
				<td align="right">Insurance End Date: </td>
				<td><cfinput type="text" name="insurance_enddate" value="" validate="date" size=10> (mm-dd-yyyy)</td>
			</tr>
			<tr><td></td><td><font color="FF6600"><u><b>Program Season</b></u></font></td></tr>
			<tr><td align="right">Program Season:</td>
				<td><cfselect name="seasonid" required="yes" message="You must select a season for the program">
					<option value="0"></option>
					<cfloop query="smg_seasons">
					<option value="#seasonid#">#season#</option>
					</cfloop>
					</cfselect></td>
			</tr>
			<tr><td></td><td>* School Dates.</td></tr>
			<tr><td></td><td><font color="FF6600"><u><b>Reports Season</b></u></font></td></tr>		
			<tr><td align="right">Season:</td>
				<td><select name="smgseasonid">
					<option value="0"></option>
					<cfloop query="smg_seasons">
					<option value="#seasonid#">#season#</option>
					</cfloop>
					</select></td>
			</tr>
			<tr><td></td><td>*Reports - Eg. 07 Jan Programs are considered 07/08 season.</td></tr>
			<tr><td></td><td><font color="FF6600"><u><b>Incentive Trip</b></u></font></td></tr>
			<tr><td align="right">Incentive Trip:</td>
				<td><cfselect name="smg_trip" required="yes" message="You must select an incentive trip for the program">
					<option value="0"></option>
					<cfloop query="smg_trips">
					<option value="#tripid#">#trip_place#</option>
					</cfloop>
					</cfselect></td>
			</tr>	
		</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</div>

<table border=0 cellpadding=2 cellspacing=2 width=100% align="center" class="section">
<tr>
	<td align="right"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.go(-1)"> &nbsp;  &nbsp; </td>
	<td align="left"> &nbsp;  &nbsp; <input name="Submit" type="image" src="pics/next.gif" border=0></td>
</tr>
</Table>

<cfinclude template="../table_footer.cfm">

</cfform>

</cfoutput>
<br><br>

</body>
</html>