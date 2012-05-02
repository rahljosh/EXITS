<!--- ------------------------------------------------------------------------- ----
	
	File:		_complianceMileageReport.cfm
	Author:		James Griffiths
	Date:		May 2, 2012
	Desc:		Compliance Mileage Report By Region
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=complianceMileageReport
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;
		param name="FORM.regionID" default=0;
		param name="FORM.displayOutOfCompliance" default="";
		param name="FORM.displayPending" default="";
		
		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
   		/**
         * Calculates the distance (in statute miles, nautical miles, kilometers or radians) between two latitude/longitude coordinates.
         * This function uses forumlae from Ed Williams Aviation Foundry website at http://williams.best.vwh.net/avFORM.htm.      
         * 
         * @param lat1 	 Latitude of first point in degrees. 
         * @param lon1 	 Longitude of first point in degrees. 
         * @param lat2 	 Latitude of second point in degrees. 
         * @param lon2 	 Longitude of second point in degrees. 
         * @param units 	 Unit to return distance in.  Options are km (kilometers), sm (statute miles), nm (nautical miles) or radians (radians).
         * @return Returns a simple value or a string to notify of incorrect parameters being passed. 
         * @author Tom Nunamaker (Contact me)
         * @version 1.0, February 10, 2002
         */
        function LatLonDist(lat1,lon1,lat2,lon2,units) {
          // Check to make sure latitutdes and longitudes are valid
          if(lat1 GT 90 OR lat1 LT -90 OR
             lon1 GT 180 OR lon1 LT -180 OR
             lat2 GT 90 OR lat2 LT -90 OR
             lon2 GT 280 OR lon2 LT -280) {
            Return ("Incorrect parameters");
          }
        
          lat1 = lat1 * pi()/180;
          lon1 = lon1 * pi()/180;
          lat2 = lat2 * pi()/180;
          lon2 = lon2 * pi()/180;
          UnitConverter = 1.150779448;  //standard is statute miles
		  
          if(units eq 'nm') {
            UnitConverter = 1.0;
          }
          
          if(units eq 'km') {
            UnitConverter = 1.852;
          }
          
          distance = 2*asin(sqr((sin((lat1-lat2)/2))^2 + cos(lat1)*cos(lat2)*(sin((lon1-lon2)/2))^2));  //radians
          
          if(units neq 'radians'){
            distance = UnitConverter * 60 * distance * 180/pi();
          }
          
          Return (distance) ;
        }
    </cfscript>
    
    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
		SELECT 
        	s.studentID, 
            s.firstname, 
            s.familylastname,
            s.active,
            s.cancelDate,
            ht.historyID,
            ht.hfSupervisingDistance,
			h.hostid, 
            h.familylastname AS hostlastname,
            CONCAT(h.address, ', ', h.city, ', ', h.state, ', ', h.zip) AS hostAddress,
            h.zip AS hostzip,
            r.regionID,
            r.regionName,
			u.userid, 
            u.firstname AS supervisingFirstName, 
            u.lastname AS supervisingLastName, 
            CONCAT(u.address, ', ', u.city, ', ', u.state, ', ', u.zip) AS supervisingAddress,
            u.zip AS supervisingZip,
            c.companyShort
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		INNER JOIN
        	smg_regions r ON r.regionID = s.regionAssigned
            AND
                r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#" list="yes"> )
        INNER JOIN
        	smg_companies c ON c.companyID = r.company
        LEFT JOIN 
        	smg_users u ON s.arearepid = u.userid
		INNER JOIN
        	smg_hostHistory ht ON ht.studentID = s.studentID
                AND 
                	ht.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">            	
				AND
                	ht.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">    
                AND
                	ht.hostID = h.hostID
                AND
                	ht.areaRepID = u.userID
				<cfif VAL(displayOutOfCompliance)>
                AND
                	(
                    	hfSupervisingDistance >= <cfqueryparam cfsqltype="cf_sql_integer" value="100">
                     OR
                    	hfSupervisingDistance = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    )
                </cfif>                    
		WHERE 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
            <cfif FORM.displayPending EQ "on">
            	AND
                	s.host_fam_approved >= <cfqueryparam cfsqltype="cf_sql_integer" value=4>
            </cfif>
        ORDER BY	
        	c.companyShort,
            r.regionName,
            supervisingLastName,
            s.familyLastName
	</cfquery> 
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<cfoutput>

	<!--- Report Header Information --->
    <cfsavecontent variable="reportHeader">
    
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th>Representative Management - Compliance Mileage Report</th>            
            </tr>
            <tr>
                <td class="center"><strong>Total Number of Students in this report:</strong> #qGetResults.recordcount# <br /></td>
            </tr>
            <tr>
            	<td class="center">
                    Program(s) included in this report: <br />
                    <cfloop query="qGetPrograms">
                        #qGetPrograms.programName# <br />
                    </cfloop>
                </td>
            </tr>            
        </table>
    
    </cfsavecontent>
    
    <cfif (NOT LEN(FORM.regionID) OR NOT LEN(FORM.programID))>
        
        <!--- Include Report Header --->
        #reportHeader#
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr class="on">
                <td class="subTitleCenter">
                    <p>You must select Program and Region information. Please close this window and try again.</p>
                    <p><a href="javascript:window.close();" title="Close Window"><img src="../pics/close.gif" /></a></p>
                </td>
            </tr>      
        </table>
        <cfabort>
    </cfif>

</cfoutput>

<!--- Output in Excel - Do not use GroupBy --->
<cfif FORM.outputType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=complianceMileageReport.xls"> 
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr><th colspan="5">Representative Management - Compliance Mileage Report</th></tr>
        <tr style="font-weight:bold;">
            <td>Region</td>
            <td>Student</td>
            <td>Supervising Representative</td>
            <td>Host Family</td>
            <td>Google Shortest Driving Distance</td>
        </tr>
        
        <cfscript>
      		vCurrentRow = 0;
		</cfscript>
    
		<cfloop query="qGetResults">
        
        	<cfoutput>
                                          
                <cfquery name="qGetHostCoordinates" datasource="MySql">
                    SELECT 
                        zip, 
                        latitude, 
                        longitude
                    FROM 
                        zip_codes
                    WHERE 
                        zip = <cfqueryparam cfsqltype="cf_sql_integer" value="#Left(VAL(qGetResults.hostZip), 5)#">
                </cfquery>
                
                <cfquery name="qGetSupervisingCoordinates" datasource="MySql">
                    SELECT 
                        zip, 
                        latitude, 
                        longitude
                    FROM 
                        zip_codes
                    WHERE 
                        zip = <cfqueryparam cfsqltype="cf_sql_integer" value="#Left(VAL(qGetResults.supervisingZip), 5)#">
                </cfquery>
                        
                <cfscript>
                    
                    vCurrentRow++;
                
                    // Old Method
                    vDistance = LatLonDist(qGetHostCoordinates.latitude,qGetHostCoordinates.longitude,qGetSupervisingCoordinates.latitude,qGetSupervisingCoordinates.longitude,'sm');
                    
                    vUpdateTable = 0;
                    
                    // Check if we have recorded distance in the database from Google driving directions
                    if ( VAL(qGetResults.hfSupervisingDistance) ) {
        
                        vGoogleDistance = qGetResults.hfSupervisingDistance;
        
                    } else {
                    
                        // New Method
                        vGoogleDistance = APPLICATION.CFC.UDF.calculateAddressDistance(origin=qGetResults.hostAddress,destination=qGetResults.supervisingAddress);
                        vUpdateTable = 1;
                        
                    }
                    
                    // Set Row Color
                    vRowColor = '';	
                    if ( vCurrentRow MOD 2 ) {
                        vRowColor = 'bgcolor="##E6E6E6"';
                    } else {
                        vRowColor = 'bgcolor="##FFFFFF"';
                    }
                    
                    // Set Alert Color
                    vSetColorCode = '';				
                    if ( VAL(vGoogleDistance) GT 120 ) {
                        vSetColorCode = 'bgcolor="##FF0000"';	
                    } else if ( VAL(vGoogleDistance) GTE 100 ) {
                        vSetColorCode = 'bgcolor="##FFE87C"';	
                    }
                </cfscript>
                
                <tr>
                    <td #vRowColor#>#qGetResults.regionName#</td>
                    <td #vRowColor#>
                        #qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentID#)
                        <cfif VAL(qGetResults.active)>
                            <span class="note">(Active)</span>
                        <cfelseif isDate(qGetResults.cancelDate)>
                            <span class="noteAlert">(Cancelled)</span>
                        </cfif>
                    </td>
                    <td #vRowColor#>
                        #qGetResults.supervisingFirstName# #qGetResults.supervisingLastName# (###qGetResults.userID#)
                        <span class="note">#qGetResults.supervisingAddress#</span>
                    </td>     
                    <td #vRowColor#>
                        #qGetResults.hostlastname# (###qGetResults.hostid#)
                        <span class="note">#qGetResults.hostAddress#</span>
                    </td>                           
                    <td #vSetColorCode#>#vGoogleDistance# mi</td>
                </tr>
                
                <cfscript>
                    // Update Distance in the database
                    if ( VAL(vUpdateTable) AND IsNumeric(vGoogleDistance) ) {
                    
                        APPLICATION.CFC.STUDENT.updateHostSupervisingDistance(
                            historyID=qGetResults.historyID	,
                            distanceInMiles=vGoogleDistance												  																	  
                        );
                        
                    }
                </cfscript>
            
            </cfoutput>
                    
        </cfloop>
        
  	</table>

<!--- On Screen Report --->
<cfelse>

	<cfoutput>
        
        <!--- Include Report Header --->   
		#reportHeader#
        
        <!--- No Records Found --->
        <cfif NOT VAL(qGetResults.recordCount)>
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr class="on">
                	<td class="subTitleCenter">No records found</td>
                </tr>      
            </table>
        	<cfabort>
        </cfif>
   	</cfoutput>
        
    <cfoutput query="qGetResults" group="regionID">

		<cfscript>
            // Set Current Row used to display light blue color on the table
            vCurrentRow = 0;
        </cfscript>

        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th class="left" colspan="5">
                    #qGetResults.regionName# Region
                </th>
            </tr>      
            <tr>
                <td class="subTitleLeft" width="28%">Student</td>
                <td class="subTitleLeft" width="28%">Supervising Representative</td>		            
                <td class="subTitleLeft" width="28%">Host Family</td>				
                <td class="subTitleCenter" width="16%">Google Shortest Driving Distance</td>
            </tr>      

		<cfoutput>
			            
			<cfquery name="qGetHostCoordinates" datasource="MySql">
				SELECT 
					zip, 
					latitude, 
					longitude
				FROM 
					zip_codes
				WHERE 
					zip = <cfqueryparam cfsqltype="cf_sql_integer" value="#Left(VAL(qGetResults.hostZip), 5)#">
			</cfquery>
			
			<cfquery name="qGetSupervisingCoordinates" datasource="MySql">
				SELECT 
					zip, 
					latitude, 
					longitude
				FROM 
					zip_codes
				WHERE 
					zip = <cfqueryparam cfsqltype="cf_sql_integer" value="#Left(VAL(qGetResults.supervisingZip), 5)#">
			</cfquery>
		
			<cfscript>
				vCurrentRow++;
			
				// Old Method
				vDistance = LatLonDist(qGetHostCoordinates.latitude,qGetHostCoordinates.longitude,qGetSupervisingCoordinates.latitude,qGetSupervisingCoordinates.longitude,'sm');
				
				vUpdateTable = 0;
				
				// Check if we have recorded distance in the database from Google driving directions
				if ( VAL(qGetResults.hfSupervisingDistance) ) {

					vGoogleDistance = qGetResults.hfSupervisingDistance;

				} else {
				
					// New Method
					vGoogleDistance = APPLICATION.CFC.UDF.calculateAddressDistance(origin=qGetResults.hostAddress,destination=qGetResults.supervisingAddress);
					vUpdateTable = 1;
					
				}
				
				vSetColorCode = '';
				
				if ( VAL(vGoogleDistance) GT 120 ) {
					vSetColorCode = 'alert';	
				} else if ( VAL(vGoogleDistance) GTE 100 ) {
					vSetColorCode = 'attention';	
				}
			</cfscript>
			                            
            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                <td>
                	#qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentID#)
					<cfif VAL(qGetResults.active)>
                        <span class="note">(Active)</span>
                    <cfelseif isDate(qGetResults.cancelDate)>
                        <span class="noteAlert">(Cancelled)</span>
                    </cfif>
                </td>
                <td>
                	#qGetResults.supervisingFirstName# #qGetResults.supervisingLastName# (###qGetResults.userID#)
                	<span class="note">#qGetResults.supervisingAddress#</span>
                </td>     
                <td>
                	#qGetResults.hostlastname# (###qGetResults.hostid#)
                	<span class="note">#qGetResults.hostAddress#</span>
                </td>                           
                <td class="center #vSetColorCode#">#vGoogleDistance# mi</td>
            </tr>
            
            <cfscript>
				// Update Distance in the database
				if ( VAL(vUpdateTable) AND IsNumeric(vGoogleDistance) ) {
				
					APPLICATION.CFC.STUDENT.updateHostSupervisingDistance(
						historyID=qGetResults.historyID	,
						distanceInMiles=vGoogleDistance												  																	  
					);
					
				}
			</cfscript>
            
		</cfoutput>
			
		</table>		
	
	</cfoutput>

</cfif>

<!--- Page Footer --->
<gui:pageFooter />	