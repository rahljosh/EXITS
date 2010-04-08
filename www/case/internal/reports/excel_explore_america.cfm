<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="caseusa">
	SELECT 
		s.studentid, s.firstname, s.familylastname, s.programid, s.regionassigned, s.grades, s.email,
		p.programname,
		h.familylastname as hostfamily, h.address as hostaddress, h.address2 as hostaddress2, 
		h.city as hostcity, h.state as hoststate, h.zip as hostzip,
		c.companyshort
	FROM smg_students s 
	INNER JOIN smg_programs p		ON 	s.programid = p.programid
	INNER JOIN smg_hosts h 	ON 	s.hostid = h.hostid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	WHERE s.active = '1' 
	AND	( <cfloop list=#form.programid# index='prog'>
		s.programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
	ORDER BY h.state, s.familylastname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_students.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
<table border="1" cellpadding="3" cellspacing="0">
<tr>
	<td>Student Name</td>
	<td>Host Family</td>
	<td>Address</td>	
	<td>City</td>	
	<td>State</td>	
	<td>Zip</td>
	<td>Email</td>	
</tr>
</cfoutput>
<cfoutput query="get_students">	
<tr>
	<td>#firstname# #familylastname#</td>
	<td>#hostfamily#</td>
	<td><cfif hostaddress is ''>#hostaddress2#<cfelse>#hostaddress#</cfif></td>
	<td>#hostcity#</td>
	<td>#hoststate#</td>
	<td>#hostzip#</td>
	<td>#email#</td>
</tr>		
</cfoutput>
</table>