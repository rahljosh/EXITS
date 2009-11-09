<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>INTERNATIONAL REPRESENTATIVES INSURANCE POLICY LIST</title>
</head>

<body>

<cfquery name="get_intl_reps" datasource="mysql">
	SELECT u.userid, u.businessname, u.extra_insurance_typeid
	FROM smg_users u
 	INNER JOIN extra_candidates extra ON u.userid = extra.intrep
	WHERE u.usertype = '8'
		AND extra.companyid = '#client.companyid#'
	GROUP BY userid
	ORDER BY businessname	
</cfquery>

<cfquery name="get_insutypes" datasource="MySql">
	SELECT insutypeid, type
	FROM smg_insurance_type
	WHERE insutypeid = '1' OR insutypeid = '14' OR insutypeid = '6'
</cfquery>

<cfoutput>

<cfform action="?curdoc=insurance/qr_intl_rep_insurance" method="post">

<cfinput type="hidden" name="count" value="#get_intl_reps.recordcount#">

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">
		
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; International Representative Insurance Policy Type List</td>
				</tr>
			</table>
			
			<br>
			
			<table width="80%" border="0" cellpadding="3" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td colspan="2" class="style1">Ps: Changes on this page will affect all EXTRA systems (H2B, TRAINEE AND W&T)</td></tr>
				<tr>
					<td colspan="2">&nbsp;</td></tr>
				<tr bgcolor="8FB6C9">
					<td class="style2" bgcolor="8FB6C9" class="style1">International Representative</td>
					<td class="style2" bgcolor="8FB6C9" class="style1">Insurance Policy Type</td>
				</tr>
				<cfloop query="get_intl_reps">
				<tr  bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
					<td class="style1">#businessname#<cfinput type="hidden" name="#currentrow#_userid" value="#userid#"></td>
					<td class="style1">
							<cfset extra_insurance_typeid = get_intl_reps.extra_insurance_typeid>
							<cfselect name="#currentrow#_extra_insurance_typeid" class="style1">
								<option value="0"></option>
								<cfloop query="get_insutypes">
								<option value="#insutypeid#" <cfif extra_insurance_typeid EQ insutypeid>selected</cfif>>#type#</option>
								</cfloop>
							</cfselect>	
					</td>
				</tr>
				</cfloop>
				<tr bgcolor="##8FB6C9">
					<td colspan="2" align="center"><cfinput type="image" name="next" value=" Update " src="../pics/update.gif" align="middle"></td>
				</tr>
			</table>
			
			<br>
			
		</td>
	</tr>
</table>

</cfform>
</cfoutput>

</body>
</html>