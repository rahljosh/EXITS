<cfquery name="insurance_report" datasource="mysql">
	SELECT stu.studentid, stu.firstname, stu.familylastname, stu.companyid,
	comp.companyshort, stu.intrep, u.businessname, stu.countrycitizen, stu.dob,stu.programid,
	country.countryname, country.countrycode, stu.programid,
	smg_programs.programname
	from smg_students stu
 	LEFT JOIN smg_companies comp on stu.companyid = comp.companyid
	LEFT JOIN smg_users u on stu.intrep = u.userid
	LEFT JOIN smg_countrylist country on stu.countrycitizen = country.countryid
	LEFT JOIN smg_programs on stu.programid = smg_programs.programid
	where stu.active = 1 and stu.programid <= 214
	and stu.companyid = #url.co#
	order by stu.companyid 
	
</cfquery>



<cfquery name="single_date" datasource="mysql">
select dep_date
from smg_flight_info
where studentid = 4928
</cfquery>
<!----
<cfheader name="Content-Disposition" value="attachment; filename=end_ins_report.xls"> 
---->
<cfoutput>

<Table>

	<tr>
		<td>Company</td><td>Agent</td><td>Student ID</td><td>First Name</td><td>Last Name</td><td>Program Name</td><td>School End Date</td><td>Program End Date</td><TD>Departure Date</TD><td>Ins End Date</td><td>Extra days</td>
	</tr>
	<cfloop query=insurance_report> 
				<cfquery name="get_flight" datasource="MySql">
						SELECT DISTINCT dep_date
						FROM smg_flight_info
						WHERE studentid = #studentid#
							AND flight_type = 'departure'
						ORDER BY dep_date DESC 
					</cfquery>
					
					<cfquery name="get_type" datasource="MySql">
						SELECT max(policy_code) as policy_code
						FROM smg_insurance
						WHERE studentid = #studentid#
					</cfquery>
					<cfif get_type.policy_code is ''>
						<cfset get_type.policy_code = 0>
					</cfif>
										
							et pt_name.type = "N/A">
							</cfif>
					
					
	<tr>
		<td>#companyshort#</td><td>#businessname#</td><td>#studentid#</td><td> #firstname# </td><td>#familylastname# </td><td>#programname#</td><td>#DateFormat(get_flight.dep_date,'mm/dd/yyyy')#</td><td>
		<cfif get_flight.dep_Date is ''>06/30/2008<cfelse>#DateFormat(get_flight.dep_date,'mm/dd/yyyy')#</cfif>
		</td>
		<Td>
		<cfif #get_flight.dep_Date# is '' or #get_flight.dep_date# gt '2008-06-01'>N<cfelseif #get_flight.dep_date# lte '2008-06-02'>X<cfelse>Woops</cfif>
		</Td>
		<td><cfif #get_flight.dep_date# is ''>30 days - default for no flight date.<cfelseif #get_flight.dep_Date# gt '2008-06-01'>#DateDiff('d','06/01/2008','#get_flight.dep_date#')#<cfelse>No Charge</cfif></td>
	</tr>
	</cfloop>
</Table>		

</cfoutput>
