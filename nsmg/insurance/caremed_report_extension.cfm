<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfsetting requesttimeout="500">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE <cfloop list=#form.programid# index='prog'>
			p.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop>
</cfquery>

<!--- get agents --->
<cfquery name="get_agents" datasource="MySQL">
	SELECT userid, businessname, smg_users.email
	FROM smg_users
	INNER JOIN smg_students ON smg_students.intrep = smg_users.userid
	WHERE smg_students.active = '1'
		 AND smg_users.insurance_typeid > '1'
		<cfif form.agentid is 0><cfelse>AND userid = '#form.agentid#'</cfif>
	GROUP BY businessname
	ORDER BY businessname
</cfquery>

<cfoutput>
<table width='95%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - Caremed Extensions</span>
</table>
<br>

<table width='95%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	<tr><td class="style3"><b>Program(s) :</b><br> 
	<cfloop query="get_program"><i>#get_program.companyshort# &nbsp; #get_program.programname#</i><br></cfloop></td></tr>
</table><br>

<table width='95%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">International Agent</th> <th width="25%">Total Assigned</th></tr>
</table><br>

<cfset insureddate = '2006/06/30'>

<cfloop query="get_agents">
	<!--- Get Students By Agent --->
	<Cfquery name="get_students" datasource="MySQL">
		SELECT DISTINCT s.studentid, s.firstname, s.familylastname, s.termination_date,
				u.businessname,
				p.type, p.seasonid, p.programname, p.enddate,
				type.programtypeid,
				u.insurance_typeid,
				sch.semester_ends, sch.year_ends, sch.schoolid,
				c.companyshort
		from smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		INNER JOIN smg_programs p ON p.programid = s.programid
		INNER JOIN smg_program_type type ON p.type = type.programtypeid
		INNER JOIN smg_school_dates sch ON (sch.schoolid = s.schoolid AND sch.seasonid = p.seasonid)
		INNER JOIN smg_companies c ON c.companyid = s.companyid
		WHERE s.active = 1 AND s.intrep = '#get_agents.userid#'
			AND u.insurance_typeid > 1
			AND (<cfloop list=#form.programid# index='prog'>
					s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			   </cfloop>)
		ORDER BY c.companyshort, s.firstname 
	</cfquery>  <!--- PS: PROGRAM TYPE = 3 - 1ST SEMESTER --->
	
	<cfif get_students.recordcount NEQ 0>
		<table width='95%' cellpadding=4 cellspacing="0" align="center" frame="box">	
		<tr><th width="75%"><a href="mailto:#get_agents.email#">#get_agents.businessname#</a> &nbsp; &nbsp; - &nbsp; &nbsp; <!--- Total of #get_students.recordcount# students ---></th><td width="25%" align="center"><!--- #get_students.recordcount# ---></td></tr>
		</table>
		<table width='95%' frame="below" cellpadding=3 cellspacing="0" align="center">
			<tr><td width="6%"><b>Company</b></td>
				<td width="4%"><b>ID</b></th>
				<td width="20%"><b>Student</b></td>
				<td width="10"><b>Program</b></td>
				<td width="13%"><b>Program End Date</b></td>
				<td width="18%"><b>Leaving USA Date</b></td>
				<td width="14%"><b>Last Day Insured</b></td>
				<td width="13%"><b>Extra Insurance Charge</b></td>
			</tr>	
			<cfloop query="get_students">
			
			<!--- FIRST SEMESTER - 12 MONTH PROGRAM / ALSO THE PRIVATE SCHOOL ONES ACCORDING TO THE END DATE --->
			<cfif get_students.programtypeid EQ '12' OR get_students.programtypeid EQ '3' OR #DateFormat(get_students.enddate, 'mm')# EQ '12' OR #DateFormat(get_students.enddate, 'mm')# EQ '1'>
				<cfset end_date = #get_students.semester_ends#>
			<cfelse>
				<cfset end_date = #get_students.year_ends#>
			</cfif>
			
			<cfquery name="get_last_insurance" datasource="MySql">
				SELECT max(insuranceid), new_date, end_date, transtype
				FROM smg_insurance
				WHERE studentid = '#get_students.studentid#'
				GROUP BY insuranceid
				ORDER BY insuranceid DESC 
			</cfquery>
	
			<cfif get_last_insurance.recordcount> <!--- AGENTS THAT DID NOT TAKE INSURANCE PREVIOUS PROGRAM --->
	
			<!--- Get start date for early returns ---->					
			<cfif get_last_insurance.transtype EQ 'early return' OR get_last_insurance.transtype EQ 'cancellation'>
				<cfset get_last_insurance.end_date = get_last_insurance.new_date>
			</cfif>
			
				<!--- TERMINATION DATE ON FILE --->
				<cfif termination_date NEQ ''>
						<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
						<td>#companyshort#</td>
						<td>###studentid#</td>
						<td>#firstname# #familylastname#</td>
						<td>#programname#</td>
						<td><cfif end_date NEQ ''>#DateFormat(end_date, 'mm/dd/yyyy')#<cfelse><font color="FF0000">Missing School End Date</font></cfif></td>
						<td>#DateFormat(termination_date, 'mm/dd/yyyy')# &nbsp; Termination Date</td>
						<td>#DateFormat(get_last_insurance.end_date, 'mm/dd/yyyy')#</td>
						<td><cfif end_date NEQ ''>
								<cfif DateDiff('d',end_date, get_last_insurance.end_date) GT '8'>
									#DateDiff('d',DateAdd('d', 8, end_date), get_last_insurance.end_date)# days /
									<cfset get_weeks = #DateDiff('d',DateAdd('d', 8, end_date), get_last_insurance.end_date)#/7>
									<cfif Ceiling(get_weeks) MOD 2 NEQ 0> <!--- INSURANCE IS CHARGED EVERY 2 WEEKS --->
										<cfset get_weeks = get_weeks + 1>
									</cfif>
									#Ceiling(get_weeks)# week(s)
								<cfelse>
									no charge
								</cfif>	
							</cfif>
						</td>
					</tr>					
				<!--- NO TERMINATION DATE - GET FLIGHT INFO --->	
				<cfelse>					
					<cfquery name="get_flight" datasource="MySql">
						SELECT DISTINCT dep_date
						FROM smg_flight_info
						WHERE studentid = #get_students.studentid#
							AND flight_type = 'departure'
						ORDER BY dep_date DESC 
					</cfquery>
					<cfif get_flight.dep_date EQ ''>
							<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
								<td>#companyshort#</td>
								<td>#studentid#</td>
								<td>#firstname# #familylastname#</td>
								<td>#programname#</td>
								<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>
								<td><font color="FF0000">Missing Information</font></td>
								<td>#DateFormat(get_last_insurance.end_date, 'mm/dd/yyyy')#</td>
								<td>
									<cfif end_date NEQ ''>
										<cfif DateDiff('d',end_date, insureddate) GT '8' >
											#DateDiff('d', DateAdd('d', 8, end_date), insureddate)# days /
											<cfset get_weeks = #DateDiff('d', DateAdd('d', 8, end_date), insureddate)# / 7>
											<cfif Ceiling(get_weeks) MOD 2 NEQ 0>
												<cfset get_weeks = get_weeks + 1>
											</cfif>
											#Ceiling(get_weeks)# week(s)
										<cfelse>
											no charge
										</cfif>	
									</cfif>
								</td>
							</tr>
					<cfelseif end_date EQ ''>
							<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
								<td>#companyshort#</td>
								<td>#studentid#</td>
								<td>#firstname# #familylastname#</td>
								<td>#programname#</td>
								<td><font color="FF0000">Missing School End Date</font></td>
								<td>#DateFormat(get_flight.dep_date, 'mm/dd/yyyy')# &nbsp; Flight Departure</td>
								<td>#DateFormat(get_last_insurance.end_date, 'mm/dd/yyyy')#</td>
								<td></td>
							</tr>		
					<cfelse>
							<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
								<td>#companyshort#</td>
								<td>#studentid#</td>
								<td>#firstname# #familylastname#</td>
								<td>#programname#</td>
								<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>
								<td>#DateFormat(get_flight.dep_date, 'mm/dd/yyyy')# &nbsp; Flight Departure</td>
								<td>#DateFormat(get_last_insurance.end_date, 'mm/dd/yyyy')#</td>
								<td><cfif DateDiff('d',end_date, get_flight.dep_date) GT '8' >
										#DateDiff('d', DateAdd('d', 8, end_date), get_flight.dep_date)# days /
										<cfset get_weeks = #DateDiff('d', DateAdd('d', 8, end_date), get_flight.dep_date)# / 7>
										<cfif Ceiling(get_weeks) MOD 2 NEQ 0>
											<cfset get_weeks = get_weeks + 1>
										</cfif>									
										#Ceiling(get_weeks)# week(s)
									<cfelse>
										no charge
									</cfif>	
								</td>
							</tr>	
					</cfif>
				</cfif>
			</cfif><!--- record count if --->
			</cfloop>
		</table><br>
	</cfif>
</cfloop>

</cfoutput>