<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New Program</title>
</head>

<script type="text/javascript">
<!--
function CheckData() {
if (document.new_program.type.value == '0') {
	alert("You must select the program's type.");
	document.new_program.type.focus();
	return false; }  	

if (document.new_program.seasonid.value == '0') {
	alert("You must select the program's season.");
	document.new_program.seasonid.focus();
	return false; }  	
}
//-->
</script>

<body>

<cfquery name="program_types" datasource="mysql">
	SELECT * 
	FROM smg_program_type 
	WHERE active = 1
</cfquery>

<cfquery name="smg_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
</cfquery>

<cfoutput>

<cfform action="?curdoc=tools/new_program_qr" method="post" name="new_program" onSubmit="return CheckData();">

<table width="90%" align="center">
	<tr><td><h3>N e w  &nbsp; &nbsp; P r o g r a m </h3></td></tr>
</table>

<table  width="90%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td colspan="2" bgcolor="C2D1EF"><b>Program Information</b></td></tr>
	<tr><td colspan="2" align="center">Please fill out each field for the new program, then click on next.</td></tr>
	<tr>
		<td width="15%" align="right">Program Name:</td>
		<td width="85%"><cfinput name="programname" size="25" required="yes" message="You must enter a program name in order to continue." maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td align="right">Program Type: </td>
		<td><cfselect name="type" required="yes" message="You must select the program's type.">
			<option value=0></option>
			<cfloop query="program_types">
			<option value="#programtypeid#">#programtype#</option>
			</cfloop> (select the program's lenght)
			</cfselect>
		</td>
	</tr>	
	<tr>
		<td align="right">Start Date:</td>
		<td><cfinput type="text" name="startdate" value="" size=10 validate="date" required="yes" message="You must enter a start date"> (mm-dd-yyyy)</td>
	</tr>
	<tr>
		<td align="right">End Date:</td>
		<td><cfinput type="text" name="enddate" value="" size=10 validate="date" required="yes" message="You must enter an end date"> (mm-dd-yyyy)</td>
	</tr>
	<tr><td colspan="2" bgcolor="C2D1EF"><b>Insurance Information</b></td></tr>
	<tr>
		<td align="right">Insurance Start Date: </td>
		<td><cfinput type="text" name="insurance_startdate" value="" validate="date" size=10> (mm-dd-yyyy)</td>
	</tr>
	<tr>
		<td align="right">Insurance End Date: </td>
		<td><cfinput type="text" name="insurance_enddate" value="" validate="date" size=10> (mm-dd-yyyy)</td>
	</tr>
	<tr><td colspan="2" bgcolor="C2D1EF"><b>Program Season</b></td></tr>
	<tr><td align="right">Program Season:</td>
		<td><cfselect name="seasonid" required="yes" message="You must select the program's season.">
			<option value="0"></option>
			<cfloop query="smg_seasons">
			<option value="#seasonid#">#season#</option>
			</cfloop>
			</cfselect></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>

<table width=90% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="right"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.go(-1)"> &nbsp;  &nbsp; </td>
		<td align="left"> &nbsp;  &nbsp; <input name="Submit" type="image" value="  next  " src="pics/next.gif" alt="Next" border="0"></td>
	</tr>
</Table>
<br><br>
</cfform>

</cfoutput>

</body>
</html>