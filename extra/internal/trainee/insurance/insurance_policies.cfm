<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance Policy Maintenance</title>
</head>

<body>

<cfquery name="insurance_codes" datasource="MySql">
	SELECT codes.insu_codeid, codes.companyid, codes.insutypeid, codes.seasonid, codes.policycode,
		   c.companyshort,
		   type.type,
		   s.season
	FROM smg_insurance_codes codes
	LEFT JOIN smg_companies c ON codes.companyid = c.companyid
	LEFT JOIN smg_insurance_type type ON codes.insutypeid = type.insutypeid
	LEFT JOIN smg_seasons s ON codes.seasonid = s.seasonid
	WHERE codes.companyid = '#client.companyid#'
	ORDER BY companyshort, season, insu_codeid
</cfquery>

<cfoutput>

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
				<tr bgcolor="8FB6C9">
					<td class="style2" bgcolor="8FB6C9">Company</td>
					<td class="style2" bgcolor="8FB6C9">Season</td>
					<td class="style2" bgcolor="8FB6C9">Policy Code</td>
					<td class="style2" bgcolor="8FB6C9">Insurance Type</td>
				</tr>
				<cfloop query="insurance_codes">
					<tr  bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
						<td>#companyshort#</td>
						<td>#season#</td>	
						<td>#policycode#</td>	
						<td>#type#</td>
					</tr>
				</cfloop>
				<cfif insurance_codes.recordcount EQ 0>
				<tr><td colspan="4">&nbsp;</td></tr>
				</cfif>
				<tr bgcolor="##8FB6C9">
					<th colspan="4"><a href="?curdoc=insurance/new_policy"><img src="../pics/update.gif" border="0" /></a></th>
				</tr>
			</table><br>
		</td>
	</tr>
</table>
</cfoutput>

</body>
</html>