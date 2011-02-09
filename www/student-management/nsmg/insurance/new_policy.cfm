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
if (document.new_policy.policycode.value == '') {
	alert("You must enter a policy code.");
	document.new_policy.policycode.focus();
	return false; }
if (document.new_policy.insutypeid.value == '0') {
	alert("You must select an insurance type.");
	document.new_policy.insutypeid.focus();
	return false; }
if (document.new_policy.seasonid.value == '0') {
	alert("You must select a season which the insurance policy will be applied to.");
	document.new_policy.seasonid.focus();
	return false; }			  	
}
//-->
</script>

<body>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>New Policy Code</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section">

<cfif client.companyid EQ '5'>
	<table border=0 cellpadding=2 cellspacing=2 width=800 align="center">
	<tr><td>You must not be logged as SMG in order to enter new policy codes.<br><br></td></tr>
	<tr>
		<td align="center"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.go(-1)"> &nbsp;  &nbsp; </td>
	</tr>
	</Table>
	</div>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<cfquery name="insu_type" datasource="MySql">
	SELECT insutypeid, type
	FROM smg_insurance_type
	WHERE insutypeid != '1'
    	and active = 1
</cfquery>

<cfquery name="smg_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
</cfquery>

<cfoutput>

<cfform action="?curdoc=insurance/qr_new_policy" method="post" name="new_policy" onSubmit="return CheckData();">

<table border=0 cellpadding=2 cellspacing=2 width=800 align="center">
	<tr><td align="center">Please fill out each field for the new policy, then click on next. </td></tr>
	<tr>
		<td>
		<table class="nav_bar" align="center">
			<tr>
				<td align="right">Policy Code: </td>
				<td><cfinput type="text" name="policycode" value="" size="25" required="yes" message="You must enter the Policy Code"></td>
			</tr>
			
			<tr>
				<td align="right">Type: </td>
				<td><cfselect name="insutypeid" required="yes" message="you must select a type">
					<option value="0">Select Type</option>
					<cfloop query="insu_type">
					<option value="#insutypeid#">#type#</option>
					</cfloop>
					</cfselect>
				</td>
			</tr>
			<tr><td align="right">Season:</td>
				<td><cfselect name="seasonid" required="yes" message="you must select a season">
					<option value="0"></option>
					<cfloop query="smg_seasons">
					<option value="#seasonid#">#season#</option>
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
	<td align="left"> &nbsp;  &nbsp; <input name="Submit" type="image" src="pics/next.gif" border=0></form></td>
</tr>
</Table>

<cfinclude template="../table_footer.cfm">

</cfform>

</cfoutput>
<br><br>

</body>
</html>