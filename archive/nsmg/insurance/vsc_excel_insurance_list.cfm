<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=vsc_students.xls"> 

<cfquery name="get_all_insured" datasource="MySql">
	SELECT DISTINCT insu.studentid, insu.firstname, insu.lastname, insu.sex, insu.dob, 
		insu.sent_to_caremed, insu.new_date, insu.end_date, insu.country_code,
		c.companyshort,
		insutype.type
	FROM smg_insurance insu
	INNER JOIN smg_students s ON insu.studentid = s.studentid
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	INNER JOIN smg_insurance_type insutype ON insu.policy_code = insutype.insutypeid
	WHERE insu.transtype = 'new'
		AND policy_code BETWEEN '7' AND '9'
	ORDER BY insu.sent_to_caremed, c.companyshort, insutype.type, insu.lastname 
</cfquery>

<cfoutput>
<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td>SMG Company Name</td>
		<td>ID</td>
		<td>First Name</td>	
		<td>Last Name</td>	
		<td>Gender</td>	
		<td>Date of Birth <br />(mm/dd/yyyy)</td>
		<td>Country of Citizenship</td>	
		<td>VSC Policy Type</td>
		<td>Date Insured <br />(mm/dd/yyyy)</td>
		<td>Policy Start Date <br />(mm/dd/yyyy)</td>
		<td>Policy End Date <br />(mm/dd/yyyy)</td>
	</tr>
	<cfloop query="get_all_insured">	
		<tr>
			<td>#companyshort#</td>
			<td>#studentid#</td>
			<td>#firstname#</td>
			<td>#lastname#</td>
			<td>#sex#</td>
			<td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
			<td>#country_code#</td>
			<td>#type#</td>
			<td>#DateFormat(sent_to_caremed, 'mm/dd/yyyy')#</td>
			<td>#DateFormat(new_date, 'mm/dd/yyyy')#</td>
			<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>
		</tr>		
	</cfloop>
</table>
</cfoutput>	