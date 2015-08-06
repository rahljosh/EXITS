<!--- Kill extra output --->

<cfsilent>

	<!--- Param Form Variables --->
    <cfparam name="FORM.studentID" default="0">
    <cfparam name="FORM.active" default="off">
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
		qStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=FORM.studentID); 
	</cfscript>
    <!----
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
	---->
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
<cfscript>
	if (FORM.active EQ "on") {
		isActive = 1;
		if (LEN(FORM.active_reason))
			FORM.active_reason = "activated - " & FORM.active_reason;
		else
			FORM.active_reason = "activated";
	} else {
		isActive = 0;
		if (LEN(FORM.active_reason))
			FORM.active_reason = "inactivated - " & FORM.active_reason;
		else
			FORM.active_reason = "inactivated";
	}
</cfscript>
<cfif qStudentInfo.active NEQ isActive>
    
    <cfquery name="active_reason" datasource="#APPLICATION.DSN#">
        INSERT INTO 
        	smg_student_status_history 
        (
        	studentID,
            userid, 
            reason
        )
        VALUES 
        (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userid)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.active_reason#">
        )
    </cfquery>
    
    <!--- Send reactivation email --->
    <cfif isActive EQ 1>
    
    	<cfscript>
            // Get Intl. Rep. Info
            qGetIntlRep = APPLICATION.CFC.USER.getUserByID(userID=qStudentInfo.intRep);
    
            // Get Current Program
            qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(ProgramID=qStudentInfo.programID);		
            
            // Email CC List
            if ( ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) ) {
                emailCC = CLIENT.projectmanager_email & ';lois@iseusa.org;' & CLIENT.email;
            } else { 
                emailCC = CLIENT.projectmanager_email & ';' & CLIENT.email;
            }
			
			// Get PM Email
			vGetProgramManagerEmail = APPLICATION.CFC.COMPANY.getCompanies(companyID=qStudentInfo.companyID).pm_email;
			
			if ( isValid("email",vGetProgramManagerEmail) ) {
				emailCC = 	emailCC  & ';' & vGetProgramManagerEmail;	 
			}
               
            // Display All Emails Involved
            emailList = CLIENT.finance_email & ';' & emailCC;
            
            // Replace ';' with a <br />
            emailList = ReplaceNoCase(emailList, ';', '<br />', "ALL");
        </cfscript>
    
    	<cfoutput>
            <cfsavecontent variable="email_message">
                <p>#qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# has been re-activated.</p>
                
                Student: <strong>#qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# (###qStudentInfo.Studentid#)</strong><br />
                
                Intl. Agent: <strong>#qGetIntlRep.businessName# (###qGetIntlRep.userID#)</strong><br />
                
                Program: <strong>#qGetProgramInfo.programName# (###qGetProgramInfo.programID#)</strong><br />
                
                Reason: <strong>#FORM.active_reason#</strong><br />
                
                Placement Approved: 
                <cfif IsDate(qStudentInfo.date_host_fam_approved)>
                    <strong>#DateFormat(qStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# @ #TimeFormat(qStudentInfo.date_host_fam_approved, 'h:mm tt')#</strong>
                <cfelse>
                    <strong>Unplaced</strong>
                </cfif> <br />
    
                SEVIS No.: 
                <cfif NOT LEN(qStudentInfo.ds2019_no)>
                    <strong>No SEVIS Number on File</strong>
                <cfelse>
                    <strong>#qStudentInfo.ds2019_no#</strong>
                </cfif> <br />                         
            
                SEVIS Fee: 
                <cfif qStudentInfo.sevis_fee_paid_date is ''>
                    <strong>Not Paid</strong>
                <cfelse>
                    <strong>Paid on #DateFormat(qStudentInfo.sevis_fee_paid_date,'mm/dd/yyyy')#</strong>
                </cfif> <br />
                
                Re-activated By: <strong>#CLIENT.name# - #CLIENT.email#</strong><br /><br />
                
                The following people received this notice: <br /> 
                <strong>#emailList#</strong><br /> <br />
            </cfsavecontent>
        </cfoutput>
    
    	<!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_from" value="#CLIENT.name# <#CLIENT.email#>">
            <cfinvokeargument name="email_to" value="#CLIENT.finance_email#">
            <cfinvokeargument name="email_cc" value="#emailCC#"> 
            <cfinvokeargument name="email_subject" value="Student Re-Activation: #qGetIntlRep.businessname# (###qGetIntlRep.userID#) - #qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# (###qStudentInfo.Studentid#) - #qGetProgramInfo.programname# (###qGetProgramInfo.programID#)">
            <cfinvokeargument name="email_message" value="#email_message#">
        </cfinvoke>
    
    </cfif>
    
</cfif>

<!--- REGION HISTORY --->
<cfquery name="qGetRegionHistory" datasource="#APPLICATION.DSN#">
	SELECT
    	*
   	FROM
    	smg_regionhistory
   	WHERE
    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">
</cfquery>

<cfif qStudentInfo.regionassigned NEQ FORM.region>

	<cfquery datasource="#APPLICATION.DSN#">
		UPDATE 
        	smg_students
		SET 
        	dateassigned = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
		WHERE 
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">
		LIMIT 1
	</cfquery>
    
    <cfquery datasource="#APPLICATION.DSN#">
    	INSERT INTO
        	smg_regionhistory
     		(
        		studentID,
                regionID,
                rguarenteeid,
                stateguaranteeid,
                fee_waived,
                reason,
                changedby,
                date
        	)
        VALUES
        	(
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.region)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.rguarantee)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.state_guarantee)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.region_reason#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
         	)
    </cfquery>
    
<cfelseif NOT VAL(qGetRegionHistory.recordCount)>
	
    <cfquery datasource="#APPLICATION.DSN#">
    	INSERT INTO
        	smg_regionhistory
     		(
        		studentID,
                regionID,
                rguarenteeid,
                stateguaranteeid,
                fee_waived,
                reason,
                changedby,
                date
        	)
        VALUES
        	(
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qStudentInfo.studentID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.region)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.rguarantee)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.state_guarantee)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="Student was unassigned">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
         	)
    </cfquery>
    
</cfif>

<cfscript>
	APPLICATION.CFC.PROGRAM.addHistory(studentID=qStudentInfo.studentID,programID= FORM.program,reason=FORM.program_reason);
</cfscript>

<!--- PROGRAM UPDATED --->
<cfif qStudentInfo.programID NEQ FORM.program>
    
	<!--- EMAIL FINANCE DEPARTMENT ONLY IF PREVIOUS PROGRAM IS VALID --->
    <cfif VAL(qStudentInfo.programID)>
    	
    	<cfscript>	
			// Get Intl. Rep. Info
			qGetIntlRep = APPLICATION.CFC.USER.getUserByID(userID=qStudentInfo.intRep);

			// Get Current Program
			qGetPreviousProgram = APPLICATION.CFC.PROGRAM.getPrograms(ProgramID=qStudentInfo.programID);

			// Get Current Program
			qGetNewProgram = APPLICATION.CFC.PROGRAM.getPrograms(ProgramID=FORM.program);
		
			// Always send a copy of the email to Admissions and Compliance
			emailCC = APPLICATION.CFC.UDF.displayAdmissionsInformation(displayInfo='email');
			
			// If there is a valid email, send a copy to the current user
			if ( IsValid("email", APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID).email) and ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) ) {
				emailCC = emailCC & ';merri@iseusa.org;' & APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID).email;				
			} else {
				emailCC = CLIENT.projectmanager_email & ';' & CLIENT.email;
			}
			
			// Display All Emails Involved
			emailList = APPLICATION.EMAIL.finance & ';' & emailCC;
			
			// Replace ';' with a <br />
			emailList = ReplaceNoCase(emailList, ';', '<br />', "ALL");
		</cfscript>
		
        <cfoutput>
            <cfsavecontent variable="emailChangeProgram">
                <p>#qStudentInfo.firstName# #qStudentInfo.familyLastName# has been assigned to a new program.</p>

                Student: <strong>#qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# (###qStudentInfo.Studentid#)</strong><br />

                Division: <strong>#APPLICATION.CFC.COMPANY.getCompanies(companyID=qStudentInfo.companyID).companyShort#</strong><br />
                
                Intl. Agent: <strong>#qGetIntlRep.businessName# (###qGetIntlRep.userID#)</strong><br />
    
                Previous Program: <strong>#qGetPreviousProgram.programName# (###qGetPreviousProgram.programID#)</strong><br />
    
                New Program: 
                <cfif VAL(FORM.program)>
                    <strong>#qGetNewProgram.programName# (###qGetNewProgram.programID#)</strong>
                <cfelse>
                    <strong>Unassigned</strong>
                </cfif>
                                            
                Date/Time: <strong>#DateFormat(now(), 'mm/dd/yy')# #TimeFormat(now(), 'hh:mm:ss tt')#</strong><br />
    
                Reason: <strong>#FORM.program_reason#</strong><br />
    
                SEVIS No.: 
                <cfif NOT LEN(qStudentInfo.ds2019_no)>
                    <strong>No SEVIS Number on File</strong><br />
                <cfelse>
                    <strong>#qStudentInfo.ds2019_no#</strong><br />
                </cfif>                         
                
                Assigned By: <strong>#APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID).firstName# #APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID).lastName# (###CLIENT.userID#)</strong><br />
                
                <p>The following people received this notice:</p>
                <strong>#emailList#</strong>
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
    <!--- END OF EMAIL FINANCE DEPARTMENT ONLY IF PREVIOUS PROGRAM IS VALID --->   

</cfif>

<!---  CANCELLING A STUDENT --->
<cfif IsDefined('FORM.student_cancel')>
	
    <cfquery datasource="#APPLICATION.DSN#">
		UPDATE 
        	smg_students
		SET 
        	canceldate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.date_canceled)#">, 
			cancelreason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancelreason#">, 
			active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
		WHERE 
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentID#">
		LIMIT 1
	</cfquery>
    
	<!--- Send Cancelation Email to finance, program manager, others | Only Send if student is current active --->
	<cfif NOT LEN(qStudentInfo.canceldate)>
		
		<cfscript>
			// Update datePlacedEnded on smg_hosthistory
			APPLICATION.CFC.STUDENT.setDatePlacedEnded(studentID=qStudentInfo.studentID, datePlacedEnded=FORM.date_canceled);
		
            // Get Intl. Rep. Info
            qGetIntlRep = APPLICATION.CFC.USER.getUserByID(userID=qStudentInfo.intRep);
    
            // Get Current Program
            qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(ProgramID=qStudentInfo.programID);		
            
            // Email CC List
			vGetProgramManagerEmail = APPLICATION.CFC.COMPANY.getCompanies(companyID=qStudentInfo.companyID).pm_email;
			vGetFacilitatorEmail = APPLICATION.CFC.USER.getRegionFacilitator(regionID=qStudentInfo.regionassigned).email;
            if ( ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) ) {
                emailCC = "bmccready@iseusa.org;lois@iseusa.org;merri@iseusa.org;" & vGetProgramManagerEmail & ";" & vGetFacilitatorEmail & ";" & CLIENT.email;
            } else { 
                emailCC = CLIENT.programmanager_email & ';' & CLIENT.email;
            }
               
            // Display All Emails Involved
            emailList = CLIENT.finance_email & ';' & emailCC;
            
            // Replace ';' with a <br />
            emailList = ReplaceNoCase(emailList, ';', '<br />', "ALL");
        </cfscript>
    	<cfquery name="placementApproved" datasource="#application.dsn#">
        	select hh.datePlaced, hh.hostid, h.familylastname
            from smg_hosthistory hh
            left outer join smg_hosts h on hh.hostID = h.hostID
            where hh.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentID#">
            and hh.datePlaced is not NULL
        </cfquery>
        <cfoutput>
            <cfsavecontent variable="email_message">
                <p>#qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# has been cancelled.</p>
                
                Student: <strong>#qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# (###qStudentInfo.Studentid#)</strong><br />
                
                Intl. Agent: <strong>#qGetIntlRep.businessName# (###qGetIntlRep.userID#)</strong><br />
                
                Program: <strong>#qGetProgramInfo.programName# (###qGetProgramInfo.programID#)</strong><br />
                
                Cancel Date: <strong>#DateFormat(FORM.date_canceled,'mm/dd/yyyy')#</strong><br />
                
                Reason: <strong>#FORM.cancelreason#</strong><br />
                
                Placement Approved: 
                <cfif val(placementApproved.recordcount)>
                <cfloop query="placementApproved">
                    <strong>#DateFormat(placementApproved.datePlaced, 'mm/dd/yyyy')# - #familyLastName# Family</strong>
                </cfloop> <cfelse>
                    <strong>Unplaced</strong>
                </cfif> <br />
    
                SEVIS No.: 
                <cfif NOT LEN(qStudentInfo.ds2019_no)>
                    <strong>No SEVIS Number on File</strong>
                <cfelse>
                    <strong>#qStudentInfo.ds2019_no#</strong>
                </cfif> <br />                         
            
                SEVIS Fee: 
                <cfif qStudentInfo.sevis_fee_paid_date is ''>
                    <strong>Not Paid</strong>
                <cfelse>
                    <strong>Paid on #DateFormat(qStudentInfo.sevis_fee_paid_date,'mm/dd/yyyy')#</strong>
                </cfif> <br />
                
                Cancelled By: <strong>#CLIENT.name# - #CLIENT.email#</strong><br /><br />
                
                The following people received this notice: <br /> 
                <strong>#emailList#</strong><br /> <br />
            </cfsavecontent>
        </cfoutput>
    	
        <!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_from" value="#CLIENT.name# <#CLIENT.email#>">
            <cfinvokeargument name="email_to" value="#CLIENT.finance_email#">
            <cfinvokeargument name="email_cc" value="#emailCC#"> 
            <cfinvokeargument name="email_subject" value="Student Cancellation: #qGetIntlRep.businessname# (###qGetIntlRep.userID#) - #qStudentInfo.FirstName# #qStudentInfo.FamilyLastName# (###qStudentInfo.Studentid#) - #qGetProgramInfo.programname# (###qGetProgramInfo.programID#)">
            <cfinvokeargument name="email_message" value="#email_message#">
        </cfinvoke>
        
    </cfif>
    <!--- End of Send Cancelation Email to finance, program manager, others | Only Send if student is current active --->
    
    <cflocation url="../index.cfm?curdoc=student_info" addtoken="no">

<cfelse>

    <cfquery datasource="#APPLICATION.DSN#">
        UPDATE 
        	smg_students
        SET 
        	canceldate = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">, 
            cancelreason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
            active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        WHERE 
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudentInfo.studentID#">
        LIMIT 1
    </cfquery>

</cfif>

<cftransaction>

<!--- UPDATE STUDENT INFORMATION --->
<cfquery datasource="#APPLICATION.DSN#">
	UPDATE 
    	smg_students
	SET 
    <Cfif form.active is 'on'>
		active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
    <cfelse>
    	active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
    </Cfif>
		regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.region#">,
		<!--- Regional Guarantee --->
        regionGuar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.regionGuar#">, <!--- yes/no --->
        <cfif FORM.regionGuar EQ 'no'>
            regionalguarantee = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">, <!--- guaranteeID --->
            state_guarantee = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">, <!--- stateID --->
        <cfelse>
            regionalguarantee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(FORM.rguarantee)#">, <!--- guaranteeID --->
            state_guarantee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state_guarantee#">, <!--- stateID --->
        </cfif>
		<!--- GUARANTEED --->
        <cfif VAL(FORM.state_guarantee)>            	
            jan_app = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
        <cfelse>
	        jan_app = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.jan_app#">,
        </cfif>
		<cfif isDefined('FORM.team_id')>companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.team_id#">, </cfif>	
				date_depositReceived = <cfif IsDefined('FORM.date_depositReceived')><cfqueryparam  cfsqltype="CF_SQL_DATE" value="#FORM.date_depositReceived#"><cfelse> <cfqueryparam  cfsqltype="CF_SQL_DATE" null="yes"> </cfif>,
        date_finalPayment = <cfif IsDefined('FORM.date_finalPayment')><cfqueryparam  cfsqltype="CF_SQL_DATE" value="#FORM.date_finalPayment#"><cfelse> <cfqueryparam  cfsqltype="CF_SQL_DATE" null="yes"> </cfif>,
        date_checkDrawn = <cfif IsDefined('FORM.date_checkDrawn')><cfqueryparam  cfsqltype="CF_SQL_DATE" value="#FORM.date_checkDrawn#"><cfelse> <cfqueryparam  cfsqltype="CF_SQL_DATE" null="yes"> </cfif>,
        date_checkSentSchool = <cfif IsDefined('FORM.date_checkSentSchool')><cfqueryparam  cfsqltype="CF_SQL_DATE" value="#FORM.date_checkSentSchool#"><cfelse> <cfqueryparam  cfsqltype="CF_SQL_DATE" null="yes"> </cfif>,
         date_i20Sent = <cfif IsDefined('FORM.date_i20Sent')><cfqueryparam  cfsqltype="CF_SQL_DATE" value="#FORM.date_i20Sent#"><cfelse> <cfqueryparam  cfsqltype="CF_SQL_DATE" null="yes"> </cfif>,
        date_i20Received = <cfif IsDefined('FORM.date_i20Received')><cfqueryparam  cfsqltype="CF_SQL_DATE" value="#FORM.date_i20Received#"><cfelse> <cfqueryparam  cfsqltype="CF_SQL_DATE" null="yes"> </cfif>,
        iffschool = <cfif IsDefined('FORM.iff_check')>'#FORM.iffschool#'<cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,		
        scholarship = <cfif IsDefined('FORM.scholarship')> <cfqueryparam cfsqltype="cf_sql_integer" value="1"> <cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,                      
		privateschool = <cfif IsDefined('FORM.privateschool_check')>'#FORM.privateschool#'<cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,
		aypenglish = <cfif IsDefined("FORM.english_check")>'#FORM.ayp_englsh#'<cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,
		ayporientation = <cfif IsDefined('FORM.orientation_check')>'#FORM.ayp_orientation#'<cfelse> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> </cfif>,
		<cfif IsDefined('FORM.direct_placement')>direct_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.direct_placement#">,</cfif>
		<!----direct_place_nature = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.direct_place_nature#">,---->
		verification_received =  <cfif FORM.verification_form EQ ''>null<cfelse>#CreateODBCDate(FORM.verification_form)#</cfif>,	
		ds2019_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_no#">,
		programID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.program#">,
		intrep = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.intrep#">
	WHERE 
    	studentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qStudentInfo.studentID#">
	LIMIT 1
</cfquery>

</cftransaction>
 
<cflocation url="../index.cfm?curdoc=student_info" addtoken="no">