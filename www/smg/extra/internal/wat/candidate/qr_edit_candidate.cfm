<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Edit Candidate</title>
</head>
<body>
<cfif NOT isDefined('form.hostcompany_status')> 
	<cfset form.hostcompany_status = '0'>
</cfif>
<!----<cfif NOT isDefined('form.confirmation_received')> 
	<cfset form.confirmation_received = '0'>
</cfif>----->
<!----<cfif wat_length EQ''>
	<cfset form.wat_length = '0'>
</cfif>---->
<cfif wat_participation EQ''>
	<cfset form.wat_participation = '0'>
</cfif>



	<cfquery name="get_candidate_info" datasource="mysql">
		SELECT candidateid, programid, hostcompanyid
		FROM extra_candidates
		WHERE uniqueid='#url.uniqueid#'
	</cfquery>
	

<!----	<cfif form.combo_position eq 0>
	<cfquery name="update_position" datasource="mysql"> 
			INSERT INTO extra_candidate_place_company (jobid, hostcompanyid, candidateid, placement_date, status)
			VALUES (0, #client.companyid#, #form.candidateid#, #CreateODBCDate(now())#, 1)
	</cfquery> 
	</cfif>--->
<cfif IsDefined('combo_position') >
<cfif form.combo_position NEQ 0>
<cfif form.currentjob NEQ form.combo_position>
	<cfquery name="update_position" datasource="mysql"> 
		INSERT INTO extra_candidate_place_company (jobid, hostcompanyid, candidateid, placement_date, status)
		VALUES (#form.combo_position#,  #form.hostcompanyid_combo#, #form.candidateid#, #CreateODBCDate(now())#, 1)
	</cfquery> 
	<cfquery name="update_currentjob" datasource="mysql">
		UPDATE extra_candidate_place_company 
		SET status = 0 
		WHERE candcompid = #form.currentjobid#
	</cfquery>
</cfif>
<cfelse>
	<cfquery name="update_position" datasource="mysql"> 
			INSERT INTO extra_candidate_place_company (jobid, hostcompanyid, candidateid, placement_date, status)
			VALUES (0, #client.companyid#, #form.candidateid#, #CreateODBCDate(now())#, 1)
	</cfquery> 
</cfif>
</cfif>

	<cfquery name="get_max_candcompid" datasource="mysql">
		SELECT MAX(candcompid) as candcompid
		FROM extra_candidate_place_company
		WHERE candidateid='#get_candidate_info.candidateid#'
	</cfquery>
	
	<!---- PROGRAM HISTORY ---->
	<cfif get_candidate_info.programid NEQ form.programid>
		<cfquery name="program_history" datasource="mysql">
		INSERT INTO extra_program_history
			(candidateid, reason, date, programid, userid )
		VALUES (#form.candidateid#, '#form.reason#', #CreateODBCDate(now())#, '#form.programid#', '#client.userid#')
		</cfquery>
	</cfif>
	
	<!---- HOST COMPANY HISTORY ---->
	<cfif  form.hostcompanyid_combo NEQ '0'>
	
	<cfif get_candidate_info.hostcompanyid NEQ form.hostcompanyid_combo>
		<cfquery name="host_history" datasource="mysql">
		INSERT INTO extra_candidate_place_company
			(candidateid, hostcompanyid, placement_date, startdate, enddate, status, <!----confirmation_received,----> reason_host)
		VALUES (#form.candidateid#, '#form.hostcompanyid_combo#', #CreateODBCDate(now())#,
			<cfif form.host_startdate NEQ ''>#CreateODBCDate(form.host_startdate)#<cfelse>NULL</cfif>,
			<cfif form.host_enddate NEQ ''>#CreateODBCDate(form.host_enddate)#<cfelse>NULL</cfif>,
			'#form.hostcompany_status#', <!----'#form.confirmation_received#',---> '#form.reason_host#')
		</cfquery>
	<cfelse>

		<cfquery name="host_history_update" datasource="mysql">
		UPDATE extra_candidate_place_company
		SET startdate=<cfif form.host_startdate NEQ ''>#CreateODBCDate(form.host_startdate)#<cfelse>NULL</cfif>,
				enddate=<cfif form.host_enddate NEQ ''>#CreateODBCDate(form.host_enddate)#<cfelse>NULL</cfif>,
				status='#form.hostcompany_status#' <!----confirmation_received='#form.confirmation_received#'---->
		WHERE candcompid = '#get_max_candcompid.candcompid#'
		</cfquery>
		
	</cfif>

	</cfif>

	<cfquery name="edit_candidate" datasource="mysql">
		UPDATE extra_candidates
		SET firstname='#form.firstname#', lastname='#form.lastname#', middlename='#form.middlename#',
				dob=<cfif form.dob NEQ ''>#CreateODBCDate(form.dob)#<cfelse>NULL</cfif>,
				sex='#form.sex#', intrep='#form.intrep#',
				birth_city='#form.birth_city#', birth_country='#form.birth_country#', 
				citizen_country='#form.citizen_country#', residence_country='#form.residence_country#', home_address='#form.home_address#', 
				home_city='#form.home_city#', home_zip='#form.home_zip#',	home_country='#form.home_country#', home_phone='#form.home_phone#',
				email='#form.email#', status = '#form.status#', personal_info='#form.personal_info#', emergency_name='#form.emergency_name#',
				emergency_phone='#form.emergency_phone#', <!----emergency_relationship='#form.emergency_relationship#', ----->
				passport_number='#form.passport_number#',
				<!---- passport_country='#form.passport_country#', 
				passport_date =<cfif form.passport_date NEQ ''>#CreateODBCDate(form.passport_date)#<cfelse>NULL</cfif>,
				passport_expires =<cfif form.passport_expires NEQ ''>#CreateODBCDate(form.passport_expires)#<cfelse>NULL</cfif>,---->				
				programid='#form.programid#', ssn='#form.ssn#', wat_participation='#form.wat_participation#', wat_placement='#form.wat_placement#',
				<!---- wat_length='#form.wat_length#',--->
				wat_vacation_start=<cfif form.wat_vacation_start NEQ ''>#CreateODBCDate(form.wat_vacation_start)#<cfelse>NULL</cfif>,
				wat_vacation_end=<cfif form.wat_vacation_end NEQ ''>#CreateODBCDate(form.wat_vacation_end)#<cfelse>NULL</cfif>,
				<!--- ticket 996
				earliestarrival=<cfif form.earliestarrival NEQ ''>#CreateODBCDate(form.earliestarrival)#<cfelse>NULL</cfif>, 
				latestarrival=<cfif form.latestarrival NEQ ''>#CreateODBCDate(form.latestarrival)#<cfelse>NULL</cfif>,
				---->
				
				<!--- document control --->
				wat_doc_agreement = <cfif IsDefined('form.wat_doc_agreement')>1<cfelse>0</cfif>,
				wat_doc_college_letter = <cfif IsDefined('form.wat_doc_college_letter')>1<cfelse>0</cfif>,
				wat_doc_passport_copy = <cfif IsDefined('form.wat_doc_passport_copy')>1<cfelse>0</cfif>,
				wat_doc_job_offer = <cfif IsDefined('form.wat_doc_job_offer')>1<cfelse>0</cfif>,
				wat_doc_orientation = <cfif IsDefined('form.wat_doc_orientation')>1<cfelse>0</cfif>,
				
				<!---- form DS-2019 ---->
				
				<cfif form.verification_received NEQ ''>
					verification_received = #CreateODBCDate(form.verification_received)# ,
					<cfelse>
					verification_received = NULL,
				</cfif>
				
				<cfif IsDefined('form.agent_accepts_sevis')>
					agent_accepts_sevis = 1,
				<cfelse>
					agent_accepts_sevis = 0,
				</cfif>
				
				<!--- DS2019 stuff ---> 
				ds2019='#form.ds2019#', <!---ds2019_position='#form.ds2019_position#', ds2019_subject='#form.ds2019_subject#',
				ds2019_street='#form.ds2019_street#', ds2019_city='#form.ds2019_city#', ds2019_state='#form.ds2019_state#',
				ds2019_zip='#form.ds2019_zip#', 
				ds2019_startdate=<cfif form.ds2019_startdate NEQ ''>#CreateODBCDate(form.ds2019_startdate)#<cfelse>NULL</cfif>,
				ds2019_enddate=<cfif form.ds2019_enddate NEQ ''>#CreateODBCDate(form.ds2019_enddate)#<cfelse>NULL</cfif>,
				-------->
				<!--- close DS2019 ---> 
				<!--- requested --->
				requested_placement = '#form.combo_request#',
				
				<!--- change_requested_comment --->
				<cfif IsDefined('form.change_requested_comment')>change_requested_comment = '#form.change_requested_comment#', </cfif>
				<!--- combo postition ---->
				<cfif IsDefined('form.combo_position')>change_requested_comment = '#form.change_requested_comment#', </cfif>
				
				cancel_date=<cfif form.cancel_date NEQ ''>#CreateODBCDate(form.cancel_date)#, active = 0<cfelse>NULL</cfif>,
				cancel_reason='#form.cancel_reason#',
				
				hostcompanyid='#form.hostcompanyid_combo#',
                
				<!--- 1047 --->
				startdate=<cfif form.program_startdate NEQ ''>#CreateODBCDate(form.program_startdate)#<cfelse>NULL</cfif>,
				enddate=<cfif form.program_enddate NEQ ''>#CreateODBCDate(form.program_enddate)#<cfelse>NULL</cfif>,
                
                <!---  Arrival Verification  --->
                <cfif IsDefined('form.verification_address')>verification_address = 1,<cfelse>verification_address = 0,</cfif>
                <cfif IsDefined('form.verification_sevis')>verification_sevis = 1,<cfelse>verification_sevis = 0,</cfif>
                <cfif IsDefined('form.verification_arrival')>verification_arrival = 1<cfelse>verification_arrival = 0</cfif>       
				
		WHERE uniqueid='#url.uniqueid#'
	</cfquery>
<!--- 	<cfdump var ="#form#">---->

	<cfoutput>
	<script language="JavaScript">
		location.replace("?curdoc=candidate/candidate_info&uniqueid=#url.uniqueid#");
	</script>
	</cfoutput>

</body>
</html>