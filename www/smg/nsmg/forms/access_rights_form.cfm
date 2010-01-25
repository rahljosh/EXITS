<!--- ------------------------------------------------------------------------- ----
	
	File:		access_rights_form.cfm
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
        
	<!--- coming from user_info.cfm with cflocation forcing entry of a Company & Regional Access record record. --->
    <cfparam name="FORM.force" default="0">
    
    <!--- after submit, if usertype 7 we return to this form with the "reports to" selection. --->
    <cfparam name="FORM.advisor" default="0">
    
    <!--- coming from user_form.cfm after adding a new user.  used to set the user_access_rights.default_access field and disable Access Level. --->
    <cfparam name="FORM.new_user" default="0">

    <cfparam name="FORM.region_disabled" default="">
    <cfparam name="FORM.access_disabled" default="">
    
    <cfscript>
		if ( NOT LEN(URL.ID) ) {
			new = true;
		} else {
			new = false;	
		}
	
		field_list = 'companyid,regionid,usertype,advisorid';
		
		// Stores errorMsgs
		errorMsg = '';	
	</cfscript>

	<cfif CLIENT.userType LTE 4>
    
        <cfquery name="qGetRegions" datasource="#application.dsn#">
            SELECT 
                regionid, 
                CONCAT(regionname,' (',regionid,')') AS region
            FROM 
                smg_regions
            WHERE 
                <cfif VAL(URL.companyID)>
                    company = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.companyID#">
                <cfelse>            
                    company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                </cfif>                
            ORDER BY 
                regionname,
                regionid
        </cfquery>

	<cfelse>
    
        <cfquery name="qGetRegions" datasource="#application.dsn#">
            SELECT 
                r.regionid, 
                CONCAT(r.regionname,' (',r.regionid,')') AS region
            FROM 
                smg_regions r
            INNER JOIN
            	user_access_rights uar ON r.regionID = uar.regionID
            WHERE 
                uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#"> 
            AND
            	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5"> 
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
        
            <cfquery datasource="#application.dsn#">
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
                	<cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertypeid#">,
                	<cfqueryparam cfsqltype="cf_sql_integer" value="1">
                )
            </cfquery>
            
        	<cflocation url="index.cfm?curdoc=user_info&userid=#URL.userID#" addtoken="No">
        
        </cfif>
       
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
    
            <cfquery name="qCheckAccess" datasource="#application.dsn#">
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
            
        </cfif>        

		<!--- No Errors --->
        <cfif NOT LEN(errorMsg)>
        
			<!--- usertype 7 gets the "reports to" selection.  Don't do after "reports to" was displayed and form submitted the second time. --->
            <cfif FORM.usertype EQ 7 AND NOT FORM.advisor>
        
        		<cfscript>
					// display the "reports to" selection.
					FORM.advisor = 1;
				
					// disable the region and access level selections.
					FORM.region_disabled = 'disabled';
					FORM.access_disabled = 'disabled';
				</cfscript>
        
			<cfelseif new>
            
                <cfquery datasource="#application.dsn#">
                    INSERT INTO 
                    	user_access_rights 
                    (
                    	userid, 
                        companyid, 
                        regionid, 
                        usertype, 
                        advisorid, 
                        default_access
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.companyid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertype#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.advisorid#">,
                        <!--- for a new user or forcing entry for user without a record, 
						this is their first user_access_rights record, so need to set it as the default. --->
                        <cfif FORM.new_user OR FORM.force>
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        <cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        </cfif>
                    )
                </cfquery>
                
        		<cflocation url="index.cfm?curdoc=user_info&userid=#URL.userID#" addtoken="No">
                
			<!--- edit --->
            <cfelse>
            
                <cfquery datasource="#application.dsn#">
                    UPDATE 
                    	user_access_rights 
                    SET
                        regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertype#">,
						<!--- if not usertype 7, set advisorid to 0 in case they had one before and the access level was changed. --->
                        <cfif FORM.usertype NEQ 7>
                        	advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        <cfelse>
                        	advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.advisorid#">
                        </cfif>
                    WHERE 
                    	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
                </cfquery>
                
        		<cflocation url="index.cfm?curdoc=user_info&userid=#URL.userID#" addtoken="No">
        	
            </cfif>
        
        </cfif>
        
	<!--- add --->
    <cfelseif new>
        
        <cfloop list="#field_list#" index="counter">        
            <cfset "FORM.#counter#" = "">
        </cfloop>
            
		<cfscript>
            FORM.companyid = CLIENT.companyid;
            FORM.advisorid = 0;
            
            // we're coming from user_form.cfm after adding a new user.  set FORM.new_user from URL.new_user, and others.
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
        
	<!--- edit --->
    <cfelseif NOT new>
        
        <cfquery name="qGetRecord" datasource="#application.dsn#">
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
		if (document.my_form.regionid.value.length == 0) {alert("Please select a Region."); return false; }
		if (document.my_form.usertype.value.length == 0) {alert("Please select an Access Level."); return false; }
		return true;
	}
</script>

<!--- CHECK RIGHTS - put here since URL.userID is required and it's set above on edit. --->
<cfinclude template="../check_rights.cfm">

<cfoutput>

<cfif NOT CLIENT.usertype LTE 5>
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
            
                <cfquery name="qRepInfo" datasource="#application.dsn#">
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
                                        <cfquery name="qGetCompany" datasource="#application.dsn#">
                                            SELECT 
                                                team_id
                                            FROM 
                                                smg_companies
                                            WHERE 
                                                companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
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
                                        <cfquery name="qGetCompany" datasource="#application.dsn#">
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
                                        <cfselect name="regionid" query="qGetRegions" value="regionid" display="region" selected="#FORM.regionid#" queryPosition="below" disabled="#FORM.region_disabled#">
                                            <option value=""></option>
                                        </cfselect>   
                                             
                                        <cfif LEN(FORM.region_disabled)>
                                            <input type="hidden" name="regionid" value="#FORM.regionid#">
                                        </cfif>
                                        
                                        <input type="hidden" name="region_disabled" value="#FORM.region_disabled#">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Access Level: <span class="redtext">*</span></td>
                                    <td>
                                        <cfquery name="qGetUserTypes" datasource="#application.dsn#">
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
                                            <cfquery name="qGetAdvisors" datasource="#application.dsn#">
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
                                                ORDER BY 
                                                    firstname
                                            </cfquery>
                                                                
                                            <cfselect NAME="advisorid" query="qGetAdvisors" value="userid" display="advisorname" selected="#FORM.advisorid#" queryPosition="below">
                                                <option value="0">Directly to Director</option>
                                            </cfselect>        
                                        </td>
                                    </tr>
                                <cfelse>
                                    <cfinput type="hidden" name="advisorid" value="#FORM.advisorid#">
                                </cfif>
                            </table>
    
                        </cfif> <!--- isDefined("hard_coded_user") --->
    
                    </td>
                </tr>
            </table>
    
            <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
                <tr>
                    <cfif not new>
                        <cfquery name="qCheckAccess" datasource="#application.dsn#">
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

