<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT 
		s.studentid, s.firstname, s.familylastname, s.programid, s.regionassigned, s.grades, s.email, s.ds2019_no, s.sex,
		p.programname,
		h.familylastname as hostfamily, h.address as hostaddress, h.address2 as hostaddress2, 
		h.city as hostcity, h.state as hoststate, h.zip as hostzip,
		sch.schoolname, sch.address as schooladdress, sch.city as schoolcity, sch.state as schoolstate, sch.zip as schoolzip, sch.principal,
		area.firstname as areafirst, area.lastname as arealast, area.userid as areaid,
		r.regionname,
		c.companyshort,
		country.countryname
	FROM smg_students s 
	INNER JOIN smg_programs p		ON 	s.programid = p.programid
	INNER JOIN smg_hosts h 	ON 	s.hostid = h.hostid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	INNER JOIN smg_countrylist country ON s.countryresident = country.countryid 
	INNER JOIN smg_regions r ON r.regionid = s.regionassigned 
	LEFT JOIN smg_schools sch ON 	s.schoolid = sch.schoolid
	LEFT JOIN smg_users area ON s.arearepid = area.userid
	WHERE s.active = '1' 
		AND s.companyid = '#client.companyid#' 
		<cfif form.regionid is 0><cfelse>
			AND s.regionassigned = #form.regionid#
		</cfif>
		<cfif not isdefined('form.grade')><cfelse>
		 AND (s.grades = 11 or s.grades = 12)
		</cfif>
		AND	( <cfloop list=#form.programid# index='prog'>
		s.programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
		<!--- and s.email <> '' --->
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
	<td><b>DS 2019</b></td>
	<td><b>Email</b></td>
	<td><b>Program</b></td>
	<td><b>Region</b></td>						
	<td><b>Host Family</b></td>
	<td><b>Address</b></td>	
	<td><b>City</b></td>	
	<td><b>State</b></td>	
	<td><b>Zip</b></td>	
	<td><b>School Name</b></td>
	<td><b>School Address</b></td>
	<td><b>School City</b></td>
	<td><b>School State</b></td>
	<td><b>School Zip</b></td>
	<td><b>School Contact</b></td>
	<td><b>Supervising Representative</b></td>
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
	<td>#ds2019_no#</td>
	<td>#email#</td>
	<td>#programname#</td>
	<td>#regionname#</td>
	<td>#hostfamily#</td>
	<td><cfif hostaddress is ''>#hostaddress2#<cfelse>#hostaddress#</cfif></td>
	<td>#hostcity#</td>
	<td>#hoststate#</td>
	<td>#hostzip#</td>
	<td>#schoolname#</td>	
	<td>#schooladdress#</td>	
	<td>#schoolcity#</td>	
	<td>#schoolstate#</td>
	<td>#schoolzip#</td>
	<td>#principal#</td>
	<td>#areafirst# #arealast#</td>
</tr>		
</cfoutput>
</table>