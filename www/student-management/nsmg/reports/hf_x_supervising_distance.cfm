<!--- ------------------------------------------------------------------------- ----
	
	File:		_report.cfm
	Author:		Marcus Melo
	Date:		November 22, 2011
	Desc:		ISEUSA.com Host Family Leads Reports

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
	</cfscript>	

	<!--- Get Program --->
    <cfquery name="qGetProgram" datasource="#APPLICATION.DSN#">
        SELECT	
            *
        FROM 	
            smg_programs 
        LEFT JOIN 
            smg_program_type ON type = programtypeid
        WHERE 
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    </cfquery>
    
    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">

	<cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
		SELECT 
        	s.studentID, 
            s.firstname, 
            s.familylastname,
            sh.hfSupervisingDistance,
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
            u.zip AS supervisingZip
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		INNER JOIN
        	smg_regions r ON r.regionID = s.regionAssigned
          	<cfif VAL(FORM.regionID)>
            	AND
                	r.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">  
            </cfif>
        LEFT JOIN 
        	smg_users u ON s.arearepid = u.userid
		INNER JOIN
        	smg_hostHistory sh ON sh.studentID = s.studentID
                AND 
                	sh.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">            	
				AND
                	sh.hostID = h.hostID
                AND
                	sh.areaRepID = u.userID
		WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
        AND 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
        ORDER BY	
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

<cfif NOT VAL(FORM.programid)>
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
<table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
	<tr>
		<th>Host Family x Supervising Representative Distance</th>            
	</tr>
	<tr>
		<td class="center">
			Program(s) Included in this Report: <br />
			<cfoutput query="qGetProgram">#qGetProgram.programname# &nbsp; (###qGetProgram.programID#)<br /></cfoutput>             
		</td>
	</tr>  
	<tr>
		<td class="center">* Incorrect parameters mean either zip code is invalid or latitude/longitude coordinates are null or invalid.</td>
	</tr>
	<tr>
		<td class="center">* Manual look up <a href="http://www.zip-codes.com/distance_calculator.asp" target="_blank">distance between zip codes</a></td>
	</tr>
</table>

<cfoutput query="qGetResults" group="regionID">

	<cfscript>
		// Set Current Row used to display light blue color on the table
		vCurrentRow = 0;
	</cfscript>
	
	<table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
		<tr>
			<th class="left">- #qGetResults.regionName# Region</th>
		</tr>      
	</table>   

	<table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
		<tr>
			<th class="left" width="25%">Host Family</th>
			<th class="left" width="25%">Supervising Representative</th>
			<th class="left" width="25%">Student</th>
			<th width="10%">Point to Point Distance</th>
			<th width="15%">Google Driving Distance</th>
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
				
				// Check if we have recorded distance in the database from google driving directions
				if ( LEN(qGetResults.hfSupervisingDistance) ) {

					vGoogleDistance = qGetResults.hfSupervisingDistance;

				} else {
				
					// New Method
					vGoogleDistance = APPLICATION.CFC.UDF.calculateAddressDistance(origin=qGetResults.hostAddress,destination=qGetResults.supervisingAddress);
					vUpdateTable = 1;
					
				}
			</cfscript>
			                            
            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                <td>#qGetResults.hostlastname# (###qGetResults.hostid#) &nbsp; - &nbsp Zip Code: #Left(qGetResults.hostzip, 5)#</td>
                <td>#qGetResults.supervisingFirstName# #qGetResults.supervisingLastName# (###qGetResults.userID#) &nbsp; - &nbsp Zip Code: #Left(qGetResults.supervisingZip, 5)#</td>
                <td>#qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentID#)</td>
                <td class="center"><cfif vDistance NEQ 'Incorrect parameters'>#Left(vDistance, 6)#<cfelse>#vDistance#</cfif> mi</td>
                <td class="center <cfif VAL(vGoogleDistance) GT 75>alert</cfif>">#vGoogleDistance# mi</td>
            </tr>
            
            <cfif VAL(vUpdateTable) AND VAL(vGoogleDistance)>
            	
                <cfquery datasource="#APPLICATION.DSN#">
                	UPDATE
                    	smg_hostHistory
                    SET
                    	hfSupervisingDistance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vGoogleDistance#">
					WHERE
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.studentID#">				                
                    AND
                    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.hostID#">				                
                    AND
                    	areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.userID#">	
				</cfquery>
                                       			                
            </cfif>
            
		</cfoutput>
			
	</table>		
	
    <br />
</cfoutput>


<!--- UPDATE MISSING LATITUDE AND LONGITUDE --->

<!---
<cfif client.usertype EQ 1>

	<cfquery name="get_zips" datasource="MySql">
		SELECT zipcodeid, zip, latitude, longitude
		FROM zip_codes
		WHERE latitude = '' 
			OR longitude = ''
		LIMIT 100
	</cfquery>
	
	<cfoutput>
		
	UPDATE Longitude and Latitude<br /><br />
	
	<cfloop query="get_zips">
	
		<!--- <cfhttp url="http://maps.google.co.uk/maps?q=11702&output=kml" delimiter="," resolveurl="yes" /> --->
		<cfhttp url="http://maps.google.com/maps?q=#zip#&output=kml" delimiter="," resolveurl="yes" />
			<!--- #cfhttp.FileContent# --->
			<!--- <cfdump var="#xmlparse(cfhttp.FileContent)#"/><br /> --->
			<cfset request.GoogleXMLResult = ''>			
			<cfset request.GoogleXMLResult = xmlparse(cfhttp.FileContent) />
			
			<cfif IsDefined('request.GoogleXMLResult.kml.placemark.lookat.latitude.XMLText') AND IsDefined('request.GoogleXMLResult.kml.placemark.lookat.longitude.XMLText')>
				<cfset request.coords = request.GoogleXMLResult.kml.placemark.point.coordinates.XMLText />
				<cfset request.latitude = request.GoogleXMLResult.kml.placemark.lookat.latitude.XMLText />
				<cfset request.longitude = request.GoogleXMLResult.kml.placemark.lookat.longitude.XMLText />
				zip = #zip# &nbsp; &nbsp; - &nbsp; &nbsp;  latitude = #request.latitude# &nbsp; &nbsp; - &nbsp; &nbsp; longitude = #request.longitude#<br />		
			
			<cfelseif IsDefined('request.GoogleXMLResult.kml.folder.lookat.latitude.XMLText') AND IsDefined('request.GoogleXMLResult.kml.folder.lookat.longitude.XMLText')>
				<cfset request.latitude = request.GoogleXMLResult.kml.folder.lookat.latitude.XMLText />
				<cfset request.longitude = request.GoogleXMLResult.kml.folder.lookat.longitude.XMLText />
				zip = #zip# &nbsp; &nbsp; - &nbsp; &nbsp;  latitude = #request.latitude# &nbsp; &nbsp; - &nbsp; &nbsp; longitude = #request.longitude#<br />			
			</cfif>
			
			<cfif IsDefined('request.latitude') AND IsDefined('request.longitude')>
				<cfquery name="update" datasource="MySql">
					UPDATE zip_codes
					SET latitude = '#request.latitude#',
						longitude = '#request.longitude#'
					WHERE zipcodeid = '#zipcodeid#'
					LIMIT 1
				</cfquery>
			</cfif>	
	</cfloop>
	</cfoutput>	
</cfif>
--->