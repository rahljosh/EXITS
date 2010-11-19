<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Insurance Codes Maintenance</title>
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
	WHERE 1=1
		<cfif client.companyid NEQ '5'>AND codes.companyid = '#client.companyid#'</cfif>
	ORDER BY companyshort, season, insu_codeid
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Insurance Codes Maintenance</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section">

<cfoutput>

<table border=0 cellpadding=2 cellspacing=2 width=600 align="center">
<tr>
	<td><b>Company</b></td>
	<td><b>Season</b></td>
	<td><b>Policy Code</b></td>	
	<td><b>Insurance Type</b></td>
</tr>
<cfloop query="insurance_codes">
<tr bgcolor="#iif(insurance_codes.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
	<td>#companyshort#</td>
	<td>#season#</td>	
	<td>#policycode#</td>	
	<td>#type#</td>
</tr>
</cfloop>
<tr><td colspan=4>&nbsp;</td></tr>
<Tr><td colspan=4 align="center">
		<cfform method="post" action="?curdoc=insurance/new_policy">
		<cfinput name="Submit" type="image" src="pics/new.gif" border=0>
		</cfform>
	</td>
</Tr>
</table>

</cfoutput>
</div>

<cfinclude template="../table_footer.cfm">

</body>
</html>