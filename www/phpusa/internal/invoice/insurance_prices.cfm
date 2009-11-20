<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>INSURANCE PRICES LIST</title>
</head>

<body>

<cfquery name="get_insutypes" datasource="MySql">
   	SELECT 
    	insutypeid, 
        type, 
        ayp5, 
        ayp10, 
        ayp12
	FROM 
    	smg_insurance_type
    WHERE
    	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>

<cfoutput>

<cfform action="?curdoc=invoice/insurance_prices_qr" method="post">

<cfinput type="hidden" name="count" value="#get_insutypes.recordcount#">
<br /><br />
<table width="90%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><th colspan="2">INSURANCE PRICES LIST</th></tr>
	<tr>
		<td width="100%" valign="top">
			<table border="0" cellpadding="5" cellspacing="0" width="90%" align="center">
				<tr bgcolor="##C2D1EF">
					<td><b>Insurance Policy Type</b></td>
					<td><b>5 Month Program</b></td>
					<td><b>10 Month Program</b></td>
					<td><b>12 Month Program</b></td>
				</tr>
				<cfloop query="get_insutypes">
					<tr  bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
						<td><cfinput type="hidden" name="#currentrow#_insutypeid" value="#insutypeid#">#type#</td>
						<td><cfinput type="text" name="#currentrow#_ayp5" value="#ayp5#" size="4"></td>
						<td><cfinput type="text" name="#currentrow#_ayp10" value="#ayp10#" size="4"></td>
						<td><cfinput type="text" name="#currentrow#_ayp12" value="#ayp12#" size="4"></td>
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
