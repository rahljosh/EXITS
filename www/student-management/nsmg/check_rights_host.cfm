<!--- ------------------------------------------------------------------------- ----
	
	File:		check_rights_host.cfm
	Author:		Marcus Melo
	Date:		August 7, 2012
	Desc:		Check if user has access to a host family

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>
        // Default Access Value
        vIsAccessDenied = true;
    
        // Office Users always have access
        if ( APPLICATION.CFC.USER.isOfficeUser() ) {
            vIsAccessDenied = false;
        }
        
        // Store List of Supervised Users
        vSupervisedUserIDList = '';
        vHostIDList = '';
    </cfscript>

    <cfswitch expression="#CLIENT.userType#">
    
        <!--- Regional Manager | Any Host Family Assigned to their region --->
        <cfcase value="5">
    
            <cfquery name="qCheckHostAccess" datasource="#APPLICATION.DSN#">
                SELECT
                    *
                FROM
                    smg_hosts
                WHERE
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
                AND
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
            </cfquery>
            
            <cfscript>
                if ( VAL(qCheckHostAccess.recordCount) ) {
                    vIsAccessDenied = false;	
                }
            </cfscript>
        
        </cfcase>
        
        <!--- Regional Advisor | Only their students and supervised user students families --->
        <cfcase value="6">
    
            <cfscript>
                // Get Available Reps
                qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionID=CLIENT.regionID);
                
                // Store Users under Advisor on a list
                vSupervisedUserIDList = ValueList(qGetUserUnderAdv.userID);
            </cfscript>
            
            <cfquery name="qCheckHostAccess" datasource="#application.dsn#">
                SELECT
                    h.hostID
                FROM
                    smg_hosts h
                INNER JOIN
                    smg_students s ON s.hostID = h.hostID
                WHERE
                    h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
                AND
                    h.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
                AND
                (
                      s.areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vSupervisedUserIDList#" list="yes">  )
                  OR 
                      s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vSupervisedUserIDList#" list="yes">  )
                )                      
            </cfquery>
            
            <cfscript>
                if ( VAL(qCheckHostAccess.recordCount) ) {
                    vIsAccessDenied = false;	
                }
            </cfscript>
        
        </cfcase>
        
        <!--- AR / Student View | Only their students families --->
        <cfcase value="7,9">
    
            <cfquery name="qCheckHostAccess" datasource="#APPLICATION.DSN#">
                SELECT
                    hostID
                FROM
                    smg_students
                WHERE
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
                AND
                    h.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
                AND
                    ( 	
                        areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    OR 
                        placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    )
            </cfquery>
            
            <cfscript>
                if ( VAL(qCheckHostAccess.recordCount) ) {
                    vIsAccessDenied = false;	
                }
            </cfscript>
        
        </cfcase>
    
    </cfswitch>

</cfsilent>
    
<!--- Check if Access is Denied --->     
<cfif vIsAccessDenied>	
	<cfoutput>
        <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
            <tr valign=middle height=24>
                <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                <td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
                <td background="pics/header_background.gif"><h2>Error</h2></td>
                <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
            </tr>
        </table>
        
        <table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
            <tr><td align="center" valign="top"><img src="pics/error_exclamation.gif" width="37" height="44"> I am sorry but you do not have the rights to see this page.</td></tr>
            <tr><td align="center">If you think this is a mistake please contact #APPLICATION.EMAIL.support#</td></tr>
            <tr><td align="center">You can view your account by clicking <a href="?curdoc=user_info&userid=#CLIENT.userid#">here<a/>.<br /><br /></td></tr>			
        </table>
        <cfinclude template="table_footer.cfm">
	</cfoutput>
    <cfabort>
</cfif>