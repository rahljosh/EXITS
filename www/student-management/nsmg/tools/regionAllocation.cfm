<!--- ------------------------------------------------------------------------- ----
	
	File:		regionAllocation.cfm
	Author:		James Griffiths
	Date:		May 16, 2012
	Desc:		Regions Allocations

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />
    
    <cfquery name="qGetSeasons" datasource="MySql">
        SELECT
            seasonID,
            season
        FROM
            smg_seasons
        WHERE
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    
    <!--- Param Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.seasonID" default="#qGetSeasons.seasonID#">
    <cfparam name="URL.seasonID" default="0">
    
    <cfscript>
        if ( VAL(URL.seasonID) ) {		
            FORM.seasonID = URL.seasonID;	
        }
    </cfscript>
    
    <cfquery name="qGetResults" datasource="MySql">
    	SELECT
        	r.regionID,
            r.regionName,
            u.userID,
            u.firstName,
            u.lastName,
            a.augustAllocation,
            a.januaryAllocation,
            a.ID,
            a.seasonID
      	FROM
        	smg_users u
       	INNER JOIN
        	user_access_rights uar ON uar.userID = u.userID
      	INNER JOIN
        	smg_regions r ON r.regionID = uar.regionID
       	LEFT OUTER JOIN
        	smg_users_allocation a ON a.userID = u.userID
            AND	
            	r.regionID = a.regionID
            AND
            	a.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
      	WHERE
        	uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
       	AND
        	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
      	AND
        	r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
      	AND
        	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
      	GROUP BY
        	r.regionID
      	ORDER BY
        	r.regionName            
    </cfquery>
    
	<!--- To update the records if update was selected --->
    <cfif VAL(FORM.submitted)>
    
        <cfloop query="qGetResults">     	
            
            <cfif VAL(FORM[qGetResults.regionID & '_allocationID'])>
            
                <cfquery name="updateAllocations" datasource="MySql">
                    UPDATE 	
                        smg_users_allocation
                    SET 
                        januaryAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetResults.regionID & '_januaryAllocation'])#">,
                        augustAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetResults.regionID & '_augustAllocation'])#">
                    WHERE 
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM[qGetResults.regionID & '_allocationID']#">
                 </cfquery>
                 
            <cfelseif VAL(FORM[qGetResults.regionID & '_januaryAllocation']) OR VAL(FORM[qGetResults.regionID & '_augustAllocation'])>
            
                <cfquery name="addAllocations" datasource="MySql">
                    INSERT INTO smg_users_allocation
                        (
                            userID, 
                            seasonID,
                            regionID, 
                            januaryAllocation, 
                            augustAllocation,
                            dateCreated
                         )
                    VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.userID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.regionID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetResults.regionID & '_januaryAllocation'])#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetResults.regionID & '_augustAllocation'])#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                 </cfquery>
                 
            </cfif>
            
        </cfloop>

        <cfscript>
			// Set Page Message if updating data
			SESSION.pageMessages.Add("Form successfully submitted.");

			// Reload page
			location("#CGI.SCRIPT_NAME#?curdoc=tools/regionAllocation&seasonID=#FORM.seasonID#", "no");	
		</cfscript>
        
    </cfif>

</cfsilent>

<style type="text/css">
	input {text-align:right}
</style>

<script type="text/javascript">
	<!--
	// submit the form
	var submitform = function() {
		$("#submitted").val(0);
		$("#intlRepAllocation").submit();
	}
	//-->
</script>
    
<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Region Allocation"
    />

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <!--- Form to choose which seasons to show allocation for --->
    <form name="intlRepAllocation" id="intlRepAllocation" action="#CGI.SCRIPT_NAME#?curdoc=tools/regionAllocation" method="post">
        <input type="hidden" name="submitted" id="submitted" value="1">
        
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td>
                        <table border="0" cellpadding="4" cellspacing="0" width="100%">
                            <tr>
                            	<td>Season:
                                	<select name="seasonID" id="seasonID" class="mediumField" onchange="submitform();">
                                        <cfloop query="qGetSeasons">
                                        <option value="#qGetSeasons.seasonID#" <cfif FORM.seasonID EQ qGetSeasons.seasonID>selected="selected"</cfif>>#qGetSeasons.season#</option>
                                        </cfloop>
                                  	</select>
                          		</td>
                        	</tr>
						</table>
					</td>
	 			</tr>
		</table>
         	
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr style="font-weight:bold;">
                <td>Region Name</td>
                <td>Regional Manager</td>
                <td>August Allocation</td>
                <td>January Allocation</td>
            </tr>
            <cfloop query="qGetResults">
                <input type="hidden" name="#qGetResults.regionID#_allocationID" value="#qGetResults.ID#">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                    <td>#qGetResults.regionName# (###qGetResults.regionID#)</td>
                    <td>#qGetResults.firstName# #qGetResults.lastName# ###qGetResults.userID#</td>
                    <td><input type="text" class="smallField" name="#qGetResults.regionID#_augustAllocation" value="#qGetResults.augustAllocation#"></td>
                    <td><input type="text" class="smallField" name="#qGetResults.regionID#_januaryAllocation" value="#qGetResults.januaryAllocation#"></td>
                </tr>
        	</cfloop>
        </table>

		<cfif listFind("1,2,3,4", CLIENT.userType)>
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td colspan="6" align="center">
                    	<!--- For some reason this is not working on the live server
                        <input type="image" src="pics/buttons_submit.png" border="0">--->
                        <input type="submit" value="Submit" />
                  	</td>
                </tr>
            </table>
        </cfif> 	
    </form>

	<!--- Table Footer --->
    <gui:tableFooter />
    
</cfoutput>
