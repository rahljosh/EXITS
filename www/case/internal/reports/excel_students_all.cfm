<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="caseusa">
	SELECT 
		s.studentid, s.firstname, s.familylastname, s.programid, s.regionassigned, s.grades, s.email, s.ds2019_no, s.sex,
		p.programname,
		h.familylastname as hostfamily, h.address as hostaddress, h.address2 as hostaddress2, 
		h.city as hostcity, h.state as hoststate, h.zip as hostzip,
		r.regionname,
		c.companyshort,
		country.countryname
	FROM smg_students s 
	INNER JOIN smg_programs p ON s.programid = p.programid
	LEFT JOIN smg_hosts h ON s.hostid = h.hostid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	INNER JOIN smg_countrylist country ON s.countryresident = country.countryid 
	LEFT JOIN smg_regions r ON r.regionid = s.regionassigned 
	WHERE s.active = '1' 
		<cfif form.regionid NEQ 0>
			AND s.regionassigned = #form.regionid#
		</cfif>
		AND	( <cfloop list=#form.programid# index='prog'>
		s.programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
		ORDER BY s.familylastname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_students.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
<table border="1" cellpadding="3" cellspacing="0">
<tr>
	<td><b>Company</b></td>
	<td><b>ID</b></td>
	<td><b>First Name</b></td>
	<td><b>Last Name</b></td>
	<td><b>Sex</b></td>
	<td><b>Country</b></td>
	<td><b>Region</b></td>						
	<td><b>Program</b></td>
	<td><b>Host Family</b></td>
</tr>
</cfoutput>
<cfoutput query="get_students">	
<tr>
	<td>#companyshort#</td>
	<td>#studentid#</td>
	<td>#firstname#</td>
	<td>#familylastname#</td>
	<td>#sex#</td>
	<td>#countryname#</td>
	<td>#regionname#</td>
	<td>#programname#</td>
	<td>#hostfamily#</td>
</tr>		
</cfoutput>
</table>