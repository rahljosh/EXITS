<!--- ------------------------------------------------------------------------- ----
	
	File:		user_info.cfm
	Author:		Marcus Melo
	Date:		March 18, 2010
	Desc:		User Information Page

	Updated:	03/18/2010 - Address change email is sent to RM, Facilitator and Thea. 	

----- ------------------------------------------------------------------------- --->

<cfajaxproxy cfc="extensions.components.cbc" jsclassname="CBC">

<!--- CHECK RIGHTS --->
<cfinclude template="check_rights.cfm">
<cfif isDefined('form.allocationSeasonID')>

<cfquery name="updateAllocations" datasource="#APPLICATION.dsn#">
	update smg_users_allocation
    	set augustAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.augustAllocation#">,
        	januaryAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.januaryAllocation#">
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#"> and seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.allocationSeasonID#">
</cfquery>
</cfif>
<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param URL variables --->
    <cfparam name="URL.action" default="">
    
    <!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.errors" default="">    
    <cfparam name="FORM.dateTrained" default="#DateFormat(now(), 'mm/dd/yyyy')#">
    <cfparam name="FORM.trainingID" default="0">
	<cfparam name="FORM.score" default="">
    
    <cfscript>
		// Get Current Season
		qGetCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();
		
		// Get Training Options
		qGetTrainingOptions = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='smgUsersTraining');
	
		// Get Training records for this user
		qGetTraining = APPLICATION.CFC.USER.getTraining(userID=URL.userID);
		
		// Get User Paperwork Struct
		stUserPaperwork = APPLICATION.CFC.USER.getUserPaperwork(userID=URL.userID);
	</cfscript>
	<Cfquery name="smgMediaRights" datasource="#APPLICATION.DSN#">
    select fk_companyid
    from smg_media_user_access
    where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </Cfquery>
	<cfquery name="availableRights" datasource="#APPLICATION.DSN#">
    select description, fieldid
    from applicationlookup
    where fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="userRole">
    and isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    <cfquery name="assignedRights" datasource="#APPLICATION.DSN#">
    select roleid
    from smg_users_role_jn
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </cfquery>
    <cfset userRights = ''>
    <Cfloop query="assignedRights">
    	<cfset userRights = #ListAppend(userrights, #roleid#)#>	
    </Cfloop>
	
	<!----Rep Info---->
    <cfquery name="rep_info" datasource="#APPLICATION.DSN#">
        SELECT 
        	smg_users.*, 
            smg_countrylist.countryname, 
            smg_insurance_type.type,
            smg_states.statename
            
        FROM 
        	smg_users
        LEFT JOIN 
        	smg_countrylist ON smg_users.country = smg_countrylist.countryid
        LEFT JOIN 
        	smg_insurance_type ON smg_users.insurance_typeid = smg_insurance_type.insutypeid
        LEFT JOIN
        	smg_states on smg_states.state = smg_users.state
        WHERE 
        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    </cfquery>
   
    <!---see if there are any reasons why account isn't enabled---->
    <cfquery name="disableReasonID" datasource="#application.dsn#">
    	SELECT
       		max(id) as id
    	FROM 
        	smg_accountdisabledhistory
        WHERE 
        	fk_userDisabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    </cfquery>
    
    <cfif val(disableReasonid.id)>
    
        <cfquery name="disableReason" datasource="#application.dsn#">
        	SELECT 
            	*
        	FROM 
            	smg_accountdisabledhistory
            WHERE 
            	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#disableReasonID.id#">
        </cfquery>
        
    </cfif>
 
    <!--- Check if logged in user has access to compliance --->
    <cfquery name="user_compliance" datasource="#APPLICATION.DSN#">
        SELECT 
        	userID, 
            compliance
        FROM 
        	smg_users
        WHERE 
        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
    </cfquery>

    <cfquery name="qGetReferences" datasource="#application.dsn#">
        SELECT 
        	*
        FROM
        	smg_user_references
        WHERE
        	referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    </cfquery>	

    <!--- get the access level of the user viewed. If null, then user viewing won't have access to username, etc. --->
    <cfinvoke component="nsmg.cfc.user" method="get_access_level" returnvariable="uar_usertype">
        <cfinvokeargument name="userID" value="#rep_info.userID#">
    </cfinvoke>
    
    <cfswitch expression="#action#">
    
		<!--- delete access level. --->
        <cfcase value="delete_uar">
            
            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM 
                	user_access_rights
                WHERE 
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.id#">
            </cfquery>
            
        </cfcase>
        
		<!--- set default access level. --->
        <cfcase value="set_default_uar">
            
			<!--- set all others to no first --->
            <cfquery name="get_all_access" datasource="#APPLICATION.DSN#">
                SELECT 
                	uar.id
                FROM 
                	user_access_rights uar
                WHERE 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
                    
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND          
                        uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    AND          
                        uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
               	
            </cfquery>
            
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	user_access_rights
                SET 
                	default_access = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                WHERE id 
                	IN (#valueList(get_all_access.id)#)
            </cfquery>
            
			<!--- set the selected to yes --->
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	user_access_rights
                SET 
                	default_access = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                WHERE 
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.id#">
            </cfquery>
        </cfcase>
        
		<!--- resend login info --->
        <cfcase value="resend_login">
            
            <cfquery name="get_user" datasource="#APPLICATION.DSN#">
                SELECT 
                	email, accountCreationVerified
                FROM 
                	smg_users
                WHERE 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
            </cfquery>
            
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#get_user.email#">
                <cfinvokeargument name="email_replyto" value="#CLIENT.email#">
                <cfinvokeargument name="email_subject" value="Login Information">
                <cfif get_user.accountCreationVerified eq 1>
                	<cfinvokeargument name="include_content" value="resend_login">
                <cfelse>
                	<cfinvokeargument name="include_content" value="newUserMoreInfo">
                </cfif>
                <cfinvokeargument name="userID" value="#URL.userID#">
            </cfinvoke>
            
        </cfcase>
        
		<!--- verify information. --->
        <cfcase value="verify_info">
            
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	smg_users
                SET 
                	last_verification = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                WHERE 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            </cfquery>
            
			<cfset temp = DeleteClientVariable("verify_info")>
            <cflocation url="index.cfm?curdoc=initial_welcome" addtoken="no">
            
        </cfcase>
        
    </cfswitch>
 <!----Student Allocation---->
   <cfquery name="qAllAvailablePrograms" datasource="#APPLICATION.dsn#">
   SELECT 
			p.programID,
			p.programName,
            p.startDate,
            p.endDate,
            p.type,
			p.seasonid,
            p.companyid,
            s.season,
            p.fk_smg_student_app_programID,
						(SELECT count(studentid) as NoStudents
						 FROM smg_students s
						 WHERE s.programID = p.programid
                   		 AND  s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">)  as NoStudents,
                      (SELECT Month(startdate) as startMonth
						 FROM smg_programs
						 WHERE programID = p.programid
                   		)  as startMonth   
                        
        FROM 
        	smg_programs p
		LEFT JOIN smg_seasons s on s.seasonid = p.seasonid
	
        WHERE
			
            p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)> 
        	AND ( p.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.publicHS#" list="yes"> )
			)
        </cfif>
		order by seasonid desc
    </cfquery>
    
    <Cfquery name="availSeasons" dbtype="query">
    select distinct season, seasonid
    from qAllAvailablePrograms
    order by seasonid desc
    </Cfquery>
    
     <!---user allocations---->
    <cfquery name="userAllocations" datasource="#application.dsn#">
    SELECT 
    	a.augustAllocation, a.januaryAllocation, a.seasonid
    FROM 
    	smg_users_allocation a
    LEFT JOIN 
    	smg_seasons s on s.seasonid = a.seasonid
    WHERE 
    	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#"> 
    AND 
    	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    


	<cfscript>
        // Form Submitted 
        if ( VAL(FORM.submitted) ) {
    
            if (NOT IsDate(FORM.dateTrained)) {
                FORM.errors = "Please enter a valid date trained (mm/dd/yyyy)";
                FORM.dateTrained = '';
            }		

            if (NOT VAL(FORM.trainingID)) {
                FORM.errors = "Please select a training type";
            }		
            
            // DOS Certification
            if ( FORM.trainingID EQ 2 AND ( NOT LEN(FORM.score) OR NOT IsValid("float", FORM.score) ) ) {
                FORM.errors = "Please enter a score in decimal format eg 93.70";
            }
            
            // There are no errors
            if (NOT LEN(FORM.errors)) {
                
                // Make sure we have a valid decimal
                FORM.score = ReplaceNoCase(FORM.score, ",", ".");
            
                // Insert Training
                APPLICATION.CFC.USER.insertTraining (
                    userID=VAL(URL.userID),
                    officeuserID=VAL(CLIENT.userID), 
                    trainingID=FORM.trainingID,
                    dateTrained=FORM.dateTrained,
                    score=FORM.score					
                );
            
                // Re-set Form Variables
                FORM.dateTrained = '';
                FORM.trainingID = 0;
                FORM.score = '';
				
                // Get updated query
                qGetTraining = APPLICATION.CFC.USER.getTraining(userID=URL.userID);
            }
        }
    </cfscript>
    
	<!----Denial/Submit/Approve info history---->
    <Cfquery name="accountDisableHistory" datasource="#application.dsn#">
    select h.date, h.fk_whoDisabled, h.reason, h.accountAction, smg_users.firstname, smg_users.lastname
    from smg_accountdisabledhistory h
    left join smg_users on smg_users.userID = h.fk_whoDisabled
    where fk_userDisabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    order by date desc
    </Cfquery>
    
</cfsilent>

<style type="text/css">
.smlink         		{font-size: 11px;}
.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #ffffff;}
.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionSubHead			{font-size:11px;font-weight:bold;}
.alert{
	width:auto;
	height:55px;
	border:#666;
	background-color:#FF9797;
	text-align:center;
	-moz-border-radius: 15px;
	border-radius: 15px;
	vertical-align:center;

}
.clearfix {
	display: block;
	clear: both;
	height: 5px;
	width: 100%;
}
</style>

<script type="text/javascript" language="javascript">
	// JQuery Ready Function
	$().ready(function() {
		// Get Selected Training
		displayTrainingScore();
	});

	$(document).ready(function() {
		$(".jQueryModal").colorbox( {
			   width:"60%",
			   height:"75%",
			   iframe:true,
			   overlayClose:false,
			   escKey:false
		});
	});

	function getCBCFromHost(userID, cbcID) {
		var cbc = new CBC();
		cbc.transferHostToUserCBC(userID, cbcID);
		window.location.reload();
	}

	// Display WebExForm
	function displayTrainingForm() {
		if($("#webExForm").css("display") == "none"){
			$("#webExForm").slideDown("slow");
		} else {
			$("#webExForm").slideUp("slow");	
		}
	}	
	
	
	// Display Score if DOS Certification is selected
	function displayTrainingScore() {
		selectedTraining = $("#trainingID").val();
		if ( selectedTraining == 2 ) {
			$("#trainingScore").slideDown("slow");
		} else {
			$("#trainingScore").slideUp("slow");	
		}
	}	
	
	// Display References
	function displayDisableHistory() {
		if($("#DisableHistory").css("display") == "none"){
			$("#DisableHistory").slideDown("slow");
		} else {
			$("#DisableHistory").slideUp("slow");	
		}
	}	
	
	// Display Experience
	function displayExperienceForm() {
		if($("#ExperienceForm").css("display") == "none"){
			$("#ExperienceForm").slideDown("slow");
		} else {
			$("#ExperienceForm").slideUp("slow");	
		}
	}		
</script>

<!--- user has no access records - force entry of one. --->
<cfif uar_usertype EQ 0>
	<!--- if viewing own profile and not office users abort with message. --->
	<cfif CLIENT.userID eq rep_info.userID and not APPLICATION.CFC.USER.isOfficeUser()>
        You have no Program Manager & Regional Access record assigned.<br />
        One must be assigned first before access to your information is allowed.<br />
    	Contact your facilitator to add the record.
        <cfabort>
    <cfelse>
		<cflocation url="index.cfm?curdoc=forms/access_rights_form&userID=#rep_info.userID#&force=1" addtoken="no">
    </cfif>
</cfif>
<cfoutput query="rep_info">
	
    <cfif NOT listFind("8,11", uar_usertype)>
    
		<cfif stUserPaperwork.accountReviewStatus EQ 'rmReview'>
            <div class="alert">
                <h1>Account Review Required</h1>
                <em>Reference Questionnaire Needed.</em>
            </div>
        <cfelseif stUserPaperwork.accountReviewStatus EQ 'officeReview'>
            <div class="alert">
                <h1>Account Review Required</h1>
                <em>CBC Approval Needed.</em>
            </div>
        <cfelseif stUserPaperwork.accountReviewStatus EQ 'missingTraining'>
            <div class="alert">
                <h1>Account Not Enabled</h1>
                <cfif NOT stUserPaperwork.isDOSCertificationCompleted AND NOT stUserPaperwork.isTrainingCompleted>
                    <em>User has submitted initial paperwork. DOS Certification and AR Training needed.</em>
                <cfelseif NOT stUserPaperwork.isDOSCertificationCompleted>
                    <em>User has submitted initial paperwork. DOS Certification needed.</em>
                <cfelse>
                    <em>User has submitted initial paperwork. AR Training needed.</em>
                </cfif>
            </div>
        <cfelseif NOT stUserPaperwork.isAccountCompliant>
            <div class="alert">
                <h1>Account Not Enabled</h1>
                <em>User has not submitted all required paperwork for this season. Please review items missing in the paperwork section.</em>
            </div>
            <br />
        </cfif>
    
    </cfif>
    
	<!--- INFORMATION --->
    <div class="rdholder"> 
   		<div class="rdtop"><span class="rdtitle">Please Note</span></div> <!-- end top --> 
        <div class="rdbox">
			<cfif isDefined("CLIENT.verify_info")>
                <font size="4" color="##FF0000"><b>
                Please verify that your Personal Information is correct, if not, please click on edit (<img src="pics/edit.png">) and update your information.<br>
                You must click below to verify your information before you may proceed.<br />
                </b></font>
                <a href="index.cfm?curdoc=user_info&action=verify_info&userID=#rep_info.userID#"><img src="pics/verify_account_info.jpg" width="144" height="112" border="0"></a>
            <cfelse>
				<!--- international user --->
                <cfif uar_usertype EQ 8>
                    <div style="font-size:14px;font-weight:bold;" align="justify">
                    Please verify that your account information is correct.
                    Inaccurate information could result in delayed communication, missed emails, inaccurate records and inefficient communication.  
                    To update your information, click on please click on the edit icon (<img src="pics/edit.png">). 
                    If information is incorrect and you update your information, please notify #CLIENT.company_submitting# immediatly of any such updates. 
                    </div> 
                <cfelse>
                    <div style="font-size:14px;font-weight:bold;" align="justify">
                    Please verify that your account information is correct.
                    Inaccurate information could result in delayed payments and missed emails.
                    #CLIENT.company_submitting# is not responsible for delayed payments if your information is incorrect.  
                    If information is incorrect and you update your information, you must notify your manager or facilitator.
                    </div>
                    If you can not edit information that is incorrect, contact your manager or facilitator.
                </cfif>
            </cfif>
        </div>
   		<div class="rdbottom"></div> <!-- end bottom --> 
    </div>
    
<!----Left column for alignment purposes---->
<div style="width:49%;float:left;display:block;">
			<!----Personal Information---->
		   <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Personal Information</span> 
                <!--- DOS Usertype does not have access to edit information --->
				<cfif CLIENT.userType NEQ 27>
	                <a href="index.cfm?curdoc=forms/user_form&userID=#url.userID#"><img src="pics/buttons/pencilBlue23x29.png" class="floatRight" border=0/></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
             <!-----****personal info****---->
             <table  cellpadding=4 cellspacing="0" border="0" width=100%>
				<tr>
					<td valign="top">
						<table  cellpadding="0" cellspacing="0" border="0" bgcolor="##ffffff" align="left">
							
							<tr>
								
								<td width=226 style="padding:5px;">
                                	<!--- international user --->
                                	<cfif uar_usertype EQ 8>
                                    	<strong>Personal Information:</strong><br />
                                    	#businessname#<br>
                                    </cfif>
									#firstname# #middlename# #lastname# - #userID#<br>
									#address#<br>
									<cfif address2 NEQ ''>#address2#<br></cfif>
									#city#, #state# #zip# #country#<br>
									<cfif phone NEQ ''>Home: #phone#<br></cfif>
									<cfif work_phone NEQ ''>Work: #work_phone#<br></cfif>
									<cfif cell_phone NEQ ''>Cell: #cell_phone#<br></cfif>
									<cfif fax NEQ ''>Fax: #fax#<br></cfif>
									<cfif email NEQ ''>Email: <a href="mailto:#email#">#email#</a><br></cfif>
									<cfif email2 NEQ ''>Alt. Email: <a href="mailto:#email2#">#email2#</a><br></cfif>
									<cfif skype_id NEQ ''>Skype ID: #skype_id#<br></cfif>
								</td>
								
							</tr>
							
						</table> 
					</td>
				<!--- international user --->
                <cfif uar_usertype EQ 8>
					<td valign="top">
						<table  cellpadding="0" cellspacing="0" border="0" bgcolor="##ffffff" align="left">
							
							<tr>
								
								<td width=226 style="padding:5px;">
                                    <strong>Billing Information:</strong><br />
                                    #billing_company#<br>
                                    #billing_contact#<br>
                                    #billing_address#<br>
                                    <cfif LEN(billing_address2)>#billing_address2#<br></cfif>
                                    #billing_city# #countryname#, #billing_zip#<Br>
                                    <cfif LEN(billing_phone)>Phone: #billing_phone#<br></cfif>
                                    <cfif LEN(billing_fax)>Fax: #billing_fax#<br></cfif>
                                    <cfif LEN(billing_email)>Email: <a href="mailto:#billing_email#">#billing_email#</a><br></cfif>	
								</td>
								
							</tr>
							
						</table> 
					</td>
                </cfif>
                	<td valign="top">
                    	<table>
                        	<tr>
					 		<cfif CLIENT.userType EQ 1>
                                <td><strong>Username:</strong></td><td align="left">#username#</td>
                            </tr>    
                            <tr>
                                <td><strong>Password:</strong></td><td align="left">#password#</td>
                             
							 <cfelseif CLIENT.usertype LTE uar_usertype> <!--- APPLICATION.CFC.USER.isOfficeUser() OR - protect passwords --->
                                 <td><strong>Username:</strong></td><td align="left">#username#</td>
                            </tr>    
                            <tr>
                                <td><strong>Password:</strong></td><td align="left">#password#</td>
                            </tr></cfif>
                          
                          
                        <cfif APPLICATION.CFC.USER.isOfficeUser() AND rep_info.changepass eq 1><br />
							<tr>
                            	<td colspan="2"><i>User will be required to change password on next log in.</i></td>
                             </tr>
                        </cfif>
                		</table>
                        <br />
                        <table border=0>
                       
                        <!--- change password: if viewing own profile. --->
                        <cfif CLIENT.userID EQ rep_info.userID OR APPLICATION.CFC.USER.isOfficeUser()>
                        <tr>
                        	<td colspan="2">
                            <a href="index.cfm?curdoc=forms/change_password"><img src="pics/buttons/chPass.png" border="0" align="left"> Change Password</a>
                        	</td>
                        </tr>	
                        </cfif>
                        
						<!--- Regional Managers and Above --->
                        <cfif CLIENT.usertype LTE 6>
                            <tr>
                                <td colspan="2">
                                    <a href="index.cfm?curdoc=history&userID=#rep_info.userID#"><img src="pics/buttons/viewHistory.png" border="0" align="left">Page View History</a>
                                    <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                        &nbsp; | &nbsp; <a href="user/index.cfm?action=statusHistory&userID=#rep_info.userID#" class="jQueryModal">Status History</a>
                                    </cfif>
                                    <br />
                                </td>
                            </tr>	
                        </cfif>
                        
                        <tr>
                        	<td colspan="2">
                        		<a href="index.cfm?curdoc=user_info&action=resend_login&userID=#rep_info.userID#"><img src="pics/buttons/emailResend.png" border="0" align="left"> Resend Login Info</a>
                        		<cfif URL.action EQ 'resend_login'><font color="red"> - Sent</font></cfif>
                        	</td>
                        </tr>	
                        </table>
					</td>
			</table>
            <!-----*****end Personal Info****---->
			
			</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            
<cfif uar_usertype EQ 8>
<!--- SIZING TABLE --->
 
              <!--- ------------------------------------------------------------------------- ---->
            <!----Logo Management for Int. Agent---->
            <!--- ------------------------------------------------------------------------- ---->
                <div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Logo Management</span>
                	 <cfif rep_info.logo is ''><Cfelse><img src="pics/logos/#rep_info.logo#"  height=16></cfif>
            	</div> 
                <div class="rdbox">
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td>
                            You can set what logo appears in the upper right hand corner for you, branch offices and your students.<br>
                            <cfform action="querys/upload_logo.cfm"  method="post" enctype="multipart/form-data" preloader="no">
                                <cfinput type="hidden" name="userID" value="#rep_info.userID#">
                                <cfinput type="file" name="UploadFile" size=35 required="yes" message="Please specify a file." validateat="onsubmit,onserver"> 
                                <cfinput type="submit" name="upload" value="Upload Picture">
                            </cfform>
                            <i>logo should be 71 pixels in height</i>
                        </td>
                    </tr>
                </table>
                 </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
              <!--- ------------------------------------------------------------------------- ---->
            <!----END Logo Management for Int. Agent---->
            <!--- ------------------------------------------------------------------------- ---->
            
            <!--- ------------------------------------------------------------------------- ---->
            <!----Notes for Int. Agent---->
            <!--- ------------------------------------------------------------------------- ---->
            
            
            <!---- NOTES ---->
                <div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                    <span class="rdtitle">Notes</span>
            	</div> 
                <div class="rdbox">
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                            <cfif comments EQ ''>No additional information available.<cfelse>#comments#</cfif><br><br>
                        </td>
                    </tr>
                </table>
               </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----End Notes for Int. Agent---->
            <!--- ------------------------------------------------------------------------- ---->
            <!---- Allocation ---->
                <div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                    <span class="rdtitle">Season Allocations</span>
            	</div> 
                <div class="rdbox">
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
               <Cfloop query="availSeasons">
               		  <cfquery name="specificPrograms" dbtype="query">
                        select *
                        from qAllAvailablePrograms
                        where seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#seasonid#">
                       </cfquery> 
                     <cfquery name="studentCountJan" dbtype="query">
                       select sum(noStudents) as totalStudents
                       from  qAllAvailablePrograms
                       where seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#specificPrograms.seasonid#"> 
                       and startMonth = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                       </cfquery>
                    <cfquery name="studentCountAug" dbtype="query">
                       select sum(noStudents) as totalStudents
                       from  qAllAvailablePrograms
                       where seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#specificPrograms.seasonid#"> 
                       and startMonth = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                       </cfquery>
                     <Cfquery name="programAllocation" dbtype="query">
                       SELECT
                            augustAllocation, januaryAllocation
                       FROM
                            userAllocations
                       WHERE
                            seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(specificPrograms.seasonid)#">
              	 	</Cfquery>
                   
                	<form action="?#cgi.QUERY_STRING#" method="post">
                    <input type="hidden" value="#seasonID#" name="allocationSeasonID">
                   
                    <tr bgcolor="##006699">
                    
                        <td style="line-height:20px;" valign="top">
                         <font color="##FFFFFF"><strong> #season#</strong></font>
                        </td>
                        <td align="center"><font color="##FFFFFF"><strong> August Allocation: 
							<cfif client.usertype lte 3>
                        		<input type="text" name="augustAllocation" value="#programAllocation.augustAllocation#" size=3/>
                        	<cfelse>
                            	#programAllocation.augustAllocation#
                            </cfif>
                            </strong>
                            </font>
                         </td>
                         <td align="center"> <font color="##FFFFFF"><strong>January Allocation: 
						 	<cfif client.usertype lte 2>
                            	<input type="text" name="januaryAllocation" value="#programAllocation.januaryAllocation#" size=3 /><input type=submit value="Update" class="basicBlueButton" />
                            <cfelse>
                            	#programAllocation.januaryAllocation#
                            </cfif>
                            </strong>
                            </font>
                            
                            </td>
                        
                    </tr>
                    </form>
                    
                    
                  	<Cfloop query="specificPrograms">
                    <tr <cfif currentrow mod 2>bgcolor="##efefef"</cfif>>
                    	<td>#programName#</td>
                          <cfif DateFormat(startDate, 'm') is 1>
                            	<Td align="center">&##8212;</Td><td align="center">#noStudents#</td>
                                
                            <cfelseif DateFormat(startDate, 'm') is 8>
                            	<td align="center">#noStudents#</td><Td align="center">&##8212;</Td>
                              
                            </cfif>
                     </tr>      
                  
                   </cfloop>
               
                   <tr bgcolor=##ccc>
                   		<td>Total Students</td><Td align="center">#studentCountAug.totalStudents#</Td><td align="center">#studentCountJan.totalStudents#</td>
                   </tr>
                  	<tr>
                    	<td><br /></td>
                    </tr>
                </Cfloop>
                </table>
               </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            
            <!--- ------------------------------------------------------------------------- ---->
            <!----End Student Allocation for Int. Agent---->
            <!--- ------------------------------------------------------------------------- ---->
            
<cfelse>
            <!----Regional Information---->
            <cfquery name="region_company_access" datasource="#APPLICATION.DSN#">
                SELECT 
                    uar.id, 
                    uar.regionid, 
                    uar.usertype, 
                    uar.changedate, 
                    uar.default_access, 
                    r.regionname, 
                    c.companyshort, 
                    c.companyID, 
                    ut.usertype AS usertypename,
                    adv.userID AS advisorid, 
                    adv.firstname, 
                    adv.lastname
                FROM 
                    user_access_rights uar
                LEFT JOIN 
                    smg_regions r ON uar.regionid = r.regionid
                INNER JOIN 
                    smg_companies c ON uar.companyid = c.companyid
                INNER JOIN 
                    smg_usertype ut ON uar.usertype = ut.usertypeid
                LEFT OUTER JOIN 
                    smg_users adv ON uar.advisorid = adv.userID
                WHERE 
                    uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                    
                <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND          
                        uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    AND          
                        uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
                    
                ORDER BY 
                    uar.companyid, uar.regionid, uar.usertype
            </cfquery>
            
            <cfquery name="check_default" dbtype="query">
                SELECT id
                FROM region_company_access
                WHERE default_access = 1
            </cfquery>
           
 			<!--- ------------------------------------------------------------------------- ---->
            <!----Regional & Company Information---->
            <!--- ------------------------------------------------------------------------- ---->
    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Company & Regional Access</span> 
                 <cfif listFind("1,2,3,4,5", CLIENT.userType)>
                <a href="index.cfm?curdoc=forms/access_rights_form&userID=#rep_info.userID#"><img src="pics/buttons/pencilBlue23x29.png" class="floatRight" border=0/></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
                <!----****company info****---->
                 <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                          
                           
                            <cfif check_default.recordCount EQ 0>
                                <font color="##FF0000">You have no default selected.  Please select a default by clicking the "No" in the "Default" column.</font>
                            </cfif>
                
                           
                                <!----scrolling table with region information---->
                                <table width="100%" cellspacing="0">
                                    <tr>
                                        <cfif listFind("1,2,3,4,5", CLIENT.userType)>
                                            <td><u>Actions</u></td>
                                        </cfif>
                                        <td><u>Default</u></td>
                                        <td><u>P.M.</u></td>
                                        <td><u>Region</u></td>
                                        <td><u>Access Level</u></td>
                                        <td><u>Reports to:</u></td>
                                        <td><u>Date Added:</u></td>
                                    </tr>
                                    <cfif region_company_access.recordcount eq 0>
                                        <tr><td colspan="7" align="center"><br />No Regions assigned for this user. Click 'Add' to assign access.</td></tr>
                                    <cfelse>
                                    
                                        <cfloop query="region_company_access">
                                       
                                            <tr bgcolor="#iif(currentRow MOD 2 ,DE("efefef") ,DE("ffffff") )#">
                                            <cfif listFind("1,2,3,4,5", CLIENT.userType)>
                                                <td>
                                                    <!--- don't allow delete if user has only one record or for the default record. Dont allow edit on 2nd VIsit Reps.  Must convert to re-block access according to training. --->
                                                    <cfif region_company_access.usertype NEQ 15>
														<cfif APPLICATION.CFC.USER.isOfficeUser() AND ( not (region_company_access.recordcount EQ 1 OR default_access))>
                                                            <a href="index.cfm?curdoc=user_info&action=delete_uar&id=#id#&userID=#rep_info.userID#" onClick="return confirm('Are you sure you want to delete this Company & Regional Access record?')">
                                                                <img src="pics/deletex.gif" border="0" alt="Delete">
                                                            </a>                                                    
                                                             -
                                                        </cfif>
                                                    <a href="index.cfm?curdoc=forms/access_rights_form&id=#id#&companyID=#companyID#&userID=#rep_info.userID#" title="Edit Access Level">Edit</a>
                                                    <cfelse>
                                                    <a href="index.cfm?curdoc=forms/convertToRep&userID=#rep_info.userID#"><img src="pics/convertBut_sm.jpg" border="0" /></a>
                                                    </cfif>
                                                </td> 
                                                <!---<td><a href="index.cfm?curdoc=forms/access_rights_form&id=#id#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>--->
                                            </cfif>
                                            <td>
                                                <cfif default_access>
                                                    Yes
                                                <cfelse>
                                                    <a href="index.cfm?curdoc=user_info&action=set_default_uar&id=#id#&userID=#rep_info.userID#" title="Set as default.">No</a>
                                                </cfif>
                                            </td>
                                            <td>#companyshort#</td>
                                            <td>#regionname# (#regionid#)</td>
                                            <td>#usertypename#</td>
                                            <td>
                                                <cfif usertype LTE 4>
                                                    n/a
                                                <cfelse>
                                                    <cfif advisorid EQ ''>
                                                        Directly to Director
                                                    <cfelse>
                                                        #firstname# #lastname#
                                                    </cfif>
                                                </cfif>
                                            </td>
                                            <td>#dateFormat(changedate, 'mm/dd/yyyy')#</td>
                                            </tr>
    
                                            <cfif usertype EQ 5>
                                            
                                                <cfquery name="check_manager_assignment" datasource="#APPLICATION.DSN#">
                                                    SELECT 
                                                    	user_access_rights.userID, 
                                                        user_access_rights.usertype, 
                                                        smg_users.firstname, 
                                                        smg_users.lastname
                                                    FROM 
                                                    	user_access_rights 
                                                    INNER JOIN 
                                                    	smg_users ON user_access_rights.userID = smg_users.userID
                                                    WHERE 
                                                    	user_access_rights.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                                                    AND 
                                                    	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionid#">
                                                    AND 
                                                    	smg_users.userID != <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
													AND
                                                    	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                                                    
                                                </cfquery>
    
                                                <cfloop query="check_manager_assignment">
                                                    <tr bgcolor="#iif(region_company_access.currentRow MOD 2 ,DE("efefef") ,DE("ffffff") )#">
                                                        <td>&nbsp;</td>
                                                        <!---<td>&nbsp;</td>--->
                                                        <td colspan="6"><em>#check_manager_assignment.firstname#  #check_manager_assignment.lastname# is also assigned as a Regional Manager for this region.</em></td>
                                                    </tr>
                                                </cfloop>
    
                                            </cfif>	
                                             
                                        </cfloop>
                                        
                                    </cfif>
                                </table>
                           
                        </td>
                    </tr>
                </table>
            
            </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END Regional & Company Information---->
            <!--- ------------------------------------------------------------------------- ---->
            
  <!--- ------------------------------------------------------------------------- ---->
            <!----CBC's---->
            <!--- ------------------------------------------------------------------------- ---->
            
                <cfquery name="get_cbc_user" datasource="#APPLICATION.DSN#">
                    SELECT cbcid, userID, date_authorized , date_sent, notes, date_expired, requestid, smg_users_cbc.seasonid, flagcbc, smg_seasons.season, batchid
                    FROM smg_users_cbc
                    LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_users_cbc.seasonid
                    WHERE smg_users_cbc.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#"> 
                    AND familyid = '0'
                    <cfif CLIENT.companyid eq 10>
                        AND smg_users_cbc.companyid = 10
                    </cfif>
                    ORDER BY smg_seasons.season
                </cfquery>
                            
                <cfquery name="check_hosts" datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT h.hostid, familylastname, h.fatherssn, h.motherssn, date_sent, date_expired, smg_seasons.season, requestid, cbc.batchid, cbc.cbcfamid
                    FROM smg_hosts h
                    INNER JOIN smg_hosts_cbc cbc ON h.hostid = cbc.hostid
                    LEFT JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
                    
                    WHERE cbc.cbc_type = 'father' AND ((h.fatherssn = '#rep_info.ssn#' AND h.fatherssn != '') OR (h.fatherfirstname = '#rep_info.firstname#' AND h.fatherlastname = '#rep_info.lastname#' <cfif rep_info.dob NEQ ''>AND h.fatherdob = '#DateFormat(rep_info.dob,'yyyy/mm/dd')#'</cfif>))
                    OR cbc.cbc_type = 'mother' AND ((h.motherssn = '#rep_info.ssn#' AND h.motherssn != '') OR (h.motherfirstname = '#rep_info.firstname#' AND h.motherlastname = '#rep_info.lastname#' <cfif rep_info.dob NEQ ''>AND h.motherdob = '#DateFormat(rep_info.dob,'yyyy/mm/dd')#'</cfif>))
                </cfquery>
                
                <cfquery name="currentSeasonCBC" dbtype="query">
                    select 
                    	date_sent
                    from 
                    	get_cbc_user
                    where 
                    	seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCurrentSeason.seasonID)#"> 
                    and 
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userID#"> 
                </cfquery>
               
          
                <div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Criminal Background Checks</span> 
                <cfif CLIENT.usertype EQ 1 OR user_compliance.compliance EQ 1 OR APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="runCBC")>
                <a href="?curdoc=cbc/users_cbc&userID=#rep_info.userID#"><img src="pics/buttons/pencilBlue23x29.png" alt="Edit" border="0" class="floatRight"></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
                
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td align="center" valign="top"><b>Season</b></td>		
                        <td align="center" valign="top"><b>Date Submitted</b> <br><font size="-2">mm/dd/yyyy</font></td>
                        <td align="center" valign="top"><b>Expiration Date</b> <br><font size="-2">mm/dd/yyyy</font></td>		
                        <td align="center" valign="top"><b>View</b></td>
                        <td align="left" valign="top"><b>Status</b></td>
                        <td align="left" valign="top" colspan="2"><b>Notes</b></td>
                        <cfif APPLICATION.CFC.USER.isOfficeUser() and CLIENT.companyid eq 10><td align="center" valign="top"><strong>Delete</strong></td></cfif>
                    </tr>				
                    <cfif get_cbc_user.recordcount EQ '0'>
                        <tr><td align="center" colspan="5">No CBC has been submitted.</td></tr>
                    <cfelse>
                        <cfloop query="get_cbc_user">
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("efefef") ,DE("ffffff") )#"> 
                            <td align="center" style="line-height:20px;"><b>#season#</b></td>
                            <td align="center" style="line-height:20px;"><cfif NOT isDate(date_sent)>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center" style="line-height:20px;"><cfif NOT isDate(date_expired)>processing<cfelse>#DateFormat(date_expired, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center" style="line-height:20px;">
								<cfif NOT LEN(requestID)>
                                	processing
								<cfelseif flagcbc EQ 1>
                                	On Hold Contact Compliance
                             	<cfelse>
									<cfif APPLICATION.CFC.USER.isOfficeUser()>
                                    	<a 
                                        	href="cbc/view_user_cbc.cfm?userID=#get_cbc_user.userID#&cbcID=#get_cbc_user.cbcID#&file=batch_#get_cbc_user.batchid#_user_#get_cbc_user.userID#_rec.xml" 
                                            target="_blank">
											<!----#requestid#---->View
                                     	</a>
                                 	</cfif>
                          		</cfif>
                        	</td>
                            <td align="left" style="line-height:20px;">
                            	<cfscript>
									APPLICATION.CFC.CBC.getCBCResultStatus(cbcID=get_cbc_user.cbcID,cbcType="user");
								</cfscript>
                            </td>
                            <td colspan="2">
								<cfif APPLICATION.CFC.USER.isOfficeUser()>
                                	#notes#
                            	<cfelse>
                                	&nbsp;
                                </cfif>
                            </td>
                            <cfif APPLICATION.CFC.USER.isOfficeUser() and CLIENT.companyid eq 10><td align="center" valign="top"><a href="delete_cbc.cfm?type=user&id=#requestid#&userID=#url.userID#"><img src="pics/deletex.gif" border=0/></td></cfif>
                        </tr>
                        </cfloop>
                    </cfif>
                    
                    <cfif check_hosts.recordCount>
                        <tr><td colspan="3"><strong>CBC Submitted for Host Family (###check_hosts.hostid#).</strong></td></tr>
                        <cfloop query="check_hosts">
                            <tr bgcolor="#iif(currentrow MOD 2 ,DE("efefef") ,DE("ffffff") )#"> 
                                <td align="center" style="line-height:20px;"><b>#season#</b></td>
                                <td align="center" style="line-height:20px;"><cfif NOT isDate(date_sent)>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                                <td align="center" style="line-height:20px;"><cfif NOT isDate(date_expired)>processing<cfelse>#DateFormat(date_expired, 'mm/dd/yyyy')#</cfif></td>
                                <td align="center" style="line-height:20px;" colspan="2"><cfif NOT LEN(requestID)>processing<cfelse><cfif APPLICATION.CFC.USER.isOfficeUser()>#requestid#</cfif></cfif></td>
                                <cfif APPLICATION.CFC.USER.isOfficeUser() and CLIENT.companyid eq 10>
                                    <td align="center" valign="top"><a href="delete_cbc.cfm?type=user&id=#requestid#&userID=#url.userID#"><img src="pics/deletex.gif" border=0/></a></td>
                                </cfif>
                                <td>
                                	<cfif ListFind("1,2,3,4",CLIENT.userType)>
                                    	<input type="button" onclick="getCBCFromHost(#userID#,#check_hosts.cbcfamid#)" value="Transfer CBC" style="font-size:10px" />
                                  	</cfif>
                                </td>
                            </tr>
                        </cfloop>		
					</cfif>                        		
                </table>
				<!----footer of  cbc  table---->
                   </div>
                 <div class="rdbottom"></div> <!-- end bottom --> 
                
                 </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!---- END CBC's---->
            <!--- ------------------------------------------------------------------------- ---->
            
  
  	<!--- ------------------------------------------------------------------------- ---->
            <!----Paymeny History---->
            <!--- ------------------------------------------------------------------------- ---->  
            
             <div class="rdholder" style="width:40%;float:left;"  > 
				<div class="rdtop"> 
                <span class="rdtitle">Payment Activity</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
                
              
                <table width="100%" cellpadding="4" cellspacing="0" border="0" >
                    <tr>
                        <td style="line-height:22px;" valign="top">
                            <Cfquery name="super_payments" datasource="#APPLICATION.DSN#">
                                select sum(amount) as amount
                                from smg_users_payments
                                where agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                                and transtype = 'supervision'
								<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                                    AND
                                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                                <cfelse>
                                    AND
                                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                                </cfif>
                            </Cfquery>
                            <Cfquery name="place_payments" datasource="#APPLICATION.DSN#">
                                select 
                                	sum(amount) as amount
                                from 
                                	smg_users_payments
                                where 
                                	agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                                and 
                                	transtype = 'placement'
								<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                                    AND
                                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                                <cfelse>
                                    AND
                                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                                </cfif>
                            </Cfquery>
                            <cfquery name="second_payments" datasource="#APPLICATION.DSN#">
                            	SELECT
                                	sum(amount) AS amount
                               	FROM
                                	smg_users_payments
                              	WHERE
                                	agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                              	AND
                                	transtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="secondVisit">
								<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                                    AND
                                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                                <cfelse>
                                    AND
                                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                                </cfif>
                            </cfquery>
                            <cfquery name="trip_payments" datasource="#APPLICATION.DSN#">
                            	SELECT
                                	amount
                               	FROM
                                	smg_users_payments
                              	WHERE
                                	agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                              	AND
                                	transtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="trip">
								<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                                    AND
                                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                                <cfelse>
                                    AND
                                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                                </cfif>
                            </cfquery>
							<cfquery name="prePlacement_payment" datasource="#APPLICATION.DSN#">
								SELECT SUM(amount) AS amount
								FROM smg_users_payments
								WHERE agentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
								AND transtype = "Pre-Placement"
								<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                                    AND companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                                <cfelse>
                                    AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                                </cfif>
							</cfquery>
                            <strong>Supervising Payments:</strong> #LSCurrencyFormat(super_payments.amount, 'local')#<br>
                            <strong>Placement Payments:</strong> #LSCurrencyFormat(place_payments.amount, 'local')#<br>
                            <strong>Second Visit Payments:</strong> #LSCurrencyFormat(second_payments.amount, 'local')#<br>
                            <cfif trip_payments.recordCount NEQ 0>
                            	<strong>Trip Payments:</strong> #LSCurrencyFormat(trip_payments.amount, 'local')#<br>
                           	</cfif>
							<cfif CLIENT.companyID EQ 14>
								<strong>Pre-Placement Payments:</strong> #LSCurrencyFormat(prePlacement_payment.amount, 'local')#<br>
							</cfif>
                            <font size = -2><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=paymentReport&userID=#rep_info.userID#">view details</a></font>
                            <cfif APPLICATION.CFC.USER.isOfficeUser()> - <font size = -2><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment&user=#rep_info.userID#">make payment</a></cfif>
                        </td>
                    </tr>
                   </table>
                        <!----footer of  payment activity table---->
                      		</div>
                     <div class="rdbottom"></div> <!-- end bottom --> 
                    
                     </div>
 			<!--- ------------------------------------------------------------------------- ---->
            <!----END Paymeny History---->
            <!--- ------------------------------------------------------------------------- ----> 
            
			<!--- ------------------------------------------------------------------------- ---->
            <!----Notes---->
            <!--- ------------------------------------------------------------------------- ---->   
               
             <div class="rdholder" style="width:58%;float:right;"  > 
				<div class="rdtop"> 
	                <span class="rdtitle">Notes</span> 
                    <!--- DOS Usertype does not have access to edit information --->
                    <cfif CLIENT.userType NEQ 27>
                        <a href="index.cfm?curdoc=forms/user_form&userID=#url.userID#"><img src="pics/buttons/pencilBlue23x29.png" height="8" border=0 class="floatRight"/></a>
                    </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">

             <cfif comments EQ ''>No additional information available.<cfelse>#comments#</cfif><br><br>
                   
                <!----footer of  notes  table---->
                   </div>
                 <div class="rdbottom"></div> <!-- end bottom --> 
                
                 </div>
 			<!--- ------------------------------------------------------------------------- ---->
            <!----END NOTES---->
            <!--- ------------------------------------------------------------------------- ----> 

 			<!--- ------------------------------------------------------------------------- ---->
            <!----Documents---->
            <!--- ------------------------------------------------------------------------- ---->   
               <!----CBC Authorization---->
               
                 <!--- Documents 
                <cfdirectory directory="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/users/#userID#/" name="documents">
				----> 
                <cfdirectory directory="c:\websites\student-management\nsmg\uploadedfiles\users\#userID#\" name="documents">
               
                <div class="rdholder" style="width:100%;float:left;"  > 
				<div class="rdtop"> 
                <span class="rdtitle">Documents</span> 
                
            	</div> <!-- end top --> 
             <div class="rdbox">       
               
              
                   
                
                     
                      <table width=100% cellspacing=0 cellpadding=2>
                        	<tr>
                            <Th align="left">Name</Th><Th align="left">Date</Th><th  align="left">Type</th>
                            </tr>
                           <cfif documents.recordcount eq 0>
                            <tr>
                                <td colspan=7>No documents are on file for #firstname#.</td>
                            </tr>
                            <cfelse>
                            <Cfloop query="documents">
                            <tr <cfif currentrow mod 2> bgcolor="##efefef"</cfif>>
                              
                                <td valign="middle"><a href="javascript:openPopUp('uploadedfiles/users/#userID#/#name#')">#name#</a></td>
                                <td valign="middle">#dateFormat(datelastModified, 'mm/dd/yyyy')#</td>
                                <td valign="middle"><img src="pics/icons/#Right(name,3)#.png" /></td>
                                
                               
                            </tr>
                            </Cfloop>
                            </cfif>
                           </table>
              
                 </div>
                 <div class="rdbottom"></div> <!-- end bottom --> 
                
                 </div>
			<!--- ------------------------------------------------------------------------- ---->
            <!---- END Emolyment History---->
            <!--- ------------------------------------------------------------------------- ---->   	
 
 <!--- ------------------------------------------------------------------------- ---->
            <!----Emolyment History---->
            <!--- ------------------------------------------------------------------------- ---->   
                <br /><br />
                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                <cfquery name="qEmploymentHistory" datasource="#application.dsn#">
                select *
                from smg_users_employment_history
                where fk_userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userID#">
                order by current
                </cfquery>
                 <!--- Experience ----> 
                
                <div class="rdholder" style="width:100%;float:left;"  > 
				<div class="rdtop"> 
                <span class="rdtitle">Experience</span> 
                
            	</div> <!-- end top --> 
             <div class="rdbox">       
               
              
                   
                  
                     
                      <table width=100% cellspacing=0 cellpadding=2>
                           <tr>
                           	 	<td colspan=7>
                                <b>Prior Exchange Experience:</b><br />
                                <cfif prevOrgAffiliation eq 0>
                                None
                                <cfelseif prevOrgAffiliation eq 1> 
                                 #prevAffiliationName#<br />
                                 <cfif #prevAffiliationProblem# is not ''><em><font color="##CCCCCC">Problems:</font></em> #prevAffiliationProblem#</cfif>
                                 <cfelse>
                                 Question not Answered.
                                 </cfif>
                                 <br /><br />
                                </td>
                           </tr>
                            <Th></Th><Th>Employer</Th><Th>Address</Th><th>City</th><Th>State</Th><th>Zip</th><th>Phone</th>
                            </tr>
                           <cfif qEmploymentHistory.recordcount eq 0>
                            <tr>
                                <td colspan=7>No employers are on file for #firstname#.</td>
                            </tr>
                            <cfelse>
                            <Cfloop query="qEmploymentHistory">
                            <tr <cfif currentrow mod 2> bgcolor="##efefef"</cfif>>
                                <td><cfif current eq 1>&radic;</cfif></td>
                                <td valign="middle">#employer#</td>
                                <td valign="middle">#address# #address2#</td>
                                <td valign="middle">#city#</td>
                                <td valign="middle">#state#</td>
                                <td valign="middle">#zip#</td>
                                <td valign="middle">#phone#</td>
                               
                            </tr>
                            </Cfloop>
                            </cfif>
                           </table>
                
                 </div>
                 <div class="rdbottom"></div> <!-- end bottom --> 
                
                 </div>
			<!--- ------------------------------------------------------------------------- ---->
            <!---- END Emolyment History---->
            <!--- ------------------------------------------------------------------------- ---->   
                </cfif>

  
  </cfif>
  </div>
  
    <!--- ------------------------------------------------------------------------- ---->
	<!---- Right Column---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
  <div style="width:49%;float:right;display:block;">
        
     <!----Start of Access Rights---->   
     
<cfif client.usertype lte 4>
		   <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Access Rights</span> 
                  <cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="userAccess")><a href="?curdoc=forms/setAccountRights&userid=#url.userid#"> <img src="pics/buttons/pencilBlue23x29.png" alt="Edit" height="8" border="0" class="floatRight"></a></cfif>
                  
            	</div> <!-- end top --> 
             <div class="rdbox">
             <table width=100%>
             	<tr>
              <cfloop query="availableRights">
                	<td valign="Center"><cfif listFind(userRights, fieldID)><img src="pics/valid.png" border=0 /><cfelse><img src="pics/invalid.png" border=0/></cfif> #description#</td>
              	<cfif (currentrow mod 3) eq 0>
                </tr>
                <tr>
                </cfif>
                </cfloop>
                <tr>
                	<Td colspan=4 align="center"><em><font color="##999999">users need to logout and  back in for their access to update.</font></em></Td>
                </tr>
                </table>
              
             
              <!----*****End Account Status****---->	
             		
             
                      
            </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----End Access Rights---->
            <!--- ------------------------------------------------------------------------- ---->   
        
        </cfif>
 <!----SMG Media Access---->
 <cfif client.userid eq 16718 or client.userid eq 1 or client.userid eq 20748>
         <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">SMG Media Access</span> 
                <cfif (client.userid eq 1 or client.userid eq 16718 or client.userid eq 20748)><a href="?curdoc=forms/setMediaRights&userid=#url.userid#"> <img src="pics/buttons/pencilBlue23x29.png" alt="Edit"border="0" class="floatRight"></a></cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
             	<table align="center" cellpadding=4 cellspacing = 0>
                	<Tr>
                    <Cfif smgMediaRights.recordcount eq 0>
                    <Td colspan=2>User has no rights to SMG Media Site. 
                     <cfif (client.userid eq 1 or client.userid eq 12312)><a href="?curdoc=forms/setMediaRights&userid=#url.userid#">Grant access by clicking here.</a></cfif>
                    </Td>
                    <cfelse>
                    <cfloop query="smgMediaRights">
                    	<Td colspan=2><img src="pics/smgLogos/#fk_companyid#.png" width=90%></Td>
                    </cfloop>
                    </Cfif>    
                     </tr>
                </table>
             
             
              <!----*****End SMG MEDIA ACCESS ****---->	
             		
             
                      
            </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
        
    </cfif>    
        
            
     <!-----Account Status---->

		   <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Account Status</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
             
              <!-----*******AccountStatus****------>
				<table width=100%>
                	<tr>
                    <td  width=230>
                    	<table>
                         	<tr>
                           		<td><strong>Status:</strong></td><td> <cfif active EQ 1>Active<cfelse>Inactive</cfif></td>
                           </tr>
                        	<tr>
                            	<td><strong>Login Enabled:</strong></td>
                                <td> 
									<cfif stUserPaperwork.isAccountCompliant>
                                		Yes
									<cfelse>
                                    	<a href="index.cfm?curdoc=user/index&action=paperworkDetails&userID=#URL.userID#">No</a>
									</cfif>
                                </td>
                           </tr>
                           
                           <cfif NOT listFind("8,11", uar_usertype)>
                               <tr>
                                    <td><strong>Paperwork Status:</strong></td>
                                    <td>
                                        <a href="index.cfm?curdoc=user/index&action=paperworkDetails&userID=#URL.userID#">
											<cfif stUserPaperwork.isAccountCompliant>
                                                Compliant
                                            <cfelse>
                                                Not Compliant
                                            </cfif>
                                        </a>
                                    </td>
                               </tr>
                           </cfif>
                               
                          </table>
     				</td>
                    <td width=230>
                        	<table>
                            	<tr>
                                	<td><strong>Last Login:</strong></td><td> #DateFormat(lastlogin, 'mm/dd/yyyy')# </td>
                                </tr>
                                <tr>
                                	<td><strong>Last Changed:</strong></td><td> #DateFormat(lastchange, 'mm/dd/yyyy')# </td>
                                </tr>
                                <tr>
                                	<td><strong>User Entered:</strong></td><td> #DateFormat(datecreated, 'mm/dd/yyyy')#</td>
                                </tr>
                                <cfif uar_usertype NEQ 8>
                                    <tr>
                                        <td><strong>Access Valid:</strong></td><td> #dateDiff('d','#now()#','2012-08-31')#  days</td>
                                    </tr>
                                </cfif> 
                             </table>   
                    </td>
                    <td>
                        <!------ UPDATE THIS MARCUS MELO --->
                        <cfif accountCreationVerified eq 0>
                        
							<cfif val(disableReasonid.id)>
                                Disabled: #dateFormat(disableReason.date, 'mm/dd/yyyy')# for:<br />
                                #disableReason.reason#<br />
                                <hr width=50% align="center" />
                            </cfif>
                        
							<cfif APPLICATION.CFC.USER.isOfficeUser()>	
                                <a href="tools/enableAccount.cfm?userID=#url.userID#" class="jQueryModal"><img src="pics/buttons/activate.png"border=0/></a>
                                
                                <cfif val(disableReasonid.id)><div align="right"><a href="javascript:displayDisableHistory();">
                                    <font color="##999999"><em>history</em></font></a> </div>  
								</cfif>
                            
							</cfif>
                        
                        <!--- Commenting out disabled button - 07/05/2012 - as per Brian Hause Request --->
                        <!---
						<cfelse>
                            
							<cfif APPLICATION.CFC.USER.isOfficeUser()>	
                                <a href="tools/disableAccount.cfm?userID=#url.userID#" class="jQueryModal"><img src="pics/buttons/disable.png" border=0/></a><br />
                                
                                <cfif val(disableReasonid.id)> <div align="right"><a href="javascript:displayDisableHistory();">
                                    <font color="##999999"><em>history</em></font></a></div>
                                </cfif>
                            </cfif>
                         --->   
						</cfif>
                    </td>                            
                  </tr>
                  <tr>
                  	<td align="right" colspan="3"></td>
                  </tr>
              </table>
              <div id="DisableHistory"  style="display:none;"  >
              				 <table width=100% align="Center">
                            <tr>
                                <th colspan=4 align="Center" class="historyTitle"><h3>History</h3></th>
                            </tr>
                            <tr>
                                <Th align="left" class="historyCol">Date</Th>
                                <th align="left" class="historyCol">User</th>
                               <th align="left" class="historyCol">Action</th>
                                <th align="left" class="historyCol">Reason</th>
                            </tr>
                            <cfloop query="accountDisableHistory">
                            
                            <tr <cfif currentrow mod 2>bgcolor="##cccccc"</cfif>>
                                <td class="historyItem">#DateFormat(date, 'mm/dd/yyyy')#</td>
                                <td class="historyItem">#firstName# #lastname#</td>
                                <td class="historyItem">#accountAction#</td>
                                <td class="historyItem">#reason#</td>
                            </tr>
                            </cfloop>
                            </table>
              </div> 
              <!----*****End Account Status****---->	
             		
             
                      
            </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----End Account Status---->
            <!--- ------------------------------------------------------------------------- ---->     
<cfif uar_usertype EQ 8>
			<!--- ------------------------------------------------------------------------- ---->
            <!----SEVIS AND INSURANCE FOR INT REP---->
            <!--- ------------------------------------------------------------------------- ---->   
   <div class="rdholder" style="width:100%;float:right;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Insurance & SEVIS Information</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td align="right"><b>Insurance :</b></td>
                        <td>
                            <cfif insurance_typeid EQ '0'>
                                <font color="FF0000">Insurance Type Information is Missing</font>
                            <cfelseif insurance_typeid EQ '1'>
                                #rep_info.type# insurance
                            <cfelse>
                                Takes #rep_info.type# insurance
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>SEVIS : </b></td>
                        <td>
                            <cfif accepts_sevis_fee EQ ''>
                                Missing SEVIS fee information
                            <cfelseif rep_info.accepts_sevis_fee EQ 0>
                                Does not accept SEVIS fee
                            <cfelse>
    
                                Accepts SEVIS fee.
                            </cfif>				
                        </td>
                    </tr>
                </table>
              </div>
                 <div class="rdbottom"></div> <!-- end bottom --> 
                
                 </div>
                 <!--- ------------------------------------------------------------------------- ---->
            <!----END SEVIS AND INSURANCE FOR INT REP---->
            <!--- ------------------------------------------------------------------------- ---->     
            
			<!--- ------------------------------------------------------------------------- ---->
            <!----Account Statement FOR INT REP---->
            <!--- ------------------------------------------------------------------------- ---->     
            <div class="rdholder" style="width:100%;float:right;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Account Activity - Statement</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                            <!--- HIDE STATEMENT FOR OFFICE USERS AND LITZ, EXPERIMENTO, AND ECSE AGENTS --->
                            <cfquery name="invoice_check" datasource="#APPLICATION.DSN#">
                                select invoice_access 
                                from smg_users
                                where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                            </cfquery>
                            <cfif (CLIENT.userID EQ 64 OR CLIENT.userID EQ 126 OR CLIENT.userID EQ 21517) OR (CLIENT.usertype NEQ 8 AND invoice_check.invoice_access NEQ 1)> 
                                <cfswitch expression="#CLIENT.companyid#">
                                	<cfcase value="14">
                                    	Not available. <br /> If you wish a copy of your statement please contact Stacy Brewer at stacy@exchange-service.org
                                    </cfcase>
                                    <cfdefaultcase>
                                    	Not available. <br /> If you wish a copy of your statement please contact Jennifer Dilig at jennifer@iseusa.org
                                    </cfdefaultcase>
                                </cfswitch>
                            <cfelse>
                                Detailed Statement : <a href="index.cfm?curdoc=intrep/invoice/statement_detailed" class="smlink" target="_top">View Statement</a><br />
                            </cfif>
                        </td>
                    </tr>
                </table>
                 </div>
                 <div class="rdbottom"></div> 
                
                 </div>
            	<!--- ------------------------------------------------------------------------- ---->
            <!----END Account Statement FOR INT REP---->
            <!--- ------------------------------------------------------------------------- ---->  
            
<cfelse>
            <!--- ------------------------------------------------------------------------- ---->
            <!----Trainging---->
            <!--- ------------------------------------------------------------------------- ---->     
          
                <!---- Training Information ---->
                
             <div class="rdholder" style="width:100%;float:right;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Training</span> 
                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                <a href="javascript:displayTrainingForm();"><img src="pics/buttons/pencilBlue23x29.png" border="0" alt="Edit" class="floatRight"></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
              
                
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <!--- New Training --->
                    <tr>
                        <td colspan="3" style="line-height:20px;" valign="top">
                            <div id="webExForm" <cfif NOT LEN(FORM.errors)> style="display:none;" </cfif> >
                                <form name="webEx" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
                                    <input type="hidden" name="submitted" value="1" />
                                    
                                    <cfif LEN(FORM.errors)>
                                        Please review the following: <br />
                                        <div style="color:##F00">
                                            #FORM.errors#
                                        </div>
                                    </cfif>
                                                                        
                                    <table width="100%">
                                        <tr>
                                            <td><label for="dateTrained">Date Trained:</label></td>
                                            <td><input type="text" name="dateTrained" value="#DateFormat(FORM.dateTrained, 'mm/dd/yyyy')#" id="dateTrained" class="datePicker" maxlength="10" />  (mm/dd/yyyy)</td>
                                        </tr>
                                        <tr>
                                            <td valign="top"><label for="trainingID">Training:</label></td>
                                            <td>
                                            	<select name="trainingID" id="trainingID" onchange="displayTrainingScore();">
                                                    <option value=""></option>
                                                    <cfloop query="qGetTrainingOptions">
                                                    	<option value="#qGetTrainingOptions.fieldID#" <cfif qGetTrainingOptions.fieldID EQ FORM.trainingID>selected="selected"</cfif> >#qGetTrainingOptions.name#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="trainingScore" class="displayNone">
                                            <td valign="top"><label for="score">Score %:</label></td>
                                            <td>
                                            	<input type="text" name="score" id="score" value="#FORM.score#" maxlength="5" size="4" />
                                                Eg: 93.70
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td><input name="Submit" type="image" src="pics/submit.gif" border=0 alt="submit"></td>
                                        </tr>
                                    </table>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <!--- Display Records --->
                    <tr>
                        <td><strong>Date Trained</strong></td>
                        <td><strong>Training</strong></td>
                        <td><strong>Score %</strong></td>
                        <td><strong>Added By</strong></td>       
                        <td><strong>Date Recorded</strong></td>                            
                    </tr>                        
                    <cfloop query="qGetTraining">
                        <tr>
                            <td>#DateFormat(qGetTraining.date_trained, 'mm/dd/yyyy')#</td>
                            <td>#qGetTraining.trainingName#</td>
                            <td>
                            	<cfif qGetTraining.score GT 0>
                                    #qGetTraining.score#%
                                    <cfif VAL(qGetTraining.has_passed)>
                                    	- <font color="##006600">Pass</font>
                                    <cfelse>
                                    	- <font color="##990000">Fail</font>
                                    </cfif>
                                <cfelse>
                                	n/a
                                </cfif>
                            </td>
                            <td>
                            	<cfif LEN(officeUser)>
                                	#officeUser#
                                <cfelse>
                                	n/a
                                </cfif>                                
                            </td>  
                            <td>#DateFormat(qGetTraining.date_created, 'mm/dd/yyyy')#</td>
                        </tr>                        
                    </cfloop> 
                    <cfif NOT VAL(qGetTraining.recordCount)>
                        <tr>
                            <td colspan="4">No training records.</td>
                        </tr>                               
                    </cfif>                      
                </table>
                
           <!----footer of  training   table---->
                   </div>
                 <div class="rdbottom"></div> <!-- end bottom --> 
                
                 </div>
 			<!--- ------------------------------------------------------------------------- ---->
            <!----END Trainging---->
            <!--- ------------------------------------------------------------------------- ---->  

<!--- international representative
<cfif uar_usertype EQ 8>

	<!--- SIZING TABLE --->
    <table width="100%" border="0" >
        <tr>
            <td width="50%" valign="top">
                <!---- LOGO MANAGEMENT ---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><cfif rep_info.logo is ''><img src="pics/logos/exits.jpg" height=16><Cfelse><img src="pics/logos/#rep_info.logo#" height=16></cfif></td>
                        <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Logo Management</h2></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding="4" cellspacing="0" border="0" class="section">
                    <tr>
                        <td>
                            You can set what logo appears in the upper right hand corner for you, branch offices and your students.<br>
                            <cfform action="querys/upload_logo.cfm"  method="post" enctype="multipart/form-data" preloader="no">
                                <cfinput type="hidden" name="userID" value="#rep_info.userID#">
                                <cfinput type="file" name="UploadFile" size=35 required="yes" message="Please specify a file." validateat="onsubmit,onserver"> 
                                <cfinput type="submit" name="upload" value="Upload Picture">
                            </cfform>
                            <i>logo should be 71 pixels in height</i>
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr valign="bottom">
                        <td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
                        <td width="100%" background="pics/header_background_footer.gif"></td>
                        <td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
                    </tr>
                </table>
                <br />
                <!---- NOTES ---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/notes.gif"></td>
                        <td background="pics/header_background.gif"><h2>Notes</h2></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding="4" cellspacing="0" border="0" class="section">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                            <cfif comments EQ ''>No additional information available.<cfelse>#comments#</cfif><br><br>
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr valign="bottom">
                        <td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
                        <td width="100%" background="pics/header_background_footer.gif"></td>
                        <td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
                    </tr>
                </table>
            </td>
            <td width="1%">&nbsp;</td>
            <td width="49%" valign="top">
                <!---- SEVIS AND INSURANCE INFORMATION ---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/insurance_scroll.gif"></td>
                        <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Insurance & SEVIS Information</h2></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding="4" cellspacing="0" border="0" class="section">
                    <tr>
                        <td align="right"><b>Insurance :</b></td>
                        <td>
                            <cfif insurance_typeid EQ '0'>
                                <font color="FF0000">Insurance Type Information is Missing</font>
                            <cfelseif insurance_typeid EQ '1'>
                                #rep_info.type# insurance
                            <cfelse>
                                Takes #rep_info.type# insurance
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>SEVIS : </b></td>
                        <td>
                            <cfif accepts_sevis_fee EQ ''>
                                Missing SEVIS fee information
                            <cfelseif rep_info.accepts_sevis_fee EQ 0>
                                Does not accept SEVIS fee
                            <cfelse>
    
                                Accepts SEVIS fee.
                            </cfif>				
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr valign="bottom">
                        <td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
                        <td width="100%" background="pics/header_background_footer.gif"></td>
                        <td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
                    </tr>
                </table>
                <br>
                <!--- STATEMENT --->		
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
                        <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Account Activity - Statement</td>
                        <td background="pics/header_background.gif" width="16"></a></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding="4" cellspacing="0" border="0" class="section">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                            <!--- HIDE STATEMENT FOR OFFICE USERS AND LITZ AND ECSE AGENTS --->
                            <cfquery name="invoice_check" datasource="#APPLICATION.DSN#">
                                select invoice_access 
                                from smg_users
                                where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                            </cfquery>
                            <cfif (CLIENT.userID EQ 64 OR CLIENT.userID EQ 126) OR (CLIENT.usertype NEQ 8 AND invoice_check.invoice_access NEQ 1)> 
                                Not available. <br /> If you wish a copy of your statement please contact Jennifer Dilig at jennifer@iseusa.org
                            <cfelse>
                                SMG Detailed Statement : <a href="index.cfm?curdoc=intrep/invoice/statement_detailed" class="smlink" target="_top">View Statement</a><br />
                            </cfif>
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr valign="bottom">
                        <td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
                        <td width="100%" background="pics/header_background_footer.gif"></td>
                        <td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

	<!--- ------------------------------------------------------------------------- ---->
            <!----END Int. Rep---->
            <!--- ------------------------------------------------------------------------- ---->   


<!--- NON-INTERNATIONAL REPRESENTATIVE --->
<cfelse>
--->
 
          

		<!--- ------------------------------------------------------------------------- ---->
            <!----Family Members---->
            <!--- ------------------------------------------------------------------------- ---->   
             
             <div class="rdholder" style="width:100%;float:right;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Other Family Members</span> 
                <!--- DOS Usertype does not have access to edit information --->
				<cfif CLIENT.userType NEQ 27>
	                <a href="?curdoc=forms/edit_family_members&userID=#rep_info.userID#"><img src="pics/buttons/pencilBlue23x29.png" border="0" alt="Edit" class="floatRight"></a>
    			</cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">
                
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                        <Cfquery name="family_members" datasource="#APPLICATION.DSN#">
                            select id, firstname, lastname, dob, relationship, no_members, auth_received, auth_received_type
                            from smg_user_family
                            where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                        </Cfquery>
                        <table width="100%" border="0">
                            <tr>
                                <td><strong>Name</strong></td>
                                <td><strong>Age</strong></td>
                                <td><strong>Relationship</strong></td>
                                <td><strong>CBC</strong></td>
                            </tr>
                            <cfif family_members.recordcount eq 0>
                                <tr><td colspan="4">No other household residents on file for this user.</td></tr>
                            </cfif>
                            
                            <cfloop query="family_members">
                                <tr>
                                    <td>#firstname# #lastname#</td>
                                    <td><cfif isDate(dob)>#DateDiff('yyyy', dob, now() )# yrs.<cfelse>n/a</cfif></td>
                                    <td>#relationship#</td>
                                    <td>
                                        <cfif isDate(dob) AND DateDiff('yyyy', dob, now() ) LTE 17>
                                            N/A
                                        <cfelse>
                                            <cfif auth_received eq 0>
                                                <a href="forms/cbc_auth_fam.cfm?id=#rep_info.uniqueid#&userID=#rep_info.userID#">Get</a>
                                                <a href="index.cfm?curdoc=forms/upload_cbc_fam&userID=#rep_info.userID#&familyID=#family_members.id#">Upload</a>
                                            <cfelse>
                                                <a href="uploadedFiles/xml_files/gis/#rep_info.userID#_#family_members.id#.#family_members.auth_received_type#">Received</a>
                                            </cfif>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfloop>	
                        </table>
                    </td>
                </tr>
                </table>
               <!----footer of  payment  table---->
                   </div>
                 <div class="rdbottom"></div> <!-- end bottom --> 
                
                 </div>

		    <!--- ------------------------------------------------------------------------- ---->
            <!----END Family Members---->
            <!--- ------------------------------------------------------------------------- ---->  

			<!--- ------------------------------------------------------------------------- ---->
            <!----Student History---->
            <!--- ------------------------------------------------------------------------- ---->  
           
             <div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Student Information</span> 
            	</div> <!-- end top --> 
             <div class="rdbox">
                <!----****student info****---->
                 <table width="100%" cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                       
                            <!----Query for placed students---->
                            <cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
                                SELECT 
                                	CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentDisplayName,
                                    s.sex, 
                                    smg_countrylist.countryname, 
                                    p.programname
                                FROM 
                                	smg_students s 
                                LEFT OUTER JOIN 
                                	smg_countrylist ON s.countryresident = smg_countrylist.countryid 
                                INNER JOIN 
                                	smg_users ON s.intrep = smg_users.userID
                                INNER JOIN 
                                	smg_programs p ON p.programid = s.programid
                                WHERE 
                                	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                                AND 
						        	s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
								<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                                    AND
                                        s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                                <cfelse>
                                    AND
                                        s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                                </cfif>
                                ORDER BY
                                	p.startDate DESC
                            </cfquery>
                            
                            <!----Query for supervised students---->
                            <cfquery name="qGetSupervisedStudents" datasource="#APPLICATION.DSN#">
                                SELECT 
                                	CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentDisplayName,
                                    s.sex, 
                                    smg_countrylist.countryname, 
                                    p.programname
                                 FROM 
                                 	smg_students s
                                 LEFT OUTER JOIN 
                                 	smg_countrylist ON s.countryresident = smg_countrylist.countryid 
                                 INNER JOIN 
                                 	smg_users ON s.intrep = smg_users.userID
                                 INNER JOIN 
                                 	smg_programs p ON p.programid = s.programid
                                 WHERE 
                                 	s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                                 AND 
						        	s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">								 
								<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                                    AND
                                        s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                                <cfelse>
                                    AND
                                        s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                                </cfif>
                                ORDER BY
                                	p.startDate DESC
                            </cfquery>	
                            
                            <!----Query for 2nd visit students---->
                            <cfquery name="qGet2ndVisitStudents" datasource="#APPLICATION.DSN#">
                                SELECT 
                                	CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentDisplayName,
                                    s.sex, 
                                    smg_countrylist.countryname, 
                                    p.programname
                                FROM 
                                	smg_students s 
                                LEFT OUTER JOIN 
                                	smg_countrylist ON s.countryresident = smg_countrylist.countryid 
                                INNER JOIN 
                                	smg_users ON s.secondvisitrepid = smg_users.userID
                                INNER JOIN 
                                	smg_programs p ON p.programid = s.programid
                                WHERE 
                                	s.secondvisitrepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
								<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                                    AND
                                        s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                                <cfelse>
                                    AND
                                        s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                                </cfif>
                                ORDER BY
                                	p.startDate DESC
                            </cfquery>
                            			
                            <style type="text/css">
                            <!--
                            div.scroll1 {
                                height: 120px;
                                
                                overflow: auto;
                            }
                            -->
                            </style>
                          
                           			<!-----Kids Placed---->
                                   
                                    <cfif qGetPlacedStudents.recordcount gt 2><div class="scroll1"></cfif>
                                    <!----scrolling table with placed information---->
                                    <table border="0" width="100%" cellpadding="2" cellspacing="0">
                                    	<tr  bgcolor="##0b5886">
                                        	<th colspan=4><font color="white">Placed (#qGetPlacedStudents.recordcount#)</font></th>
                                        </tr>
                                        <cfif qGetPlacedStudents.recordcount EQ 0>
                                            <tr><td colspan="6" align="left">Rep has not placed any students</td></tr>
                                        <cfelse>
                                        <tr>
                                            <Th align="left">First Last (ID)</Th><th align="left">Gender</th><th align="left">Country</th><th align="left">Program</th>
                                        </tr>
                                        </cfif>
                                        <cfloop query="qGetPlacedStudents">
                                        <tr bgcolor="#iif(qGetPlacedStudents.currentrow MOD 2 ,DE("efefef") ,DE("ffffff") )#">		
                                            <td align="left">#qGetPlacedStudents.studentDisplayName#</td>
                                            <td align="left">#qGetPlacedStudents.sex#</td>
                                            <td  align="left">#Left(qGetPlacedStudents.countryname,13)#</td>
                                            <td align="left"><u>#qGetPlacedStudents.programname#</u></td>
                                        </tr>
                                        </cfloop>
                                    </table>
                            
                            <cfif qGetPlacedStudents.recordcount gt 2></div></cfif><br>
                            
                            <cfif qGetSupervisedStudents.recordcount gt 2><div class="scroll1"></cfif>
                            <!----scrolling table with supervised information---->
                            <table width="100%" border="0" cellpadding="2" cellspacing="0">
                            	<tr bgcolor="##0b5886">
                                    <th colspan=4><font color="white">Supervising (#qGetSupervisedStudents.recordcount#)</font></th>
                                </tr>
                                <cfif qGetSupervisedStudents.recordcount eq 0>
                                    <tr><td colspan="6" align="left">Rep is not supervising any students</td></tr>
                                 <cfelse>
                                <tr>
                                   <Th align="left">First Last (ID)</Th><th align="left">Gender</th><th align="left">Country</th><th align="left">Program</th>
                                 </tr>
                                 </cfif>
                                <cfloop query="qGetSupervisedStudents">
                                	<tr bgcolor="#iif(qGetSupervisedStudents.currentrow MOD 2 ,DE("efefef") ,DE("ffffff") )#">		
                                        <td align="left">#qGetSupervisedStudents.studentDisplayName#</td>
                                        <td align="left">#qGetSupervisedStudents.sex#</td>
                                        <td  align="left">#Left(qGetSupervisedStudents.countryname,13)#</td>
                                        <td align="left"><u>#qGetSupervisedStudents.programname#</u></td>
                                    </tr>
                                </cfloop>
                            </table>
                            
                                 
                            <cfif qGetSupervisedStudents.recordcount gt 2></div></cfif>
                            <!----Second Visit Students---->
                             <br />
                            <cfif qGet2ndVisitStudents.recordcount gt 2><div class="scroll1"></cfif>
                            <!----scrolling table with secondvisit information---->
                            <table border="0" width="100%" cellpadding="4" cellspacing="0">
                              	<tr  bgcolor="##0b5886">
                                    <th colspan=4><font color="white">Second Visit Students: (#qGet2ndVisitStudents.recordcount#)</font></th>
                                </tr>
                                <cfif qGet2ndVisitStudents.recordcount EQ 0>
                                    <tr><td colspan="6" align="left">Rep is not a 2nd Visit rep for any students.</td></tr>
                                <cfelse>
                                    <tr>
                                        <Th align="left">First Last (ID)</Th><th align="left">Gender</th><th align="left">Country</th><th align="left">Program</th>
                                    </tr>
                                </cfif>
                                <cfloop query="qGet2ndVisitStudents">
                                    <tr bgcolor="#iif(qGet2ndVisitStudents.currentrow MOD 2 ,DE("efefef") ,DE("ffffff") )#">		
                                        <td align="left">#qGet2ndVisitStudents.studentDisplayName#</td>
                                        <td align="left">#qGet2ndVisitStudents.sex#</td>
                                        <td  align="left">#Left(qGet2ndVisitStudents.countryname,13)#</td>
                                        <td align="left"><u>#qGet2ndVisitStudents.programname#</u></td>
                                     </tr>
                                </cfloop>
                            </table>
                            
                        </td>
                    </tr>
                </table>
                
                <!----****end student info---->
              
                <!----footer of  student table---->
                </div>
                <div class="rdbottom"></div> <!-- end bottom --> 
                </div>

 			<!--- ------------------------------------------------------------------------- ---->
            <!----END Student History---->
            <!--- ------------------------------------------------------------------------- ---->  

          	
			<!--- ------------------------------------------------------------------------- ---->
            <!----References---->
            <!--- ------------------------------------------------------------------------- ---->         
            <div class="rdholder"  style="width:100%;float:right;" > 
            
                <div class="rdtop"> 
                	<span class="rdtitle">References</span> 
                    
					<!--- DOS Usertype does not have access to edit information --->
                    <cfif CLIENT.userType NEQ 27>
                        <a href="user/index.cfm?action=reference&userID=#rep_info.userID#" class="jQueryModal"><img src="pics/buttons/pencilBlue23x29.png" border="0" alt="Edit" class="floatRight"></a>
                    </cfif>
                    
                </div> <!-- end top --> 
                
                <div class="rdbox">    
                    <table width="100%" cellpadding="4" cellspacing="0">
                        <tr>
                        	<td colspan="5"><strong>Season: #qGetCurrentSeason.season#</strong></td>
                        </tr>
                        <tr bgcolor="##CCCCCC">
                        	<td>Name</td>
                        	<td align="center">Phone</td>                                
                        	<td align="center">Status</td>
                        	<cfif listFind("1,2,3,4,5,6", CLIENT.userType) AND CLIENT.userID NEQ userID>
                        		<td align="center">Report</td>
                        	</cfif>
                        	<!--- DOS Usertype does not have access to edit information --->
                        	<cfif CLIENT.userType NEQ 27 OR APPLICATION.CFC.USER.isOfficeUser() OR CLIENT.userID EQ rep_info.userID>
                        		<td align="center">Actions</td> 
                        	</cfif>
                        </tr>
                        
                        <cfif NOT VAL(qGetReferences.recordcount)>   	
                            <tr>
                                <td colspan="4">No references on file.</td>
                            </tr>
                        </cfif>
                        
                        <Cfloop query="qGetReferences">
                            
                            <Cfquery name="getReferenceReportBySeason" datasource="#APPLICATION.DSN#">
                            	SELECT 
                                	*
                            	FROM 
                            		smg_users_references_tracking
                            	WHERE 
                                	fk_ReferencesID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetReferences.refid)#"> 
                                AND
                                	seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#">
                            </Cfquery>
                            
                            <tr <cfif qGetReferences.currentrow mod 2>bgcolor=##efefef</cfif>>
                                <td><strong>#firstname# #lastname#</strong> - <em>#relationship# (#howlong#)</em></td>
                                <td align="Center">#phone#</td>
                                <td align="Center">
                                    <cfif getReferenceReportBySeason.recordcount>
									
										<cfif qGetReferences.approved eq 0>
                                            Waiting
                                        <Cfelseif qGetReferences.approved eq 1>
                                            Pending
                                        <Cfelseif qGetReferences.approved eq 2>
                                            Approved
                                        <Cfelseif qGetReferences.approved eq 3>
                                            Rejected
                                        </cfif>
									
                                    <cfelse>
                                    	Pending
                                    </cfif>                                                                         
                                </td>
                                <cfif listFind("1,2,3,4,5,6", CLIENT.userType) AND CLIENT.userID NEQ userID> 
                                    <td align="Center">
                                        <cfif getReferenceReportBySeason.recordcount>
                                            <a href="javascript:openPopUp('forms/viewRefrencesQuestionaire.cfm?reportid=#getReferenceReportBySeason.id#', 640, 800);">View Report</a>
                                        <cfelse>
                                            <a href="javascript:openPopUp('forms/refrencesQuestionaire.cfm?ref=#refid#&rep=#userID#', 680, 800);">Submit Report
                                        </cfif>
                                    </td>
                                </cfif>
                                <!--- DOS Usertype does not have access to edit information --->
                                <cfif CLIENT.userType NEQ 27 OR APPLICATION.CFC.USER.isOfficeUser() OR CLIENT.userID EQ rep_info.userID>
                                    <td align="center">
                                        [
                                        <a href="user/index.cfm?action=reference&refID=#qGetReferences.refID#&userID=#qGetReferences.referenceFor#" class="jQueryModal">Edit</a> 
                                        |
                                        <a href="index.cfm?curdoc=user/index&action=welcome&subAction=deleteReference&refID=#qGetReferences.refID#&userID=#qGetReferences.referenceFor#" onClick="return confirm('Are you sure you want to delete this reference?')">Delete</a>
										]
                                    </td>
                                </cfif> 
                            </tr>
                            <tr <cfif qGetReferences.currentrow mod 2>bgcolor=##efefef</cfif>>
                            	<td colspan="5">#qGetReferences.address# #qGetReferences.address2# #qGetReferences.city# #qGetReferences.state#, #qGetReferences.zip#</td>
                            </tr>
                        </Cfloop>
                    </table>
                </div>
                
                <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----End References---->
            <!--- ------------------------------------------------------------------------- ---->                  
            			

</cfif>
		
</cfoutput>