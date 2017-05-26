<!--- Check if decided to host was clicked because the email should also be sent out in this case. --->
<cfajaxproxy cfc="extensions.components.cbc" jsclassname="CBC">

<cfscript>
    qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=URL.hostID);
    qCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();
    vCurrentSeasonStatus = APPLICATION.CFC.HOST.getApplicationList(hostID=qGetHostInfo.hostID,seasonID=qCurrentSeason.seasonID).applicationStatusID;
</cfscript>

<cfset goingToHost = 0>
<cfif structKeyExists(FORM, "decideToHost")>
    <cfif FORM.decideToHost EQ 0>
        <cfset goingToHost = 0>
    <cfelse>
        <cfset goingToHost = 1>
    </cfif>
</cfif>


<cfif structKeyExists(FORM, "withCompetitor")>
    <cfquery datasource="#APPLICATION.DSN#">
        UPDATE smg_hosts
        SET with_competitor = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.withCompetitor)#">,
            call_back_updated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            call_back_updated_by = #CLIENT.userid#
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
    </cfquery>

     <cfscript>
        applicationHistory = APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
            applicationID=7,
            foreignTable='smg_hosts',
            foreignID=URL.hostID,
            enteredByID=CLIENT.userID,
            dateCreated=NOW(),
            status_update='With Competitor'
        );
    </cfscript>

    <cfset applicationHistoryID = applicationHistory />

</cfif>


<cfif structKeyExists(FORM, "hostNewSeason")>
    <cfif FORM.hostNewSeason EQ 1>
        <cfscript>
            APPLICATION.CFC.HOST.setHostSeasonStatus(hostID=URL.hostID,seasonID=qCurrentSeason.seasonID);
            goingToHost = 1;
        </cfscript>
    </cfif>
</cfif>

<!--- Send email to host family and update application, check for password first. --->
<cfif structKeyExists(FORM, "sendAppEmail") OR goingToHost EQ 1>

    <cfquery datasource="#APPLICATION.DSN#">
        UPDATE smg_hosts
        SET
            dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
            <cfif structKeyExists(FORM, "sendAppEmail")>
                <cfif FORM.sendAppEmail EQ "Convert to eHost">
                    ,areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                </cfif>
            </cfif>
            <cfif qGetHostInfo.password is ''>
                ,password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">
            </cfif>
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
    </cfquery>
    <cfif NOT VAL(qGetHostInfo.applicationStatusID)>
        <cfscript>
            APPLICATION.CFC.HOST.setHostSeasonStatus(hostID=URL.hostID,seasonID=qCurrentSeason.seasonID);
        </cfscript>
    </cfif>
    <cfquery name="qGetUpdatedPassword" datasource="#APPLICATION.DSN#">
        SELECT password, email
        FROM smg_hosts
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
    </cfquery>
    
       <cfscript>
            // Data Validation
            
            // Email Address
            if ( NOT LEN(TRIM(qGetUpdatedPassword.email)) ) {
                SESSION.formErrors.Add("Please provide an email address.");
            }   
            
            // Valid Email Address
            if ( LEN(TRIM(qGetUpdatedPassword.email)) AND NOT isValid("email", TRIM(qGetUpdatedPassword.email)) ) {
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }   
        </cfscript> 
        
    <cfif NOT SESSION.formErrors.length()>
    <cfscript>
        APPLICATION.CFC.HOST.sendWelcomeLetter(
            email=#qGetHostInfo.email#,
            password=#qGetUpdatedPassword.password#,
            fatherFirstName=#qGetHostInfo.fatherFirstName#,
            motherFirstName=#qGetHostInfo.motherFirstName#);
    </cfscript>
    </cfif>
                 
</cfif>

<cfif structKeyExists(FORM, "decideToHost")>
    <cfquery datasource="#APPLICATION.DSN#">
        UPDATE smg_hosts
        SET dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
            isHosting = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.decideToHost)#">,
            call_back_updated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            call_back_updated_by = #CLIENT.userid#
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostInfo.hostID#">
    </cfquery>

    <cfif VAL(FORM.decideToHost)>
        <cfscript>
            applicationHistory = APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
                applicationID=7,
                foreignTable='smg_hosts',
                foreignID=URL.hostID,
                enteredByID=CLIENT.userID,
                dateCreated=NOW(),
                status_update='Available To Host'
            );
        </cfscript>
    <cfelse>
        <cfscript>
            applicationHistory = APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
                applicationID=7,
                foreignTable='smg_hosts',
                foreignID=URL.hostID,
                enteredByID=CLIENT.userID,
                dateCreated=NOW(),
                status_update='Decided Not to Host'
            );
        </cfscript>
    </cfif>

    <cfset applicationHistoryID = applicationHistory />
</cfif>

<cfif structKeyExists(FORM, "call_back")>
    <cfquery datasource="#APPLICATION.DSN#">
        UPDATE smg_hosts
        SET dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
            call_back = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.call_back)#">,
            call_back_updated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            call_back_updated_by = #CLIENT.userid#
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostInfo.hostID#">
    </cfquery>

    <Cfif FORM.call_back EQ 1>
        <cfscript>
            applicationHistory = APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
                applicationID=7,
                foreignTable='smg_hosts',
                foreignID=URL.hostID,
                enteredByID=CLIENT.userID,
                dateCreated=NOW(),
                status_update='Call Back'
            );
        </cfscript>
    <Cfelseif FORM.call_back EQ 2>
        <cfscript>
            applicationHistory = APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
                applicationID=7,
                foreignTable='smg_hosts',
                foreignID=URL.hostID,
                enteredByID=CLIENT.userID,
                dateCreated=NOW(),
                status_update='Call Back Next SY'
            );
        </cfscript>
    <cfelse>
        <cfscript>
            applicationHistory = APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
                applicationID=7,
                foreignTable='smg_hosts',
                foreignID=URL.hostID,
                enteredByID=CLIENT.userID,
                dateCreated=NOW(),
                status_update='Available to Host'
            );
        </cfscript>
    </Cfif>

    <cfset applicationHistoryID = applicationHistory />
</cfif>

<cfif structKeyExists(FORM, "updateApplicationHistoryNotes")>
    <cfquery datasource="#APPLICATION.DSN#">
        UPDATE applicationhistory
        SET comments = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.explanation#">
        WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.applicationHistoryID#">
    </cfquery>

    <cflocation url="index.cfm?curdoc=host_fam_info&hostid=#URL.hostid#" addtoken="No">
</cfif>

<strong>New Status:</strong> 
<cfif structKeyExists(FORM, "decideToHost") AND goingToHost EQ 0>
    Decided Not To Host
<cfelseif structKeyExists(FORM, "decideToHost") AND goingToHost EQ 1>
    Available to Host
<cfelseif structKeyExists(FORM, "withCompetitor") AND FORM.withCompetitor EQ 1>
    With Competitor
<cfelseif structKeyExists(FORM, "hostNewSeason")>
    Available to Host
<cfelseif structKeyExists(FORM, "call_back")>
    <cfif FORM.call_back EQ 1>
        Call Back
    <cfelseif FORM.call_back EQ 2>
        Call Back Next SY
    <cfelseif FORM.call_back EQ 0>
        Available to Host
    </cfif>
</cfif>


<div id="statusNotes" style="margin-top: 10px">
    <cfform method="post" action="index.cfm?curdoc=host_fam_info_status_update&hostid=#url.hostid#">
        Notes:
        <textarea name='explanation' id='explanation' style="width: 50%;height: 40px;vertical-align: top;"></textarea>
        <input type="hidden" name="updateApplicationHistoryNotes" id="updateApplicationHistoryNotes" value="1" />
        <input type="hidden" name="applicationHistoryID" id="applicationHistoryID" value="<cfoutput>#applicationHistoryID#</cfoutput>" />
        <br />

        <input type="submit" value="Save"  alt="Save" border="0" class="buttonBlue" style="margin-top:5px" />
    </cfform>
</div>
