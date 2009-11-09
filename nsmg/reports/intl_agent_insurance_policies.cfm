<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>International Representative Policies</title>
</head>

<body>

<cfquery name="get_insurance_type" datasource="MySql">
	SELECT insutypeid, type 
	FROM smg_insurance_type
</cfquery>
	
<cfoutput>					

<table align="center" width="95%" frame="box">
	<tr><th>International Representative Policies</th></tr>
	<cfloop query="get_insurance_type">
		<tr><td><b>Insurance Policy Type : #get_insurance_type.type#</b></td></tr>
		<cfquery name="get_agents" datasource="MySql"> 
			SELECT 	u.userid, u.businessname, type.type
			FROM smg_students s 
			INNER JOIN smg_users u ON s.intrep = u.userid
			LEFT JOIN smg_insurance_type type ON type.insutypeid = u.insurance_typeid 
			WHERE s.active = '1'
				AND s.companyid != '6'	
				AND type.insutypeid = '#get_insurance_type.insutypeid#'
			GROUP BY u.userid
			ORDER BY u.businessname
		</cfquery>
		<cfloop query="get_agents">
			<tr><td>&nbsp; &nbsp; &nbsp; &nbsp; #businessname#</td></tr>
		</cfloop>
			<tr><td>&nbsp;</td></tr>
	</cfloop>
</table>

</cfoutput>
</body>
</html>