<cfif not isDefined('form.transportation')>
	<br>
	You must indicate how the student will be transported to school.  Click back to make a selection.
    <br>
    <br>
	<div class="button">
    	<input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()">
  	</div>
    <br>
	<cfabort>
</cfif>

<cfif #form.transportation# is "other" and #form.other_Desc# is ''>
	You indicated 'Other' as the method of transportation to school, but didn't fill out the Other description box.<br>Use your browsers back button to enter the description.
	<div class="button">
    	<input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()">
  	</div>
	<cfabort>
<cfelseif #form.transportation# is not "other">
	<cfset form.other_desc = ''>
</cfif>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
    <cfquery name="insert_transportation" datasource="MySQL">
        UPDATE
            smg_hosts
        SET
            schoolTransportation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.transportation#">,
            schooldistance = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.distance_school)#">,
            schoolcosts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.school_costs#">,
            other_trans = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.other_desc#">	
        WHERE
            hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">
    </cfquery>
</cftransaction>
<cflocation url="index.cfm?curdoc=forms/host_fam_pis_7" addtoken="no">