<!--- ------------------------------------------------------------------------- ----
	
	File:		_officeIncentiveTripReport.cfm
	Author:		James Griffiths
	Date:		June 18, 2014
	Desc:		Incentive Trip Guests	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.seasonID" default=0;
		param name="FORM.companyID" default=0;
		param name="FORM.reportType" default=1;
		param name="FORM.outputType" default="flashPaper";

		// Set Report Title To Keep Consistency
		vReportTitle = "Office Management - Incentive Trip Report";
		if (FORM.reportType EQ 1) {
			vReportTitle = vReportTitle & " Guest List";	
		} else {
			vReportTitle = vReportTitle & " Payment List";
		}
		
		vCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
	</cfscript>
    
    <cfquery name="qGetCompanies" datasource="#APPLICATION.DSN#">
    	SELECT *
        FROM smg_companies
        WHERE companyName = "International Student Exchange"
        AND companyID != 5
        ORDER BY companyID
    </cfquery>
    
    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
    
    	<cfscript>
			// Data Validation
            if ( NOT VAL(FORM.companyID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one company");
            }
		</cfscript>
        
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
    
    		<cfif FORM.reportType EQ 1>
            	<cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                    SELECT
                        guest.*,
                        r.regionName,
                        u.firstName,
                        u.lastName,
                        u.userID,
                        CASE
                            WHEN guest.userType = 0 THEN "Regular Guest"
                            ELSE ut.userType
                            END AS guestType
                    FROM smg_incentive_trip_guests guest
                    INNER JOIN smg_users u ON u.userID = guest.userID
                    INNER JOIN user_access_rights uar ON uar.userID = u.userID
                        AND uar.default_access = 1
                    INNER JOIN smg_regions r ON r.regionID = uar.regionID
                    LEFT OUTER JOIN smg_userType ut ON ut.userTypeID = guest.userType
                    WHERE isDeleted = 0
                    AND guest.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
                    AND uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.companyID#"> )
                    GROUP BY guest.ID
                </cfquery>
            <cfelseif FORM.reportType EQ 2>
                
                <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                	SELECT
                    	u.userID,
                        u.firstName,
                        u.lastName,
                        CASE
                        	WHEN payment.takingCheck = "" OR payment.takingCheck IS NULL OR payment.takingCheck = 0 THEN 0
                            ELSE 1
                            END AS takingCheck,
                        (
                        	SELECT COUNT(studentID) 
                     		FROM smg_students s    
                    		INNER JOIN smg_programs p ON p.programID = s.programID    
                     		INNER JOIN smg_incentive_trip t ON t.tripID = p.tripID
                     		WHERE s.placeRepID = u.userID
                            AND s.host_fam_approved < 5 
                        	AND s.active = 1
                        	AND t.active = 1 ) AS placementCount,
                     	(
                        	SELECT COUNT(*)
                            FROM smg_incentive_trip_guests
           					WHERE isDeleted = 0
            				AND userID = u.userID
          					AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#"> ) AS guestCount
                    FROM smg_users u
                    INNER JOIN user_access_rights uar ON uar.userID = u.userID
                        AND uar.default_access = 1
                 	LEFT OUTER JOIN smg_incentive_trip_payment payment ON payment.userID = u.userID
                    	AND payment.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
                    WHERE u.userID IN (
           				SELECT placeRepID 
                  		FROM smg_students s    
                  		INNER JOIN smg_programs p ON p.programID = s.programID
                      	INNER JOIN smg_incentive_trip t ON t.tripID = p.tripID
                      	WHERE s.host_fam_approved < 5 
                      	AND s.active = 1      
                      	AND t.active = 1 )      
                    AND (
                   		SELECT COUNT(studentID) 
                     	FROM smg_students s    
                    	INNER JOIN smg_programs p ON p.programID = s.programID    
                     	INNER JOIN smg_incentive_trip t ON t.tripID = p.tripID
                     	WHERE s.placeRepID = u.userID
                        AND s.host_fam_approved < 5 
                        AND s.active = 1
                        AND t.active = 1 ) > 6
                   	AND uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.companyID#"> )
                    GROUP BY u.userID
                    ORDER BY u.lastName, u.firstName
                </cfquery>
                
            </cfif>
            
        </cfif>
    
	</cfif>
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

	<cfoutput>

        <form action="report/index.cfm?action=officeIncentiveTripReport" name="officeIncentiveTrip" id="officeIncentiveTrip" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="8" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Season: <span class="required">*</span></td>
                    <td>
                        <select name="seasonID" id="seasonID" class="xLargeField" required>
                            <cfloop query="qGetSeasonList">
                            	<cfif seasonID EQ vCurrentSeason>
                                	<option value="#seasonID#" selected="selected">#season#</option>
                                <cfelse>
                                	<option value="#seasonID#">#season#</option>
                                </cfif>
                          	</cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Company: <span class="required">*</span></td>
                    <td>
                        <select name="companyID" id="companyID" class="xLargeField" multiple size="5" required>
                            <cfloop query="qGetCompanies">
                            	<option value="#companyID#">#companyShort#</option>
                            </cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Report Type: <span class="required">*</span></td>
                    <td>
                        <select name="reportType" id="reportType" class="xLargeField" required>
                            <option value="1">Guest List</option>
                            <option value="2">Payment List</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" class="xLargeField">
                        	<option value="flashPaper">FlashPaper</option>
                            <option value="onScreen">On Screen</option>
                            <option value="Excel">Excel Spreadsheet</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required Fields</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                        This report will provide a total of all new area reps per region.
                    </td>		
                </tr>
                <tr>
                    <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                </tr>
            </table>
        </form>	

	</cfoutput>
    
<!--- FORM Submitted --->
<cfelse>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	
    
    <!--- FORM Submitted with errors --->
    <cfif SESSION.formErrors.length()> 
       
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />	
            
		<cfabort>            
	</cfif>
    
    <cfsavecontent variable="report">
    
    	<cfif FORM.outputType EQ "excel">
        	<style type="text/css">
				table {
					border: thin solid black;	
				}
				td {
					border: thin solid black;
					font-weight: normal;
				}
				.subTitleLeft, .subTitleCenter, .subTitleRight {
					font-size: 12px;
					font-weight: bold;
				}
			</style>
        <cfelse>
        	<style type="text/css">
				td {
					font-weight: bold;
				}
				.subTitleLeft, .subTitleCenter, .subTitleRight {
					font-size: 10px;
				}
			</style>
        </cfif>
    
        <cfoutput>
        
        	<cfscript>
				vCols = 7;
				if (FORM.reportType EQ 2) {
					vCols = 6;	
				}
			</cfscript>
              
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th colspan="#vCols#">#vReportTitle#</th>            
                </tr>
            </table>
            
            <cfif FORM.reportType EQ 1>
            
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <td class="subTitleLeft" width="15%">Guest Name</td>
                        <td class="subTitleLeft" width="10%">DOB</td>	
                        <td class="subTitleLeft" width="15%">Departure Airport</td>
                        <td class="subTitleLeft" width="10%">Region</td>
                        <td class="subTitleLeft" width="10%">Guest Type</td>
                        <td class="subTitleLeft" width="15%">Guest of</td>
                        <td class="subTitleCenter" width="25%">Comments</td>
                    </tr>
                    
                    <cfscript>
                        vRowCount = 1;
                        vRowColor = "##FFFFFF";
                    </cfscript>
                    
                    <cfloop query="qGetResults">
                    
                        <cfscript>
                            if ( vRowCount MOD 2 ) {
                                vRowColor = "##F2F2F2";
                            } else {
                                vRowColor = "##FFFFFF";
                            }
                            vRowCount ++;
                        </cfscript>
                        
                        <tr>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#name#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#DateFormat(dob,'mm/dd/yyyy')#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#departureAirport#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#regionName#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#guestType#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#firstName# #lastName# (###userID#)</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#comments#</td>
                        </tr>
                        
                    </cfloop>
                </table>
                
            <cfelse>
            
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <td class="subTitleLeft" width="21%">Representative</td>
                        <td class="subTitleCenter" width="13%">Number of Placements</td>	
                        <td class="subTitleCenter" width="13%">Number of Earned Trips</td>
                        <td class="subTitleCenter" width="13%">Number of Guests</td>
                        <td class="subTitleCenter" width="10%">Taking Check</td>
                        <td class="subTitleLeft" width="15%">Amount owed to Rep.</td>
                        <td class="subTitleLeft" width="15%">Amount Rep owes</td>
                    </tr>
                    
                    <cfscript>
                        vRowCount = 1;
                        vRowColor = "##FFFFFF";
                    </cfscript>
                    
                    <cfloop query="qGetResults">
                        
                        <cfscript>
                            if ( vRowCount MOD 2 ) {
                                vRowColor = "##F2F2F2";
                            } else {
                                vRowColor = "##FFFFFF";
                            }
                            vRowCount ++;
                            
                            vNumPlacements = qGetResults.placementCount;
                            vTripsEarned = APPLICATION.CFC.USER.getTripsEarned(numPlacements = vNumPlacements);
                            vNumGuests = qGetResults.guestCount;
                            
                            vCost = 0;
                            if (vTripsEarned GTE vNumGuests) {
                                vCost = vCost - ((vTripsEarned - vNumGuests)*500);
                            } else {
                                vCost = vCost + APPLICATION.CFC.USER.getAdditionalTripCost(numEarnedTrips=vTripsEarned,numPlacements=vNumPlacements);
								vRemainingGuests = vNumGuests - vTripsEarned - 1;
								vCost = vCost + (vRemainingGuests*1800);
                            }
                            
                            vISEOwes = 0;
                            vRepOwes = 0;
                            if (vCost LT 0) {
                                vISEOwes = -vCost;	
                            } else {
                                vRepOwes = vCost;	
                            }
							
							vTakingCheck = "No";
							if (vCost LT 0 AND takingCheck) {
								vTakingCheck = "Yes";
							}
                            
                        </cfscript>
                    
                        <tr>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#firstName# #lastName# (###userID#)</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#vNumPlacements#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#vTripsEarned#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#vNumGuests#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#vTakingCheck#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">$#vISEOwes#</td>
                            <td style="font-size:10px" bgcolor="#vRowColor#" align="left">$#vRepOwes#</td>
                        </tr>
                        
                    </cfloop>
                </table>
            
            </cfif>
                
        </cfoutput>
        
    </cfsavecontent>
    
    <cfif FORM.outputType EQ "flashPaper">

        <cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">

            <!--- Page Header --->
            <gui:pageHeader
                headerType="applicationNoHeader"
                filePath="../"
            />
            
            <cfoutput>#report#</cfoutput>
            
        </cfdocument>
        
    <cfelseif FORM.outputType EQ 'excel'>
    
        <cfcontent type="application/msexcel">
        <cfheader name="Content-Disposition" value="attachment; filename=#vReportTitle#.xls">
        <cfoutput>#report#</cfoutput>
        
    <cfelse>
    
        <cfoutput>#report#</cfoutput>
        
    </cfif>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    