<cfquery name="stu_ins" datasource="mysql">
	SELECT distinct stu.studentid, stu.firstname, stu.familylastname, stu.dob, smg_insurance_type.insutypeid, smg_insurance_type.type, stu.programid as stu_program_id,
	smg_insurance_codes.policycode, smg_insurance_type.insutypeid, stu.programid, smg_programs.startdate, smg_programs.enddate, stu.schoolid, smg_programs.seasonid, 												smg_programs.insurance_startdate, smg_programs.insurance_enddate, smg_programs.enddate as program_end_Date, smg_flight_info.dep_date
	FROM smg_students stu
	LEFT JOIN smg_programs on smg_programs.programid = stu.programid
	LEFT JOIN smg_users on smg_users.userid = stu.intrep
	LEFT JOIN smg_insurance_type on smg_insurance_type.insutypeid = smg_users.insurance_typeid
	LEFT JOIN smg_insurance_codes on smg_insurance_codes.insutypeid = smg_insurance_type.insutypeid
	LEFT JOIN smg_flight_info on smg_flight_info.studentid = stu.studentid
	where <!----studentid = 13719---->
	
	smg_programs.active = 1 and stu.studentid NOT IN (select studentid  from smg_insurance_batch where type = 'N')
	and stu.companyid = 4
	and stu.active = 1
	and insurance_batch = 1
	and smg_flight_info.flight_type = 'arrival' 
	and smg_flight_info.arrival_time <> 'null'
	and smg_users.insurance_typeid > 10
	order by policycode
	
</cfquery>

<cfoutput>
<cfdump var="#stu_ins#">


	<Cfquery name="get_policy_code" dbtype=query>
	select distinct policycode as pc
	from stu_ins
	</Cfquery>
<cfdump var="#get_policy_code#">
<cfloop query="get_policy_code">
	<cfquery name="get_students_by_policy" dbtype="query">
	select *
	from stu_ins
	where policycode = '#pc#'
	</cfquery>
<cfdump var="#get_students_by_policy#">
</cfloop>
	<!-------->
<!----

<cfdump var="#stu_ins#">
---->

<!----  ---->
<cfset xlsfilename = '#CreateUUID()#'>

<!-----show xls to user---->
<!----

---->
<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->


<!-----save xls to server---->


<cfset current_file ="
<cfheader name="Content-Disposition" value="inline;
 filename=mySurveyResults.xls">
<cfcontent type="application/msexcel" >
				<TABLE>
				<tr>
					<th colspan=8 align="Center"><strong>Enrollment Sheet</strong></th><th>eSecutive</th>
				</tr>
				<tr bgcolor="##CCCCCC">
					<td colspan=9>&nbsp;</td>
				</tr>
					<Tr>
						<td>POLICY</td>
						<td>POLICY ID</td>
						<Td>STUDENT ID</Td>
						<td>PROGAMID</td>
						<td>Last Name</td>
						<Td>First Name</Td>
						<td>Date of Birth</td>
						<TD>Start Date</TD>
						
						<TD>End Date</TD>
					</Tr>
				
					<cfloop query = "stu_ins">
					<!----
					<cfquery name="insert_student_id" datasource="mysql">
						insert into smg_insurance_batch (studentid, file,type, date)
							values (#studentid#,'#xlsfilename#','N', #now()#)
					</cfquery>---->
					<Tr>
						<td>#type#</td>
						<td>#policycode#</td>
						<td>#studentid#</td>
						<td>#stu_program_id#</td>
						<td>#familylastname#</td>
						<Td>#firstname#</Td>
						<td>#DateFormat(dob,'mm/dd/yy')#</td>
						
						
						<td><!----Get arrival date from flight info---->
				
						<cfif now() lt #insurance_enddate#>
							<cfquery name="flight_arrival" datasource="mysql">
							select dep_date
							from smg_flight_info
							where studentid = #studentid#
							and flight_type = 'arrival' and arrival_time <> 'null'
							limit 1
							</cfquery>
							<!----
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
								---->
						</cfif>
						<!----
							<cfquery name="insert_start_Date" datasource="mysql">
								update smg_insurance_batch
									set startdate = #dep_date#
								WHERE studentid = #studentid#
								AND file = '#xlsfilename#'
							</cfquery>
							---->
						#DateFormat(dep_Date, 'mm/dd/yy')#
						</td>
						<td>
						
						
						<!---Insurance End date---->
							<!----SEt end date to 1) Flight departure date if current date is before blanket insruance date (set in program maint)---->
						<!----If no flight date and its before ins_end date, sent to insurance end date---->
						<!----After insurance end date, set to departure date, if no departure date, set to End of School + 5, if no school date, set to Insurance end date from program maint)---->
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
						<!----
						<cfdump var="#flight_departure#">
					<cfdump var="#school_end#">
					---->
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
				
					#DateFormat(insurance_enddate,'mm/dd/yy')#
		<!----
					
						<cfquery name="insert_start_Date" datasource="mysql">
								update smg_insurance_batch
									set enddate = #insurance_enddate#,
									submitted = #now()#
								where studentid = #studentid# and file = '#xlsfilename#'
							</cfquery>
					---->
						</td>		
					</tr>
					</cfloop>
				</table>"
				>
			<cffile action="write" file="/ output="#my_code#" addnewline="yes" nameconflict="overwrite"> 	
<!----
<cffile action="write" file="/var/www/html/student-management/nsmg/sevis/xml/#get_company.companyshort#/activate/#get_company.companyshort#_activate_00#get_batchid.batchid#.xml" output="#toString(sevis_batch)#">
---->
</cfoutput>
