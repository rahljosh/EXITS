<cfquery name="stu_ins" datasource="mysql">
	SELECT distinct stu.studentid, stu.firstname, stu.familylastname, stu.dob, smg_insurance_type.insutypeid, smg_insurance_type.type, stu.programid as stu_program_id,
	smg_insurance_codes.policycode, smg_insurance_type.insutypeid, stu.programid, smg_programs.startdate, smg_programs.enddate, stu.schoolid, smg_programs.seasonid, smg_programs.insurance_startdate, smg_programs.insurance_enddate, smg_programs.enddate as program_end_Date
	FROM smg_students stu
	LEFT JOIN smg_programs on smg_programs.programid = stu.programid
	LEFT JOIN smg_users on smg_users.userid = stu.intrep
	LEFT JOIN smg_insurance_type on smg_insurance_type.insutypeid = smg_users.insurance_typeid
	LEFT JOIN smg_insurance_codes on smg_insurance_codes.insutypeid = smg_insurance_type.insutypeid
	where smg_programs.active = 1 and stu.studentid NOT IN (select studentid  from smg_insurance_batch where type = 'N')
	and stu.companyid < 6 and smg_programs.insurance_batch = 1

</cfquery>
<table>
	<Tr>
		<Td>I</Td><td>P</td><td>S</td><td>T</td><Td>To insert on Spreadsheet</Td>
	</Tr>
<cfoutput query="stu_ins">


<cfquery name="flight_departure" datasource="mysql">
	select dep_date
	from smg_flight_info
	where studentid = #studentid#
	and flight_type = 'departure'
	limit 1
</cfquery>

<cfquery name="school_end" datasource="mysql">
	select year_ends from smg_school_dates
	where schoolid = #schoolid# and seasonid = #seasonid#
</cfquery>

<!----Flight Info is missing or after 15th for May---->

<Cfset currentdate = #now()#>

<cfset initial = #CreateODBCDate('05/15/2009')#>

<cfif flight_departure.dep_Date is ''>
	<cfset primary = ''>
<cfelse>
	<cfset primary = #DateFormat(flight_departure.dep_Date, 'mm/dd/yy')#>
</cfif>

<cfif school_end.year_ends is ''>
	<cfset secondary = ''>
<cfelse>
	<cfset secondary = #DateFormat(DateAdd("d", "5", #school_end.year_ends#), 'mm/dd/yy')#>
</cfif>

<cfset tertiary = #DateFormat(insurance_enddate,'mm/dd/yy')#>

<cfif #primary# is not '' and #primary# gt #initial#>
	<cfset showdate = #primary#>
<cfelseif #secondary# is not '' and #secondary# lt #initial#>
	<cfset showdate = #secondary#>
<cfelseif #currentdate# lt #initial#>
	<cfset showdate = #initial#>

<cfelse>
	<cfset showdate = #DateFormat(tertiary, 'mm/dd/yy')#>
</cfif> 





	
	
	<tr>
	
<Td>#initial#</Td><td> #primary#</Td><td> #secondary#</Td><td> #tertiary#</td><td>#showdate#</td>
</tr>




</cfoutput>