<cfif not IsDefined('url.state')>
	You must enter a url.state.
	<cfabort>
</cfif>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<!---
<cfquery name="get_hosts" datasource="caseusa">
	SELECT stu.studentid, 
		   host.hostid, host.familylastname, host.address, host.address2, host.city, host.state, host.zip
	FROM smg_students stu
	INNER JOIN smg_hosts host ON stu.hostid = host.hostid
	WHERE stu.active = '1'
		AND ( stu.programid = '66' or stu.programid = '69' or stu.programid = '70' or stu.programid = '72' or
		stu.programid = '4' or stu.programid = '68' or stu.programid = '76' or stu.programid = '73')
	GROUP BY host.hostid
	ORDER BY host.familylastname
</cfquery>
--->

<cfquery name="get_hosts" datasource="caseusa">
	SELECT hostid, familylastname, address, address2, city, state, zip,	
		fatherfirstname, motherfirstname, phone
	FROM smg_hosts 
	WHERE active = '1' AND state = '#url.state#'  AND companyid = '1'
	ORDER BY familylastname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_users.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
	<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td>Host ID</td>
		<td>Last Name</td>
		<td>Mother</td>
		<td>Father</td>
		<td>Phone</td>
		<td>Address</td>
		<td>City</td>
		<td>State</td>
		<td>Zip</td>
	</tr>
</cfoutput>
<cfoutput query="get_hosts">
	<tr>
		<td>#hostid#</td>
		<td>#familylastname#</td>
		<td>#motherfirstname#</td>
		<td>#fatherfirstname#</td>
		<td>#phone#</td>
		<td><cfif #address# is ''>#Address2#<cfelse>#Address#</cfif></td>
		<td>#City#</td>
		<td>#State#</td>
		<td>#ZIP#</td>
	</tr>
</cfoutput>
<cfoutput>
	</table>
</cfoutput> 