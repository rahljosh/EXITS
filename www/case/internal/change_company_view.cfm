<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Change Company View</title>
<link rel="stylesheet" href="smg.css" type="text/css">

</head>

<body font-face="Arial">

	<cfquery name="get_companies" datasource="caseusa">
		SELECT distinct companyid
		FROM user_access_rights
		WHERE userid = '#client.userid#'
	</cfquery>
	<Table border=0 align="center" bgcolor="#B5D66E"width="100%">
	<th colspan=12><h1>You have access to the following companies, please choose which one you would like to view:<br></th>
		<tr>
	<Cfset ce = '#DateFormat(DateAdd('d','0','#now()#'), 'yyyy-mm-dd')# #TimeFormat(DateAdd('n','1','#now()#'), 'HH:mm:ss')#'>
	
	<cfoutput query="get_companies">

		<cfquery name="companies_available" datasource="caseusa">
			SELECT companyid,companyname,companyshort
			FROM smg_companies
			WHERE companyid = '#get_companies.companyid#' 
				AND companyid <= '5'
				<!---
				<cfif client.usertype NEQ '1'>
					AND companyid != '6'
				</cfif> --->
		</cfquery>

		<cfcookie name="prev_view" value=#cgi.http_referer# expires='#ce#'>
		<cfloop query="companies_Available">
		<td valign="middle" width=80><a href="set_company.cfm?id=#companyid#"><img src="pics/logos/#LCase(companyshort)#_clear.gif" align="center" border=0></td><td width=180><a href="set_company.cfm?id=#companyid#">#companyshort#<br>#companyname#<br></td>
		</cfloop>

</cfoutput>
</table>
<table width=100%  cellpadding=0 cellspacing=0>
	<tr >
		<td height=24 align="center" background="pics/footer_background.gif">&copy;2005 Student Management Group :: Powered by <a href="http://www.exitgroup.org/" target="_blank"><font color="black">E</font><font color="orange">X</font><font color="black">ITS</font></a></td>
	</tr>
</table>
</body>
</html>