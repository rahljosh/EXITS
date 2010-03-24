<!--- <cftry> --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Variables --->
    <cfparam name="appNewsText" default="">
    <cfparam name="appStatusText" default="">
    <cfparam name="submitSectionText" default="">
    
    <!--- Submit Button - This is used in a few status when the student needs to submit the application --->
    <cfsavecontent variable="submitButton">
        <div align="center">
            <a href="querys/check_app_before_submit.cfm"><img src="pics/submit-app.gif" border=0></a>
        </div>
        <br>
        <font size=-1>
            *<em>An initial check for required information is performed before the application is submited. This does not
            guarantee that the application will not be denied by #qGetIntlRep.businessname# and more information will be requested.</em>
        </font>                            
    </cfsavecontent>

    <!--- Approval Button - This is used in a few status when branch or Intl. Rep need to approve/deny the application --->
	<cfsavecontent variable="approvalButton">
        <div align="center">
            <a href="querys/check_app_before_submit.cfm"><img src="pics/approve.gif" alt="Approve Application" align="center" border="0"></a>
            &nbsp; &nbsp; &nbsp;
            <a href="?curdoc=deny_application"><img border=0 src="pics/deny.gif" alt="Deny Application" align="center" border="0"></a>
        </div>
	</cfsavecontent>

	<cfoutput>
	
	<!--- Set up texts depending on the current status --->

    <cfswitch expression="#qGetLatestStatus.status#">
        
        <!--- 1 - Application Issued --->
        <cfcase value="1">
            
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                Welcome to the #qOrgInfo.companyname# EXITS Online Application.<br><br>
                There are 5 main sections of the application with multiple pages under each main section. The menu
                across the top of the screen shows each section of the application along with a check list, print options, and a support link.<br><br>
                
                To begin your application, click on the student application section above. You can fill out the application in any order
                and come back to each section at any time to add, edit or finish the application. To save your progress simply push the save button
                at the bottom of the page you have most recently worked on.<br><br>
                                
                Keep in mind that if you don't access your account at least once in 30 days your application will be deleted and you 
                will have to start the entire process over. <br><br>
                <div align="center"><form action="index.cfm?curdoc=section1&id=1" method="post"><input type="image" alt="Start Application" src="pics/start-application.gif"></form></div>
            </cfsavecontent>
            
            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/incomplete.gif" align="left" style="padding-right:10px;">  
                Issued - Your application has been issued but has not been activated. <br><br>
                Please follow the instructions on the Welcome Email in order to activate your application.
            </cfsavecontent>

        </cfcase>
        
        
        <!--- 2 - Application Active --->
        <cfcase value="2">
        
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                Welcome to the #qOrgInfo.companyname# EXITS Online Application.<br><br>
                There are 5 main sections of the application with multiple pages under each main section. The menu
                across the top of the screen shows each section of the application along with a check list, print options, and a support link.<br><br>
                
                To begin your application, click on the student application section above. You can fill out the application in any order
                and come back to each section at any time to add, edit or finish the application. To save your progress simply push the save button
                at the bottom of the page you have most recently worked on.<br><br>
                                
                Keep in mind that if you don't access your account at least once in 30 days your application will be deleted and you 
                will have to start the entire process over. <br><br>
                <div align="center"><form action="index.cfm?curdoc=section1&id=1" method="post"><input type="image" alt="Start Application" src="pics/start-application.gif"></form></div>
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/incomplete.gif" align="left" style="padding-right:10px;"> 
                In Progress - Your application has not been submitted for review. <br><br>
                If your application is ready to submit, click 'Submit Application to Representative' below.  
                To view missing items, click on <a href="?curdoc=check_list&id=cl">Check List</a> in the menu.
			</cfsavecontent>

            <!--- Submit Section Text --->
            <cfsavecontent variable="submitSectionText"> 
                       
				<!--- Must be Submitted by Student --->
                <cfif CLIENT.userType EQ 10>
                    #submitButton#
                <cfelse>
                    <em>* This application must be submitted by the student.</em>                                   
                </cfif>
                
            </cfsavecontent>
            
        </cfcase>
    
    
        <!--- 3 - Application submitted to Branch --->
        <cfcase value="3">
            
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                Your application is currently being reviewed by #qGetBranch.businessname#.
                Your applicaiton may be denied by #qGetBranch.businessname# for information they feel is incomplete or missing,
                in which case you will need to provide the requestd information and resubmit the application.
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/under_review.gif" align="left" style="padding-right:10px;"> 
                Under Review - Application has been submitted to #qGetBranch.businessname#.  
			</cfsavecontent>

            <!--- Submit Section Text --->
            <cfsavecontent variable="submitSectionText"> 
                    
				<!--- Must be submitted by Branch --->
                <cfif get_student_info.branchid EQ CLIENT.userID>
                    #approvalButton#
                <cfelse>
                    <em>* This application must be submitted by #qGetBranch.businessname#.</em>                                  
                </cfif>

            </cfsavecontent>

        </cfcase>
        
        
        <!--- 4 - Application Rejected by Branch --->
        <cfcase value="4">
            
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
            	Your application has been rejected by #qGetBranch.businessname#. You may need to provide more information, please see notes on the right.
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/incomplete.gif" align="left" style="padding-right:10px;"> 
                Rejected - Your application has been rejected by #qGetBranch.businessname#. 
			</cfsavecontent>

            <!--- Submit Section Text --->
            <cfsavecontent variable="submitSectionText">  
                      
				<!--- Must be re-submitted by Student --->
                <cfif CLIENT.userType EQ 10>
                    #submitButton#
                <cfelse>
                    <em>* This application must be re-submitted by the student.</em>                                   
                </cfif>
                
            </cfsavecontent>

        </cfcase>
    
    
        <!--- 5 - Application submitted to Intl. Rep. --->
        <cfcase value="5">
            
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                Your application is currently being reviewed by #qGetIntlRep.businessname#.
                Your applicaiton may be denied by #qGetIntlRep.businessname# for information they feel is incomplete or missing,
                in which case you will need to provide the request information and resubmit the application.						
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/under_review.gif" align="left" style="padding-right:10px;"> 
                Under Review - Application has been submitted to #qGetIntlRep.businessname#.  
			</cfsavecontent>

            <!--- Submit Section Text --->
            <cfsavecontent variable="submitSectionText">     
                   
				<!--- Check if Agent is allowed to submit Applications --->            
                <cfif CLIENT.usertype EQ 8 AND ListFind(APPLICATION.submitAppNotAllowed, CLIENT.userID)> 
                    We are currently not accepting applications for the upcoming season. <br>
                    You can send this application back to your <cfif get_student_info.branchID> branch <cfelse> student </cfif> by clicking the deny button below.
                    Please contact Brian Hause at <a href="mailto:bhause@iseusa.com">bhause@iseusa.com</a> if you have any questions.                    
					<br><br>
                    <div align="center">						
                    	<a href="?curdoc=deny_application"><img border=0 src="pics/deny.gif" alt="Deny Application" align="center" border="0"></a>                    
					</div>                        
                <cfelseif CLIENT.usertype EQ 8>
                    #approvalButton#
                <cfelse>
                	<em>* This application must be submitted by #qGetIntlRep.businessname#.</em>   
                </cfif>
                
            </cfsavecontent>
            
        </cfcase>
    
    
        <!--- 6 - Application Rejected by Intl. Rep. --->
        <cfcase value="6">
            
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                Your application has been rejected by #qGetIntlRep.businessname#. You may need to provide more information, please see notes on the right.
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/incomplete.gif" align="left" style="padding-right:10px;"> 
                Rejected - Your application has been rejected by #qGetIntlRep.businessname#. 
                You may need to provide more information, please see notes on below. 
			</cfsavecontent>

            <!--- Submit Section Text --->
            <cfsavecontent variable="submitSectionText">            
				
                <!--- There is a branch --->
                <cfif VAL(get_student_info.branchid)>

                    <cfif get_student_info.branchid EQ CLIENT.userID>
                        #approvalButton#
                    <cfelse>
                        <em>* This application must be submitted by #qGetBranch.businessname#.</em>                                  
                    </cfif>
                
                <!--- There is no branch --->
                <cfelse>
                
					<!--- Must be re-submitted by Student --->
                    <cfif CLIENT.userType EQ 10>
                        #submitButton#
                    <cfelse>
                        <em>* This application must be re-submitted by the student.</em>                                   
                    </cfif>
                
                </cfif>

            </cfsavecontent>
            
        </cfcase>
    
    
        <!--- 7 - Application submitted to SMG --->
        <cfcase value="7">
            
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                Your application has been approved by #qGetIntlRep.businessname# and submitted to SMG headquarters in New York.  
                If SMG denies your application due to missing or incomplete information, it will be first sent back to #qGetIntlRep.businessname# who may be able
                to provide the additional information.  If #qGetIntlRep.businessname# is not able to provide it, it will be rejected back to you so you can provide
                the information and then resubmit it for processing.  
                <br><br>
                If SMG approves your application it will immediately be available for placement.
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">                            
                <img src="pics/under_review.gif" align="left" style="padding-right:10px;"> 
                Approved - Your application has been approved by #qGetIntlRep.businessname#! 
			</cfsavecontent>
            
        </cfcase>
    
    
        <!--- 8 - Application under review --->
        <cfcase value="8">

        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                Your application is under review by #qOrgInfo.companyshort_nocolor#.  
                If #qOrgInfo.companyshort_nocolor# denies your application due to missing or incomplete information, it will be first sent back to #qGetIntlRep.businessname# who may be able
                to provide the additional information.  If #qGetIntlRep.businessname# is not able to provide it, it will be rejected back to you so you can provide
                the information and then resubmit it for processing.  
                <br><br>
                If #qOrgInfo.companyshort_nocolor# approves your application it will immediately be available for placement.
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/under_review.gif" align="left" style="padding-right:10px;"> 
                Reviewing - Your application has been received and it's under review by #qOrgInfo.companyshort_nocolor#. 
			</cfsavecontent>
            
            <!--- Submit Section Text --->
            <cfsavecontent variable="submitSectionText">            

            </cfsavecontent>
            
        </cfcase>
    
    
        <!--- 9 - Application rejected by SMG --->
        <cfcase value="9">
            
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                #qOrgInfo.companyshort_nocolor# has denied your application. You or #qGetIntlRep.businessname# needs to provide more information. Please see details on the right.
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">                            
                <img src="pics/incomplete.gif" align="left" style="padding-right:10px;"> 
                Rejected - Your application has been rejected by #qOrgInfo.companyshort_nocolor#. 
			</cfsavecontent>

            <!--- Submit Section Text --->
            <cfsavecontent variable="submitSectionText">     
                   
				<!--- Check if Agent is allowed to submit Applications --->            
                <cfif CLIENT.usertype EQ 8 AND ListFind(APPLICATION.submitAppNotAllowed, CLIENT.userID)> 
                    We are currently not accepting applications for the upcoming season. <br>
                    You can send this application back to <cfif get_student_info.branchID> #qGetBranch.businessname# <cfelse> the student </cfif> by clicking the deny button below.
                    Please contact Brian Hause at <a href="mailto:bhause@iseusa.com">bhause@iseusa.com</a> if you have any questions.                    
					<br><br>
                    <div align="center">						
                    	<a href="?curdoc=deny_application"><img border=0 src="pics/deny.gif" alt="Deny Application" align="center" border="0"></a>                    
					</div>                        
                <cfelseif CLIENT.usertype EQ 8>
                    #approvalButton#
                <cfelse>
                	<em>* This application must be re-submitted by #qGetIntlRep.businessname#.</em>   
                </cfif>
                
            </cfsavecontent>
            
        </cfcase>
    
    
        <!--- 10 - Application approved by SMG --->
        <cfcase value="10">
  
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                On Hold. Your application is currently on hold. #qOrgInfo.companyshort_nocolor# will be contacting #qGetIntlRep.businessname#.
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/incomplete.gif" align="left" style="padding-right:10px;"> 
                On Hold - Your application has been put on hold.
			</cfsavecontent>

        </cfcase>
    
    
        <!--- 11 - Application approved by SMG --->
        <cfcase value="11">

        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                <h3>Congratulations!</h3>
                Your application has been approved. Your profile and information are showing as available for placement in the region/state you requested or where assigned
                to upon acceptance of your application.  Once you are placed with a family, your host family information will be available below.
            </cfsavecontent>

            <!--- Application Status Text --->
            <cfsavecontent variable="appStatusText">            
                <img src="pics/approved.gif" align="left" style="padding-right:10px;"> 
                Approved - Your application has been approved by #qOrgInfo.companyshort_nocolor#! #qOrgInfo.companyshort_nocolor# is in the processing of locating a host family.
			</cfsavecontent>

        </cfcase>
    
    	<!--- Default --->
    	<cfdefaultcase>
        
        	<!--- Application News Text --->
        	<cfsavecontent variable="appNewsText">
                Welcome to the #qOrgInfo.companyname# EXITS Online Application.<br><br>
                There are 5 main sections of the application with multiple pages under each main section. The menu
                across the top of the screen shows each section of the application along with a check list, print options, and a support link.<br><br>
                
                To begin your application, click on the student application section above. You can fill out the application in any order
                and come back to each section at any time to add, edit or finish the application. To save your progress simply push the save button
                at the bottom of the page you have most recently worked on.<br><br>
                                
                Keep in mind that if you don't access your account at least once in 30 days your application will be deleted and you 
                will have to start the entire process over. <br><br>
                <div align="center"><form action="index.cfm?curdoc=section1&id=1" method="post"><input type="image" alt="Start Application" src="pics/start-application.gif"></form></div>
            </cfsavecontent>
                    
        </cfdefaultcase>
    
    </cfswitch>

	</cfoutput>

</cfsilent>

<cfoutput>

<!--- APPLICATION EXPIRED --->
<cfif qGetLatestStatus.status LTE 2 AND get_student_info.application_expires LT now()>
	<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
		<tr valign=middle height=24>
			<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
			<td background="../pics/header_background.gif"><h2>APPLICATION EXPIRED</h2></td>
            <td background="../pics/header_background.gif" width=16></td>
			<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width=100% class="section">
	<tr>
		<td>
		<cfif CLIENT.usertype NEQ 10 AND (get_student_info.intrep EQ CLIENT.userid OR get_student_info.branchid EQ CLIENT.userid)>
			<cfform method="post" action="querys/extend_deadline.cfm">

				<cfset maxdeadline = 90>
				<cfset expdate = #DateAdd('d', maxdeadline, now())#>
				
				This application has expired. You can re-activate it by extending the application deadline below in 90 days.  
				At this time you can extend the deadline up to #DateFormat(expdate, 'mm/dd/yyyy')#.<br><br>

				Extend Deadline by: 
				<cfif maxdeadline GT 1>
					<select name="extdeadline">
						<cfloop index="i" from="5" to="#maxdeadline#" step="5">
							<option value=#i#>#i#</option>
						</cfloop>
					</select>
					days from today. <input type="submit" value="Extend Deadline"><br>
				<cfelse>
					<b>You can not extend the deadline</b>.
					<cfinput type="hidden" name="extdeadline" value="0">
				</cfif> 
                
			</cfform>
		<cfelse>
			Your Application has expired. Please contact <cfif qGetBranch.recordcount eq 0>#qGetIntlRep.businessname#<cfelse>#qGetBranch.businessname#</cfif> to 
			reactivate your account.<br><br>
			<cfif qGetBranch.recordcount eq 0>#qGetIntlRep.businessname#<br>#qGetIntlRep.phone#<br><a href="mailto:#qGetIntlRep.email#">#qGetIntlRep.email#</a><cfelse>#qGetBranch.businessname#<br>#qGetBranch.phone#<br><a href="mailto:#qGetBranch.email#">#qGetBranch.email#</a></cfif>
		</cfif>
		</td>
	</tr>
	</table>
	
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
	</table>
    
    <cfabort>

</cfif>
    
<!--- APPLICATION ACTIVE --->
<Table width=100% border=0 align="center">
<tr>
    <td width=49% valign="top">
        <!--- Application News --->
        <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
            <tr valign=middle height=24>
                <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
                <td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
                <td background="../pics/header_background.gif"><h2>Application News </h2></td>
                <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
            </tr>
        </table>
        <table width=100% class="section">
            <tr>
                <td style="padding:10px 10px 10px 10px;">
                     #appNewsText# 
                </td>
            </tr>
        </table>
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr valign=bottom >
                <td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
                <td width=100% background="../pics/header_background_footer.gif"></td>
                <td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
            </tr>
        </table>
    </td>
    
    <td width="2%">&nbsp;</td>
   
    <td width="49%" valign="top">
        <!----App Status Reports---->
        <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
            <tr valign=middle height=24>
                <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
                <td width=26 background="../pics/header_background.gif"><img src="pics/sticky-active.gif"></td>
                <td background="../pics/header_background.gif"><h2>Application Status</h2></td>
                <td background="../pics/header_background.gif" align="right">Last Changed: #DateFormat(get_student_info.lastchanged, 'mm/dd/yyyy')#</td>
                <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
            </tr>
        </table>
        <table width=100% cellpadding=3 cellspacing=0 border=0 class="section">
            <tr>
                <td style="line-height:20px;" valign="top">
                    <table width=100%>
                        <tr>
                            <td valign="top" style="padding:10px 10px 10px 10px;">
                            	#appStatusText#
                            
								<!--- Reason --->
                                <cfif LEN(qGetLatestStatus.reason)><br><br>
                                    <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0>
                                        <tr>
                                            <td valign="top"><img src="pics/error_exclamation_clear.gif"></td>
                                            <td width="2%">&nbsp;</td>
                                            <td align="left" width="100%">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor=##ffffff>
                                                    <tr valign="top">
                                                        <td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="../pics/address_topleft.gif" height=6 width=6></td>
                                                        <td width=100% style="line-height:1px; font-size:2px; border-top: 1px solid ##557aa7;">&nbsp;</td>
                                                        <td width=6 style="border-right: 1px solid ##557aa7;"><img src="../pics/address_topright.gif" height=6 width=6></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
                                                        <td width=100% style="padding:5px;">#qGetLatestStatus.reason#</td>
                                                        <td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="bottom">
                                                        <td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="../pics/address_bottomleft.gif" height=6 width=6></td>
                                                        <td width=100% style="line-height:1px; font-size:2px; border-bottom: 1px solid ##557aa7;">&nbsp;</td>
                                                        <td width=6 style="border-right: 1px solid ##557aa7;"><img src="../pics/address_bottomright.gif" height=6 width=6></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </cfif>
                            
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <!--- Submit / Approval Button --->
                <td style="padding:10px 10px 10px 10px;">                    
					#submitSectionText#
                </td>
            </tr>
        </table>
        
		<!----footer of table---->
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr valign=bottom >
                <td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
                <td width=100% background="../pics/header_background_footer.gif"></td>
                <td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
            </tr>
        </table>
        
        <br>
        
        <cfif LEN(get_student_info.app_intl_comments)>
            <!--- INTL. Rep. Comments --->
            <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                <tr valign=middle height=24>
                    <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
                    <td background="../pics/header_background.gif"><h2>#qGetIntlRep.businessname# Comments</h2></td>
                    <td background="../pics/header_background.gif" width=16></td>
                    <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
            <table width=100% class="section">
                <tr><td><div align="justify">#get_student_info.app_intl_comments#</div></td></tr>
            </table>
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr valign=bottom >
                    <td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
                    <td width=100% background="../pics/header_background_footer.gif"></td>
                    <td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
                </tr>
            </table>
        </cfif>				
        </td>
    </tr>
</table>

<br>

<!--- Do not display Profiles for these agents --->    
<cfif NOT ListFind(APPLICATION.displayProfileNotAllowed, qGetIntlRep.userid)>

	<!--- Student Profile  --->
    <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
        <tr valign=middle height=24>
            <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
            <td background="../pics/header_background.gif"><h2>Student Profile</h2> </td><td background="../pics/header_background.gif" width=16></td>
            <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
    
    <table width=100% class="section">
        <tr><td>   
        <cfif qGetLatestStatus.status EQ 11>
            Click here to view your general profile overview: <a href="?curdoc=profile&unqid=#get_student_info.uniqueid#" target="_top">Your Profile</a>
        <cfelse>
            Your student profile will be available here once your application is processed.
        </cfif>
        </td></tr>
    </table>
    
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr valign=bottom >
            <td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
            <td width=100% background="../pics/header_background_footer.gif"></td>
            <td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
        </tr>
    </table>
    
    <br><br>
    
    <!--- Host Family Section --->
    <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
        <tr valign=middle height=24>
            <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="../pics/header_background.gif"><img src="../pics/news.gif"></td>
            <td background="../pics/header_background.gif"><h2>Host Family Information </h2></td><td background="../pics/header_background.gif" width=16></td>
            <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
    
    <table width=100% class="section">
        <tr>
            <td>
                <cfquery name="host_fam" datasource="MySQL">
                    SELECT 
                    	hostid
                    FROM
                    	smg_students
                    WHERE 
                    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
                </cfquery>
            
                <cfif (host_fam.recordcount EQ 0 OR get_student_info.host_fam_approved GT 4)>
                    Information on your host family and location will be available here once you are assigned to a host family. <br><br>
                <cfelse>
                    <cfset CLIENT.hostid = host_fam.hostid>
                    <cfset hostid = host_fam.hostid>
                    <img src="pics/external_link.png" border=0> indicates additional information from external site(s). <br>
                    <img src="pics/sat_image.png" border=0> satalite images of area. <br>SMG is not responsible for information received or available from the external sites linked below.  Some links may not be valid.<br><br>
                
                    <!----host family info---->
                    <cfinclude template="../querys/family_info.cfm">
                    
                    <!-----Host Children----->
                    <cfquery name="host_children" datasource="MySQL">
                        SELECT *
                        FROM smg_host_children
                        WHERE hostid = '#family_info.hostid#'
                        ORDER BY birthdate
                    </cfquery>
                    
                <!--- REGION --->
                <cfquery name="get_region" datasource="MySQl">
                    SELECT regionid, regionname
                    FROM smg_regions
                    WHERE regionid = '#family_info.regionid#'
                </cfquery>
                
                <!--- SCHOOL ---->
                <cfquery name="get_school" datasource="MySQL">
                    SELECT schoolid, schoolname, address, city, state, begins, ends,url
                    FROM smg_Schools
                    WHERE schoolid = '#family_info.schoolid#'
                </cfquery>
                    
                <style type="text/css">
                <!--
                div.scroll {
                    height: 155px;
                    width:auto;
                    overflow:auto;
                    border-left: 2px solid c6c6c6;
                    border-right: 2px solid c6c6c6;
                    background: FFFFFF;
                    left:auto;
                }
                div.scroll2 {
                    height: 100px;
                    width:auto;
                    overflow:auto;
                    border-left: 2px solid c6c6c6;
                    border-right: 2px solid c6c6c6;
                    background: FFFFFF;
                    left:auto;
                }
                -->
                </style>
                    
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr><td width="60%" align="left" valign="top">
                        <!--- HEADER OF TABLE --- Host Family Information --->
                        <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" >
                            <tr valign=middle height=24>
                                <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"><img src="../pics/family.gif"></td>
                                <td background="../pics/header_background.gif"><h2>Host Family Information</h2></td><cfif CLIENT.usertype LTE '4'><td background="../pics/header_background.gif"></td></cfif>
                                <td background="../pics/header_background.gif" width=16></td><td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
                        </table>
                        <!--- BODY OF A TABLE --->
                        <table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
                            <tr><td>Family Name:</td><td>#family_info.familylastname#</td><td></td><td></td></tr>
                            <tr><td>Address:</td><td>#family_info.address#</td></tr>
                            <tr><td>City:</td><td><a href="http://en.wikipedia.org/wiki/#family_info.city#%2C_#family_info.state#" target="_blank">#family_info.city# <img src="pics/external_link.png" border=0></a>  <a href="http://maps.google.com/maps?f=q&hl=en&q=#family_info.city#+#family_info.state#&btnG=Search&t=h"> <img src="pics/sat_image.png" border=0></a></td></tr>
                            <tr><td>State:</td><td>
                            <cfquery name="get_state_name" datasource="MySQL">
                            select statename
                            from smg_states
                            where state='#family_info.state#'
                            </cfquery>
                            <a href="http://en.wikipedia.org/wiki/#get_state_name.statename#" target="_blank">#family_info.state# <img src="pics/external_link.png" border=0></a></td><td>ZIP:</td><td>#family_info.zip#</td></tr>
                            <tr><td>Phone:</td><td>#family_info.phone#</td></tr>
                            <tr><td>Email:</td><td><a href="mailto:#family_info.email#">#family_info.email#</a></td></tr>
                            <tr><td>Host Father:</td><td>#family_info.fatherfirstname# #family_info.fatherlastname# &nbsp; <cfif family_info.fatherbirth is '0'><cfelse> <cfset calc_age_father = #CreateDate(family_info.fatherbirth,01,01)#> (#DateDiff('yyyy', calc_age_father, now())#) </cfif></td><td>Occupation:</td><td><cfif family_info.fatherworkposition is ''>n/a<cfelse>#family_info.fatherworkposition#</cfif></td></tr>
                            <tr><td>Host Mother:</td><td>#family_info.motherfirstname# #family_info.motherlastname#  &nbsp; <cfif family_info.motherbirth is '0'><cfelse> <cfset calc_age_mom = #CreateDate(family_info.motherbirth,01,01)#> (#DateDiff('yyyy', calc_age_mom, now())#) </cfif></td><td>Occupation:</td><td><cfif family_info.motherworkposition is ''>n/a<cfelse>#family_info.motherworkposition#</cfif></td></tr>
                        </table>	
                        <!--- BOTTOM OF A TABLE --->
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
                        </table>		
                    </td>
                    <td width="2%"></td> <!--- SEPARATE TABLES --->
                    <td width="38%" align="right" valign="top">
                        <!--- HEADER OF TABLE --- Other Family Members --->
                        <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" >
                            <tr valign=middle height=24>
                                <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"><img src="../pics/family.gif"></td>
                                <td background="../pics/header_background.gif"><h2>Other Family Members</h2></td>
                                <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
                        </table>
                        <!--- BODY OF TABLE --->
                        <table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
                            <tr><td width="40%"><u>Name</u></td>
                                <td width="20%"><u>Sex</u></td>
                                <td width="20%"><u>Age</u></td>
                                <td width="20%"><u>At Home</u></td></tr>
                            <cfloop query="host_children">
                                <tr><td width="40%">#name#</td>
                                    <td width="20%">#sex#</td>
                                    <td width="20%"><cfif birthdate is ''><cfelse>#DateDiff('yyyy', birthdate, now())#</cfif></td>
                                    <td width="20%">#liveathome#</td></tr>
                            </cfloop>
                        </table>
                        <!--- BOTTOM OF A TABLE --->
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
                        </table>		
                    </td></tr>
                    </table><br>
                    
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td width="32%" align="left" valign="top">
                            <!--- HEADER OF TABLE --- COMMUNITY INFO --->
                            <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                                <tr valign=middle height=24>
                                    <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"><img src="../pics/family.gif"></td>
                                    <td background="../pics/header_background.gif"><h2>Community Info</h2></td>
                                    <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
                            </table>
                            <!--- BODY OF TABLE --->
                            <table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
                                <tr><td></td><td colspan="3"></td></tr>
                                <tr><td>Community:</td><td colspan="3"><cfif family_info.community is ''>n/a<cfelse> #family_info.community#</cfif></td></tr>
                                <tr><td>Closest City:</td><td><cfif family_info.nearbigcity is ''>n/a<cfelse> <a href="http://en.wikipedia.org/wiki/#family_info.nearbigcity#" target="_blank">#family_info.nearbigcity# <img src="pics/external_link.png" border=0></a></cfif></td><td>Distance:</td><td>#family_info.near_City_dist# miles</td></tr>
                                <tr><td>Airport Code:</td><td colspan="3"><cfif family_info.major_air_code is ''>n/a<cfelse> <a href="http://www.airnav.com/airport/K#family_info.major_air_code#" target="_blank">#family_info.major_air_code# <img src="pics/external_link.png" border=0></a> <a href="http://maps.google.com/maps?f=q&hl=en&q=#family_info.major_air_code#+airport&btnG=Search&t=k&t=h"><img src=pics/sat_image.png border=0></a></cfif></td></tr>
                                <tr><td>Airport City:</td><td colspan="3"><cfif family_info.airport_city is '' and family_info.airport_state is ''>n/a<cfelse><a href="http://en.wikipedia.org/wiki/#family_info.airport_city#%2C_#family_info.airport_state#" target="_blank">#family_info.airport_city# / #family_info.airport_state# <img src="pics/external_link.png" border=0></a> <a href="http://maps.google.com/maps?f=q&hl=en&q=#family_info.airport_city#+#family_info.airport_state#&btnG=Search&t=h" target="_blank"> <img src="pics/sat_image.png" border=0></a></cfif></td></tr>
                                <tr><td valign="top">Interests: </td><td colspan="3">#family_info.pert_info#</td></tr>
                            </table>				
                            <!--- BOTTOM OF A TABLE  --- COMMUNITY INFO --->
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
                            </table>				
                        </td>
                        <td width="2%"></td> <!--- SEPARATE TABLES --->
                        <td width="28%" align="center" valign="top">
                            <!--- HEADER OF TABLE --- SCHOOL --->
                            <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                                <tr valign=middle height=24>
                                    <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"><img src="../pics/school.gif"></td>
                                    <td background="../pics/header_background.gif"><h2>School Info</h2></td>
                                    <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
                            </table>
                            <!--- BODY OF TABLE --->
                            <table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
                                <tr><td>School:</td><td><cfif get_school.recordcount is '0'>there is no school assigned<cfelse>#get_school.schoolname#</cfif></td></tr>
                                <tr><td>Address:</td><td><cfif get_school.address is ''>n/a<cfelse>#get_school.address#</cfif></td></tr>
                                <tr><td>City:</td><td><cfif get_school.city is '' and get_school.state is ''>n/a<cfelse><a href="http://en.wikipedia.org/wiki/#get_school.city#%2C_#get_school.state#" target="_blank">#get_school.city# / #get_school.state# <img src="pics/external_link.png" border=0></a> <a href="http://maps.google.com/maps?f=q&hl=en&q=#get_school.city#+#get_school.state#&btnG=Search&t=h" target="_blank"> <img src=pics/sat_image.png border=0></a></cfif></td></tr>
                                <tr><td>Start Date:</td><td><cfif get_school.begins is ''>n/a<cfelse>#DateFormat(get_school.begins, 'mm/dd/yyyy')#</cfif></td></tr>
                                <tr><td>End Date:</td><td><cfif get_school.ends is ''>n/a<cfelse>#DateFormat(get_school.ends, 'mm/dd/yyyy')#</cfif></td></tr>			
                                <tr><td>Web Site:</td><td><cfif get_school.url is ''>n/a<cfelse><a href="#get_school.url#" target="_blank">#get_school.url#</a></cfif></td></tr>
                            </table>				
                            <!--- BOTTOM OF A TABLE --- SCHOOL  --->
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
                            </table>		
                        </td>
                        <td width="2%"></td> <!--- SEPARATE TABLES --->
                        <td width="36%" align="right" valign="top">
                                    <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                                <tr valign=middle height=24>
                                    <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td><td width=26 background="../pics/header_background.gif"></td>
                                    <td background="../pics/header_background.gif"><h2>Host Interests</h2></td>
                                    <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td></tr>
                            </table>
                            <!--- BODY OF TABLE --->
                            <table width="100%" border=0 cellpadding=3 cellspacing=0 class="section">
                                <tr><td>
                                <cfloop list="#family_info.interests#" index=i>
                                <cfquery name="interest_label" datasource="mysql">
                                select interest
                                from smg_interests 
                                where interestid = #i#
                                </cfquery>
                                #interest_label.interest#<cfif #i# eq #listlast(family_info.interests)#><cfelse>,</cfif> 
                                </cfloop>
                                </td></tr>
                            </table>				
                            <!--- BOTTOM OF A TABLE --- interests  --->
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td><td width=100% background="../pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
                            </table>		
                        </td>
                    </tr>
                    </table><br>
                </cfif>
            </td>
        </tr>
    </table>
    
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr valign=bottom >
            <td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
            <td width=100% background="../pics/header_background_footer.gif"></td>
            <td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
        </tr>
    </table>
    <!----close tag to not show the profiles for STB---->
</cfif>

</cfoutput>

<!---
	<cfcatch type="any">
		<cfinclude template="error_message.cfm">
	</cfcatch>
</cftry>
--->
		
