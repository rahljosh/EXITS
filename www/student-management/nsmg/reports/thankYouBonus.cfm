<!--- ------------------------------------------------------------------------- ----
	
	File:		thankYouBonus.cfm
	Author:		Marcus Melo
	Date:		September 09, 2010
	Desc:		Thank You Bonus Report by Region

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="9999">
	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionAssigned" default="0">

	<cfscript>		
        // Get Region List
        qGetRegionList = APPCFC.REGION.getRegions(companyID=CLIENT.companyID);

       // Declare variable to store total by region
        totalBonusRegion = 0;
    </cfscript>	

    
    <cfif FORM.submitted>
    
    	<cfscript>		
			// Get Selected Region
			qGetSelectedRegion = APPCFC.REGION.getRegions(regionID=FORM.regionID);
		</cfscript>
    
		<!--- Get only 10 August Placements - 10 Month and 1st Semester --->
        <cfquery name="qTotalPlacedCurrent" datasource="#APPLICATION.dsn#">
            SELECT
                u.userID,
                u.firstName,
                u.lastName,
                COUNT(s.studentID) AS count
            FROM 
                smg_students s
            INNER JOIN
                smg_users u ON u.userID = s.placeRepID
            INNER JOIN 
                smg_programs p ON p.programid = s.programid AND p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,3,5,25" list="yes"> )
            INNER JOIN 
                smg_incentive_trip t ON p.tripid = t.tripid
            WHERE 
                s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#"> 
            AND 
                s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
            AND 
                t.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
			<!--- Get active students or students canceled after July 31st that either withdrewl or terminated the program --->
            AND 
                (
                    s.cancelDate IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                OR
                    (
                        s.cancelDate > <cfqueryparam cfsqltype="cf_sql_date" value="#Year(now())#-07-31">                
                    AND    
                        (
                            s.cancelReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="Withdrawl">   
                        OR
                            s.cancelReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="Termination">   
                        )
                    )
                 )
            GROUP BY
                u.userID        
            ORDER BY
                u.lastName
        </cfquery>
                
        <cfquery name="qIncentiveTrip" datasource="#APPLICATION.dsn#">
            SELECT 
                tripID,
                trip_place
            FROM 
                smg_incentive_trip 
            WHERE 
                active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        </cfquery>

	</cfif>

</cfsilent>

<cfoutput>

<cfif NOT FORM.submitted>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Placement Bonus Report"
        tableRightTitle=""
    />
    
    <table border="0" cellpadding="8" cellspacing="2" width=100% class="section">
        <tr>
            <td width="50%" valign="top">
                
                <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                <input type="hidden" name="submitted" value="1">
                <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                    <tr><th colspan="2" bgcolor="##e2efc7">Placement Bonus Report</th></tr>
                    <tr>
                        <td>Region: </td>
                        <td align="left">
                            <select name="regionID">
                                <cfloop query="qGetRegionList">
                                    <option value="#qGetRegionList.regionID#">#qGetRegionList.regionName#</option>
                                </cfloop>
                            </select>
                        </td>
                     </tr>
                    <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                </table>
                </form>
                
            </td>
            <td width="50%" valign="top">
                
            </td>
        </tr>
    </table>
    
    <!--- Table Footer --->
    <gui:tableFooter />
    
<cfelse>

    <table width="100%" cellpadding="4" cellspacing="0" align="center" style="border:1px solid ##333333">
        <tr>
            <th colspan="4">Thank You Bonus Report - Region: #qGetSelectedRegion.regionName#</th>
        </tr>
        <tr valign="top" bgcolor="##CCCCCC">
            <td><strong>Placing Representative</strong></td>
            <th>August students placed in #Year(now())-1#</th>
            <th>August students placed in #Year(now())#</th>
            <td><strong>Bonus</strong></td>
        </tr>       
        <cfloop query="qTotalPlacedCurrent">
        
            <cfquery name="qTotalIncentiveTrip" datasource="#APPLICATION.dsn#">
                SELECT
                    COUNT(s.studentID) AS count
                FROM 
                    smg_students s
                INNER JOIN 
                    smg_programs ON smg_programs.programid = s.programid
                INNER JOIN 
                    smg_incentive_trip t ON smg_programs.tripid = t.tripid
                WHERE 
                    s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qTotalPlacedCurrent.userID#"> 
                AND 
                    s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                AND 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    t.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
            </cfquery>
        
            <!--- 
			Get only 10 August Placements - 10 Month and 1st Semester
			It does not include students that were cancelled prior to August 31st 
			--->
            <cfquery name="qTotalPlacedPrevious" datasource="#APPLICATION.dsn#">
                SELECT
                    COUNT(s.studentID) AS count
                FROM 
                    smg_students s
                INNER JOIN 
                    smg_programs p ON p.programid = s.programid AND p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,3,5,25" list="yes"> )
                INNER JOIN 
                    smg_incentive_trip t ON p.tripid = t.tripid
                WHERE 
                    s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qTotalPlacedCurrent.userID#"> 
                AND 
                    s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                <!--- Get active students or students canceled after July 31st that either withdrewl or terminated the program --->
                AND 
                    (
                        s.cancelDate IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    OR
                        (
                            s.cancelDate > <cfqueryparam cfsqltype="cf_sql_date" value="#Year(now())-1#-07-31">                
                        AND    
                            (
                                s.cancelReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="Withdrawl">   
                            OR
                                s.cancelReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="Termination">   
                            )
                        )
                     )
                AND 
                    t.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qIncentiveTrip.tripID - 1#">  
            </cfquery>
        
            <cfscript>
                // Number of Placements for previous season
                setPlacedPrevious = qTotalPlacedPrevious.count;
                //setPlacedPrevious = 0;
                
                // Number of Placements for current season
                setPlacedCurrent = qTotalPlacedCurrent.count;
                //setPlacedCurrent = 6;
                
                // Number of minimum placements to get 1st bonus (previous placement + 3)
                setMinCurrent = setPlacedPrevious + 3;
                
                // Declare Multiplier
                setMultiplier = 0;
        
                // Declare First Bonus
                firstBonusMessage = '';
        
                // Set current row used in the loop
                currentRow = 0;
        
                if ( ListFind("0,1,2,3,4,5", setPlacedPrevious) ) {
                    // Starts at $450 with $50 increment for 0-5 students placed previous year
                    setBonus = 450 + (50 * setPlacedPrevious);		
                } else if ( ListFind("6,7,8,9,10", setPlacedPrevious) ) {
                    // $800 bonus for 6-10 students placed previous year
                    setBonus = 800;
                } else if ( ListFind("11,12,13,14,15", setPlacedPrevious) ) {
                    // $900 bonus for 11-15 students placed previous year
                    setBonus = 900;
                } else {
                    // $1000 bonus for 16 students placed previous year and on 
                    setBonus = 1000;
                }
                
                // Check if setMinCurrent goal has been reached, if yes user won a bonus and we need to reset setMinCurrent
                if ( setPlacedCurrent GTE setMinCurrent ) {
                    
                    // Calculate how many times bonus needs to be multiplied
                    setFirstBonusMultiplier = fix( (setPlacedCurrent - setPlacedPrevious) / 3);
                    firstBonusMessage = setBonus * setFirstBonusMultiplier;
                    
					// Calculate Total Region Bonus
                    totalBonusRegion = totalBonusRegion + firstBonusMessage;
                    
                    // setMinCurrent has been reached. Set a new setMinCurrent in increments of 3
                    do {
                        setMinCurrent = setMinCurrent + 3;
                    } while ( setPlacedCurrent GTE setMinCurrent );
                }
            </cfscript>
        
            <tr bgcolor="###iif(qTotalPlacedCurrent.currentrow MOD 2 ,DE("FFFFFF") ,DE("EDEDED") )#">
                <td>#qTotalPlacedCurrent.firstName# #qTotalPlacedCurrent.lastName# (###qTotalPlacedCurrent.userID#)</td>
                <td align="center">#setPlacedPrevious#</td>
                <td align="center">#setPlacedCurrent#</td>	
                <td>
                    <cfif LEN(firstBonusMessage)>
                       #DollarFormat(firstBonusMessage)# <br />
                    <cfelse>
                        n/a
                    </cfif>
                </td>
            </tr>
            
        </cfloop>
        
        <tr>
            <td colspan="3" align="right">Total Bonus for #qGetSelectedRegion.regionName# Region:</td>
            <td><strong>#DollarFormat(totalBonusRegion)#</strong></td>
        </tr>
    </table>

</cfif>

</cfoutput>