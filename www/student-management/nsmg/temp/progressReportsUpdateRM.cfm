<!--- ------------------------------------------------------------------------- ----
	
	File:		progressReportsUpdateRM.cfm
	Author:		Marcus Melo
	Date:		July 29, 2011
	Desc:		Updates regional manager information on pending progress reports for
				regions that were merged.
	
	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <cfsetting requesttimeout="9999">
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">

	<cfscript>
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getRegions(companyID=CLIENT.companyID);
	</cfscript>
	
    <cfif FORM.submitted>

        <cfloop query="qGetRegionList">
            
            <!--- Get Regional Manager --->
            <cfquery name="qGetRM" datasource="mysql">
                SELECT 
                    uar.userID,
                    CONCAT(u.firstName, ' ', u.lastName) AS managerName
                FROM 
                    user_access_rights uar
                INNER JOIN
                	smg_users u ON u.userID = uar.userID
                WHERE
                    uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionList.regionID#">
                AND
                    uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                AND
                	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				GROUP BY
                	uar.userID                    
            </cfquery>
                
            <cfif qGetRM.recordCount EQ 1>
            
                <!--- Update Pending Reports --->
                <cfquery name="qGetPendingReports" datasource="mysql">
                    UPDATE
                    	progress_reports
                    SET
                    	fk_rd_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRM.userID#">
                    WHERE
                        pr_rd_approved_date IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    AND
                    	fk_rd_user != <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRM.userID#">
                    AND
                    	fk_student IN 	( 	
                        					SELECT 	
                                                studentID 
                                            FROM 
                                                smg_students 
                                            WHERE 
                                                active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                                            AND 
                                                regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionList.regionID#"> 
										)														
                </cfquery>
            
            <cfelse>
    
                <cfscript>
					if ( nOT VAL(qGetRM.recordCount) ) {
						// No Managers
						SESSION.formErrors.Add('Region: #qGetRegionList.regionName# - No manager assigned');
					} else {
						// Multiple Managers
						vManagerList = ValueList(qGetRM.managerName);	
					
						// Multiple RM - Error
						SESSION.formErrors.Add('Region: #qGetRegionList.regionName# - Multiple manager assigned: #vManagerList# ');
					}
                </cfscript>
                    
            </cfif>
		
        </cfloop>

   </cfif>
   
</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<!--- Table Header --->
        <gui:tableHeader
            imageName="current_items.gif"
            tableTitle="Merge Regions"
            width="50%"
            imagePath="../"
        />    
        
        <!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="50%"
            />
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="50%"
            />
		
        <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        	<input type="hidden" name="submitted" value="1" />
        
            <table width="50%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                <tr class="projectHelpTitle">
                    <th>Updates Regional Manager Information for Pending Progress Reports</th>
               	</tr>
                <tr>
                    <td>
                    	Regions often get merged so we'll need to update the regional manager information on progress reports. 
                        This tool gets the active regional manager and updates the information for pending progress reports so the 
                        current regional manager can approve it.
                    </td>
                </tr>
                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                    <tr>
                        <th>
                            <input type="submit" name="Submit" />
                        </th>
                    </tr>                
                </cfif>
            </table>     
        
        </form>
        
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="50%"
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>                             