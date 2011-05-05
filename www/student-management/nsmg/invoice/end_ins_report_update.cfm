<cfquery name="insurance_report" datasource="mysql">
	SELECT stu.studentid, stu.firstname, stu.familylastname, stu.companyid,
	comp.companyshort, stu.intrep, u.businessname, stu.countrycitizen, stu.dob,stu.programid, stu.schoolid,
	country.countryname, country.countrycode, stu.programid, smg_programs.enddate,
	smg_school_dates.year_ends,
	smg_programs.programname
	from smg_students stu
 	LEFT JOIN smg_companies comp on stu.companyid = comp.companyid
	LEFT JOIN smg_users u on stu.intrep = u.userid
	LEFT JOIN smg_countrylist country on stu.countrycitizen = country.countryid
	LEFT JOIN smg_programs on stu.programid = smg_programs.programid
	LEFT JOIN smg_school_dates on stu.schoolid = smg_school_dates.schoolid

	where stu.active = 1 and stu.programid <= 214
	and stu.companyid = #url.co# and smg_school_dates.seasonid = 4
	order by stu.companyid 
	
</cfquery>

<cfheader name="Content-Disposition" value="attachment; filename=end_ins_report.xls"> 

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
                            AND isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
						ORDER BY dep_date DESC 
					</cfquery>
					
					<cfquery name="get_type" datasource="MySql">
						SELECT max(policy_code) as policy_code, end_date
						FROM smg_insurance
						WHERE studentid = #studentid#
						group by policy_code
					</cfquery>
					<cfif get_type.policy_code is ''>
						<cfset get_type.policy_code = 0>
					</cfif>
										
							
					
					
	<tr>
		<td>#companyshort#</td><td>#businessname#</td><td>#studentid#</td><td> #firstname# </td><td>#familylastname# </td><td>#programname#</td>
		<td><cfif year_ends is ''>
				<cfset school_year_end = '06/30/2008'>
			<cfelse>
				<cfset school_year_ends=#DateFormat(year_ends, 'mm/dd/yyyy')#>
			 </cfif>#school_year_ends#
		</td>
		<td><cfif school_year_ends is '06/30/2008'><cfset prog_end_date = '06/23/2008'><cfelse><cfset prog_end_date = #school_year_ends#></cfif>  
		<cfset df= '#DateAdd('d',7,prog_end_date)#'>#DateFormat(df , 'mm/dd/yyyy')#</td>
		<td><cfif get_flight.dep_date is ''><cfset departure_date = '06/30/2008'><cfelse><cfset departure_date = '#get_flight.dep_date#'></cfif>#DateFormat(departure_date,'mm/dd/yyyy')#</td>
		<td><cfif get_flight.dep_date is ''><cfset departure_date = '06/30/2008'><cfelse><cfset departure_date = '#get_flight.dep_date#'></cfif>#DateFormat(departure_date,'mm/dd/yyyy')#</td>
		<td><cfset chargeem = #DateDiff('d',df,departure_date)#> <cfif chargeem lte 0>0<cfelse>#chargeem#</cfif> </td>
		
</tr>
	</cfloop>
</Table>		

</cfoutput>
