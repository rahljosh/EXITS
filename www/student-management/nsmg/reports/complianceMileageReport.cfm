<!--- ------------------------------------------------------------------------- ----
	
	File:		complianceMileageReport.cfm
	Author:		Marcus Melo
	Date:		February 01, 2012
	Desc:		Host Family - Supervising Representative Distance

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<cfsetting requesttimeout="9999">

    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.displayOutOfCompliance" default=0;
		
		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
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
        	smg_hosthistory ht ON ht.studentID = s.studentID
                AND 
                	ht.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">            	
				AND
                	ht.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">    
                AND
                	ht.hostID = h.hostID
                AND
                	ht.areaRepID = u.userID
				<!---
                AND
                	ht.schoolID = s.schoolID
                AND
                	ht.placeRepID = s.placeRepID
				--->
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
        ORDER BY	
        	c.companyShort,
            r.regionName,
            supervisingLastName,
            s.familyLastName
	</cfquery> 

	<cfscript>
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
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<cfif NOT VAL(FORM.programid) OR NOT VAL(FORM.regionID)>
	<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">
		<tr><td align="center">
				<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
				Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
				<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
			</td>
		</tr>
	</table>
	<cfabort>
</cfif>

<!--- Run Report --->
<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
	<tr>
		<th>Compliance Mileage Report</th>            
	</tr>
    <tr>
        <td class="center">
            Program(s) included in this report: <br />
            <cfoutput query="qGetPrograms">
                #qGetPrograms.programName# <br />
            </cfoutput>
        </td>
    </tr>
</table>

<cfoutput query="qGetResults" group="regionID">

	<cfscript>
		// Set Current Row used to display light blue color on the table
		vCurrentRow = 0;
	</cfscript>

	<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
		<tr>
			<th class="left" colspan="5">
				<cfif CLIENT.companyID EQ 5>
                	- #qGetResults.companyShort# 
                </cfif>
            	- #qGetResults.regionName# Region
            </th>
		</tr>      
		<tr>
			<td class="subTitleLeft" width="26%">Student</td>
            <td class="subTitleLeft" width="22%">Supervising Representative</td>		            
            <td class="subTitleLeft" width="22%">Host Family</td>				
			<td class="subTitleCenter" width="15%">Google Shortest Driving Distance</td>
		</tr>      

		<cfoutput>
			            
			<cfscript>
				vCurrentRow++;
							
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

<!--- Page Header --->
<gui:pageFooter />