<!--- Kill extra output --->
<cfsilent>

	<!--- Param Form Variables --->
    <cfparam name="FORM.studentID" default="0">
    <cfparam name="FORM.active" default="0">
    <cfparam name="FORM.active_reason" default="">   
    <cfparam name="FORM.region" default="0">
    <cfparam name="FORM.jan_App" default="0">
    <cfparam name="FORM.regionGuar" default="no">	
    <cfparam name="FORM.rguarantee" default="0">
    <cfparam name="FORM.regionalguarantee" default="0">
    <cfparam name="FORM.state_guarantee" default="0">

	<!--- Stores error information --->
    <cfparam name="active_error" default="">

	<cfscript>
		// Get Student Information 
		qStudentInfo = AppCFC.STUDENT.getStudentByID(studentID=FORM.studentID); 
	</cfscript>
    
    <cfscript>
		// Data validation
		if ( NOT VAL(qStudentInfo.active) AND VAL(FORM.active) AND NOT LEN(FORM.active_reason) ) {
			active_error ="You must specify a reason for making this student active.  Please use your browsers back button to make the change.";
		} else if ( VAL(qStudentInfo.active) AND VAL(FORM.active) AND LEN(FORM.active_reason) ) {
			active_error ="You provided an explanation for changing the status of a student, but didn't change the status. Please use your browsers back button to change the status to inactive, or remove the explanation.";
		} else if ( NOT VAL(qStudentInfo.active) AND NOT VAL(FORM.active) AND LEN(FORM.active_reason) ) {
			active_error ="You provided an explanation for changing the status of a student, but didn't change the status. Please use your browsers back button to change the status to active, or remove the explanation.";
		} else IF ( VAL(qStudentInfo.active) AND NOT VAL(FORM.active) AND NOT LEN(FORM.active_reason) ) {
			active_error ="You must specify a reason for making this student inactive.  Please use your browsers back button to make the change.";
		}
	</cfscript>

</cfsilent>

<link rel="stylesheet" href="../smg.css" type="text/css">


<!--- Errors Found --->	
<cfif LEN(active_error)>
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
<cfif NOT LEN(FORM.active_reason)>
    <cfquery name="active_reason" datasource="mysql">
        INSERT INTO 
        	smg_active_stu_reasons 
        (
        	studentid,
            userid, 
            reason
        )
        VALUES 
        (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentid#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.active_reason#">
        )
    </cfquery>
</cfif>

<!--- REGION HISTORY --->
<cfif qStudentInfo.regionassigned NEQ FORM.region>
	<cfquery name="region_history" datasource="MySql">
		INSERT INTO 
        	smg_regionhistory
		(
            studentid, 
            regionid, 
            rguarenteeid,	
            stateguaranteeid, 
            fee_waived, 
            reason, 
            changedby,  
            date
        )
		VALUES
			(
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.region#">,
				<cfif FORM.regionGuar EQ 'no'>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                <cfelse>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.rguarantee#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.state_guarantee#">,
                    <cfif VAL(FORM.jan_App)> 
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.jan_app#">,
                    <cfelse>
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.jan_app#">,
                    </cfif>
                </cfif>
				<cfif VAL(qStudentInfo.regionassigned)>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.region_reason#">,
                <cfelse>
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="Student was unassigned">,
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
			)
	</cfquery>
	
	<cfquery name="update_dateassigned" datasource="MySql">
		UPDATE 
        	smg_students
		SET 
        	dateassigned = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
		WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentid#">
		LIMIT 1
	</cfquery>
</cfif>

<!--- PROGRAM UPDATED --->
<cfif qStudentInfo.programid NEQ FORM.program>

	<!--- INSERT PROGRAM HISTORY --->
    <cfquery name="program_history" datasource="MySql">
		INSERT INTO 
        	smg_programhistory
		(
        	studentid, 
            programid, 
            reason, 
            changedby,  
            date
        )
		VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentid#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.program#">, 
        	<cfif VAL(qStudentInfo.programid)>
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.program_reason#">, 
            <cfelse>
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="Student was unassigned">, 
            </cfif>
           	<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> 
        )
	</cfquery>
    
	<!--- EMAIL FINANCE DEPARTMENT ONLY IF PREVIOUS PROGRAM IS VALID --->
    <cfif VAL(qStudentInfo.programid)>
    	
    	<cfscript>	
			// Always send a copy of the email to Admissions
			emailCC = APPLICATION.EMAIL.admissions;
			
			// If there is a valid email, send a copy to the current user
			if ( IsValid("email", APPCFC.USER.getUserByID(userID=CLIENT.userID).email) ) {
				emailCC = emailCC & ';' & APPCFC.USER.getUserByID(userID=CLIENT.userID).email;				
			}
		</cfscript>
		
        <cfoutput>
        <cfsavecontent variable="emailChangeProgram">
            <p>
                <h2>Finance Department</h2>
            </p>
            
            <p>
                This email is to let you know student 
                #qStudentInfo.firstName# #qStudentInfo.familyLastName# (###qStudentInfo.studentID#) - 
                #APPCFC.COMPANY.getCompanies(companyID=qStudentInfo.companyID).companyShort# was assigned to a new program.
            </p> 
            
            <p>
                SEVIS No.: 
				<cfif NOT LEN(qStudentInfo.ds2019_no)>
                	<strong>No SEVIS Number on File</strong>
				<cfelse>
                	<strong>#qStudentInfo.ds2019_no#</strong>
				</cfif>                            
            </p>
            
            <p>
                Intl. Agent: #APPCFC.USER.getUserByID(userID=qStudentInfo.intRep).businessName# (###qStudentInfo.intRep#)
            </p>
        
            <p>
                Previous Program Information:
                #APPCFC.PROGRAM.getPrograms(ProgramID=qStudentInfo.programid).programName# (###APPCFC.PROGRAM.getPrograms(ProgramID=qStudentInfo.programid).programID#)                         
            </p>
            
            <p>
                New Program Information: 
                <cfif VAL(FORM.program)>
                    #APPCFC.PROGRAM.getPrograms(ProgramID=FORM.program).programName# (###APPCFC.PROGRAM.getPrograms(ProgramID=FORM.program).programID#)
                <cfelse>
                    Unassigned
                </cfif>                                
            </p>
        
            <p>
                Reason for changing the program: 
                #FORM.program_reason#
            </p>
        
            <p>
                Assigned By: 
                #APPCFC.USER.getUserByID(userID=CLIENT.userID).firstName# #APPCFC.USER.getUserByID(userID=CLIENT.userID).lastName# (###CLIENT.userID#)
                <a href="mailto:#APPCFC.USER.getUserByID(userID=CLIENT.userID).email#">#APPCFC.USER.getUserByID(userID=CLIENT.userID).email#</a>
            </p>
            
            <p>
                Date/Time: #DateFormat(now(), 'mm/dd/yy')# #TimeFormat(now(), 'hh:mm:ss tt')#
            </p>                            
            
            <p>
                The following people received this notice:<br />
                #APPLICATION.EMAIL.finance#;#emailCC#
            </p>
            
            <p>
                <cfif APPLICATION.IsServerLocal>
                    PS: Development Server
                <cfelse>
                    PS: Production Server
                </cfif>
            </p>
        </cfsavecontent>
        </cfoutput>

		<!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_from" value="#APPLICATION.EMAIL.support#">
            <cfinvokeargument name="email_to" value="#APPLICATION.EMAIL.finance#">
            <cfinvokeargument name="email_cc" value="#emailCC#">
            <cfinvokeargument name="email_subject" value="Student #qStudentInfo.firstName# #qStudentInfo.familyLastName# (###qStudentInfo.studentID#) Change Program Notification">
            <cfinvokeargument name="email_message" value="#emailChangeProgram#">
        </cfinvoke>
	
	</cfif>    

</cfif>

<!---  CANCELLING A STUDENT --->
<cfif IsDefined('FORM.student_cancel')>


	<cfif VAL(qStudentInfo.hostid) AND NOT LEN(qStudentInfo.canceldate)>
		<cfquery name="hostchangereason" datasource="MySql">		
			INSERT INTO 
            	smg_hosthistory	
            (
            	hostid, 
                studentid, 
                schoolid, 
                dateofchange, 
                arearepid, 
                placerepid, 
                changedby, 
                reason
            )
			VALUES
            (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.hostid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentid#">,                 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.schoolid#">,                 
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,              
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.arearepid#">,                 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.placerepid#">,                 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="Student Canceled Program for the following reason: #FORM.cancelreason#">
            )
		</cfquery>
	</cfif> 
	
    <cfquery name="cancel_student" datasource="MySql">
		UPDATE 
        	smg_students
		SET 
        	canceldate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.date_canceled)#">, 
			cancelreason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancelreason#">, 
			active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
		WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentid#">
		LIMIT 1
	</cfquery>
<!----Send Email to Finace Email, prgram manager, others---->
<cfoutput>

    <cfquery name="intagent" datasource="#application.dsn#">
        select businessname
        from smg_users
        where userid = #qStudentInfo.intrep#
    </cfquery>
    
    <cfquery name="programname" datasource="#application.dsn#">
        select programname
        from smg_programs
        where programid = #qStudentInfo.programid#
    </cfquery>
    
    <cfsavecontent variable="email_message">
        #qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# has been cancelled.
        <br /><br />
        Student: <strong>#qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# (#qStudentInfo.Studentid#)</strong><br />
        Int Agent: <strong>#intagent.businessname# (#qStudentInfo.intrep#)</strong><br />
        Program: <strong>#programname.programname# (#qStudentInfo.programid#)</strong><br />
        Cancel Date: <strong>#DateFormat(FORM.date_canceled,'mm/dd/yyyy')#</strong><br />
        Reason: <strong>#FORM.cancelreason#</strong><br />
        Placement Approved: <cfif qStudentInfo.date_host_fam_approved is ''>Unplaced<cfelse>#DateFormat(qStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# @ #TimeFormat(qStudentInfo.date_host_fam_approved, 'h:mm tt')#</cfif> <br />
        Sevis:  <cfif qStudentInfo.sevis_fee_paid_date is ''>Not Paid<cfelse>#DateFormat(qStudentInfo.sevis_fee_paid_date,'mm/dd/yyyy')#</cfif><br />
        SEVIS No.: <cfif qStudentInfo.ds2019_no is ''><strong>No SEVIS Number on File</strong><cfelse> <strong> #qStudentInfo.ds2019_no#</strong></cfif><br />
        Cancelled By: #client.name# - #client.email#<br /><br />
        
        The following people received this notice:<br />
        #client.projectmanager_email# #client.finance_email# #client.email#
     
        <p>
            <cfif APPLICATION.IsServerLocal>
                PS: Development Server
            <cfelse>
                PS: Production Server
            </cfif>
        </p>
    </cfsavecontent>
			
<!--- send email --->
<cfinvoke component="nsmg.cfc.email" method="send_mail">
	<cfinvokeargument name="email_to" value="#client.finance_email#">
	<cfinvokeargument name="email_subject" value="Student Cancellation: #intagent.businessname# -(#qStudentInfo.intrep#) - #qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# (#qStudentInfo.Studentid#) - #programname.programname# (#qStudentInfo.programid#)">
	<cfinvokeargument name="email_message" value="#email_message#">
	<cfif client.companyid lte 5>
	    <cfinvokeargument name="email_cc" value="#client.projectmanager_email#,  #client.email#, pat@iseusa.com, ellen@iseusa.com"> 
    <cfelse>
    	<cfinvokeargument name="email_cc" value="#client.projectmanager_email#,  #client.email#">
    </cfif>
    <cfinvokeargument name="email_from" value="#client.name# <#client.email#>">
</cfinvoke>
   
    </cfoutput>

<!----End of Email to ---->
    <cflocation url="../index.cfm?curdoc=student_info" addtoken="no">
<cfelse>

    <cfquery name="cancel_student" datasource="MySql">
        UPDATE 
        	smg_students
        SET 
        	canceldate = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">, 
            cancelreason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
            active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentid#">
        LIMIT 1
    </cfquery>
</cfif>

<cftransaction>

<!--- UPDATE STUDENT INFORMATION --->
<cfquery name="Update_Student" datasource="MySql">
	UPDATE 
    	smg_students
	SET 
		active = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.active)#">,
		regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.region#">,
		<!--- Regional Guarantee --->
        regionGuar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.regionGuar#">, <!--- yes/no --->
        regionalguarantee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.rguarantee)#">, <!--- guaranteeID --->
        state_guarantee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state_guarantee#">, <!--- stateID --->
		<!--- GUARANTEED --->
        <cfif VAL(FORM.state_guarantee)>            	
            jan_app = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
        <cfelse>
	        jan_app = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.jan_app#">,
        </cfif>
		<cfif isDefined('FORM.team_id')>companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.team_id#">, </cfif>	
		iffschool = <cfif IsDefined('FORM.iff_check')>'#FORM.iffschool#'<cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,		
        scholarship = <cfif IsDefined('FORM.scholarship')> <cfqueryparam cfsqltype="cf_sql_integer" value="1"> <cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,                      
		privateschool = <cfif IsDefined('FORM.privateschool_check')>'#FORM.privateschool#'<cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,
		aypenglish = <cfif IsDefined("FORM.english_check")>'#FORM.ayp_englsh#'<cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,
		ayporientation = <cfif IsDefined('FORM.orientation_check')>'#FORM.ayp_orientation#'<cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,
		<cfif IsDefined('FORM.direct_placement')>direct_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.direct_placement#">,</cfif>
		direct_place_nature = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.direct_place_nature#">,
		verification_received =  <cfif FORM.verification_form EQ ''>null<cfelse>#CreateODBCDate(FORM.verification_form)#</cfif>,	
		ds2019_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_no#">,
		programid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.program#">,
		intrep = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.intrep#">
	WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qStudentInfo.studentid#">
	LIMIT 1
</cfquery>

</cftransaction>
 
<cflocation url="../index.cfm?curdoc=student_info" addtoken="no">