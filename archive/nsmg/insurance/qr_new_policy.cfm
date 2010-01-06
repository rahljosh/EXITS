<cftransaction action="begin" isolation="serializable">
<cftry>

	<cfquery name="get_policy" datasource="MySql">
		SELECT insu_codeid, companyid, insutypeid, seasonid, policycode
		FROM smg_insurance_codes
		WHERE companyid = '#client.companyid#' 
			AND insutypeid = '#form.insutypeid#'
			AND seasonid = '#form.seasonid#'
	</cfquery>

	<cfif get_policy.recordcount NEQ '0'>
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
				<td background="pics/header_background.gif"><h2>New Policy Code</h2></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>
		<div class="section">
		<table border=0 cellpadding=2 cellspacing=2 width=800 align="center">
		<tr><td>This code has been entered for this company. You can only add one type of insurance per season.<br><br></td></tr>
		<tr>
			<td align="center"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.go(-1)"> &nbsp;  &nbsp; </td>
		</tr>
		</Table>
		</div>
		<cfinclude template="../table_footer.cfm">
		<cfabort>
	</cfif>

	<cfquery name="insert_insurance" datasource="MySql">
		INSERT INTO smg_insurance_codes
			(companyid, insutypeid, seasonid, policycode)
		VALUES ('#client.companyid#', '#form.insutypeid#', '#form.seasonid#', '#form.policycode#')
	</cfquery>

	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
		location.replace("?curdoc=insurance/insurance_codes");
	//-->
	</script>
	</head>
	</html>	

	<cfcatch type="any">
		<cfinclude template="../forms/error_message.cfm">
	</cfcatch>
</cftry>
	
</cftransaction>