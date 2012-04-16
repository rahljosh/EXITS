<!--- ------------------------------------------------------------------------- ----
	
	File:		user_info.cfm
	Author:		Marcus Melo
	Date:		March 18, 2010
	Desc:		User Information Page

	Updated:	03/18/2010 - Address change email is sent to RM, Facilitator and Thea. 	

----- ------------------------------------------------------------------------- --->

<!--- CHECK RIGHTS --->
<cfinclude template="check_rights.cfm">

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
		// Get Training Options
		qGetTrainingOptions = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(applicationID=7,fieldKey='smgUsersTraining');
	
		// Get Training records for this user
		qGetTraining = APPLICATION.CFC.USER.getTraining(userID=URL.userid);
		  
    	//Check if paperwork is complete for season
		CheckPaperwork = APPLICATION.CFC.udf.paperworkCompleted(userid=URL.userid,season=9);
		
         //Check if paperwork is complete for season
		get_paperwork = APPLICATION.CFC.udf.allpaperworkCompleted(userid=url.userid,seasonid=9);
	</cfscript>

	<!----Rep Info---->
    <cfquery name="rep_info" datasource="#APPLICATION.DSN#">
        SELECT 
        	smg_users.*, 
            smg_countrylist.countryname, 
            smg_insurance_type.type
        FROM 
        	smg_users
        LEFT JOIN 
        	smg_countrylist ON smg_users.country = smg_countrylist.countryid
        LEFT JOIN 
        	smg_insurance_type ON smg_users.insurance_typeid = smg_insurance_type.insutypeid
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
    </cfquery>
    
    <!--- Check if logged in user has access to compliance --->
    <cfquery name="user_compliance" datasource="#APPLICATION.DSN#">
        SELECT 
        	userid, 
            compliance
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfquery>

    <cfquery name="qreferences" datasource="MySQL">
        SELECT 
        	*
        FROM
        	smg_user_references
        WHERE
        	referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
    </cfquery>	

    <!--- get the access level of the user viewed.
    If null, then user viewing won't have access to username, etc. --->
    <cfinvoke component="nsmg.cfc.user" method="get_access_level" returnvariable="uar_usertype">
        <cfinvokeargument name="userid" value="#rep_info.userid#">
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
                	user_access_rights.id
                FROM 
                	user_access_rights
                INNER JOIN 
                	smg_companies ON user_access_rights.companyid = smg_companies.companyid
                WHERE 
                	smg_companies.website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.company_submitting#">
                AND 
                	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
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
                	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
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
                <cfinvokeargument name="userid" value="#URL.userid#">
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
                	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            </cfquery>
            
			<cfset temp = DeleteClientVariable("verify_info")>
            <cflocation url="index.cfm?curdoc=initial_welcome" addtoken="no">
            
        </cfcase>
        
    </cfswitch>

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
                    officeUserID=VAL(CLIENT.userID), 
                    trainingID=FORM.trainingID,
                    dateTrained=FORM.dateTrained,
                    score=FORM.score					
                );
            
                // Re-set Form Variables
                FORM.dateTrained = '';
                FORM.trainingID = 0;
                FORM.score = '';
                // Get updated query
                qGetTraining = APPLICATION.CFC.USER.getTraining(userID=URL.userid);
            }
        }
    </cfscript>

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
</style>

<script type="text/javascript" language="javascript">
	// JQuery Ready Function
	$().ready(function() {
		// Get Selected Training
		displayTrainingScore();
	});
	
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
	function displayReferenceForm() {
		if($("#referenceForm").css("display") == "none"){
			$("#referenceForm").slideDown("slow");
		} else {
			$("#referenceForm").slideUp("slow");	
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
	displayExperienceForm
</script>

<!--- user has no access records - force entry of one. --->
<cfif uar_usertype EQ 0>
	<!--- if viewing own profile and not office users abort with message. --->
	<cfif CLIENT.userid eq rep_info.userid and not CLIENT.usertype LTE 4>
        You have no Program Manager & Regional Access record assigned.<br />
        One must be assigned first before access to your information is allowed.<br />
    	Contact your facilitator to add the record.
        <cfabort>
    <cfelse>
		<cflocation url="index.cfm?curdoc=forms/access_rights_form&userid=#rep_info.userid#&force=1" addtoken="no">
    </cfif>
</cfif>

<cfoutput query="rep_info">

<cfif not val(accountCreationVerified) AND uar_usertype NEQ 8>

	<cfif get_paperwork.reviewAcct eq 1>
        <div class="alert">
        <h1>Account Review Required - Account appears ready for manual reveiw. </h1>
        <em>Please review references and run CBC.  When everything looks fine, approve the CBC through Paperwork menu to activate account.</em> </div>
        <br />
    <cfelseif get_paperwork.areaRepOK eq 0 or get_paperwork.arearepOk is ''>
        <div class="alert">
        <h1>Account Not Active </h1>
        <em>Please review items missing in the paperwork section.</em> </div>
        <br />
    </cfif>
    
</cfif>

<!--- SIZING TABLE --->
<table border="0" width="100%">
	<tr>
		<td>
			<!--- INFORMATION --->
			<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
				<tr valign="middle" height="24">
					<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
					<td width="26" background="pics/header_background.gif"><img src="pics/user.gif"></td>
					<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;</h2></td>
					<td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
				<tr>
					<td style="line-height:20px;" valign="top">
						<cfif isDefined("CLIENT.verify_info")>
                            <font size="4" color="##FF0000"><b>
                            Please verify that your Personal Information is correct, if not, please click on edit (<img src="pics/edit.png">) and update your information.<br>
                            You must click below to verify your information before you may proceed.<br />
                            </b></font>
                            <a href="index.cfm?curdoc=user_info&action=verify_info&userid=#rep_info.userid#"><img src="pics/verify_account_info.jpg" width="144" height="112" border="0"></a>
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
</table><br>

<!--- SIZING TABLE --->
<table border="0" width="100%">
	<tr>
		<td>
			<!----Personal Information---->
		  <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" >
				<tr valign="middle" height="24">
					<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
					<td width="26" background="pics/header_background.gif"><img src="pics/user.gif"></td>
					<td background="pics/header_background.gif"><h2>Personal Information</h2></td>
					<cfif CLIENT.userType NEQ 27>
                    	<td background="pics/header_background.gif" width="16"><a href="index.cfm?curdoc=forms/user_form&userid=#rep_info.userid#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>
					</cfif>
                    <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
				<tr valign="top">
					<td>
						<table width=245 cellpadding="0" cellspacing="0" border="0" bgcolor="##ffffff" align="left">
							<tr valign=top>
								<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_topleft.gif" height=6 width=6></td>
								<td width=201 style="line-height:1px; font-size:2px; border-top: 1px solid ##557aa7;">&nbsp;</td>
								<td width=6><img src="pics/address_topright.gif" height=6 width=6></td>
							</tr>
							<tr>
								<td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
								<td width=226 style="padding:5px;">
                                	<!--- international user --->
                                	<cfif uar_usertype EQ 8>
                                    	<strong>Personal Information:</strong><br />
                                    	#businessname#<br>
                                    </cfif>
									#firstname# #middlename# #lastname# - #userid#<br>
									#address#<br>
									<cfif address2 NEQ ''>#address2#<br></cfif>
									#city# #state#, #zip# #countryname#<br>
									<cfif phone NEQ ''>Home: #phone#<br></cfif>
									<cfif work_phone NEQ ''>Work: #work_phone#<br></cfif>
									<cfif cell_phone NEQ ''>Cell: #cell_phone#<br></cfif>
									<cfif fax NEQ ''>Fax: #fax#<br></cfif>
									<cfif email NEQ ''>Email: <a href="mailto:#email#">#email#</a><br></cfif>
									<cfif email2 NEQ ''>Alt. Email: <a href="mailto:#email2#">#email2#</a><br></cfif>
									<cfif skype_id NEQ ''>Skype ID: #skype_id#<br></cfif>
								</td>
								<td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
							</tr>
							<tr valign="bottom">
								<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_bottomleft.gif" height=6 width=6></td>
								<td width=201 style="line-height:1px; font-size:2px; border-bottom: 1px solid ##557aa7;">&nbsp;</td>
								<td width=6><img src="pics/address_bottomright.gif" height=6 width=6></td>
							</tr>
						</table> 
					</td>
				<!--- international user --->
                <cfif uar_usertype EQ 8>
					<td>
						<table width=245 cellpadding="0" cellspacing="0" border="0" bgcolor="##ffffff" align="left">
							<tr valign=top>
								<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_topleft.gif" height=6 width=6></td>
								<td width=201 style="line-height:1px; font-size:2px; border-top: 1px solid ##557aa7;">&nbsp;</td>
								<td width=6><img src="pics/address_topright.gif" height=6 width=6></td>
							</tr>
							<tr>
								<td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
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
								<td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
							</tr>
							<tr valign="bottom">
								<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_bottomleft.gif" height=6 width=6></td>
								<td width=201 style="line-height:1px; font-size:2px; border-bottom: 1px solid ##557aa7;">&nbsp;</td>
								<td width=6><img src="pics/address_bottomright.gif" height=6 width=6></td>
							</tr>
						</table> 
					</td>
                </cfif>
					<td>
                        <strong>Last Login:</strong>&nbsp;&nbsp; #DateFormat(lastlogin, 'mm/dd/yyyy')#<br>
                        <strong>User Entered:</strong>&nbsp;&nbsp; #DateFormat(datecreated, 'mm/dd/yyyy')#<br>
                        <strong>Last Changed:</strong>&nbsp;&nbsp; #DateFormat(lastchange, 'mm/dd/yyyy')# #timeFormat(lastchange)#<br>
                        <strong>Status:</strong>&nbsp;&nbsp; <cfif active EQ 1>Active<cfelse>Inactive</cfif><br>
                        <strong>Login Fully Enabled:</strong>&nbsp;&nbsp; <Cfif accountCreationVerified is '' or  accountCreationVerified eq 0><a href="index.cfm?curdoc=forms/user_paperwork&userid=#url.userid#"> No</a><Cfelse>Yes</Cfif><Br />
                        
                        <cfif CLIENT.userType EQ 1>
                            <strong>Username:</strong>&nbsp;&nbsp;#username#<br>
                            <strong>Password:</strong>&nbsp;&nbsp;#password#<br>
                        <cfelseif CLIENT.usertype LT uar_usertype> <!--- CLIENT.usertype LTE 4 OR - protect passwords --->
                            <strong>Username:</strong>&nbsp;&nbsp;#username#<br>
                            <strong>Password:</strong>&nbsp;&nbsp;#password#<br>
                      </cfif>
                      
                        <!--- change password: if viewing own profile. --->
                        <cfif CLIENT.userid EQ rep_info.userid>
                            <a href="index.cfm?curdoc=forms/change_password">Change Password</a><br>
                        </cfif>
                        
						<cfif CLIENT.usertype LTE 4 AND rep_info.changepass eq 1>
							<i>User will be required to change password on next log in.</i><br />
						</cfif>
                        
                        <cfif CLIENT.usertype LTE 6>
                            <a href="index.cfm?curdoc=history&userid=#rep_info.userid#">view history</a><br>
                        </cfif>
                        
                        <cfif CLIENT.userType NEQ 27>
	                        <a href="index.cfm?curdoc=user_info&action=resend_login&userid=#rep_info.userid#"><img src="pics/email.gif" border="0" align="left"> Resend Login Info Email</a>
    					</cfif>
                        
                        <cfif URL.action EQ 'resend_login'><font color="red"> - Sent</font></cfif>
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
</table><br>

<!--- international representative --->
<cfif uar_usertype EQ 8>

	<!--- SIZING TABLE --->
    <table width="100%" border="0" >
        <tr>
            <td width="50%" valign="top">
                <!---- LOGO MANAGEMENT ---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><cfif rep_info.logo is ''><img src="pics/logos/smg_clear.gif" height=16><Cfelse><img src="pics/logos/#rep_info.logo#" height=16></cfif></td>
                        <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Logo Management</h2></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding="4" cellspacing="0" border="0" class="section">
                    <tr>
                        <td>
                            You can set what logo appears in the upper right hand corner for you, branch offices and your students.<br>
                            <cfform action="querys/upload_logo.cfm"  method="post" enctype="multipart/form-data" preloader="no">
                                <cfinput type="hidden" name="userid" value="#rep_info.userid#">
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
                                where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                            </cfquery>
                            <cfif (CLIENT.userid EQ 64 OR CLIENT.userid EQ 126) OR (CLIENT.usertype NEQ 8 AND invoice_check.invoice_access NEQ 1)> 
                                <cfswitch expression="#client.companyid#">
                                	<cfcase value="14">
                                    	Not available. <br /> If you wish a copy of your statement please contact Stacy Brewer at stacy@exchange-service.org
                                    </cfcase>
                                    <cfdefaultcase>
                                    	Not available. <br /> If you wish a copy of your statement please contact Marcel Maebara at marcel@student-management.com
                                    </cfdefaultcase>
                                </cfswitch>
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

<!--- NON-INTERNATIONAL REPRESENTATIVE --->
<cfelse>
 <!----Regional Information---->
                            <cfquery name="region_company_access" datasource="#APPLICATION.DSN#">
                                SELECT uar.id, uar.regionid, uar.usertype, uar.changedate, uar.default_access, r.regionname, c.companyshort, c.companyID, ut.usertype AS usertypename,
                                    adv.userid AS advisorid, adv.firstname, adv.lastname
                                FROM user_access_rights uar
                                LEFT JOIN smg_regions r ON uar.regionid = r.regionid
                                INNER JOIN smg_companies c ON uar.companyid = c.companyid
                                INNER JOIN smg_usertype ut ON uar.usertype = ut.usertypeid
                                LEFT JOIN smg_users adv ON uar.advisorid = adv.userid
                                WHERE c.website = '#client.company_submitting#'
                                AND uar.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
                                ORDER BY uar.companyid, uar.regionid, uar.usertype
                            </cfquery>
                            
                            <cfquery name="check_default" dbtype="query">
                                SELECT id
                                FROM region_company_access
                                WHERE default_access = 1
                            </cfquery>
                           
	<!--- SIZING TABLE --->
    <table width="100%" border="0" >
        <tr>
            <td width="50%" valign="top">
    	
                <!----Regional & Company Information---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/usa.gif"></td>
                        <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Company & Regional Access</h2></td>
                        <cfif CLIENT.usertype LTE 5>
                        	
                           	 	<td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/access_rights_form&userid=#rep_info.userid#">Add</a></td>
                         	
                         </cfif>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                            <style type="text/css">
                            <!--
                            div.scroll {
                                height: 210px;
                                overflow: auto;
                            }
                            -->
                            </style>
    
                           
                            <cfif check_default.recordCount EQ 0>
                                <font color="##FF0000">You have no default selected.  Please select a default by clicking the "No" in the "Default" column.</font>
                            </cfif>
                
                            <div class="scroll">
                                <!----scrolling table with region information---->
                                <table width="100%" cellspacing="0">
                                    <tr>
                                        <cfif CLIENT.usertype LTE 5>
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
                                       
                                            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffff") ,DE("ffffe6") )#">
                                            <cfif CLIENT.usertype LTE 5>
                                                <td>
                                                    <!--- don't allow delete if user has only one record or for the default record. Dont allow edit on 2nd VIsit Reps.  Must convert to re-block access according to training. --->
                                                    <cfif region_company_access.usertype neq 15>
														<cfif CLIENT.usertype LTE 4 AND ( not (region_company_access.recordcount EQ 1 OR default_access))>
                                                            <a href="index.cfm?curdoc=user_info&action=delete_uar&id=#id#&userid=#rep_info.userid#" onClick="return confirm('Are you sure you want to delete this Company & Regional Access record?')">
                                                                <img src="pics/deletex.gif" border="0" alt="Delete">
                                                            </a>                                                    
                                                             -
                                                        </cfif>
                                                        <a href="index.cfm?curdoc=forms/access_rights_form&id=#id#&companyID=#companyID#&userid=#rep_info.userid#" title="Edit Access Level">[ Edit ]</a>
                                                    <cfelse>
                                                        <a href="index.cfm?curdoc=forms/convertToRep&userid=#rep_info.userid#"><img src="pics/convertBut_sm.jpg" border="0" /></a>
                                                        - 
                                                        <a href="index.cfm?curdoc=forms/access_rights_form&id=#id#&companyID=#companyID#&userid=#rep_info.userid#" title="Edit Access Level">[ Edit ]</a>
                                                    </cfif>
                                                </td> 
                                                <!---<td><a href="index.cfm?curdoc=forms/access_rights_form&id=#id#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>--->
                                            </cfif>
                                            <td>
                                                <cfif default_access>
                                                    Yes
                                                <cfelse>
                                                    <a href="index.cfm?curdoc=user_info&action=set_default_uar&id=#id#&userid=#rep_info.userid#" title="Set as default.">No</a>
                                                </cfif>
                                            </Td>
                                            <td>#companyshort#</Td>
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
    
                                            <cfif usertype EQ 4>
                                            
                                                <cfquery name="check_facilitator_assignment" datasource="#APPLICATION.DSN#">
                                                    select user_access_rights.userid, user_access_rights.usertype, smg_users.firstname, smg_users.lastname
                                                    from user_access_rights 
                                                    INNER JOIN smg_users on user_access_rights.userid = smg_users.userid
                                                    where user_access_rights.usertype = 4
                                                    and regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionid#">
                                                    and smg_users.userid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
                                                </cfquery>
    
                                                <cfloop query="check_facilitator_assignment">
                                                    <tr bgcolor="#iif(region_company_access.currentRow MOD 2 ,DE("ffffff") ,DE("ffffe6") )#">
                                                        <td>&nbsp;</td>
                                                        <!---<td>&nbsp;</td>--->
                                                        <td colspan="6"><em>#check_facilitator_assignment.firstname#  #check_facilitator_assignment.lastname# is also assigned as a Facilitator for this region.</em></td>
                                                    </tr>
                                                </cfloop>
                                                
                                            <cfelseif usertype EQ 5>
                                            
                                                <cfquery name="check_manager_assignment" datasource="#APPLICATION.DSN#">
                                                    SELECT user_access_rights.userid, user_access_rights.usertype, smg_users.firstname, smg_users.lastname
                                                    FROM user_access_rights 
                                                    INNER JOIN smg_users ON user_access_rights.userid = smg_users.userid
                                                    WHERE user_access_rights.usertype = 5
                                                    AND regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionid#">
                                                    AND smg_users.userid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
                                                </cfquery>
    
                                                <cfloop query="check_manager_assignment">
                                                    <tr bgcolor="#iif(region_company_access.currentRow MOD 2 ,DE("ffffff") ,DE("ffffe6") )#">
                                                        <td>&nbsp;</td>
                                                        <!---<td>&nbsp;</td>--->
                                                        <td colspan="6"><em>#check_manager_assignment.firstname#  #check_manager_assignment.lastname# is also assigned as a Regional Manager for this region.</em></td>
                                                    </tr>
                                                </cfloop>
    
                                            </cfif>	
                                             
                                        </cfloop>
                                        
                                    </cfif>
                                </table>
                            </div>
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
            <td>&nbsp;</td>
            <td width="49%" valign="top">
                <!----Student Information---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
                        <td background="pics/header_background.gif"><h2>Student Information</td><td background="pics/header_background.gif" width="16"></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                       
                            <!----Query for placed students---->
                            <cfquery name="get_placed_students" datasource="#APPLICATION.DSN#">
                                SELECT smg_students.studentid, smg_students.familylastname, smg_students.firstname, smg_students.placerepid,
                                    smg_students.sex, smg_countrylist.countryname, smg_students.countryresident, smg_students.city, smg_students.branchid as branch,
                                    smg_users.firstname as intl_firstname, smg_users.lastname as intl_lastname, smg_users.businessname as intl_businessname,
                                    p.programname
                                FROM smg_students 
                                LEFT JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid 
                                INNER JOIN smg_users ON smg_students.intrep = smg_users.userid
                                INNER JOIN smg_programs p ON p.programid = smg_students.programid
                                WHERE smg_students.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
                                AND 
						        	smg_students.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
								AND smg_students.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.globalCompanyList#" list="yes">)
                            </cfquery>
                            <!----Query for supervised students---->
                            <cfquery name="get_supervised_students" datasource="#APPLICATION.DSN#">
                                SELECT smg_students.studentid, smg_students.familylastname, smg_students.firstname, smg_students.placerepid,
                                    smg_students.sex, smg_countrylist.countryname, smg_students.countryresident, smg_students.city, smg_students.branchid as branch,
                                    smg_users.firstname as intl_firstname, smg_users.lastname as intl_lastname, smg_users.businessname as intl_businessname,
                                    p.programname
                                 FROM smg_students 
                                 LEFT JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid 
                                 INNER JOIN smg_users ON smg_students.intrep = smg_users.userid
                                 INNER JOIN smg_programs p ON p.programid = smg_students.programid
                                 WHERE smg_students.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
                                 AND 
						        	smg_students.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
								 
	                               AND smg_students.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.globalCompanyList#" list="yes">)
                                
                            </cfquery>	
                             <!----Query for 2nd visit students---->
                            <cfquery name="get_2ndvisit_students" datasource="#APPLICATION.DSN#">
                                SELECT smg_students.studentid, smg_students.familylastname, smg_students.firstname, smg_students.placerepid,
                                    smg_students.sex, smg_countrylist.countryname, smg_students.countryresident, smg_students.city, smg_students.branchid as branch,
                                    smg_users.firstname as intl_firstname, smg_users.lastname as intl_lastname, smg_users.businessname as intl_businessname,
                                    p.programname
                                FROM smg_students 
                                LEFT JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid 
                                INNER JOIN smg_users ON smg_students.secondvisitrepid = smg_users.userid
                                INNER JOIN smg_programs p ON p.programid = smg_students.programid
                                WHERE smg_students.secondvisitrepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
                                
								AND smg_students.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.globalCompanyList#" list="yes">)
                            </cfquery>			
                            <style type="text/css">
                            <!--
                            div.scroll1 {
                                height: 120px;
                                width: 490px;
                                overflow: auto;
                            }
                            -->
                            </style>
                            
                            <table width="480" border="0">
                                <Tr>
                                    <td width="30" align="left"><u>ID</u></td>
                                    <td width="70" align="left"><u>Last</u> </td>
                                    <td width="70" align="left"><u>First</u> </td>
                                    <td width="30" align="left"><u>Sex</u></td>
                                    <td width="70" align="left"><u>Country</u></td>
                                    <td width="140" align="left"><u>Business Name</u></td>
                                    <td width="70" align="left"><u>Program</u></td>
                                </Tr>
                            </table>
                            <u>Placed:</u> &nbsp; (#get_placed_students.recordcount#)
                            <cfif get_placed_students.recordcount gt 2><div class="scroll1"></cfif>
                            <!----scrolling table with placed information---->
                            <table border="0" width="100%">
                                <Cfif get_placed_students.recordcount EQ 0>
                                    <tr><td colspan="6" align="Center">Rep has not placed any students</td></tr>
                                </Cfif>
                                <cfloop query="get_placed_Students">
                                <tr bgcolor="#iif(get_placed_Students.currentrow MOD 2 ,DE("fffff6") ,DE("ffffe6") )#">		
                                    <td width="30" align="left">#studentid#</td>
                                    <td width="70" align="left">#familylastname#</td>
                                    <td width="70" align="left">#firstname#</td>
                                    <td width="30" align="left">#Left(sex,1)#</td>
                                    <td width="70" align="left">#Left(countryname,13)#</td>
                                    <td width=140 align="left"><cfif len(intl_businessname) gt 17>#Left(intl_businessname,17)#...<cfelse>#intl_businessname#</cfif></td>
                                    <td width="70" align="left"><u>#programname#</u></td>
                                </tr>
                                </cfloop>
                            </table>
                            <cfif get_placed_students.recordcount gt 2></div></cfif><br>
                            <u>Supervising:</u> &nbsp; (#get_supervised_students.recordcount#)
                            <cfif get_supervised_students.recordcount gt 2><div class="scroll1"></cfif>
                            <!----scrolling table with supervised information---->
                            <table width="100%" border="0">
                                <Cfif get_supervised_students.recordcount eq 0>
                                    <Tr><td colspan="6" align="Center">Rep is not supervising any students</td></Tr>
                                </Cfif>
                                <cfloop query="get_supervised_students">
                                <tr bgcolor="#iif(get_supervised_students.currentrow MOD 2 ,DE("fffff6") ,DE("ffffe6") )#">		
                                    <td width="30" align="left">#studentid#</td>
                                    <td width="70" align="left">#familylastname#</td>
                                    <td width="70" align="left">#firstname#</td>
                                    <td width="30" align="left">#Left(sex,1)#</td>
                                    <td width="70" align="left">#Left(countryname,13)#</td>
                                    <td width=120 align="left"><cfif len(intl_businessname) gt 17>#Left(intl_businessname,17)#...<cfelse>#intl_businessname#</cfif></td>
                                    <td width="70" align="left"><u>#programname#</u></td>
                                </tr>
                                </cfloop>
                            </table>
                            <cfif get_supervised_students.recordcount gt 2></div></cfif>
                            <!----Second Visit Students---->
                             <u>Second Visit Students:</u> &nbsp; (#get_2ndvisit_students.recordcount#)
                            <cfif get_2ndvisit_students.recordcount gt 2><div class="scroll1"></cfif>
                            <!----scrolling table with secondvisit information---->
                            <table border="0" width="100%">
                                <Cfif get_2ndvisit_students.recordcount EQ 0>
                                    <tr><td colspan="6" align="Center">Rep is not responsible for 2nd Visit on any students.</td></tr>
                                </Cfif>
                                <cfloop query="get_2ndvisit_students">
                                <tr bgcolor="#iif(get_2ndvisit_students.currentrow MOD 2 ,DE("fffff6") ,DE("ffffe6") )#">		
                                    <td width="30" align="left">#studentid#</td>
                                    <td width="70" align="left">#familylastname#</td>
                                    <td width="70" align="left">#firstname#</td>
                                    <td width="30" align="left">#Left(sex,1)#</td>
                                    <td width="70" align="left">#Left(countryname,13)#</td>
                                    <td width=140 align="left"><cfif len(intl_businessname) gt 17>#Left(intl_businessname,17)#...<cfelse>#intl_businessname#</cfif></td>
                                    <td width="70" align="left"><u>#programname#</u></td>
                                </tr>
                                </cfloop>
                            </table>
                            
                        </td>
                    </tr>
                </table>
                <!----footer of  regional table---->
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
    
    <br>
    
    <!--- SIZING TABLE --->
    <Table width="100%" border="0">
        <tr>
            <td width="30%" valign="top">
                <!---- PAYMENT INFORMATION ---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
                        <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Payment Activity </td><td background="pics/header_background.gif" width="16"></a></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                            <Cfquery name="super_payments" datasource="#APPLICATION.DSN#">
                                select sum(amount) as amount
                                from smg_rep_payments
                                where agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
                                and transtype = 'supervision'
                               AND companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.globalCompanyList#" list="yes">)
                               
                            </Cfquery>
                            <Cfquery name="place_payments" datasource="#APPLICATION.DSN#">
                                select sum(amount) as amount
                                from smg_rep_payments
                                where agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
                                and transtype = 'placement'
                                AND companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.globalCompanyList#" list="yes">)
                            </Cfquery>		
                            <strong>Supervising Payments:</strong> <Cfif super_payments.recordcount is 0>$0.00<cfelse>#LSCurrencyFormat(super_payments.amount, 'local')#</cfif><br>
                            <strong>Placement Payments:</strong> <Cfif place_payments.recordcount is 0>$0.00<cfelse>#LSCurrencyFormat(place_payments.amount, 'local')#</cfif><br>
                            <font size = -2><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=paymentReport&userID=#rep_info.userid#">view details</a></font>
                            <cfif CLIENT.usertype lte 4> - <font size = -2><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment&user=#rep_info.userid#">make payment</a></cfif>
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
            <td width=5></td>
            <td width="30%" valign="top">
                <!---- NOTES ---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/notes.gif"></td>
                        <td background="pics/header_background.gif"><h2>Notes</h2></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                            <Cfif comments EQ ''>No additional information available.<cfelse>#comments#</cfif><br><br>
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
            <td width=5></td>
            <td width=40% valign="top">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/family.gif"></td>
                        <td background="pics/header_background.gif"><h2>&nbsp;Other Family Members</h2></td>
                        <cfif CLIENT.userType NEQ 27>
                        	<td background="pics/header_background.gif" width="16"><a href="?curdoc=forms/edit_family_members&userid=#rep_info.userid#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>
                        </cfif>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
                    <tr>
                        <td style="line-height:20px;" valign="top">
                        <Cfquery name="family_members" datasource="#APPLICATION.DSN#">
                            select firstname, lastname, dob, relationship, no_members, auth_received, auth_received_type
                            from smg_user_family
                            where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#">
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
                                    <Td>#relationship#</Td>
                                    <Td>
                                        <cfif isDate(dob) AND DateDiff('yyyy', dob, now() ) LTE 17>
                                            N/A
                                        <cfelse>
                                            <cfif auth_received eq 0>
                                                <a href="forms/cbc_auth_fam.cfm?id=#rep_info.uniqueid#&userid=#rep_info.userid#">Get</a>
                                                <a href="index.cfm?curdoc=forms/upload_cbc_fam&id=#rep_info.uniqueid#&userid=#rep_info.userid#">Upload</a>
                                            <cfelse>
                                                <a href="uploadedfiles/cbc_auth/household/#rep_info.uniqueid#_#rep_info.userid#.#auth_received_type#">Received</a>
                                            </cfif>
                                        </cfif>
                                    </Td>
                                </tr>
                            </cfloop>	
                        </table>
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
    
    <br>
    
    <!--- SIZING TABLE --->
    <Table width="100%" border="0">	
        <tr>
            <td width="50%" valign="top">
                <!---- AR PAPERWORK ---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/clock.gif"></td>
                        <td background="pics/header_background.gif"><h2>Paperwork</td>
                        <td background="pics/header_background.gif" width="16">
                        <cfif client.usertype lte 4>
                        	<a href="?curdoc=forms/user_paperwork&userid=#rep_info.userid#"><img src="pics/edit.png" border="0" alt="Edit"></a>
                        </cfif></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <!----CBC---->
                <cfquery name="get_cbc_user" datasource="#APPLICATION.DSN#">
                    SELECT cbcid, userid, date_authorized , date_sent, notes, date_expired, requestid, smg_users_cbc.seasonid, flagcbc, smg_seasons.season, batchid
                    FROM smg_users_cbc
                    LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_users_cbc.seasonid
                    WHERE smg_users_cbc.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userid#"> 
                    AND familyid = '0'
                    <cfif CLIENT.companyid eq 10>
                        AND smg_users_cbc.companyid = 10
                    </cfif>
                    ORDER BY smg_seasons.season
                </cfquery>
                            
                <cfquery name="check_hosts" datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT h.hostid, familylastname, h.fatherssn, h.motherssn, date_sent, date_expired, smg_seasons.season, requestid, cbc.batchid
                    FROM smg_hosts h
                    INNER JOIN smg_hosts_cbc cbc ON h.hostid = cbc.hostid
                    LEFT JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
                    
                    WHERE cbc.cbc_type = 'father' AND ((h.fatherssn = '#rep_info.ssn#' AND h.fatherssn != '') OR (h.fatherfirstname = '#rep_info.firstname#' AND h.fatherlastname = '#rep_info.lastname#' <cfif rep_info.dob NEQ ''>AND h.fatherdob = '#DateFormat(rep_info.dob,'yyyy/mm/dd')#'</cfif>))
                    OR cbc.cbc_type = 'mother' AND ((h.motherssn = '#rep_info.ssn#' AND h.motherssn != '') OR (h.motherfirstname = '#rep_info.firstname#' AND h.motherlastname = '#rep_info.lastname#' <cfif rep_info.dob NEQ ''>AND h.motherdob = '#DateFormat(rep_info.dob,'yyyy/mm/dd')#'</cfif>))
                </cfquery>
                
                <Cfquery name="currentSeasonCBC" dbtype="query">
                select date_sent
                from get_cbc_user
                where seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(get_paperwork.seasonid)#"> 
                and userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#"> 
                </Cfquery>
                
                <table width="100%" cellpadding=2 cellspacing="0" border="0" class="section">
                    <tr style="line-height:20px;"><td><b>Season: #get_paperwork.season#</td></tr>
                <Cfif region_company_access.recordcount eq 1 and region_company_access.usertype neq 15>
                    <tr bgcolor="##FFFFFF"><td width="40%">AR Information Sheet</td>
                        <td><input type="checkbox" name="ar_info_sheet_check" disabled="disabled" <cfif get_paperwork.ar_info_sheet NEQ ''>checked="checked"</cfif>>
                            Date: #DateFormat(get_paperwork.ar_info_sheet, 'mm/dd/yyyy')#				
                        </td>
                    </tr>
                    <tr><td>AR Ref. Questionnaire ##1</td>
                        <td><input type="checkbox" name="ar_ref_quest1_check" disabled="disabled" <cfif get_paperwork.ar_ref_quest1 NEQ ''>checked="checked"</cfif>> 
                            Date: #DateFormat(get_paperwork.ar_ref_quest1, 'mm/dd/yyyy')#					
                        </td>
                    </tr>
                    <tr bgcolor="##FFFFFF"><td>AR Ref. Questionnaire ##2</td>
                        <td><input type="checkbox" name="ar_ref_quest2_check" disabled="disabled" <cfif get_paperwork.ar_ref_quest2 NEQ ''>checked="checked"</cfif>> 
                            Date: #DateFormat(get_paperwork.ar_ref_quest2, 'mm/dd/yyyy')#					
                        </td>
                    </tr>
                    <tr><td>CBC Authorization Form</td>
                        <td><input type="checkbox" name="ar_cbc_auth_form_check" disabled="disabled" <cfif get_paperwork.ar_cbc_auth_form NEQ ''>checked="checked"</cfif>> 
                           Date:
						   <cfif get_paperwork.cbcSig is not ''>
									<Cfif user_compliance.compliance EQ 1 OR client.userid eq userid or client.usertype eq 1>
                                     <a href="javascript:openPopUp('uploadedfiles/users/#userid#/Season#get_paperwork.seasonid#cbcAuthorization.pdf', 640, 800);">
                                    </cfif> 
                         	</cfif>
                           
                             #DateFormat(get_paperwork.ar_cbc_auth_form, 'mm/dd/yyyy')#</a>			
                        </td>
                    </tr>
                    
                    <tr>
                        <td>CBC Approved</td>
                        <td><input type="checkbox" name="ar_cbc_auth_processed" disabled="disabled" <cfif get_paperwork.ar_cbcAuthReview NEQ ''>checked="checked"</cfif>> 
                           Date:
						   
                           <Cfif currentSeasonCBC.recordcount neq 0>
                             #DateFormat(get_paperwork.ar_cbcAuthReview, 'mm/dd/yyyy')#</a>			
                           </Cfif>
                        </td>
                    </tr>
					
                    <tr bgcolor="##FFFFFF"><td>AR Agreement</td>
                        <td><input type="checkbox" name="ar_agreement_check" disabled="disabled" <cfif get_paperwork.ar_agreement NEQ ''>checked="checked"</cfif>> 
                            Date:
                            	<cfif get_paperwork.agreeSig is not ''>
                               		 <Cfif user_compliance.compliance EQ 1 OR client.userid eq userid or client.usertype eq 1>
                                	 	<a href="javascript:openPopUp('uploadedfiles/users/#userid#/Season#get_paperwork.seasonid#AreaRepAgreement.pdf', 640, 800);">
                                     </cfif>
   								</cfif>
                             #DateFormat(get_paperwork.ar_agreement, 'mm/dd/yyyy')#</a>
                        </td>
                    </tr>
                    <tr><td>AR Training Sign-off Form</td>
                        <td><input type="checkbox" name="ar_training_check" disabled="disabled" <cfif get_paperwork.ar_training NEQ ''>checked="checked"</cfif>> 
                            Date: #DateFormat(get_paperwork.ar_training, 'mm/dd/yyyy')#
                        </td>
                    </tr>
                  </Cfif>	
                    <tr><td>2nd Visit User Info Sheet</td>
                        <td><input type="checkbox" name="ar_secondVisist_check" disabled="disabled" <cfif get_paperwork.secondVisit NEQ ''>checked="checked"</cfif>> 
                            Date: #DateFormat(get_paperwork.secondVisit, 'mm/dd/yyyy')#
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
            <td width="5">&nbsp;</td>
            <td width="50%" valign="top">
                
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/notes.gif"></td>
                        <td background="pics/header_background.gif"><h2>Criminal Background Check</td>
                        <cfif CLIENT.usertype EQ 1 OR user_compliance.compliance EQ 1>
                            <td background="pics/header_background.gif" width="16"><a href="?curdoc=cbc/users_cbc&userid=#rep_info.userid#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>
                        </cfif>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding="4" cellspacing="0" border="0" class="section">
                    <tr>
                        <td align="center" valign="top"><b>Season</b></td>		
                        <td align="center" valign="top"><b>Date Submitted</b> <br><font size="-2">mm/dd/yyyy</font></td>
                        <td align="center" valign="top"><b>Expiration Date</b> <br><font size="-2">mm/dd/yyyy</font></td>		
                        <td align="center" valign="top"><b>View</b></td>
                        <td align="left" valign="top"><b>Notes</b></td>
                        <cfif client.usertype lte 4 and client.companyid eq 10><td align="center" valign="top"><strong>Delete</strong></td></cfif>
                    </tr>				
                    <cfif get_cbc_user.recordcount EQ '0'>
                        <tr><td align="center" colspan="5">No CBC has been submitted.</td></tr>
                    <cfelse>
                        <cfloop query="get_cbc_user">
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td align="center" style="line-height:20px;"><b>#season#</b></td>
                            <td align="center" style="line-height:20px;"><cfif NOT isDate(date_sent)>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center" style="line-height:20px;"><cfif NOT isDate(date_expired)>processing<cfelse>#DateFormat(date_expired, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center" style="line-height:20px;"><cfif NOT LEN(requestID)>processing<cfelseif flagcbc EQ 1>On Hold Contact Compliance<cfelse><cfif CLIENT.usertype lte 4><a href="cbc/view_user_cbc.cfm?userID=#get_cbc_user.userID#&cbcID=#get_cbc_user.cbcID#&file=batch_#get_cbc_user.batchid#_user_#get_cbc_user.userid#_rec.xml" target="_blank"><!----#requestid#---->View </a></cfif></cfif></td>
                            <cfif client.usertype lte 4><td>#notes#</td></cfif>
                            <cfif client.usertype lte 4 and client.companyid eq 10><td align="center" valign="top"><a href="delete_cbc.cfm?type=user&id=#requestid#&userid=#url.userid#"><img src="pics/deletex.gif" border=0/></td></cfif>
                        </tr>
                        </cfloop>
                    </cfif>
                    <cfloop query="check_hosts">
                        <tr><td colspan="3">CBC Submitted for Host Family (###hostid#).</td></tr>
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td align="center" style="line-height:20px;"><b>#season#</b></td>
                            <td align="center" style="line-height:20px;"><cfif NOT isDate(date_sent)>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center" style="line-height:20px;"><cfif NOT isDate(date_expired)>processing<cfelse>#DateFormat(date_expired, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center" style="line-height:20px;"><cfif NOT LEN(requestID)>processing<cfelse><cfif CLIENT.usertype lte 4>#requestid#</cfif></cfif></td>
                            <cfif client.usertype lte 4 and client.companyid eq 10><td align="center" valign="top"><a href="delete_cbc.cfm?type=user&id=#requestid#&userid=#url.userid#"><img src="pics/deletex.gif" border=0/></td></cfif>
                        </tr>
                    </cfloop>				
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
    
    <br>
    
	<!--- SIZING TABLE --->
    <Table width="100%" border="0">	
        <tr>
            <td width="50%" valign="top">
                
                <!---- Training Information ---->
                <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/notes.gif"></td>
                        <td background="pics/header_background.gif"><h2>Training</h2></td>
                        <cfif VAL(CLIENT.USERTYPE) LTE 4>
                            <td background="pics/header_background.gif" width="80"><a href="javascript:displayTrainingForm();">Add Record</a></td>
                        </cfif>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                
                <table width="100%" cellpadding="4" cellspacing="0" border="0" class="section">
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
                                            <td><input type="text" name="dateTrained" value="#DateFormat(FORM.dateTrained, 'mm/dd/yyyy')#" id="dateTrained" class="date-pick" maxlength="10" />  (mm/dd/yyyy)</td>
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
                                    	<img src="pics/green_check.gif" border="0" />
                                    <cfelse>
                                    	<img src="pics/delete.png" border="0" />
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
                
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr valign="bottom">
                        <td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
                        <td width="100%" background="pics/header_background_footer.gif"></td>
                        <td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
                    </tr>
                </table>
            
            </td>
            <td width="50%" valign="top">
                <!--- References ---->    
                 <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/notes.gif"></td>
                        <td background="pics/header_background.gif"><h2>References</h2></td>
                        <cfif CLIENT.userType NEQ 27>
                        	<td background="pics/header_background.gif" width="140" align="right"><a href="javascript:openPopUp('forms/repRefs.cfm?curdoc=repRefs&userid=#url.userid#', 640, 800);">Add/Edit Refs</a></td>
                        </cfif>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
                   <tr><td align="Center" colspan=4<cfif get_paperwork.ar_ref_quest1 is '' or get_paperwork.ar_ref_quest2 is ''> bgcolor="##FF0000"</cfif> ><a href="javascript:displayReferenceForm();"><cfif get_paperwork.ar_ref_quest1 is '' or get_paperwork.ar_ref_quest2 is ''><font color="##ffffff"></cfif>View / Hide References</font></a><br /></td></tr>
                   <td><td align="center">
                   
                   
                    <div id="referenceForm"  style="display:none;"  >
                    <table width=100%>
                    <tr><td><b>Season: #get_paperwork.season#</td></tr>
                    <tr>
                        <td valign="top">
                            <table width=100% cellspacing=0 cellpadding="4">
                            	<Tr bgcolor="##CCCCCC">
                                <Td>Name</Td>
                                <Td align="center">Phone</Td>                                
                                <td align="center">Status</td>
                                <td align="center">
										<Cfif client.usertype lte 5 and client.userid neq userid>
										Report</cfif>
                                    </td>
                                    
                                </Tr>
							
                            <Cfif qreferences.recordcount EQ 0>   	
                            <tr>
                                <td colspan=3>No references on file.</td>
                             </tr>
                             <cfelse>
                             <Cfloop query="qreferences">
                             <Cfquery name="checkRefReport" datasource="#APPLICATION.DSN#">
                             select *
                             from areaRepQuestionaireTracking
                             where fk_ReferencesID = #refid# 
                             
                             </Cfquery>
                             <tr <Cfif qreferences.currentrow mod 2>bgcolor=##ffffe5</cfif>>
                               	<Td><strong>#firstname# #lastname#</strong> - <em>#relationship# (#howlong#)</em></Td>
                                <td align="Center">#phone#</td>
                                <Td align="Center">
                                <Cfif qreferences.approved eq 0>
                                Waiting
                                <Cfelseif qreferences.approved eq 1>
                                Pending
                                <Cfelseif qreferences.approved eq 2>
                                Approved
                                <Cfelseif qreferences.approved eq 3>
                                Rejected
                                </Cfif>
                                </Td>
                                <Td align="Center">
                                
                                <Cfif client.usertype lte 6 and client.userid neq userid>
									<Cfif checkRefReport.recordcount eq 0 and client.usertype lte 6 >
                                     <a href="javascript:openPopUp('forms/refrencesQuestionaire.cfm?ref=#refid#&rep=#userid#', 680, 800);">Submit Report
                                    <cfelse>
                                   <a href="javascript:openPopUp('forms/viewRefrencesQuestionaire.cfm?reportid=#checkRefReport.id#', 640, 800);">View Report</a>
                                    </Cfif>
                                <cfelse>
                               
                                </cfif>
                                </Td> 
                              
                             </tr>
                             <Tr <Cfif qreferences.currentrow mod 2>bgcolor=##ffffe5</cfif>>
                             	<td colspan=2>#address# #address2# #city# #state#, #zip#</td><Td colspan=2></Td>
                             </Tr>
                             </Cfloop>
                             </Cfif>
                         
                              </table>
                        </td>
                    </tr>
                </table>
                </div>
                <!---_Table around References area---->
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
                <br /><br />
                <Cfif client.usertype lte 4>
                <cfquery name="qEmploymentHistory" datasource="MySQL">
                select *
                from smg_users_employment_history
                where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
                order by current
                </cfquery>
                 <!--- Experience ---->    
                 <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                    <tr valign="middle" height="24">
                        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                        <td width="26" background="pics/header_background.gif"><img src="pics/notes.gif"></td>
                        <td background="pics/header_background.gif"><h2>Experience</h2></td>
                        <td background="pics/header_background.gif" width="140" align="right"></td>
                        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" cellpadding=10 cellspacing="0" border="0" class="section">
                   <tr><td align="Center"><a href="javascript:displayExperienceForm();">View / Hide Experience</a><br />
                   
                   
                    <div id="ExperienceForm"  style="display:none;"  >
                     
                      <table width=100% cellspacing=0 cellpadding=2 class="border">
                           <Tr>
                           	 	<td colspan=7>
                                <b>Prior Exchange Experience:</b><br />
                                <Cfif prevOrgAffiliation eq 0>
                                None
                                <cfelseif prevOrgAffiliation eq 1> 
                                 #prevAffiliationName#<br />
                                 <cfif #prevAffiliationProblem# is not ''><em><font color="##CCCCCC">Problems:</font></em> #prevAffiliationProblem#</cfif>
                                 <cfelse>
                                 Question not Answered.
                                 </Cfif>
                                 <br /><br />
                                </td>
                           </Tr>
                            <Th></Th><Th>Employer</Th><Th>Address</Th><th>City</th><Th>State</Th><th>Zip</th><th>Phone</th>
                            </Tr>
                           <Cfif qEmploymentHistory.recordcount eq 0>
                            <tr>
                                <td colspan=7>No employers are on file for #firstname#.</td>
                            </tr>
                            <cfelse>
                            <Cfloop query="qEmploymentHistory">
                            <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
                                <Td><cfif current eq 1>&radic;</cfif></Td>
                                <Td valign="middle">#employer#</Td>
                                <td valign="middle">#address# #address2#</td>
                                <Td valign="middle">#city#</Td>
                                <td valign="middle">#state#</td>
                                <td valign="middle">#zip#</td>
                                <td valign="middle">#phone#</td>
                               
                            </tr>
                            </Cfloop>
                            </cfif>
                           </table>
                </div>
                <!---_Table around Experience area---->
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
                </cfif>
            </td>
        </tr>
    </Table>        

</cfif>

</cfoutput>
