<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Edit Program</title>
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

<Cfquery name="get_program" datasource="MySQL">
	SELECT  p.programid, p.programname, p.type, p.startdate, p.enddate, p.insurance_startdate, p.insurance_enddate, p.insurance_batch,
			p.companyid, p.programfee, p.seasonid, p.programfee, p.insurance_w_deduct, p.insurance_wo_deduct,
			smg_companies.companyshort,
			smg_program_type.programtype,
			smg_seasons.season
	FROM smg_programs p
	INNER JOIN smg_companies ON smg_companies.companyid = p.companyid
	LEFT JOIN smg_program_type ON smg_program_type.programtypeid = p.type
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = p.seasonid
	WHERE p.programid = <cfqueryparam value="#url.programid#" cfsqltype="cf_sql_integer">
</Cfquery>

<cfquery name="program_types" datasource="mysql">
	SELECT * 
	FROM smg_program_type 
	WHERE active = 1
</cfquery>

<cfquery name="smg_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
</cfquery>

<cfoutput query="get_program">

<cfform action="?curdoc=tools/edit_program_qr" method="post" name="new_program" onSubmit="return CheckData();">

<cfinput type="hidden" name="programid" value="#programid#">
<table width="90%" align="center">
	<tr><td><h3>N e w  &nbsp; &nbsp; P r o g r a m </h3></td></tr>
</table>

<table  width="90%" class="box" bgcolor="ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td colspan="2" bgcolor="C2D1EF"><b>Program Information</b></td></tr>
	<tr>
		<td width="15%" align="right">Program Name:</td>
		<td width="85%"><cfinput name="programname" size="25" value="#programname#" required="yes" message="You must enter a program name in order to continue." maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td align="right">Program Type: </td>
		<td><cfselect name="type" required="yes" message="You must select the program's type.">
			<option value=0></option>
			<cfloop query="program_types">
			<option value="#programtypeid#" <cfif get_program.type EQ programtypeid>selected</cfif>>#programtype#</option>
			</cfloop> (select the program's lenght)
			</cfselect>
		</td>
	</tr>	
	<tr>
		<td align="right">Start Date:</td>
		<td><cfinput type="text" name="startdate" value="#DateFormat(startdate, 'mm-dd-yyyy')#" size=10 validate="date" required="yes" message="You must enter a start date"> (mm-dd-yyyy)</td>
	</tr>
	<tr>
		<td align="right">End Date:</td>
		<td><cfinput type="text" name="enddate" value="#DateFormat(enddate, 'mm-dd-yyyy')#" size=10 validate="date" required="yes" message="You must enter an end date"> (mm-dd-yyyy)</td>
	</tr>
		<tr>
		<td align="right">Default Program Fee:</td>
		<td><cfinput type="text" name="programfee" value="#programfee#" size=10  required="yes" message="You must enter a program fee"> 0000.00</td>
	</tr>
	<tr><td colspan="2" bgcolor="C2D1EF"><b>Insurance Information</b></td></tr>
	<tr>
		<td align="right">Insurance Start Date: </td>
		<td><cfinput type="text" name="insurance_startdate" value="#DateFormat(insurance_startdate, 'mm-dd-yyyy')#" validate="date" size=10> (mm-dd-yyyy)</td>
	</tr>
	<tr>
		<td align="right">Insurance End Date: </td>
		<td><cfinput type="text" name="insurance_enddate" value="#DateFormat(insurance_enddate, 'mm-dd-yyyy')#" validate="date" size=10> (mm-dd-yyyy)</td>
	</tr>
					<tr><td align="right"> </td>
			<td><input type="checkbox" name="ins_batch" <cfif get_program.insurance_batch eq 1>checked</cfif>> Include Program in Batch Insurance Submission</td>
		</tr>
		<tr><td></td><td><u><b>Insurance Fees</b></u></td></tr>
		<tr>
			<td align="right"><cfif #Right(cgi.HTTP_REFERER, 11)# is 'new_program' ><font color="red"></cfif>Deductible:</td>
			<td><input type="text" name ="insurance_w_deduct" value="#insurance_w_deduct#" size="5"></td>
		</tr>
		<tr>
			<td align="right"><cfif #Right(cgi.HTTP_REFERER, 11)# is 'new_program' ><font color="red"></cfif>Non-deductible:</td>
			<td><input type="text" name ="insurance_wo_deduct" value="#insurance_wo_deduct#" size="5"></td>
		</tr>
	<tr><td colspan="2" bgcolor="C2D1EF"><b>Program Season</b></td></tr>
	<tr><td align="right">Program Season:</td>
		<td><cfselect name="seasonid" required="yes" message="You must select the program's season.">
			<option value="0"></option>
			<cfloop query="smg_seasons">
			<option value="#seasonid#" <cfif seasonid EQ get_program.seasonid>selected</cfif>>#season#</option>
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