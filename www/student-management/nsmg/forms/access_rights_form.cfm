<!--- ------------------------------------------------------------------------- ----
	
	File:		access_rights_FORM.cfm
	Author:		Marcus Melo
	Date:		January 14, 2010
	Desc:		Inserts/Edits User Access Rights

	Updated:  	01/14/2010 - Editing Current Region Assigned

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param URL Variables --->
	<cfparam name="URL.ID" default="">
	<cfparam name="URL.userID" default="">
    <cfparam name="URL.companyID" default="">

	<!--- Param FORM Variables --->
	<cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.advisorID" default="0">

	<!--- coming from user_info.cfm with cflocation forcing entry of a Company & Regional Access record record. --->
    <cfparam name="FORM.force" default="0">
    
    <!--- after submit, if usertype 7 we return to this form with the "reports to" selection. --->
    <cfparam name="FORM.advisor" default="0">
    
    <!--- coming from user_FORM.cfm after adding a new user.  used to set the user_access_rights.default_access field and disable Access Level. --->
    <cfparam name="FORM.new_user" default="0">

    <cfparam name="FORM.region_disabled" default="">
    <cfparam name="FORM.access_disabled" default="">
    
    <cfscript>
		if ( NOT LEN(URL.ID) ) {
			new = true;
		} else {
			new = false;	
		}
	
		field_list = 'companyid,regionid,usertype,advisorID';
		
		// Stores errorMsgs
		errorMsg = '';	
	</cfscript>

	<cfif ListFind("1,2,3,4", CLIENT.userType)>
    
        <cfquery name="qGetRegions" datasource="#APPLICATION.DSN#">
            SELECT 
                regionid, 
                CONVERT( CONCAT(regionname,' (',regionid,')') USING latin1) AS region
            FROM 
                smg_regions
            WHERE 
                <cfif VAL(URL.companyID)>
                    company = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.companyID#">
                <cfelse>            
                    company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                </cfif> 
            AND	
            	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">               
            ORDER BY 
                regionname,
                regionid
        </cfquery>

	<cfelse>
    
        <cfquery name="qGetRegions" datasource="#APPLICATION.DSN#">
            SELECT 
                r.regionid, 
                CONVERT( CONCAT(regionname,' (',r.regionid,')') USING latin1) AS region
            FROM 
                smg_regions r
            INNER JOIN
            	user_access_rights uar ON r.regionID = uar.regionID
            WHERE 
                uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#"> 
            AND
            	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userType#"> 
            AND	
            	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">    
                           
			<cfif VAL(URL.companyID)>
                AND 
                    uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.companyID#">
            <cfelse>   
                AND 
                    uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            </cfif>  
                
            ORDER BY 
                r.regionname,
                r.regionid
        </cfquery>
    
    </cfif>

    <!--- Form Submitted --->
    <cfif VAL(FORM.submitted)>
    
		<!--- special submit for forced hard coded users. --->
        <cfif isDefined("FORM.hard_coded_user_submitted")>
        
            <cfquery datasource="#APPLICATION.DSN#">
                INSERT INTO 
                	user_access_rights 
                (
                	userid, 
                    companyid, 
                    usertype, 
                    default_access
                )
                VALUES 
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">,
					<!--- CASE, WEP, Canada and ESI --->
                    <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                    <cfelse>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                    </cfif>    
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertypeid#">,
                	<cfqueryparam cfsqltype="cf_sql_integer" value="1">
                )
            </cfquery>
          
        	<cflocation url="index.cfm?curdoc=user_info&userid=#URL.userID#" addtoken="No">
        
        </cfif> <!--- special submit for forced hard coded users. --->
       
		<cfscript>
			// Data Validation
			if ( NOT LEN(FORM.regionid) ) {
				errorMsg = "Please select a Region.";
			}
		
			if ( NOT LEN(FORM.usertype) ) {
				errorMsg = "Please select an Access Level.";
			}
		</cfscript>
    	
    	<!--- No Errors / Check for Access --->
        <cfif NOT LEN(errorMsg)>
    
            <cfquery name="qCheckAccess" datasource="#APPLICATION.DSN#">
                SELECT 
                	id
                FROM 
                	user_access_rights
                WHERE 
                	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
                AND 
                	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
                <cfif NOT new>
                	AND id != <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
                </cfif>
            </cfquery>
            
			<cfscript>
                // Data Validation
                if ( VAL(qCheckAccess.recordcount) ) {
                    errorMsg = "Sorry, an access level with this region has already been entered for this user.";
                }
            </cfscript>
            
        </cfif>  <!--- No Errors / Check for Access --->     

		<!--- No Errors --->
        <cfif NOT LEN(errorMsg)>
        
			<!--- Area Rep and 2nd Visit Rep get the "reports to" selection.  Don't do after "reports to" was displayed and form submitted the second time. --->
            <cfif ListFind("7,15", FORM.userType) AND NOT FORM.advisor>
        
        		<cfscript>
					// display the "reports to" selection.
					FORM.advisor = 1;
				
					// disable the region and access level selections.
					FORM.region_disabled = 'disabled';
					FORM.access_disabled = 'disabled';
				</cfscript>
        	
            <!--- New User --->
			<cfelseif new>
            
                <cfquery datasource="#APPLICATION.DSN#">
                    INSERT INTO 
                    	user_access_rights 
                    (
                    	userid, 
                        companyid, 
                        regionid, 
                        usertype, 
                        advisorID, 
                        default_access
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertype#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.advisorID#">,
                        <!--- for a new user or forcing entry for user without a record, 
						this is their first user_access_rights record, so need to set it as the default. --->
                        <cfif FORM.new_user OR FORM.force>
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        <cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        </cfif>
                    )
                </cfquery>
                
				<cfif listFind("1,2,3,4,5,12", CLIENT.companyID) AND ListFind("6,7", FORM.usertype)>
        	   
                    <cfquery name="newUserInfo" datasource="#APPLICATION.DSN#">
                        select 
                            u.firstname, u.lastname, u.email, u.address, u.address2, u.city, u.state, u.zip, u.phone, u.email
                        from 
                            smg_users u 
                        where 
                            userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
                    </cfquery>
                   
                    <cfquery name="userType" datasource="#APPLICATION.DSN#">
                        select 
                            usertype
                        from 
                            smg_usertype
                        where 
                            usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertype#">
                    </cfquery>
               
                    <cfquery name="regionalManager" datasource="#APPLICATION.DSN#">
                        select 
                            u.email, u.firstname
                        from 
                            smg_users u
                        left join 
                            user_access_rights uar on uar.userid = u.userid
                        where 
                            uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
                        and 
                            uar.usertype = 5
                    </cfquery>
               
                   <cfsavecontent variable="email_message">
                       <cfoutput>
                           The following rep was just added to the database:<br /><Br />
                           
                           Userype: <strong>#usertype.usertype#</strong><Br />
                           Program Manager: <strong>#CLIENT.programmanager#</strong><br />
                           <Br />
                           #newUserInfo.firstname# #newUserInfo.lastname# (#url.userID#)<br />
                           #newUserInfo.address#<br />
                           <cfif newUserInfo.address2 is not ''>
                           #newUserInfo.address2#<br />
                           </cfif>
                           #newUserInfo.city# #newUserInfo.state#, #newUserInfo.zip#
                           <br /><br />
                           Email: #newUserInfo.email#<br />
                           Phone: #newUserInfo.phone#<br />
                       </cfoutput>
                   </cfsavecontent>
                
					<!--- send email --->
                    <cfinvoke component="nsmg.cfc.email" method="send_mail">
                        <cfinvokeargument name="email_to" value="megan@iseusa.com">
                        <cfif isValid("email", regionalManager.email)>
                            <cfinvokeargument name="email_cc" value=" #regionalManager.email#">
                        </cfif>
                        <cfinvokeargument name="email_subject" value="New Rep Added">
                        <cfinvokeargument name="email_message" value="#email_message#">
                        <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                    </cfinvoke>
                    
            	</cfif>
            
        		<cflocation url="index.cfm?curdoc=user_info&userid=#URL.userID#" addtoken="No">
                
			<!--- edit --->
            <cfelse>
            
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                    	user_access_rights 
                    SET
                        regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertype#">,
                        advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.advisorID#">
                    WHERE 
                    	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
                </cfquery>
                
				<cfif listFind("1,2,3,4,5,12", CLIENT.companyID) AND ListFind("6,7", FORM.usertype)>

                    <cfquery name="newUserInfo" datasource="#APPLICATION.DSN#">
                        select 
                        	u.firstname, u.lastname, u.email, u.address, u.address2, u.city, u.state, u.zip, u.phone, u.email
                        from 
                        	smg_users u 
                        where 
                        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
                    </cfquery>

                    <cfquery name="userType" datasource="#APPLICATION.DSN#">
                        select 
                        	usertype
                        from 
                        	smg_usertype
                        where 
                        	usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertype#">
                    </cfquery>
                     
                    <cfsavecontent variable="email_message">
                    
						<cfoutput>
                            The following rep was just added to the database:<br /><Br />
                            
                            Userype: <strong>#usertype.usertype#</strong><Br />
                            Program Manager: <strong>#CLIENT.programmanager#</strong><br />
                            <Br />
                            #newUserInfo.firstname# #newUserInfo.lastname# (#url.userID#)<br />
                            #newUserInfo.address#<br />
                            <cfif newUserInfo.address2 is not ''>
                            #newUserInfo.address2#<br />
                            </cfif>
                            #newUserInfo.city# #newUserInfo.state#, #newUserInfo.zip#
                            <br /><br />
                            Email: #newUserInfo.email#<br />
                            Phone: #newUserInfo.phone#<br />
                        </cfoutput>
                        
                    </cfsavecontent>
                    
                    <!--- send email --->
                    <cfinvoke component="nsmg.cfc.email" method="send_mail">
                       <cfinvokeargument name="email_to" value="megan@iseusa.com">
                        <cfinvokeargument name="email_subject" value="New Rep Added">
                        <cfinvokeargument name="email_message" value="#email_message#">
                        <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                    </cfinvoke>
			
				</cfif>
                
        		<cflocation url="index.cfm?curdoc=user_info&userid=#URL.userID#" addtoken="No">
        	
            </cfif> <!--- Area Rep and 2nd Visit Rep get the "reports to" selection.  Don't do after "reports to" was displayed and form submitted the second time. --->
        
        </cfif> <!--- No Errors --->
        
	<!--- add | FORM.submitted --->
    <cfelseif new> 
        
        <cfloop list="#field_list#" index="counter">        
            <cfset "FORM.#counter#" = "">
        </cfloop>
            
		<cfscript>
            FORM.companyid = CLIENT.companyid;
            FORM.advisorID = 0;
            
            // we're coming from user_FORM.cfm after adding a new user.  set FORM.new_user from URL.new_user, and others.
			if ( isDefined("URL.new_user") ) {
				FORM.new_user = 1;
				FORM.usertype = URL.usertype;
				FORM.access_disabled = 'disabled';
			}
        	
			// coming from user_info.cfm. set FORM.force from URL.force
			if ( isDefined("URL.force") ) {
				FORM.force = 1;
			}
        </cfscript>
        
	<!--- edit | FORM.submitted --->
    <cfelseif NOT new>
        
        <cfquery name="qGetRecord" datasource="#APPLICATION.DSN#">
            SELECT 
            	*
            FROM 
            	user_access_rights
            WHERE 
            	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
        </cfquery>
        
        <cfloop list="#field_list#" index="counter">
        	<cfset "FORM.#counter#" = evaluate("qGetRecord.#counter#")>
        </cfloop>
        
		<cfscript>
			// userid is passed in the url for a new record, but set it for edit.
			URL.userID = qGetRecord.userid;
		</cfscript>
    
    </cfif> <!--- FORM.submitted --->
    
</cfsilent>

<script type="text/javascript">
	function checkForm() {
		if (document.my_FORM.regionid.value.length == 0) {alert("Please select a Region."); return false; }
		if (document.my_FORM.usertype.value.length == 0) {alert("Please select an Access Level."); return false; }
		return true;
	}
</script>

<!--- CHECK RIGHTS - put here since URL.userID is required and it's set above on edit. --->
<!---  11/23/10 - Allowing advisors to add an user
	<cfinclude template="../check_rights.cfm">
--->

<cfoutput>

<cfif CLIENT.usertype GT 6>
	<p>You do not have access to this page.</p>
    <cfabort>
</cfif>

<cfif LEN(URL.ID) AND NOT isNumeric(URL.ID)>
	<p>A numeric id is required to edit an Access record.</p>
	<cfabort>
</cfif>

<cfif LEN(errorMsg)>
	<script language="JavaScript">
        alert('#errorMsg#');
    </script>
</cfif>

<!--- this table is so the form is not 100% width. --->
<table align="center">
	<tr>
    	<td>

			<!--- header of the table --->
            <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/usa.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Program Manager & Regional Access</h2></td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
    
            <cfif FORM.force>
            
                <cfquery name="qRepInfo" datasource="#APPLICATION.DSN#">
                    SELECT 
                        smg_companies.team_id, 
                        smg_usertype.usertypeid, 
                        smg_usertype.usertype
                    FROM 
                        smg_users
                    LEFT JOIN 
                        smg_companies ON smg_users.defaultcompany = smg_companies.companyid
                    LEFT JOIN 
                        smg_usertype ON smg_users.usertype = smg_usertype.usertypeid
                    WHERE 
                        userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
                </cfquery>
                
                <!--- these usertypes are hard coded and don't get the form selections. --->
                <cfif listFind("8,11,13", qRepInfo.usertypeid)>
                    <cfset hard_coded_user = 1>
                </cfif>
                
                <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                    <tr>
                        <td>
                            This user has no Company & Regional Access record assigned.<br />
                            One must be assigned first before access to the user is allowed.<br />
                            The current information for this user is:<br /><br />
                            <table border=0 cellpadding=2 cellspacing=0>
                                <tr>
                                    <td class="label">Program Manager:</td>
                                    <td>#qRepInfo.team_id#</td>
                                </tr>
                                <tr>
                                    <td class="label">Access level:</td>
                                    <td>#qRepInfo.usertype#</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            
            </cfif>
    
            <cfform name="my_form" action="index.cfm?curdoc=forms/access_rights_form&id=#URL.ID#&companyID=#URL.companyID#&userid=#URL.userID#" method="post" onSubmit="return checkForm();">
            <input type="hidden" name="submitted" value="1">
            <input type="hidden" name="force" value="#FORM.force#">
            <input type="hidden" name="advisor" value="#FORM.advisor#">
            <input type="hidden" name="new_user" value="#FORM.new_user#">
    		
            <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                <tr>
                    <td>
    
                        <!--- this is set in the "force" section above for an international user. --->
                        <cfif isDefined("hard_coded_user")>
                        
                            <input type="hidden" name="hard_coded_user_submitted" value="1">
                            <input type="hidden" name="usertypeid" value="#qRepInfo.usertypeid#">
                            
                            <p>Click "Submit" to add the following Company & Regional Access information.</p>
                            <table border=0 cellpadding=4 cellspacing=0>
                                <tr>
                                    <td class="label">Program Manager:</td>
                                    <td>
                                        <!--- all hard coded users get the same company and not their current company. --->
                                        <cfquery name="qGetCompany" datasource="#APPLICATION.DSN#">
                                            SELECT 
                                                team_id
                                            FROM 
                                                smg_companies
                                            WHERE 
                                            <!--- CASE, WEP, Canada and ESI --->
                                            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
                                                companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                                            <cfelse>
                                                companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                                            </cfif>    
                                        </cfquery>
                                        #qGetCompany.team_id#  
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Access Level:</td>
                                    <td>#qRepInfo.usertype#</td>
                                </tr>
                            </table>
                        
                        <cfelse>
    
                            <span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
                            <table border=0 cellpadding=4 cellspacing=0>
                                <tr>
                                    <td class="label">Program Manager:</td>
                                    <td>
                                        <cfquery name="qGetCompany" datasource="#APPLICATION.DSN#">
                                            SELECT 
                                                team_id
                                            FROM 
                                                smg_companies
                                            WHERE 
                                                companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">
                                        </cfquery>
                                        #qGetCompany.team_id#
                                        <input type="hidden" name="companyid" value="#FORM.companyid#">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Region: <span class="redtext">*</span></td>
                                    <td>
                                        <cfselect name="regionid" query="qGetRegions" value="regionid" display="region" selected="#FORM.regionid#" queryPosition="below" disabled="#FORM.region_disabled#"></cfselect>   
                                             
                                        <cfif LEN(FORM.region_disabled)>
                                            <input type="hidden" name="regionid" value="#FORM.regionid#">
                                        </cfif>
                                        
                                        <input type="hidden" name="region_disabled" value="#FORM.region_disabled#">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Access Level: <span class="redtext">*</span></td>
                                    <td>
                                        <cfquery name="qGetUserTypes" datasource="#APPLICATION.DSN#">
                                            SELECT 
                                                usertypeid, 
                                                usertype
                                            FROM 
                                                smg_usertype
                                            <!--- don't include international since those are added automatically when adding a new user. --->
                                            <!--- include international rep --->
                                            WHERE 
                                                usertypeid IN (1,2,3,4,5,6,7,8,9)
                                            <cfif CLIENT.usertype GT 4>
                                            AND 
                                                usertypeid > <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
                                            <cfelse>
                                            AND 
                                                usertypeid >= <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
                                            OR 
                                            	usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="15">
                                            </cfif>
                                            ORDER BY 
                                                usertypeid
                                        </cfquery>
                                        
                                        <cfselect name="usertype" query="qGetUserTypes" value="usertypeid" display="usertype" selected="#FORM.usertype#" queryPosition="below" disabled="#FORM.access_disabled#">
                                            <option value=""></option>
                                        </cfselect>
                                        
                                        <cfif LEN(FORM.access_disabled)>
                                            <cfinput type="hidden" name="usertype" value="#FORM.usertype#">
                                        </cfif>
                                        
                                        <cfinput type="hidden" name="access_disabled" value="#FORM.access_disabled#">
                                    </td>
                                </tr>
        
                                <cfif FORM.advisor>
                                    <tr>
                                        <td class="label">Reports To:</td>
                                        <td>
                                            <cfquery name="qGetAdvisors" datasource="#APPLICATION.DSN#">
                                                SELECT 
                                                    u.userid, 
                                                    CONCAT(u.firstname,' ',u.lastname) AS advisorname
                                                FROM 
                                                    user_access_rights uar
                                                INNER JOIN 
                                                    smg_users u ON uar.userid = u.userid
                                                WHERE 
                                                    uar.usertype = 6
                                                AND 
                                                    uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
                                                <cfif CLIENT.userType EQ 6>
                                                	AND
                                                    	uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                                                </cfif>
                                                ORDER BY 
                                                    firstname
                                            </cfquery>
                                                                
                                            <cfselect NAME="advisorID" query="qGetAdvisors" value="userid" display="advisorname" selected="#FORM.advisorID#" queryPosition="below">
                                                <cfif CLIENT.userType NEQ 6>
	                                                <option value="0">Directly to Director</option>
                                                </cfif>
                                            </cfselect>        
                                        </td>
                                    </tr>
                                <cfelse>
                                    <cfinput type="hidden" name="advisorID" value="#FORM.advisorID#">
                                </cfif>
                            </table>
    
                        </cfif> <!--- isDefined("hard_coded_user") --->
    
                    </td>
                </tr>
            </table>
    
            <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
                <tr>
                    <cfif not new>
                        <cfquery name="qCheckAccess" datasource="#APPLICATION.DSN#">
                            SELECT 
                                user_access_rights.userid
                            FROM 
                                user_access_rights
                            INNER JOIN 
                                smg_companies ON user_access_rights.companyid = smg_companies.companyid
                            WHERE 
                                smg_companies.website = <cfqueryparam cfsqltype="cf_sql_varchar" value="SMG">
                            AND 
                                user_access_rights.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
                        </cfquery>
                        
                        <!--- don't allow delete if user has only one record. --->
                        <cfif qCheckAccess.recordcount GT 1>
                            <td><a href="index.cfm?curdoc=user_info&action=delete_uar&id=#URL.ID#&userid=#URL.userID#" onClick="return confirm('Are you sure you want to delete this Company & Regional Access record?')"><img src="pics/delete.gif" border="0"></a></td>
                        </cfif>
                    </cfif>
                    <td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
                </tr>
            </table>
            
            </cfform>
    
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign=bottom >
                    <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
                    <td width=100% background="pics/header_background_footer.gif"></td>
                    <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
                </tr>
            </table>

		</td>
	</tr>
</table>
<!--- this table is so the form is not 100% width. --->

</cfoutput>

