<!--- ------------------------------------------------------------------------- ----
	
	File:		_userIncentiveTripReport.cfm
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
		vReportTitle = "Representative Management - Incentive Trip Report";
		if (FORM.reportType EQ 1) {
			vReportTitle = vReportTitle & " Guest List";	
		} else if (FORM.reportType EQ 2) {
			vReportTitle = vReportTitle & " Payment List";
		} else {
			vReportTitle = vReportTitle & " Payment List with Students";	
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
    
    <!--- Get the current user's region. This is used for Regional Managers to limit the results. --->
    <cfquery name="qGetUserRegion" datasource="#APPLICATION.DSN#">
		SELECT regionID
        FROM user_access_rights
        WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
        AND default_access = 1  	
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
                    	<cfif CLIENT.userType EQ 5>AND r.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetUserRegion.regionID)#"></cfif>
                    LEFT OUTER JOIN smg_userType ut ON ut.userTypeID = guest.userType
                    WHERE isDeleted = 0
                    AND guest.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
                    AND uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.companyID#"> )
                    GROUP BY guest.ID
                </cfquery>
            <cfelseif ListFind("2,3",FORM.reportType) >
                <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                	SELECT
                    	u.userID,
                        u.firstName,
                        u.lastName,
                        r.regionName,
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
                            AND (s.cancelDate IS NULL OR s.cancelDate = "") 
                        	AND t.active = 1
                            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG,FORM.companyID)>
                            	AND s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#"> )
                            <cfelse>
                            	AND s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.companyID#"> )
                          	</cfif> ) AS placementCount,
                       	(
                        	SELECT SUM(points)
                            FROM smg_incentive_trip_points
                            WHERE isDeleted = 0
                            AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
                            AND userID = u.userID ) AS pointCount,
                     	(
                        	SELECT COUNT(*)
                            FROM smg_incentive_trip_guests
           					WHERE isDeleted = 0
            				AND userID = u.userID
          					AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#"> ) AS guestCount
                    FROM smg_users u
                    INNER JOIN user_access_rights uar ON uar.userID = u.userID
                        AND uar.default_access = 1
                  	INNER JOIN smg_regions r ON r.regionID = uar.regionID
                 	LEFT OUTER JOIN smg_incentive_trip_payment payment ON payment.userID = u.userID
                    	AND payment.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
                    WHERE uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.companyID#"> )
                    <cfif CLIENT.userType EQ 5>AND uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetUserRegion.regionID)#"></cfif>
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

        <form action="report/index.cfm?action=userIncentiveTripReport" name="officeIncentiveTrip" id="officeIncentiveTrip" method="post" target="blank">
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
                <cfif CLIENT.companyID EQ 5>
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
                <cfelse>
                	<input type="hidden" name="companyID" value="#CLIENT.companyID#" />
                </cfif>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Report Type: <span class="required">*</span></td>
                    <td>
                        <select name="reportType" id="reportType" class="xLargeField" required>
                            <option value="1">Traveler List</option>
                            <option value="2">Payment List</option>
                            <option value="3">Payment List with Students</option>
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
                        <td class="subTitleLeft" width="18%">Representative</td>
                        <td class="subTitleLeft" width="12%">Region</td>
                        <td class="subTitleCenter" width="10%">Number of Placements/Points</td>	
                        <td class="subTitleCenter" width="10%">Number of Earned Trips</td>
                        <td class="subTitleCenter" width="10%">Number of Travelers </td>
                        <td class="subTitleCenter" width="10%">Taking Check</td>
                        <td class="subTitleLeft" width="15%">Amount owed to Rep.</td>
                        <td class="subTitleLeft" width="15%">Amount Rep owes</td>
                    </tr>
                    
                    <cfscript>
                        vRowCount = 1;
                        vRowColor = "##FFFFFF";
						
						vTotalPlacements = 0;
						vTotalEarnedTrips = 0;
						vTotalGuests = 0;
						vTotalTakingCheck = 0;
						vTotalISEOwes = 0;
						vTotalRepOwes = 0;
                    </cfscript>
                    
                    <cfloop query="qGetResults">
                    
                    	<cfscript>
							vNumPlacements = VAL(qGetResults.placementCount) + VAL(qGetResults.pointCount);
							vTripsEarned = APPLICATION.CFC.USER.getTripsEarned(numPlacements = vNumPlacements);
							vNumGuests = qGetResults.guestCount;
						</cfscript>
                    
                    	<cfif vNumPlacements GT 6>
                        
							<cfscript>
                                if ( vRowCount MOD 2 ) {
                                    vRowColor = "##F2F2F2";
                                } else {
                                    vRowColor = "##FFFFFF";
                                }
                                vRowCount ++;
                                
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
								
								vTotalPlacements = vTotalPlacements + vNumPlacements;
								vTotalEarnedTrips = vTotalEarnedTrips + vTripsEarned;
								vTotalGuests = vTotalGuests + vNumGuests;
								vTotalISEOwes = vTotalISEOwes + vISEOwes;
								vTotalRepOwes = vTotalRepOwes + vRepOwes;
								
								if (vTakingCheck EQ "Yes") {
									vTotalTakingCheck = vTotalTakingCheck + vTakingCheck;	
								}
                                
                            </cfscript>
                        
                            <tr>
                                <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#firstName# #lastName# (###userID#)</td>
                                <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#regionName#</td>
                                <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#vNumPlacements#</td>
                                <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#vTripsEarned#</td>
                                <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#vNumGuests#</td>
                                <td style="font-size:10px" bgcolor="#vRowColor#" align="center">#vTakingCheck#</td>
                                <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#DollarFormat(vISEOwes)#</td>
                                <td style="font-size:10px" bgcolor="#vRowColor#" align="left">#DollarFormat(vRepOwes)#</td>
                            </tr>
                            
                            <cfif FORM.reportType EQ 3>
                            	
								<!--- Get students and points --->
                                <cfquery name="qGetPlacements" datasource="#APPLICATION.DSN#">
                                	SELECT s.*
                                    FROM smg_students s    
                                    INNER JOIN smg_programs p ON p.programID = s.programID    
                                    INNER JOIN smg_incentive_trip t ON t.tripID = p.tripID
                                    WHERE s.placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.userID#">
                                    AND s.host_fam_approved < 5
                                    AND (s.cancelDate IS NULL OR s.cancelDate = "")
                                    AND t.active = 1
                                    <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG,FORM.companyID)>
                                        AND s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#"> )
                                    <cfelse>
                                        AND s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.companyID#"> )
                                    </cfif>
                                </cfquery>
                                <cfquery name="qNonQualifiedGetPlacements" datasource="#APPLICATION.DSN#">
                                	SELECT s.*
                                    FROM smg_students s    
                                    INNER JOIN smg_programs p ON p.programID = s.programID    
                                    INNER JOIN smg_incentive_trip t ON t.tripID = p.tripID
                                    WHERE s.placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.userID#">
                                    AND (s.host_fam_approved >= 5 OR (s.cancelDate IS NOT NULL AND s.cancelDate != ""))
                                    AND t.active = 1
                                    <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG,FORM.companyID)>
                                        AND s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#"> )
                                    <cfelse>
                                        AND s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.companyID#"> )
                                    </cfif>
                                </cfquery>
                                <tr>
                                    <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="2">&nbsp;</td>
                                    <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="7">EARNED:</td>
                                </tr>
                                <cfloop query="qGetPlacements">
                                    <tr>
                                        <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="2">&nbsp;</td>
                                        <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="7">&nbsp;&nbsp;&nbsp;#firstName# #middlename# #familylastname# (###studentID#)</td>
                                    </tr>
                              	</cfloop>
                                <tr>
                                    <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="2">&nbsp;</td>
                                    <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="7">&nbsp;&nbsp;&nbsp;+#VAL(qGetResults.pointCount)# points</td>
                                </tr>
                                <tr>
                                    <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="2">&nbsp;</td>
                                    <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="7">NOT EARNED:</td>
                                </tr>
                                <cfloop query="qNonQualifiedGetPlacements">
                                    <tr>
                                        <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="2">&nbsp;</td>
                                        <td style="font-size:10px" bgcolor="#vRowColor#" align="left" colspan="7">&nbsp;&nbsp;&nbsp;#firstName# #middlename# #familylastname# (###studentID#)</td>
                                    </tr>
                              	</cfloop>
                                
                            </cfif>
                            
                      	</cfif>
                        
                    </cfloop>
                    
                    <tr>
                        <td style="font-size:12px; font-weight:bold; border-top:thin solid black;" colspan="2">TOTAL:</td>
                        <td style="font-size:12px; font-weight:bold; border-top:thin solid black;" align="center">#vTotalPlacements#</td>
                        <td style="font-size:12px; font-weight:bold; border-top:thin solid black;" align="center">#vTotalEarnedTrips#</td>
                        <td style="font-size:12px; font-weight:bold; border-top:thin solid black;" align="center">#vTotalGuests#</td>
                        <td style="font-size:12px; font-weight:bold; border-top:thin solid black;" align="center">#vTotalTakingCheck#</td>
                        <td style="font-size:12px; font-weight:bold; border-top:thin solid black;">#DollarFormat(vTotalISEOwes)#</td>
                        <td style="font-size:12px; font-weight:bold; border-top:thin solid black;">#DollarFormat(vTotalRepOwes)#</td>
                    </tr>
                    
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