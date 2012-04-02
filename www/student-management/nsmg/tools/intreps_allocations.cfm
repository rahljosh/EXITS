<!--- ------------------------------------------------------------------------- ----
	
	File:		intreps_allocations.cfm
	Author:		James Griffiths
	Date:		March 28, 2012
	Desc:		International Representatives Allocations

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
    
    <cfquery name="qGetRepresentatives" datasource="MySql">
        SELECT DISTINCT
            u.userid,
            u.firstName,
            u.lastName,
            u.businessname,
            sua.augustAllocation,
            sua.januaryAllocation,
            sua.ID,
            s.season,
            s.seasonID
        FROM
            smg_users u
        INNER JOIN
            user_access_rights uar ON uar.userid = u.userid
        INNER JOIN
            smg_students stu ON stu.intrep = u.userid
        LEFT JOIN
            smg_users_allocation sua ON u.userid = sua.userid
            <cfif VAL(FORM.inputSeason)>
            AND
                sua.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.inputSeason#">
            </cfif>
        LEFT JOIN
            smg_seasons s ON s.seasonID = sua.seasonID
        WHERE
            uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND
            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
        ORDER BY
            u.businessname   
    </cfquery>

	<!--- To update the records if update was selected --->
    <cfif VAL(FORM.submitted)>
    
        <cfloop query="qGetRepresentatives">
            
            <cfif VAL(FORM[qGetRepresentatives.userID & '_allocationID'])>
            
                <cfquery name="updateAllocations" datasource="MySql">
                    UPDATE 	
                        smg_users_allocation
                    SET 
                        januaryAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetRepresentatives.userID & '_januaryAllocation'])#">,
                        augustAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetRepresentatives.userID & '_augustAllocation'])#">
                    WHERE 
                        userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepresentatives.userid#">
                    AND 
                        seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.inputSeason#">
    
                 </cfquery>
                 
            <cfelseif VAL(FORM[qGetRepresentatives.userID & '_januaryAllocation']) OR VAL(FORM[qGetRepresentatives.userID & '_augustAllocation'])>
            
                <cfquery name="addAllocations" datasource="MySql">
                    INSERT INTO smg_users_allocation
                        (
                            userID, 
                            seasonID, 
                            januaryAllocation, 
                            augustAllocation,
                            dateCreated
                         )
                    VALUES
                        (
                            #qGetRepresentatives.userID#, 
                            #FORM.inputSeason#,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetRepresentatives.userID & '_januaryAllocation'])#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetRepresentatives.userID & '_augustAllocation'])#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                 </cfquery>
                 
            </cfif>
            
        </cfloop>
        
        <cflocation url="#CGI.SCRIPT_NAME#?curdoc=tools/intreps_allocations&inputSeason=#FORM.inputSeason#" addtoken="no">
        
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
        tableTitle="International Representative Allocations"
    />
    
    <!--- Form to choose which seasons to show allocation for --->
    <form name="intlRepAllocation" id="intlRepAllocation" action="#CGI.SCRIPT_NAME#?curdoc=tools/intreps_allocations" method="post">
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
                    <strong>ID</strong>
                </td>
                <td>
                    <strong>Representative</strong>
                </td>
                <td>
                    <strong>August Allocation</strong>
                </td>
                <td>
                    <strong>January Allocation</strong>
                </td>
            </tr>
            <cfloop query="qGetRepresentatives">
                <input type="hidden" name="#qGetRepresentatives.userID#_allocationID" value="#qGetRepresentatives.id#">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                    <td>
                        <a href="index.cfm?curdoc=user_info&userid=#qGetRepresentatives.userid#">#qGetRepresentatives.userid#</a>
                    </td>
                    <td>
                        #qGetRepresentatives.businessname#
                    </td>
                    <td>
                        <input type="text" class="smallField" name="#qGetRepresentatives.userID#_augustAllocation" value="#qGetRepresentatives.augustAllocation#">
                    </td>
                    <td>
                        <input type="text" class="smallField" name="#qGetRepresentatives.userID#_januaryAllocation" value="#qGetRepresentatives.januaryAllocation#">
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

