<link rel="stylesheet" href="smg.css" type="text/css">
<cfif not isDefined('url.change')>
	<cfset url.change = 0>
	<cfset form.results = "null">
	<cfset url.available_families = 0>
	<cfset form.available_families = 0>	
</cfif>

<cfif url.change is 1 and form.reason is not ''>
    <cfquery name="school_info" datasource="#APPLICATION.DSN#">
        SELECT schoolid
        FROM smg_hosts
        WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.available_families)#">
    </cfquery>

	<cfif #form.available_families# is 0> <!--- change to unplaced --->
        <cfquery name="change_host" datasource="#APPLICATION.DSN#"> 
        	UPDATE smg_students
        	SET
            	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.available_families)#">,
            	schoolid = 0,
            	doubleplace = '0',
            	arearepid = '0',
            	placerepid = '0'
        	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">
        </cfquery>
	<cfelse> <!--- change host --->
        <cfquery name="change_host" datasource="#APPLICATION.DSN#">
            UPDATE smg_students
            SET
            	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.available_families)#">,
                schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(school_info.schoolID)#">,
                doubleplace = '0',
                arearepid = '0',
                placerepid = '0'
            WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">
        </cfquery>
	</cfif>

    <cfquery name="change_reason" datasource="#APPLICATION.DSN#"> <!--- host history --->
    	INSERT INTO smg_hosthistory (
        	hostID,
            studentID,
            reason,
            dateOfChange,
            areaRepID,
            placeRepID,
            createdBy,
            updatedBy
        )
        VALUES (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.studentID)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.areaRepID)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.placeRepID)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
        )
    </cfquery>
    The host family has been changed.
    <cflocation url="../host_info.cfm?studentid=#client.studentid#&hostid=#form.available_families#&region=#url.region#&studentname=#url.studentname#&regionname=#url.regionname#&arearepid=#url.arearepid#&placerepid=#url.placerepid#&reload=parent" addtoken="no">	

<cfelse>
    <cfquery name="get_Available_hosts" datasource="#APPLICATION.DSN#">
    	SELECT hostid, familylastname, fatherfirstname, motherfirstname, fatherlastname, motherlastname
    	FROM smg_hosts
    	WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.region)#">
    </cfquery>
    <cfoutput>
    <span class="application_section_header">Change Host Family</span><br>
    <br>
    The following families in the #url.regionname# are available to host a student: <br>
    </cfoutput>
    <cfform action="../forms/change_host.cfm?studentid=#client.studentid#&hostid=#url.hostid#&region=#url.region#&studentname=#url.studentname#&regionname=#url.regionname#&arearepid=#url.arearepid#&placerepid=#url.placerepid#&change=1" method="post">
    <cfselect name="available_families">
    <option value=0>change to unplaced</option>
    <cfoutput query="get_Available_hosts">
    <cfif url.change is 1>
        <cfif #form.available_families# is #hostid#><option value=#hostid# selected>#fatherfirstname# <cfif #motherlastname# is #fatherlastname#><cfelse>#fatherlastname#</cfif> and #motherfirstname#<cfif #motherlastname# is #fatherlastname#> #familylastname#<cfelse> #motherlastname#</cfif> </option>
	<cfelse>
	<option value=#hostid#>#fatherfirstname# <cfif #motherlastname# is #fatherlastname#><cfelse>#fatherlastname#</cfif> and #motherfirstname#<cfif #motherlastname# is #fatherlastname#> #familylastname#<cfelse> #motherlastname#</cfif> </option>
	</cfif>
	<cfelse>
<option value=#hostid#>#fatherfirstname# <cfif #motherlastname# is #fatherlastname#><cfelse>#fatherlastname#</cfif> and #motherfirstname#<cfif #motherlastname# is #fatherlastname#> #familylastname#<cfelse> #motherlastname#</cfif> </option>
</cfif>
</cfoutput>
</cfselect>
<br>
<br>

<cfif url.change is 1><font color="red">YOU MUST INCLUDE A REASON FOR CHANGING THE FAMILY:<cfelse>Please indicate why you are changing the host family:</cfif><br>
<textarea cols=50 rows=10 name="reason"></textarea>

<table>
	<Tr>
		<td align="right" width="50%"><br><input type="submit" value="change host">&nbsp;&nbsp;</td><td align="left" width="50%"></</cfform><Br>&nbsp;&nbsp;
<input type="button" value="close window" onClick="javascript:window.close()"></td>
	</tr>
</table>
</cfif>