<cfif not client.usertype LTE 4>
	You do not have access to this page.
    <cfabort>
</cfif>

<cfparam name="url.id" default="">
<cfif url.id EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(url.id)>
        a numeric id is required to edit an Access record.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfif new>
	<cfparam name="url.userid" default="">
	<cfif not isNumeric(url.userid)>
        a numeric userid is required to add a new Access record.
        <cfabort>
	</cfif>
</cfif>

<!--- coming from user_info.cfm with cflocation forcing entry of a Company & Regional Access record record. --->
<cfparam name="form.force" default="0">

<!--- after submit, if usertype 7 we return to this form with the "reports to" selection. --->
<cfparam name="form.advisor" default="0">

<!--- coming from user_form.cfm after adding a new user.  used to set the user_access_rights.default_access field and disable Access Level. --->
<cfparam name="form.new_user" default="0">

<cfset field_list = 'companyid,regionid,usertype,advisorid'>
<cfset errorMsg = ''>

<cfparam name="form.region_disabled" default="">
<cfparam name="form.access_disabled" default="">

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
    
    <!--- special submit for forced hard coded users. --->
    <cfif isDefined("form.hard_coded_user_submitted")>
        <cfquery datasource="#application.dsn#">
            INSERT INTO user_access_rights (userid, companyid, usertype, default_access)
            VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">,
            5,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.usertypeid#">,
            1
            )
        </cfquery>
        <cflocation url="index.cfm?curdoc=user_info&userid=#url.userid#" addtoken="No">
    </cfif>
    
	<cfif trim(form.regionid) EQ ''>
		<cfset errorMsg = "Please select the Region.">
	<cfelseif trim(form.usertype) EQ ''>
		<cfset errorMsg = "Please select the Access Level.">
	</cfif>
    <cfif errorMsg EQ ''>
        <cfquery name="check_access" datasource="#application.dsn#">
            SELECT id
            FROM user_access_rights
            WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.regionid#">
            AND userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
            <cfif not new>
                AND id <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
            </cfif>
        </cfquery>
		<cfif check_access.recordcount NEQ 0>
            <cfset errorMsg = "Sorry, an access level with this region has already been entered for this user.">
        </cfif>
	</cfif>        
    <cfif errorMsg EQ ''>
		<!--- usertype 7 gets the "reports to" selection.  Don't do after "reports to" was displayed and form submitted the second time. --->
        <cfif form.usertype EQ 7 and not form.advisor>
            <!--- display the "reports to" selection. --->
            <cfset form.advisor = 1>
            <!--- disable the region and access level selections. --->
            <cfset form.region_disabled = 'disabled'>
            <cfset form.access_disabled = 'disabled'>
		<cfelseif new>
            <cfquery datasource="#application.dsn#">
                INSERT INTO user_access_rights (userid, companyid, regionid, usertype, advisorid, default_access)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.companyid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.regionid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.usertype#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.advisorid#">,
                <!--- for a new user or forcing entry for user without a record, this is their first user_access_rights record, so need to set it as the default. --->
                <cfif form.new_user or form.force>1<cfelse>0</cfif>
                )
            </cfquery>
            <cflocation url="index.cfm?curdoc=user_info&userid=#url.userid#" addtoken="No">
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE user_access_rights SET
                regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.regionid#">,
                usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.usertype#">,
                <!--- if not usertype 7, set advisorid to 0 in case they had one before and the access level was changed. --->
				<cfif form.usertype NEQ 7>
                	advisorid = 0
                <cfelse>
                    advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.advisorid#">
                </cfif>
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
			</cfquery>
            <cflocation url="index.cfm?curdoc=user_info&userid=#url.userid#" addtoken="No">
		</cfif>
	</cfif>

<!--- add --->
<cfelseif new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = "">
	</cfloop>
    
    <cfset form.companyid = client.companyid>
    <cfset form.advisorid = 0>
    
    <!--- we're coming from user_form.cfm after adding a new user.  set form.new_user from url.new_user, and others. --->
    <cfif isDefined("url.new_user")>
	    <cfset form.new_user = 1>
	    <cfset form.usertype = url.usertype>
    	<cfset form.access_disabled = 'disabled'>
    </cfif>

	<!--- coming from user_info.cfm.  set form.force from url.force --->
    <cfif isDefined("url.force")>
	    <cfset form.force = 1>
    </cfif>

<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM user_access_rights
		WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
    <!--- userid is passed in the url for a new record, but set it for edit. --->
    <cfset url.userid = get_record.userid>

</cfif>

<!--- CHECK RIGHTS - put here since url.userid is required and it's set above on edit. --->
<cfinclude template="../check_rights.cfm">

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
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

<cfif form.force>

    <cfquery name="rep_info" datasource="#application.dsn#">
        SELECT smg_companies.team_id, smg_usertype.usertypeid, smg_usertype.usertype
        FROM smg_users
        LEFT JOIN smg_companies ON smg_users.defaultcompany = smg_companies.companyid
        LEFT JOIN smg_usertype ON smg_users.usertype = smg_usertype.usertypeid
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </cfquery>
    
    <!--- these usertypes are hard coded and don't get the form selections. --->
    <cfif listFind("8,11,13", rep_info.usertypeid)>
        <cfset hard_coded_user = 1>
    </cfif>
    
    <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
        <tr><td>
        	This user has no Company & Regional Access record assigned.<br />
			One must be assigned first before access to the user is allowed.<br />
			The current information for this user is:<br /><br />
            <cfoutput>
            <table border=0 cellpadding=2 cellspacing=0>
                <tr>
                    <td class="label">Program Manager:</td>
                    <td>#rep_info.team_id#</td>
                </tr>
                <tr>
                    <td class="label">Access level:</td>
                    <td>#rep_info.usertype#</td>
                </tr>
            </table>
            </cfoutput>
        </td></tr>
    </table>
    
</cfif>

<cfform action="index.cfm?curdoc=forms/access_rights_form&id=#url.id#&userid=#url.userid#" method="post" name="my_form" onSubmit="return checkForm();">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="force" value="#form.force#">
<cfinput type="hidden" name="advisor" value="#form.advisor#">
<cfinput type="hidden" name="new_user" value="#form.new_user#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<!--- this is set in the "force" section above for an international user. --->
<cfif isDefined("hard_coded_user")>

	<input type="hidden" name="hard_coded_user_submitted" value="1">
	<cfinput type="hidden" name="usertypeid" value="#rep_info.usertypeid#">
    
    <p>Click "Submit" to add the following Company & Regional Access information.</p>
    <table border=0 cellpadding=4 cellspacing=0>
        <tr>
            <td class="label">Program Manager:</td>
            <td>
	            <!--- all hard coded users get the same company and not their current company. --->
                <cfquery name="get_company" datasource="#application.dsn#">
                    SELECT team_id
                    FROM smg_companies
                    WHERE companyid = 5
                </cfquery>
                <cfoutput>#get_company.team_id#</cfoutput>    
            </td>
        </tr>
        <tr>
            <td class="label">Access Level:</td>
            <td><cfoutput>#rep_info.usertype#</cfoutput></td>
        </tr>
    </table>

<cfelse>

	<script type="text/javascript">
    function checkForm() {
        if (document.my_form.regionid.value.length == 0) {alert("Please select the Region."); return false; }
        if (document.my_form.usertype.value.length == 0) {alert("Please select the Access Level."); return false; }
        return true;
    }
    </script>
   
    <span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
    <table border=0 cellpadding=4 cellspacing=0>
        <tr>
            <td class="label">Program Manager:</td>
            <td>
                <cfquery name="get_company" datasource="#application.dsn#">
                    SELECT team_id
                    FROM smg_companies
                    WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.companyid#">
                </cfquery>
                <cfoutput>#get_company.team_id#</cfoutput>    
                <cfinput type="hidden" name="companyid" value="#form.companyid#">
            </td>
        </tr>
        <tr>
            <td class="label">Region: <span class="redtext">*</span></td>
            <td>
                <cfquery name="get_regions" datasource="#application.dsn#">
                    SELECT regionid, CONCAT(regionname,' (',regionid,')') AS region
                    FROM smg_regions
                    WHERE company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                    ORDER BY regionname, regionid
                </cfquery>
                <cfselect NAME="regionid" query="get_regions" value="regionid" display="region" selected="#form.regionid#" queryPosition="below" disabled="#form.region_disabled#">
                    <option value=""></option>
                </cfselect>        
                <cfif form.region_disabled NEQ ''>
                    <cfinput type="hidden" name="regionid" value="#form.regionid#">
                </cfif>
                <cfinput type="hidden" name="region_disabled" value="#form.region_disabled#">
            </td>
        </tr>
        <tr>
            <td class="label">Access Level: <span class="redtext">*</span></td>
            <td>
                <cfquery name="get_usertypes" datasource="#application.dsn#">
                    SELECT usertypeid, usertype
                    FROM smg_usertype
                    <!--- don't include international since those are added automatically when adding a new user. --->
                    WHERE usertypeid IN (1,2,3,4,5,6,7,9)
                    <cfif not client.usertype LTE 4>
                        AND usertypeid > <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
                    </cfif>
                    ORDER BY usertypeid
                </cfquery>
                <cfselect NAME="usertype" query="get_usertypes" value="usertypeid" display="usertype" selected="#form.usertype#" queryPosition="below" disabled="#form.access_disabled#">
                    <option value=""></option>
                </cfselect>
                <cfif form.access_disabled NEQ ''>
                    <cfinput type="hidden" name="usertype" value="#form.usertype#">
                </cfif>
                <cfinput type="hidden" name="access_disabled" value="#form.access_disabled#">
            </td>
        </tr>
    <cfif form.advisor>
        <tr>
            <td class="label">Reports To:</td>
            <td>
                <cfquery name="get_advisors" datasource="#application.dsn#">
                    SELECT u.userid, CONCAT(u.firstname,' ',u.lastname) AS advisorname
                    FROM user_access_rights uar
                    INNER JOIN smg_users u ON uar.userid = u.userid
                    WHERE uar.usertype = 6
                    AND uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.regionid#">
                    ORDER BY firstname
                </cfquery>					
                <cfselect NAME="advisorid" query="get_advisors" value="userid" display="advisorname" selected="#form.advisorid#" queryPosition="below">
                    <option value="0">Directly to Director</option>
                </cfselect>        
            </td>
        </tr>
    <cfelse>
        <cfinput type="hidden" name="advisorid" value="#form.advisorid#">
    </cfif>
    </table>

</cfif>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
    	<cfif not new>
            <cfquery name="check_access" datasource="#application.dsn#">
                SELECT user_access_rights.userid
                FROM user_access_rights
   				INNER JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
                WHERE smg_companies.website = 'SMG'
                AND user_access_rights.userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer">
            </cfquery>
			<!--- don't allow delete if user has only one record. --->
            <cfif check_access.recordcount GT 1>
				<td><a href="index.cfm?curdoc=user_info&delete_access_right=<cfoutput>#url.id#&userid=#url.userid#</cfoutput>" onClick="return confirm('Are you sure you want to delete this Company & Regional Access record?')"><img src="pics/delete.gif" border="0"></a></td>
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
