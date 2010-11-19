<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New Policy Policy</title>
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
</head>

<body>

<cfquery name="insu_type" datasource="MySql">
	SELECT insutypeid, type
	FROM smg_insurance_type
	WHERE insutypeid = '6'
</cfquery>

<cfquery name="smg_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
</cfquery>

<cfoutput>

<cfform action="?curdoc=insurance/qr_new_policy" method="post" name="new_policy" onSubmit="return CheckData();">
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; New Insurance Policy</td>
				</tr>
			</table><br>
			<table width="80%" border="0" cellpadding="3" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr bgcolor="8FB6C9"><td colspan="2" class="style2">Please fill out each field for the new policy, then click on next.</td></tr>
				<tr>
					<td align="right">Policy Code: </td>
					<td><cfinput type="text" name="policycode" value="" size="25" required="yes" message="You must enter the Policy Code"></td>
				</tr>
				<tr>
					<td align="right">Type: </td>
					<td><cfselect name="insutypeid" required="yes" message="you must select a type">
						<option value="0"></option>
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
				<tr bgcolor="##8FB6C9">
					<th colspan="4" valign="top">	
						<a href="?curdoc=insurance/insurance_policies"><img src="../pics/goback.gif" border="0" /></a>
						&nbsp; &nbsp; &nbsp; &nbsp; 
						<cfinput name="Submit" type="image" src="../pics/next.gif" border=0></th>				
				</tr>
			</table><br>
		</td>
	</tr>
</table>
</cfform>

</cfoutput>

</body>
</html>