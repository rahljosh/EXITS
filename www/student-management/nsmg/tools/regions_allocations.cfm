<!--- ------------------------------------------------------------------------- ----
	
	File:		regions_allocations.cfm
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
    <cfparam name="FORM.inputSeason" default="#qGetSeasons.seasonID#">
    <cfparam name="URL.inputSeason" default="0">
    
    <cfscript>
        if ( VAL(URL.inputSeason) ) {		
            FORM.inputSeason = URL.inputSeason;	
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
       	LEFT JOIN
        	smg_users_allocation a ON a.userID = u.userID
            AND
            	a.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.inputSeason#">
      	WHERE
        	uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
       	AND
        	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
      	AND
        	r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
      	AND
        	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
      	GROUP BY
        	r.regionName
      	ORDER BY
        	r.regionName
    </cfquery>

	<!--- To update the records if update was selected --->
    <cfif VAL(FORM.submitted)>
    
        <cfloop query="qGetResults">     	
            
            <cfif VAL(FORM[qGetResults.userID & '_allocationID'])>
            
                <cfquery name="updateAllocations" datasource="MySql">
                    UPDATE 	
                        smg_users_allocation
                    SET 
                        januaryAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetResults.userID & '_januaryAllocation'])#">,
                        augustAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetResults.userID & '_augustAllocation'])#">
                    WHERE 
                        userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.userid#">
                    AND 
                        seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.inputSeason#">
    
                 </cfquery>
                 
            <cfelseif VAL(FORM[qGetResults.userID & '_januaryAllocation']) OR VAL(FORM[qGetResults.userID & '_augustAllocation'])>
            
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
                            #qGetResults.userID#, 
                            #FORM.inputSeason#,
                            #qGetResults.regionID#,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetResults.userID & '_januaryAllocation'])#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetResults.userID & '_augustAllocation'])#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                 </cfquery>
                 
            </cfif>
            
        </cfloop>
        
        <cflocation url="#CGI.SCRIPT_NAME#?curdoc=tools/regions_allocations&inputSeason=#FORM.inputSeason#" addtoken="no">
        
    </cfif>

</cfsilent>

<style type="text/css">
	input {text-align:right}
</style>

<script type="text/javascript">
	<!--
	// submit the form
	var submitform = function() {
		//$("#submit").submit();
		$("#intlRepAllocation").submit();
	}
	//-->
</script>
    
<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Region Allocations"
    />
    
    <!--- Form to choose which seasons to show allocation for --->
    <form name="intlRepAllocation" id="intlRepAllocation" action="#CGI.SCRIPT_NAME#?curdoc=tools/regions_allocations" method="post">
        <input type="hidden" name="submitted" value="1">
        
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td>
                        <table border="0" cellpadding="4" cellspacing="0" width="100%">
                            <tr>
                            	<td>Season:
                                	<select name="inputSeason" id="inputSeason" class="mediumField" onchange="submitform();">
                                        <cfloop query="qGetSeasons">
                                        <option value="#qGetSeasons.seasonID#" <cfif inputSeason EQ qGetSeasons.seasonID>selected="selected"</cfif>>#qGetSeasons.season#</option>
                                        </cfloop>
                                  	</select>
                          		</td>
                        	</tr>
						</table>
					</td>
	 			</tr>
		</table>
         	
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
                <td>
                    <strong>Region ID</strong>
                </td>
                <td>
                    <strong>Region Name</strong>
                </td>
                <td>
                    <strong>Regional Manager</strong>
                </td>
                <td>
                    <strong>August Allocation</strong>
                </td>
                <td>
                    <strong>January Allocation</strong>
                </td>
            </tr>
            
            <cfloop query="qGetResults">
                
                <input type="hidden" name="#qGetResults.userID#_allocationID" value="#qGetResults.ID#">
                
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                	<td>#qGetResults.regionID#</td>
                    <td>#qGetResults.regionName#</td>
                    <td>#qGetResults.firstName# #qGetResults.lastName# ###qGetResults.userID#</td>
                    <td>
                        <input type="text" class="smallField" name="#qGetResults.userID#_augustAllocation" value="#qGetResults.augustAllocation#">
                    </td>
                    <td>
                        <input type="text" class="smallField" name="#qGetResults.userID#_januaryAllocation" value="#qGetResults.januaryAllocation#">
                    </td>
                </tr>
                
        	</cfloop>
        </table>
        
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
                <td align="center">
					<input type="submit" name="Submit" value="Update" />                    
                </td>
            </tr>
        </table>
    </form>
    
</cfoutput>

<!--- Table Footer --->
<cfinclude template="../table_footer.cfm">      

