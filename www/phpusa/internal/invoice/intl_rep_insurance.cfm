<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>INTERNATIONAL REPRESENTATIVES INSURANCE POLICY LIST</title>
</head>

<body>

<cfquery name="get_intl_reps" datasource="mysql">
	SELECT userid, businessname, php_insurance_typeid 
	FROM smg_students s
	INNER JOIN php_students_in_program php ON s.studentid = php.studentid
	INNER JOIN smg_users u ON s.intrep = u.userid
	WHERE u.usertype = '8'
		AND php.companyid = '#client.companyid#'
	GROUP BY userid
	ORDER BY businessname	
</cfquery>

<cfquery name="get_insutypes" datasource="MySql">
	SELECT insutypeid, type
	FROM smg_insurance_type
</cfquery>

<cfoutput>

<cfform action="?curdoc=invoice/intl_rep_insurance_qr" method="post">

<cfinput type="hidden" name="count" value="#get_intl_reps.recordcount#">
<br /><br />
<table width="90%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><th colspan="2">INTERNATIONAL REPRESENTATIVES INSURANCE POLICY LIST</th></tr>
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="5" cellspacing="0" width="90%" align="center">
				<tr bgcolor="##C2D1EF">
					<td><b>International Representative</b></td>
					<td><b>Insurance Policy Type</b></td>
				</tr>
				<cfloop query="get_intl_reps">
					<tr  bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
						<td>
							#businessname#
							<cfinput type="hidden" name="#currentrow#_userid" value="#userid#">
						</td>
						<td>
							<cfset php_insurance_typeid = get_intl_reps.php_insurance_typeid>
							<cfselect name="#currentrow#_php_insurance_typeid">
								<option value="0"></option>
								<cfloop query="get_insutypes">
								<option value="#insutypeid#" <cfif php_insurance_typeid EQ insutypeid>selected</cfif>>#type#</option>
								</cfloop>
							</cfselect>	
						</td>
					</tr>
				</cfloop>
				<tr bgcolor="##C2D1EF"><th colspan="5"><cfinput type="image" name="next" value=" Update " src="pics/update.gif" align="middle" submitOnce></th></tr>
			</table>
		</td>
	</tr>
</table>
<br /><br />
</cfform>
</cfoutput>

</body>
</html>
