<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insert Insurance File</title>
</head>

<body>

<cftry>

	<cfquery name="get_policy" datasource="MySql">
		SELECT insu_codeid, companyid, insutypeid, seasonid, policycode
		FROM smg_insurance_codes
		WHERE companyid = '#client.companyid#' 
			AND insutypeid = '#form.insutypeid#'
			AND seasonid = '#form.seasonid#'
	</cfquery>

	<cfif get_policy.recordcount NEQ '0'>
		<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
			<tr>
				<td bordercolor="FFFFFF">
					<!----Header Table---->
					<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
						<tr bgcolor="E4E4E4">
							<td class="title1">&nbsp; &nbsp; Insurance Policy Maintenance</td>
						</tr>
					</table><br>
					<table width="80%" border="0" cellpadding="3" cellspacing="0" align="center" bordercolor="C7CFDC">	
						<tr><td>Error: This code has been entered for this company. You can only add one type of insurance per season.</td></tr>
						<tr bgcolor="#8FB6C9">
							<th><input name="back" type="image" src="../pics/goback.gif" border=0 onClick="javascript:history.go(-1)"></th>
						</tr>
					</table><br>
				</td>
			</tr>
		</table>
		<cfabort>
	</cfif>

	<cfif form.policycode EQ '' OR form.insutypeid EQ 0 OR form.seasonid EQ 0>
		<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
			<tr>
				<td bordercolor="FFFFFF">
					<!----Header Table---->
					<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
						<tr bgcolor="E4E4E4">
							<td class="title1">&nbsp; &nbsp; Insurance Policy Maintenance</td>
						</tr>
					</table><br>
					<table width="80%" border="0" cellpadding="3" cellspacing="0" align="center" bordercolor="C7CFDC">	
						<tr><td>Error: Please make sure Policy Code, Type and Season are filled in properly.</td></tr>
						<tr bgcolor="#8FB6C9">
							<th><input name="back" type="image" src="../pics/goback.gif" border=0 onClick="javascript:history.go(-1)"></th>
						</tr>
					</table><br>
				</td>
			</tr>
		</table>	
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
		location.replace("?curdoc=insurance/insurance_policies");
	//-->
	</script>
	</head>
	</html>	

	<cfcatch type="any">
		<cfinclude template="../error_message.cfm">
	</cfcatch>
</cftry>
	
</body>
</html>