<cfset vGrantAccess = 0>

<cfif ListFind("5,6,7", CLIENT.usertype)>
	 
   	<cfif CLIENT.userType EQ 5>
    
    	<cfquery name="qCheckHosts" datasource="#APPLICATION.DSN#">
        	SELECT
            	*
           	FROM
            	smg_hosts
          	WHERE
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
          	AND
            	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
        </cfquery>
        <cfif VAL(qCheckHosts.recordCount)>
			<cfset vGrantAccess = 1>
        </cfif>
        
    <cfelseif CLIENT.userType EQ 6>
    	<cfquery name="qGetReps" datasource="#APPLICATION.DSN#">
        	SELECT DISTINCT
                userid
            FROM 
            	user_access_rights
            WHERE 
            	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
            AND
            	(
                	advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            	OR
                	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
             	)
        </cfquery>
        <cfloop query="qGetReps">
        	<cfquery name="qCheckHosts" datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
                    hostID
                FROM
                    smg_students
                WHERE
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
                AND
                    ( 	
                        arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetReps.userid#">
                    OR
                        placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    )
           	</cfquery>
        	<cfif VAL(qCheckHosts.recordCount)>
				<cfset vGrantAccess = 1>
            </cfif>
        </cfloop>
        
	<cfelseif CLIENT.userType EQ 7>
    
        <cfquery name="qCheckHosts" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT
                hostID
            FROM
                smg_students
            WHERE
                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
            AND
                ( 	
                    arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                OR 
                    placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                )
        </cfquery>
        <cfif VAL(qCheckHosts.recordCount)>
            <cfset vGrantAccess = 1>
        </cfif>
        
    </cfif>
    
<cfelse>
	<cfset vGrantAccess = 1>
</cfif>

<cfif vGrantAccess EQ 0>	
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>Error</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
		<tr><td align="center" valign="top">
				<img src="pics/error_exclamation.gif" width="37" height="44"> I am sorry but you do not have the rights to see this page.
			</td>
		</tr>
		<tr><td align="center">If you think this is a mistake please contact <cfoutput>#APPLICATION.EMAIL.support#</cfoutput></td></tr>
		<tr><td align="center">You can view your account by clicking <a href="?curdoc=user_info&userid=<cfoutput>#CLIENT.userid#</cfoutput>">here<a/>.<br /><br /></td></tr>			
	</table>
	<cfinclude template="table_footer.cfm">
	<cfabort>
</cfif>