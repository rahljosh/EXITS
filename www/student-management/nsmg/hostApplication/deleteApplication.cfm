<!--- ------------------------------------------------------------------------- ----
	
	File:		deleteApplication.cfm
	Author:		Marcus Melo
	Date:		02/04/2013
	Desc:		Deletes a host family application

	Updated:	DELETE FROM
				
				smg_host_animals
				smg_host_app_history
				smg_host_children
					
				smg_host_reference
				smg_host_reference_anwers
				smg_host_reference_tracking
				
				secondvisitanswers
				progress_reports
				
				smg_hosts
				smg_hosts_cbc

				document (family pictures/schoolAcceptance)
				delete uploaded files from uploadedFiles/hostApp/#hostID#
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="0">
     
    <!--- Param FORM Variables --->
    <cfparam name="FORM.hostID" default="0">
    <cfparam name="FORM.submitted" default="0">

    <cfscript>
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
	
		// Get Host Application Information
		qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=VAL(FORM.hostID));
		
		vCanHostBeDeleted = false;
	</cfscript>	
    
    <cfquery name="qCheckPlacements" datasource="#APPLICATION.DSN#">
        SELECT
            sh.*,
            CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentDisplayName            
        FROM
            smg_hosthistory sh
        INNER JOIN
        	smg_students s ON s.studentID = sh.studentID
        WHERE
            sh.hostID = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
    </cfquery>  
    
	<cfscript>
		if ( qGetHostInfo.recordCount AND NOT VAL(qCheckPlacements.recordCount) ) {
			vCanHostBeDeleted = true;
		}
	</cfscript>
    
    <cfif FORM.submitted AND vCanHostBeDeleted>


		<!--- Delete Animals --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                smg_host_animals
            WHERE
                hostID = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        </cfquery>   
            
            
        <!--- Delete Children --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                smg_host_children
            WHERE
                hostID = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        </cfquery>   
    
    
        <!--- Delete CBC --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                smg_hosts_cbc
            WHERE
                hostID = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        </cfquery>   
        
        
        <!--- Reference Tracking --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                smg_host_reference_tracking
            WHERE
                fk_referencesID IN (
                                    SELECT
                                        refID
                                    FROM
                                        smg_host_reference
                                    WHERE
                                        referenceFor = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
                                    )
        </cfquery>   
    
    
        <!--- Reference Answers --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                smg_host_reference_answers
            WHERE
                fk_reportID IN (
                                    SELECT
                                        refID
                                    FROM
                                        smg_host_reference
                                    WHERE
                                        referenceFor = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
                                    )
        </cfquery>   
        
        
        <!--- Reference --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                smg_host_reference
            WHERE
                referenceFor = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        </cfquery>   
        
        
        <!--- Initial Visit - Second Visit Answers --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                secondvisitanswers
            WHERE
                fk_reportID IN (
                                    SELECT
                                        pr_ID
                                    FROM
                                        progress_reports
                                    WHERE
                                        fk_host = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
                                    )
        </cfquery>   


        <!--- Initial Visit - Progress Reports --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                progress_reports
            WHERE
                fk_host = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        </cfquery>   

        
        <!--- Delete Host App History --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                smg_host_app_history
            WHERE
                hostID = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        </cfquery>   
    

		<!--- Delete Document --->
        <cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                document
            WHERE
            	foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosts">
            AND
                foreignID = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        </cfquery>   
    
        
        <!--- Delete Folder --->
        <cftry>
        	
            <cfdirectory action="delete" directory="#APPLICATION.PATH.hostApp##VAL(qGetHostInfo.hostID)#">

            <cfcatch type="any">
				<!--- Handle Error --->            
            </cfcatch>
        
        </cftry>
        

        <!--- Delete Host --->
		<cfquery datasource="#APPLICATION.DSN#">
            DELETE FROM
                smg_hosts
            WHERE
                hostID = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        </cfquery> 
        
	</cfif>
            
</cfsilent>    

<cfoutput>
	
    <cfif NOT VAL(FORM.submitted)>
    	
        <cfif APPLICATION.CFC.USER.isOfficeUser()>
        
            <form name="deleteHost" action="#CGI.SCRIPT_NAME#" method="post" style="border:1px solid ##ccc; width:400px;">
                <input type="hidden" name="submitted" value="1">     
                
                <h2>Delete Host Family Data</h2>   
                
                <p>
                    Please Enter host ID:
                    <input type="text" name="hostID" value="">
                </p>
    
                <input type="submit" name="submit"> <br /> <br />
    
                <span style="color:##F00">PS: DATA IS PERMANENTLY DELETED. <br /> Please be sure you are typing in the correct HOST ID.</span>
                
            </form>
            
		<cfelse>
        
        	<p>You don't have rights to see this page</p>        
        
        </cfif>            
   
    <cfelseif NOT VAL(qGetHostInfo.recordCount)>

        <h2>Host family could not be found. Please try a different ID</h2>
        
        <a href="#CGI.SCRIPT_NAME#">GO BACK</a>
    
    <cfelseif vCanHostBeDeleted>
    
        <h2>Data Successfully deleted</h2>
        
        <p>Host Family: #qGetHostInfo.familyLastName# (###qGetHostInfo.hostID#)</p>
        
        <p>Data deleted from smg_host_animals</p>
        
        <p>Data deleted from smg_host_app_history</p>
        
        <p>Data deleted from smg_host_children</p>
            
        <p>Data deleted from smg_host_reference</p>
        
        <p>Data deleted from smg_host_reference_anwers</p>
        
        <p>Data deleted from smg_host_reference_tracking</p>

        <p>Data deleted from secondvisitanswers</p>
        
        <p>Data deleted from progress_reports</p>
        
        <p>Data deleted from smg_hosts</p>
        
        <p>Data deleted from smg_hosts_cbc</p>
        
        <p>Data deleted from document</p>
        
        <p>Uploaded files deleted from #APPLICATION.PATH.hostApp##qGetHostInfo.hostID#</p>
        
        <a href="#CGI.SCRIPT_NAME#">GO BACK</a>
	
    <cfelse>

        <h2>Host family could not be deleted. HF record is assigned to one or more students</h2>

    	<p>Host Family: #qGetHostInfo.familyLastName# (###qGetHostInfo.hostID#)</p>
    
        <cfloop query="qCheckPlacements">
        	Student: #qCheckPlacements.studentDisplayName# <br />
        </cfloop>
    
    </cfif>
    
</cfoutput>