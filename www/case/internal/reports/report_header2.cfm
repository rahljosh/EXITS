<!-----Company Information----->
<Cfquery name="companyshort" datasource="caseusa">
SELECT *
FROM smg_companies
WHERE companyid = #client.companyid#
</Cfquery>
<!-----Intl. Agent----->
<cfquery name="int_Agent" datasource="caseusa">
SELECT companyid, businessname, fax, email
FROM smg_users 
WHERE userid = #get_student_info.intrep#
</cfquery>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput>
<table width="100%" align="center" border=0 bgcolor="FFFFFF">
	<tr><th colspan="4"  valign="top" align="left">#companyshort.companyname#</th></tr>
	<tr>
		<td width="60" align="left"></td>	
		<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="right"></td>	
</tr>		
</table>
</cfoutput>
<br>
<table  width=650 align="center" border=0 bgcolor="FFFFFF">
	<hr width=90% align="center">
</table>
<br>
