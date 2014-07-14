<cfif NOT VAL(FORM.region)>

    <p>
        There is no Region assigned. Please go back and assign a region.<br>
        <div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
    </p>

<cfelseif NOT isdefined("FORM.community")>

    <p>
        You must select "Would you describe the community as". Please go back and try again.<br>
        <div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
    </p>

<cfelse>
    
	<cfscript>
        // Get Region Information
        vGetCompanyID = APPLICATION.CFC.REGION.getRegions(regionID=FORM.region).company;
    </cfscript>
    
    <cftransaction action="BEGIN" isolation="SERIALIZABLE">
    
        <cfquery name="insert_community_info" datasource="#APPLICATION.DSN#">
            UPDATE 
                smg_hosts
            SET 
                regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.region#">,
                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vGetCompanyID)#">,
                nearbigCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.near_City#">,
                near_City_Dist = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.near_City_Dist#">,
                community = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.community#">,
                point_interest = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.point_interest#">,
                major_air_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.major_air_code#">,
                dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        		updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">          
            WHERE 
                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
        </cfquery>
    
    </cftransaction>
    
    <cflocation url="index.cfm?curdoc=forms/double_placement" addtoken="no">

</cfif> 