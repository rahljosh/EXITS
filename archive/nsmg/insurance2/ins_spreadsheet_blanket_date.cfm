<cfquery name="stu_ins" datasource="mysql">
	SELECT distinct stu.studentid, stu.firstname, stu.familylastname, stu.dob, smg_insurance_type.insutypeid, smg_insurance_type.type, stu.programid as stu_program_id,
	smg_insurance_codes.policycode, smg_insurance_type.insutypeid, stu.programid, smg_programs.startdate, smg_programs.enddate, stu.schoolid, smg_programs.seasonid, 	smg_programs.insurance_startdate, smg_programs.insurance_enddate, smg_programs.enddate as program_end_Date
	FROM smg_students stu
	LEFT JOIN smg_programs on smg_programs.programid = stu.programid
	LEFT JOIN smg_users on smg_users.userid = stu.intrep
	LEFT JOIN smg_insurance_type on smg_insurance_type.insutypeid = smg_users.insurance_typeid
	LEFT JOIN smg_insurance_codes on smg_insurance_codes.insutypeid = smg_insurance_type.insutypeid

	where <!----studentid = 13719---->
	
	smg_programs.active = 1 
	and stu.companyid = 4
	and stu.active = 1
	and insurance_batch = 1

	and smg_users.insurance_typeid > 10
	order by policycode
	
</cfquery>
<!----TEst Query to remove duplicate
<cfquery name="stu_ins" dbtype="query">
	SELECT distinct flight_type, *
	FROM stu_ins1
	order by studentid
</cfquery>
---->
<cfoutput>
<!----
<cfdump var="#stu_ins#">


---->
<!----


	<Cfquery name="get_policy_code" dbtype=query>
	select distinct policycode as pc
	from stu_ins_master
	</Cfquery>
<cfdump var="#get_policy_code#">
<cfloop query="get_policy_code">
	<cfquery name="stu_ins" dbtype="query">
	select *
	from stu_ins_master
	where policycode = '#pc#'
	</cfquery>
---->

	<!-------->
<!----

<cfdump var="#stu_ins#">
---->


<cfset xlsfilename = 'dmd_#DateFormat(now(),'mmddyyyy')#'>

<!-----show xls to user---->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=#xlsfilename#.xls"> 


<!-----save xls to server---->



				<TABLE>
				<tr>
					<th colspan=8 align="Center"><strong>Enrollment Sheet</strong></th><th></th><th>eSecutive</th>
				</tr>
				<tr bgcolor="##CCCCCC">
					<td colspan=9>&nbsp;</td>
				</tr>
					<Tr>
						<td>POLICY</td>
						<td>POLICY ID</td>
						<td>Last Name</td>
						<Td>First Name</Td>
						<td>Date of Birth</td>
						<TD>Start Date</TD>
						<TD>End Date</TD>
						<td>&nbsp;</td>
						<td>Days</td>
					</Tr>
			
				
					<cfloop query = "stu_ins">
					
					<Tr>
						<td>#type#</td>
						<td>#policycode#</td>
						<td>#familylastname#</td>
						<Td>#firstname#</Td>
						<td>#DateFormat(dob,'dd-mmm-yy')#</td>
						
						
						<td><!----Get arrival date from flight info---->
		<!----
						<cfif now() lt #insurance_enddate#>
							<cfquery name="flight_arrival" datasource="mysql">
							select dep_date
							from smg_flight_info
							where studentid = #studentid#
							and flight_type = 'arrival' and arrival_time <> 'null'
							limit 1
							</cfquery>
							
							<cfif flight_arrival.recordcount neq 0>
							<cfquery name="insert_start_Date" datasource="mysql">
								update smg_insurance_batch
									set startdate = #flight_arrival.dep_date#
								WHERE studentid = #studentid#
								AND file = '#xlsfilename#'
							</cfquery>
								#DateFormat(flight_arrival.dep_date,'mm/dd/yy')#
							<cfelse>
								#DateFormat(insurance_startdate,'mm/dd/yy')#
							<cfquery name="insert_start_Date" datasource="mysql">
								update smg_insurance_batch
									set startdate = #insurance_startdate#
								where studentid = #studentid# and file = '#xlsfilename#'
							</cfquery>
							</cfif>
						<cfelse>
							<cfquery name="insert_start_Date" datasource="mysql">
								update smg_insurance_batch
									set startdate = #insurance_startdate#
								where studentid = #studentid# and file = '#xlsfilename#'
							</cfquery>
								#DateFormat(insurance_startdate, 'mm/dd/yy')#
						</cfif>
					---->
						
						</td>
						<td>
						
						
						<!---Insurance End date---->
							<!----SEt end date to 1) Flight departure date if current date is before blanket insruance date (set in program maint)---->
						<!----If no flight date and its before ins_end date, sent to insurance end date---->
						<!----After insurance end date, set to departure date, if no departure date, set to End of School + 5, if no school date, set to Insurance end date from program maint)----><!----
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
					
						<cfdump var="#flight_departure#">
					<cfdump var="#school_end#">
				
						<!----gt is before date, lt is after date---->
				
						<Cfset currentdate = #now()#>

						<cfset initial = #CreateODBCDate('05/15/2009')#>
						
						<cfif flight_departure.dep_Date is ''>
							<cfset primary = ''>
						<cfelse>
							<cfset primary = #CreateODBCDate('#flight_departure.dep_Date#')#>
						</cfif>
						
						<cfif school_end.year_ends is ''>
							<cfset secondary = ''>
						<cfelse>
							<cfset secondary = #DateFormat(DateAdd("d", "5", #school_end.year_ends#), 'mm/dd/yy')#>
						</cfif>
						
						<cfset tertiary = #CreateODBCDate('#insurance_enddate#')#>
						
						<cfif #primary# is not '' and #primary# lt #initial#>
							<cfset showenddate = #primary#>
						<cfelseif #secondary# is not '' and #secondary# lt #initial#>
							<cfset showenddate = #secondary#>
						<cfelseif #currentdate# lt #initial#>
							<cfset showenddate = #initial#>
						
						<cfelse>
							<cfset showenddate = #CreateODBCDate('#tertiary#')#>
						</cfif> 
	---->
				
		
					
				
					
						</td>	
						<td>&nbsp;</td>
						<td></td>
					</tr>
					</cfloop>
				</table>


</cfoutput>
