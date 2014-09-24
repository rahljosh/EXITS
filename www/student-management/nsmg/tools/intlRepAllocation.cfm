<!--- ------------------------------------------------------------------------- ----
	
	File:		intlRepAllocation.cfm
	Author:		James Griffiths
	Date:		March 28, 2012
	Desc:		International Representatives Allocations

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />
    
    <cfquery name="qGetSeasons" datasource="#APPLICATION.DSN#">
        SELECT seasonID, season
        FROM smg_seasons
        WHERE active = 1
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
    
    <cfquery name="qGetRepresentatives" datasource="#APPLICATION.DSN#">
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
        FROM smg_users u
        INNER JOIN user_access_rights uar ON uar.userid = u.userid
        LEFT JOIN smg_users_allocation sua ON u.userid = sua.userid
			AND sua.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
        LEFT JOIN smg_seasons s ON s.seasonID = sua.seasonID
        WHERE uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
        ORDER BY u.businessname   
    </cfquery>

	<!--- To update the records if update was selected --->
    <cfif VAL(FORM.submitted)>
    
        <cfloop query="qGetRepresentatives">
        
        	<cfquery name="qGetAllocations" datasource="#APPLICATION.DSN#">
            	SELECT *
                FROM smg_users_allocation
                WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepresentatives.userID#">
                AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
            </cfquery>
            
            <cfif VAL(qGetAllocations.recordCount)>
            
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE smg_users_allocation
                    SET 
                        januaryAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetRepresentatives.userID & '_januaryAllocation'])#">,
                        augustAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetRepresentatives.userID & '_augustAllocation'])#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAllocations.id#">
               	</cfquery>
                 
            <cfelse>
            
                <cfquery datasource="#APPLICATION.DSN#">
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
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepresentatives.userID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetRepresentatives.userID & '_januaryAllocation'])#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM[qGetRepresentatives.userID & '_augustAllocation'])#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                 </cfquery>
                 
            </cfif>
            
        </cfloop>

        <cfscript>
			// Set Page Message if updating data
			SESSION.pageMessages.Add("Form successfully submitted.");

			// Reload page
			location("#CGI.SCRIPT_NAME#?curdoc=tools/intlRepAllocation&seasonID=#FORM.seasonID#", "no");	
		</cfscript>
        
    </cfif>

</cfsilent>

<script type="text/javascript">
	// change the season
	var changeSeason = function(url) {
		var season = $("#seasonID").val();
		window.location = url + "&seasonID=" + season;
	}
</script>
    
<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="International Representative Allocation"
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
    <form name="intlRepAllocation" id="intlRepAllocation" action="#CGI.SCRIPT_NAME#?curdoc=tools/intlRepAllocation" method="post">
    	<input type="hidden" name="submitted" id="submitted" value="1">
        
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
                <td>
                	Season:
                    <select name="seasonID" id="seasonID" class="mediumField" onchange="changeSeason('#CGI.SCRIPT_NAME#?curdoc=tools/intlRepAllocation');">
                        <cfloop query="qGetSeasons">
                        	<option value="#qGetSeasons.seasonID#" <cfif FORM.seasonID EQ qGetSeasons.seasonID>selected="selected"</cfif>>#qGetSeasons.season#</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
		</table>

        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr style="font-weight:bold;">
                <td>Representative</td>
                <td>August Allocation</td>
                <td>January Allocation</td>
            </tr>
            <cfloop query="qGetRepresentatives">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                    <td><a href="index.cfm?curdoc=user_info&userid=#qGetRepresentatives.userid#">#qGetRepresentatives.businessname# (###qGetRepresentatives.userid#)</a></td>
                    <td><input type="text" class="smallField" name="#qGetRepresentatives.userID#_augustAllocation" value="#qGetRepresentatives.augustAllocation#"></td>
                    <td><input type="text" class="smallField" name="#qGetRepresentatives.userID#_januaryAllocation" value="#qGetRepresentatives.januaryAllocation#"></td>
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