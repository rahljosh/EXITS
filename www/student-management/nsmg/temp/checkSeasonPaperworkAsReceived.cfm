<!--- ------------------------------------------------------------------------- ----
	
	File:		checkSeasonPaperworkAsReceived.cfm
	Author:		Marcus Melo
	Date:		October 2nd, 2012
	Desc:		Check if paperwork is complete and give users access to the DB	
	
	Notes:						
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<cfscript>
        // Get Current Paperwork Season ID
        vCurrentSeasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
    </cfscript>

    <cfquery name="qGetPendingPaperwork" datasource="#APPLICATION.dsn#">
    	SELECT
        	*
        FROM 
			smg_users_paperwork
        WHERE 
        	seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vCurrentSeasonID#">
		AND 
        	dateaccessgranted IS NULL            
        <!---
        AND 	
        	ar_ref_quest1 IS NOT NULL
        AND 
        	ar_ref_quest2 IS NOT NULL
        
        AND 
        	ar_cbc_auth_form IS NOT NULL
        AND 
        	ar_agreement IS NOT NULL
        AND 
        	agreeSig != ''
        AND 
        	cbcsig != ''
		--->			        
    </cfquery>
    
    <cfscript>
		vTimeStamp = now();
		vCompliantCount = 0;
	</cfscript>
    
</cfsilent>

<cfoutput>

    <cfloop query="qGetPendingPaperwork">
    
    	<cfscript>
			stUserPaperwork = APPLICATION.CFC.USER.getUserPaperwork(userID=qGetPendingPaperwork.userID);	
		</cfscript>			
        
        <cfif stUserPaperwork.isAccountCompliant>
        
        	<p>User Compliant: #qGetPendingPaperwork.userID#</p>
        	
            <cfscript>
				vCompliantCount ++;
			</cfscript>
            
        </cfif>
        
        <cfquery datasource="#APPLICATION.dsn#">
        	UPDATE
            	smg_users_paperwork
			SET
        		dateaccessgranted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vTimeStamp#">,
            	accessGrantedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="510">  
			WHERE
            	paperworkID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPendingPaperwork.paperworkID#">  
			LIMIT 1                                 
		</cfquery>
            
    </cfloop>
    
    <p>Total Reps In Query --> #qGetPendingPaperwork.recordCount#</p>
    <p>Total Compliant --> #vCompliantCount#</p>
    
</cfoutput>    


