<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get Students  --->
<Cfquery name="get_students" datasource="caseusa">
	SELECT 
		s.studentid, s.firstname, s.familylastname, s.programid, s.regionassigned, s.grades, s.email, s.ds2019_no,
		p.programname,
		c.companyshort, c.companyname, c.iap_auth,
		country.countryname
	FROM smg_students s 
	INNER JOIN smg_programs p  ON 	s.programid = p.programid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	INNER JOIN smg_countrylist country ON country.countryid = s.countrycitizen
	WHERE s.active = '1' 
	AND s.ds2019_no LIKE 'N%'
	AND s.hostid = '0' <!--- EXCLUDING PENDING PLACEMENTS --->
	AND	( <cfloop list=#form.programid# index='prog'>
		s.programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
	ORDER BY s.ds2019_no
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
	<td>Program Number</td>
	<td>Program Name</td>
	<td>Participant's Last Name</td>	
	<td>Participant's First Name</td>	
	<td>SEVIS ID</td>	
	<td>Country of Citizenship</td>
	<td>Seeking Placement (Y/N)</td>
	<td>Program Cancelled (Y/N)</td>		
	<td>Date of Entry into U.S.</td>
	<td>Date of Expected Entry into U.S.</td>
</tr>
</cfoutput>
<cfoutput query="get_students">	
<tr>
	<td>#iap_auth#</td>
	<td>#companyname#</td>
	<td>#familylastname#</td>
	<td>#firstname#</td>
	<td>#ds2019_no#</td>
	<td>#countryname#</td>
	<td>Y</td>
	<td>N</td>
	<td>N/A</td>
	<td>N/A</td>
</tr>		
</cfoutput>
</table>