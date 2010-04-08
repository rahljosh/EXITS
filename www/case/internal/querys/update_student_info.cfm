<link rel="stylesheet" href="../smg.css" type="text/css">
<cfparam name="active_error" default="none" type="any"  >
<cfquery name="get_student_info" datasource="caseusa">
	SELECT studentid, hostid, schoolid, arearepid, placerepid, canceldate, active,
		regionassigned, regionguar, regionalguarantee, state_guarantee, jan_app, programid
	FROM smg_students
	WHERE studentid = '#client.studentid#'
</cfquery>
<cfif (get_student_info.active neq 1 AND IsDefined('form.active')) and form.active_reason is ''>
	<cfset active_error ="You must specify a reason for making this student active.  Please use your browsers back button to make the change.">

<cfelseif (get_student_info.active eq 1 AND IsDefined('form.active')) and form.active_reason is not ''>
	<cfset active_error ="You provided an explanation for changing the status of a student, but didn't change the status. Please use your browsers back button to change the status to inactive, or remove the explanation.">

<cfelseif (get_student_info.active eq 0 AND not IsDefined('form.active')) and form.active_reason is not ''>
		<cfset active_error ="You provided an explanation for changing the status of a student, but didn't change the status. Please use your browsers back button to change the status to active, or remove the explanation.">
<cfelseif (get_student_info.active eq 1 AND not IsDefined('form.active')) and form.active_reason is ''>
	<cfset active_error ="You must specify a reason for making this student inactive.  Please use your browsers back button to make the change.">

</cfif>
	
<cfif active_error is not 'none'>
<cfoutput>
<table width="100%"cellpadding=0 cellspacing=0 border=0 height=24 bgcolor=##ffffff>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" class="tablecenter" background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td class="tablecenter" background="../pics/header_background.gif"><h2>SMG - System Error</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section"><br>
<table width=660 cellpadding=0 cellspacing=0 border=0 align="center">
		<Tr>
			<td colspan=2>
			<!-- Error Message -->
						<table cellSpacing="0" cellPadding="0" width="100%" border="0">
							<tr>
								<td width="6"><img height=6 src="http://www.phpusa.com/internal/pics/table-borders/red-err-lefttopcorner.gif" width=6></td>
								<td bgColor="##bb0000" height="6"><img height=6 src="spacer.gif" width=1 ></td>
								<td width="6"><img height=6 src="http://www.phpusa.com/internal/pics/table-borders/red-err-righttopcorner.gif" width=6></td>
							</tr>

							<tr>
								<td class="errMessageGradientStyle" bgColor="##bb0000"><img height=45 src="spacer.gif" width=1 >
								</td>
								<td class="errMessageGradientStyle" bgColor="##bb0000">
									<table cellSpacing="0" cellPadding="10" width="100%" border="0">
										<tr>
											<td vAlign="middle" align="center"><img src="http://www.phpusa.com/internal/pics/error-exclamate.gif" ></td>
											
											<td vAlign="middle" align="left"><font color="white"><strong><span class=upper>ALERT!&nbsp;&nbsp; ALARM!&nbsp;&nbsp;  Alarma!&nbsp;&nbsp;  Alerte!&nbsp;&nbsp;  Allarme!&nbsp;&nbsp;  Alerta!</span> </strong><br>
				<br />							
<h4>#active_error#</h4>
											</td>
										</tr>
									</table>
								</td>
								<td class="errMessageGradientStyle" bgColor="##bb0000"><img 
							height=45 src="spacer.gif" width=1 >
								</td>
							</tr>

							<tr>
								<td><img height=6 src="http://www.phpusa.com/internal/pics/table-borders/red-err-leftbottcorner.gif" width=6></td>
								<td bgColor="##bb0000"><img height=6 src="spacer.gif" width=1 ></td>
								<td><img height=6 src="http://www.phpusa.com/internal/pics/table-borders/red-err-rightbottomcorner.gif" width=6></td>
							</tr>
						</table>
					</div>
					
			<!-- End error message end -->
			</td>			
		</Tr>
	<tr><td>
		
				
		 <br>
		 <div align="center"><input name="back" type="image" src="../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br>
		 <br><br>
	</td></tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
</table>

</cfoutput>

<cfabort>
</cfif>
<!----Activation History---->
<cfif form.active_reason is not ''>
<cfquery name="active_reason" datasource="caseusa">
	insert into smg_active_stu_reasons (studentid, userid, reason)
				values (#get_student_info.studentid#, #client.userid#, '#form.active_reason#')
</cfquery>
</cfif>


<!--- REGION HISTORY --->
<cfif get_student_info.regionassigned NEQ form.region>
	<cfquery name="region_history" datasource="caseusa">
		INSERT INTO smg_regionhistory
			(studentid, regionid, rguarenteeid,	stateguaranteeid, fee_waived, reason, changedby,  date)
		VALUES
			('#get_student_info.studentid#', '#form.region#', 
			<cfif form.regionguar EQ 'no'>
				'0', '0', '0',
			<cfelse>
				<cfif isDefined('form.rguarantee')> '#form.rguarantee#', <cfelse> '0', </cfif>
				<cfif IsDefined('form.state_guarantee')>'#form.state_guarantee#', <cfelse> '0', </cfif>
				<cfif isDefined('form.jan_App')> 
					'#form.jan_app#', 		
				<cfelse>
					'#get_student_info.jan_app#',
				</cfif>
			</cfif>
			<cfif get_student_info.regionassigned NEQ '0'>'#form.region_reason#', <cfelse> 'Student was unassigned',</cfif>
			'#client.userid#', #CreateODBCDateTime(now())# )
	</cfquery>
	
	<cfquery name="update_dateassigned" datasource="caseusa">
		UPDATE smg_students
		SET dateassigned = #CreateODBCDateTime(now())#
		WHERE studentid = '#get_student_info.studentid#'
		LIMIT 1
	</cfquery>
</cfif>

<!--- PROGRAM HISTORY --->
<cfif get_student_info.programid NEQ form.program>
	<cfquery name="program_history" datasource="caseusa">
		INSERT INTO smg_programhistory
			(studentid, programid, reason, changedby,  date)
		VALUES
			('#get_student_info.studentid#', '#form.program#', 
			<cfif get_student_info.programid NEQ '0'>'#form.program_reason#', <cfelse> 'Student was unassigned',</cfif>
			'#client.userid#', #CreateODBCDateTime(now())# )
	</cfquery>
</cfif>

<!---  CANCELLING A STUDENT --->
<cfif IsDefined('form.student_cancel')>
	
	<cfif get_student_info.hostid NEQ 0 AND get_student_info.canceldate EQ ''>
		<cfquery name="hostchangereason" datasource="caseusa">		
			INSERT INTO smg_hosthistory	(hostid, studentid, schoolid, dateofchange, arearepid, placerepid, changedby, reason)
			VALUES('#get_student_info.hostid#', '#get_student_info.studentid#', '#get_student_info.schoolid#', 
				#CreateODBCDateTime(now())#, '#get_student_info.arearepid#', '#get_student_info.placerepid#', 
				'#client.userid#','Student Canceled Program for the following reason: #form.cancelreason#')
		</cfquery>
	</cfif> 
	<cfquery name="cancel_student" datasource="caseusa">
		UPDATE smg_students
		SET canceldate = #CreateODBCDate(form.date_canceled)#, 
			cancelreason = '#form.cancelreason#', 
			active = '0'
		WHERE studentid = '#get_student_info.studentid#'
		LIMIT 1
	</cfquery>

    <cflocation url="../index.cfm?curdoc=student_info" addtoken="no">
<cfelse>
		<cfquery name="cancel_student" datasource="caseusa">
		UPDATE smg_students
		SET canceldate = null, 
			cancelreason = '', 
			active = '1'
		WHERE studentid = '#get_student_info.studentid#'
		LIMIT 1
	</cfquery>
</cfif>

<cftransaction>

<!--- UPDATE STUDENT INFORMATION --->
<cfquery name="Update_Student" datasource="caseusa">
	UPDATE smg_students
	SET <cfif IsDefined('form.active')> active = '1', <cfelse> active = '0', </cfif>
		regionassigned = '#form.region#', 
		<!--- Regional Guarantee --->
		<cfif isDefined('form.regionguar')> 
			regionguar = '#form.regionguar#',
			<cfif form.regionguar EQ 'no'>
				regionalguarantee = '0',
				state_guarantee = '0',
			<cfelse>
				<!--- GUARANTEED --->
				<cfif isDefined('form.rguarantee')>regionalguarantee = '#form.rguarantee#',</cfif>
				<cfif IsDefined('form.state_guarantee')>
					state_guarantee = '#form.state_guarantee#',
					<cfif form.state_guarantee NEQ '0'>
						jan_app = '0',
					</cfif>
				</cfif>
			</cfif>
			<cfif isDefined('form.jan_App')>
				jan_app = '#form.jan_app#',
			</cfif>
		</cfif>
		iffschool = <cfif IsDefined('form.iff_check')>'#form.iffschool#'<cfelse>'0'</cfif>,
		scholarship = <cfif IsDefined('form.scholarship')>'1'<cfelse>'0'</cfif>,
		privateschool = <cfif IsDefined('form.privateschool_check')>'#form.privateschool#'<cfelse>'0'</cfif>,
		aypenglish = <cfif IsDefined("form.english_check")>'#form.ayp_englsh#'<cfelse>'0'</cfif>,
		ayporientation = <cfif IsDefined('form.orientation_check')>'#form.ayp_orientation#'<cfelse>'0'</cfif>,
		<cfif IsDefined('form.direct_placement')>direct_placement = '#form.direct_placement#',</cfif>
		direct_place_nature = '#form.direct_place_nature#',
		verification_received =  <cfif form.verification_form EQ ''>null<cfelse>#CreateODBCDate(form.verification_form)#</cfif>,	
		ds2019_no ='#form.ds2019_no#',
		programid = '#form.program#',
		intrep = '#form.intrep#'
	WHERE studentid = '#get_student_info.studentid#'
	LIMIT 1
</cfquery>

</cftransaction>
 
<cflocation url="../index.cfm?curdoc=student_info" addtoken="no">