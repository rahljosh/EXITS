<!--- ------------------------------------------------------------------------- ----
	
	File:		_paperworkDetails.cfm
	Author:		Marcus Melo
	Date:		October 2nd, 2012
	Desc:		Paperwork Detail Page	
	
	Notes:						
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.subAction" default="">
	<cfparam name="URL.userID" default="0">
	<cfparam name="URL.seasonID" default="0">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.subAction" default="">
    <cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.seasonID" default="0">

	<cfscript>
		// Set FORM.subAction
		if ( LEN(URL.subAction) ) {
			FORM.subAction = URL.subAction;	
		}

		// Set FORM.userID
		if ( VAL(URL.userID) ) {
			FORM.userID = URL.userID;	
		}
		
		// Set FORM.seasonID
		if ( VAL(URL.seasonID) ) {
			FORM.seasonID = URL.seasonID;	
		}
		
        // Get User Information
        qGetUser = APPLICATION.CFC.USER.getUsers(userID=FORM.userID);

		// Get Current User Paperwork Struct
		stUserPaperwork = APPLICATION.CFC.USER.getUserPaperwork(userID=URL.userID);

		// Get Paperwork Info
		qGetSeasonPaperwork = APPLICATION.CFC.USER.getSeasonPaperwork(userID=FORM.userID); // ,getAllRecords=1

        // Get User CBC
        qGetUserCBC = APPLICATION.CFC.CBC.getCBCUserByID(userID=FORM.userID,cbcType='user');
	</cfscript>
	
    <!--- Delete Paperwork --->
	<cfswitch expression="#FORM.subAction#">
    
        <cfcase value="update">
        
            <cfloop From="1" To="#qGetSeasonPaperwork.recordCount#" Index="x">
            	
				<!--- Param FORM Variables --->
                <cfparam name="FORM.ar_agreement_#x#" default="#qGetSeasonPaperwork.ar_agreement#">
                <cfparam name="FORM.ar_ref_quest1_#x#" default="#qGetSeasonPaperwork.ar_ref_quest1#">
                <cfparam name="FORM.ar_ref_quest2_#x#" default="#qGetSeasonPaperwork.ar_ref_quest2#">
                <cfparam name="FORM.ar_training_#x#" default="#qGetSeasonPaperwork.ar_training#">
                <cfparam name="FORM.ar_cbc_auth_form_#x#" default="#qGetSeasonPaperwork.ar_cbc_auth_form#">
                
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                        smg_users_paperwork 
                    SET
                        ar_agreement = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['ar_agreement_' & x]#" null="#NOT IsDate(FORM['ar_agreement_' & x])#">,
						ar_ref_quest1 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['ar_ref_quest1_' & x]#" null="#NOT IsDate(FORM['ar_ref_quest1_' & x])#">,
                        ar_ref_quest2 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['ar_ref_quest2_' & x]#" null="#NOT IsDate(FORM['ar_ref_quest2_' & x])#">,
                        ar_training = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['ar_training_' & x]#" null="#NOT IsDate(FORM['ar_training_' & x])#">,
                        ar_cbc_auth_form = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['ar_cbc_auth_form_' & x]#" null="#NOT IsDate(FORM['ar_cbc_auth_form_' & x])#">
                    WHERE
                        paperworkID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM['paperworkID_' & x]#">
                    AND
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">
                    LIMIT 1
                </cfquery>
                    
            </cfloop>
    
            <cfscript>
                // Add Page Message
                SESSION.pageMessages.Add("Paperwork successfully updated");	
    
                // Refresh Page
                Location("index.cfm?curdoc=user/index&action=paperworkDetails&userID=#FORM.userID#", "no");
            </cfscript>

        </cfcase>        
        
        <cfcase value="delete">
			
            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM
                    smg_users_paperwork
                WHERE
                    seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
                AND
                    userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">
            </cfquery>
                
            <cfscript>
                // Add Page Message
                SESSION.pageMessages.Add("Paperwork successfully deleted");	
    
                // Refresh Page
                Location("index.cfm?curdoc=user/index&action=paperworkDetails&userID=#FORM.userID#", "no");
            </cfscript>
        
        </cfcase>
    
    </cfswitch>
            
    <cfquery name="qGetRegionCompanyAccess" datasource="MySQL">
        SELECT 
        	uar.companyid, 
            uar.regionid, 
            uar.usertype, 
            uar.id, 
            uar.advisorid,
            r.regionname,
            c.companyshort,
            ut.usertype as usertypename, 
            ut.usertypeid,
            adv.firstname, 
            adv.lastname
        FROM 
        	user_access_rights uar
        INNER JOIN 
        	smg_regions r ON r.regionid = uar.regionid
        INNER JOIN 
        	smg_companies c ON c.companyid = uar.companyid
        INNER JOIN 
        	smg_usertype ut ON ut.usertypeid = uar.usertype
        LEFT JOIN 
        	smg_users adv ON adv.userID = uar.advisorid
        WHERE 
        	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">
        ORDER BY 
        	r.regionname
    </cfquery>

</cfsilent>

<style type="text/css">
	.thinBlueBorder {
		border: thin solid #efefef;
		margin-bottom:15px;
	}
</style>

<cfoutput>

	<script type="text/javascript">
        <!-- Begin
        function CheckDates(ckname, frname) {
            if (document.form.elements[ckname].checked) {
                document.form.elements[frname].value = "#DateFormat(now(), 'mm/dd/yyyy')#";
                }
            else { 
                document.form.elements[frname].value = '';  
            }
        }
    
        function zp(n){
            return n<10?("0"+n):n; 
		}
            
		function insertDate(t,format){
            var now=new Date();
            var DD=zp(now.getDate());
            var MM=zp(now.getMonth()+1);
            var YYYY=now.getFullYear();
            var YY=zp(now.getFullYear()%100);
            format=format.replace(/DD/,DD);
            format=format.replace(/MM/,MM);
            format=format.replace(/YYYY/,YYYY);
            format=format.replace(/YY/,YY);
            t.value=format;
		}
		//  End -->
    </script>

	<!--- CHECK RIGHTS --->
    <cfinclude template="../check_rights.cfm">

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        width="90%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        width="90%"
        />
 
    <div class="rdholder"> 
    	
        <div class="rdtop"> 
    		<span class="rdtitle">Paperwork & Account Access</span> 
    	</div> <!-- end top --> 
    	
        <div class="rdbox">

			<!----Header Format Table---->
            <div class="thinBlueBorder">
                <table border=0 cellpadding=8 cellspacing=0 width="100%" >
                    <tr>
                        <td valign="top"><h2>User</h2>#qGetUser.firstname# #qGetUser.lastname# (###qGetUser.userID#)</td>
                        <td valign="top">
                        	<h2>Current Paperwork Status</h2>
							<cfif stUserPaperwork.isAccountCompliant>
                            	<strong>Compliant:</strong> Yes
							<cfelse>
                            	<strong>Compliant:</strong> No (Missing Paperwork)
							</cfif>
                        </td>
                        <td valign="top">
                        	<h2>Current Account Status</h2>
                        	<strong>Active:</strong> #YesNoFormat(VAL(qGetUser.active))#
                            
                            <br />
                        	
                            <strong>Fully Enabled:</strong> #YesNoFormat(VAL(qGetUser.accountCreationVerified))#
                        </td>
                        <td width="150"><a href="index.cfm?curdoc=user_info&userID=#FORM.userID#"><img src="pics/buttons/userProfile.png" border="0" height=40></a></td> 
                    </tr>
                </table>
            </div>

            <!--- Update --->
            <cfform name="form" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#"method="post">
                <cfinput type="hidden" name="userID" value="#FORM.userID#">
                <cfinput type="hidden" name="submittedUserType" value="#qGetRegionCompanyAccess.usertype#">
                <cfinput type="hidden" name="subAction" value="update"> 

                <table cellpadding="4" cellspacing="0" border="0" width="100%">
                    <tr bgcolor="##000000" style="color:##FFFFFF;">
                        <td>Current Season</td>
                        <td align="center">Agreement</td>
                        <cfif NOT stUserPaperwork.isSecondVisitRepresentative>
                            <td align="center">Ref. Questionnaire ##1</td>
                            <td align="center">Ref. Questionnaire ##2</td>
                            <td align="center">AR Training </td>
						</cfif>
                        <td align="center">CBC Authorization </td>
                        <td align="center">CBC Approved</td>
                        <td></td>
                    </tr>
                    
					<cfif NOT VAL(qGetSeasonPaperwork.recordcount)>
                        <tr>
                            <td colspan="8" align="center">No paperwork has been recorded.</td>
                        </tr>
                    </cfif>
                
                    <cfloop query="qGetSeasonPaperwork">
                    
                    	<cfinput type="hidden" name="paperworkid_#currentrow#" value="#paperworkid#">
                    
                        <tr <cfif currentrow mod 2> bgcolor="##eae8e8"</cfif>>
                            <td><strong>#qGetSeasonPaperwork.years#</strong></td>
                            
                            <!--- Editable for Office Users --->
                            <cfif APPLICATION.CFC.USER.isOfficeUser()>

                                <td align="center"><input type="text" name="ar_agreement_#qGetSeasonPaperwork.currentrow#" value="#DateFormat(qGetSeasonPaperwork.ar_agreement, 'mm/dd/yyyy')#" class="datePicker" disabled></td>
                                <cfif NOT stUserPaperwork.isSecondVisitRepresentative>
                                    <td align="center"><input type="text" name="ar_ref_quest1_#qGetSeasonPaperwork.currentrow#" value="#DateFormat(qGetSeasonPaperwork.ar_ref_quest1, 'mm/dd/yyyy')#" class="datePicker" <cfif NOT IsDate(qGetSeasonPaperwork.ar_ref_quest1)>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif>></td>
                                    <td align="center"><input type="text" name="ar_ref_quest2_#qGetSeasonPaperwork.currentrow#" value="#DateFormat(qGetSeasonPaperwork.ar_ref_quest2, 'mm/dd/yyyy')#" class="datePicker" <cfif NOT isDate(qGetSeasonPaperwork.ar_ref_quest2)>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif>></td>
                                    <td align="center"><input type="text" name="ar_training_#qGetSeasonPaperwork.currentrow#"  value="#DateFormat(qGetSeasonPaperwork.ar_training, 'mm/dd/yyyy')#" class="datePicker" disabled></td>
                                </cfif>
                                <td align="center"><input type="text" name="ar_cbc_auth_form_#qGetSeasonPaperwork.currentrow#" value="#DateFormat(qGetSeasonPaperwork.ar_cbc_auth_form, 'mm/dd/yyyy')#" class="datePicker" disabled></td>
                                <td align="center">
									<cfif NOT LEN(qGetUserCBC.requestID)>
                                        <a href="index.cfm?curdoc=cbc/users_cbc&userID=#FORM.userID#&return=paperwork">CBC hasn't run</a>
                                    <cfelse>
                                        <a href="javascript:openPopUp('cbc/displayCBC.cfm?view=approve&userID=#qGetUserCBC.userID#&cbcID=#qGetUserCBC.cbcID#&file=batch_#qGetUserCBC.batchID#_user_#qGetUserCBC.userID#_rec.xml', 750, 775);">
											<cfif qGetUserCBC.flagcbc eq 1>
                                                <img src="pics/buttons/warning.png" height=15 width=15 /> Flagged
                                            <cfelseif isDate(qGetUserCBC.denied)>
                                                <img src="pics/buttons/denied.png" height=15 width=15 /> Denied &nbsp;
                                            <cfelseif isDate(qGetUserCBC.date_approved)>
                                                #DateFormat(qGetUserCBC.date_approved, 'mm/dd/yyyy')#
                                            <cfelse>
                                                Required
                                            </cfif>
                                        </a>
                                    </cfif>
                                </td>
                                <td><a href="index.cfm?curdoc=user/index&action=paperworkDetails&subAction=delete&userID=#qGetSeasonPaperwork.userID#&seasonID=#qGetSeasonPaperwork.seasonID#" title="Delete Season"><img src="pics/x.png" height="20" border="0"></a></td>
                            
							<!--- Read Only --->
                            <cfelse>
                            	
                                <td align="center">#DateFormat(qGetSeasonPaperwork.ar_agreement, 'mm/dd/yyyy')#</td>
                                <cfif NOT stUserPaperwork.isSecondVisitRepresentative>
                                    <td align="center">#DateFormat(qGetSeasonPaperwork.ar_ref_quest1, 'mm/dd/yyyy')#</td>
                                    <td align="center">#DateFormat(qGetSeasonPaperwork.ar_ref_quest2, 'mm/dd/yyyy')#</td>
                                    <td align="center">#DateFormat(qGetSeasonPaperwork.ar_training, 'mm/dd/yyyy')#</td>
                                </cfif>
                                <td align="center">#DateFormat(qGetSeasonPaperwork.ar_cbc_auth_form, 'mm/dd/yyyy')#</td>
                                <td align="center">
									<cfif NOT LEN(qGetUserCBC.requestID)>
                                        CBC hasn't run
                                    <cfelse>                                        
										<cfif qGetUserCBC.flagcbc eq 1>
                                            <img src="pics/buttons/warning.png" height=15 width=15 /> Flagged
                                        <cfelseif isDate(qGetUserCBC.denied)>
                                            <img src="pics/buttons/denied.png" height=15 width=15 /> Denied &nbsp;
                                        <cfelseif isDate(qGetUserCBC.date_approved)>
                                            #DateFormat(qGetUserCBC.date_approved, 'mm/dd/yyyy')#
                                        <cfelse>
                                            Required
                                        </cfif>
                                    </cfif>
                                </td>
                                <td>&nbsp;</td>
                            
							</cfif>
                            
                        </tr>
                    </cfloop>
                    
					<cfif APPLICATION.CFC.USER.isOfficeUser()>
                        <tr>
                        	<td colspan="8" align="center"><input type="image" src="pics/buttons/update_44.png" /></td>
                        </tr>
                    </cfif>
                    
				</table>
            
            </cfform>
    
		</div>
		
		<div class="rdbottom"></div> <!-- end bottom --> 

	</div>
    
</cfoutput>    