<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Edit Candidate</title>
</head>
<body>

<cfquery name="get_candidate_info" datasource="mysql">
	SELECT candidateid, programid, hostcompanyid
	FROM extra_candidates
	WHERE uniqueid= <cfqueryparam value="#url.uniqueid#" cfsqltype="cf_sql_char" maxlength="40">
</cfquery>

<cfif NOT isDefined('form.hostcompany_status')> 
	<cfset form.hostcompany_status = '0'>
</cfif>

<!----<input type="hidden" name="get_hostcompanyid_combo" value="#hostcompany.hostcompanyid#">
	<input type="hidden" name="get_status" value="#candidate_place_company.status#">
	<input type="hidden" name="get_startdate" value="#candidate_place_company.startdate#">
	<input type="hidden" name="get_enddate" value="#candidate_place_company.enddate#">
	<input type="hidden" name="get_confirmation" value="#candidate_place_company.confirmation_received#">	---->
	
<cfif IsDefined('combo_position') >
<cfif form.combo_position NEQ 0>
<cfif form.currentjob NEQ form.combo_position> <!----
OR form.get_hostcompanyid_combo NEQ hostcompany.hostcompanyid
OR form.get_status NEQ form.hostcompany_status
OR form.startdate NEQ form.host_startdate
OR form.enddate NEQ form.host_enddate
OR form.get_confirmation NEQ form.confirmation_received >---->
	<cfquery name="update_position" datasource="mysql"> 
		INSERT INTO extra_candidate_place_company (jobid, hostcompanyid, candidateid, placement_date, status)
		VALUES (#form.combo_position#, #form.hostcompanyid_combo#, #form.candidateid#, #CreateODBCDate(now())#, 1)
	</cfquery>
	<cfquery name="update_currentjob" datasource="mysql">
		UPDATE extra_candidate_place_company 
		SET status = 0 
		WHERE candcompid = #form.currentjobid#
	</cfquery>
</cfif>
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
				'#form.hostcompany_status#', <!----'#form.confirmation_received#',-----> '#form.reason_host#')
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
				<!----home_city='#form.home_city#', home_zip='#form.home_zip#',	---->home_country='#form.home_country#', home_phone='#form.home_phone#',
				email='#form.email#', ssn='#form.ssn#', personal_info='#form.personal_info#', emergency_name='#form.emergency_name#',
				status = '#form.status#', 
				enddate=<cfif form.host_enddate NEQ ''>#CreateODBCDate(form.host_enddate)#<cfelse>NULL</cfif>,
				emergency_phone='#form.emergency_phone#', <!----emergency_relationship='#form.emergency_relationship#',----> 
				passport_number='#form.passport_number#', passport_country='#form.passport_country#', 
				passport_date =<cfif form.passport_date NEQ ''>#CreateODBCDate(form.passport_date)#<cfelse>NULL</cfif>,
				passport_expires =<cfif form.passport_expires NEQ ''>#CreateODBCDate(form.passport_expires)#<cfelse>NULL</cfif>,				
				programid='#form.programid#', h2b_participated='#form.h2b_participated#', 
				
				<cfif NOT IsDefined('form.h2b_date_expires') OR form.h2b_date_expires EQ ''>
				h2b_date_expires = NULL ,
				<cfelse>
				h2b_date_expires = #CreateODBCDate(form.h2b_date_expires)#,
				</cfif>
				
				<cfif NOT IsDefined('form.h2b_i94') OR form.h2b_i94 EQ ''>
				h2b_i94 = NULL ,
				<cfelse>
				h2b_i94 = '#form.h2b_i94#',
				</cfif>
				
				<cfif IsDefined('form.check_i129')>
				h2b_i129_filled = 1 ,
				<cfelse>
				h2b_i129_filled = 0 ,
				</cfif>
				
				requested_placement = '#form.combo_request#',
				<!----earliestarrival =<cfif form.earliestarrival NEQ ''>#CreateODBCDate(form.earliestarrival)#<cfelse>NULL</cfif>, 
				latestarrival =<cfif form.latestarrival NEQ ''>#CreateODBCDate(form.latestarrival)#<cfelse>NULL</cfif>,--->
				<cfif cancel_date eq ''>
				<cfif IsDefined('form.active')>active = 1,</cfif>
				cancel_date = NULL,
				<cfelse>
				cancel_date = #CreateODBCDate(form.cancel_date)#,
				</cfif>
				cancel_reason='#form.cancel_reason#',
				
				<cfif IsDefined('form.hostcompanyid_combo') OR form.hostcompanyid_combo NEQ ''>
				hostcompanyid='#form.hostcompanyid_combo#'
				</cfif>
		WHERE uniqueid='#url.uniqueid#'
	</cfquery>
	<!----Cancelle A Student---->
	
	
	

	
	
	
	<html>
	<head>
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("Candidate Updated!");
		location.replace("?curdoc=candidate/candidate_info&uniqueid=#url.uniqueid#");
	-->
	</script>
	</cfoutput>
	</head>
	</html> 		

		

</body>
</html>