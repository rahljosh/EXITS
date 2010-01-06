<cfquery name="insurance_report" datasource="mysql">
	SELECT stu.studentid, stu.firstname, stu.familylastname, stu.companyid,
	comp.companyshort, stu.intrep, u.businessname, stu.countrycitizen, stu.dob,
	country.countryname, country.countrycode, stu.programid
	from smg_students stu
 	LEFT JOIN smg_companies comp on stu.companyid = comp.companyid
	LEFT JOIN smg_users u on stu.intrep = u.userid
	LEFT JOIN smg_countrylist country on stu.countrycitizen = country.countryid
	where stu.active = 1 and stu.programid <= 214
	and stu.companyid = #url.co#
	order by stu.companyid 
	
</cfquery>



<cfquery name="single_date" datasource="mysql">
select dep_date
from smg_flight_info
where studentid = 4928
</cfquery>

<cfheader name="Content-Disposition" value="attachment; filename=end_ins_report.xls"> 

<cfoutput>

<Table>

	<tr>
		<td>Agent</td><td>Company</td><td>DOB </td><td>Student ID</td><td>First Name</td><td>Last Name</td><td>Citizenship</td><td>Country Code</td><td>Policy Type</td><TD>Departure Date</TD><td>Ins End Date</td><td>Trans. Type</td><td>Days to Invoice</td>
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
										
							<cfif get_type.recordcount neq 0>
								<cfif len(get_type.policy_code) gt 2>
								<!----Codes for Policy COde instead of type---->
									<cfquery name="pt_name" datasource="mysql">
									select smg_insurance_codes.insutypeid, smg_insurance_type.type
									from smg_insurance_codes
									LEFT JOIN smg_insurance_type on smg_insurance_codes.insutypeid = smg_insurance_type.insutypeid
									where policycode = #get_type.policy_code#
									</cfquery>
								<Cfelse>
									<cfquery name="pt_name" datasource="mysql">
									select type
									from smg_insurance_type
									where insutypeid = #get_type.policy_code#
									</cfquery>
								</cfif>
							<cfelse>
								<cfset pt_name.type = "N/A">
							</cfif>
					
					
	<tr>
		<td>#businessname#</td><td>#companyshort#</td><td>#DateFormat(dob,'mm/dd/yyyy')#</td><td>#studentid#</td><td> #firstname# </td><td>#familylastname# </td><td>#countryname#</td><td>#countrycode#</td><td>#pt_name.type#</td><td>#DateFormat(get_flight.dep_date,'mm/dd/yyyy')#</td><td>
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
