<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="reports.css" type="text/css">
<title>Host Family - Supervising Rep - Distance</title>
</head>

<body>

<cfsetting requesttimeout="500">

<CFSCRIPT>
/**
 * Calculates the distance (in statute miles, nautical miles, kilometers or radians) between two latitude/longitude coordinates.
 * This function uses forumlae from Ed Williams Aviation Foundry website at http://williams.best.vwh.net/avform.htm.      
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
function LatLonDist(lat1,lon1,lat2,lon2,units)
{
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
</CFSCRIPT>

<cfif not IsDefined('form.programid')>
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

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid NEQ 0>
			AND regionid = '#form.regionid#'	
		</cfif>
	ORDER BY regionname
</cfquery>

<cfset countline = 0>

<cfoutput>
<table width="100%" cellpadding="4" cellspacing="0" align="center">
	<span class="application_section_header">#companyshort.companyshort# - Host Family x Supervising Representative Distance</span>
</table><br>

<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop> 
	</td></tr>
	<tr><td>* Calculates the distance (in statute miles) between two latitude/longitude coordinates (point to point distance).</td></tr>
	<tr><td>* Incorrect parameters mean either zip code is invalid or latitude/longitude coordinates are null or invalid.</td></tr>
	<tr><td>* Manual look up <a href="http://www.zip-codes.com/distance_calculator.asp" target="_blank">distance between zip codes</a></td></tr>
</table><br>

<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">	
	<tr><th width="100%">Region</th></tr>
</table><br>

<cfloop query="get_region">
	
	<cfset current_region = get_region.regionid>
	
	<Cfquery name="get_students" datasource="MySQL">
		SELECT s.studentid, s.firstname, s.familylastname,
			h.hostid, h.familylastname as hostlastname, h.zip as hostzip,
			u.userid, u.firstname as superfirst, u.lastname as superlast, u.zip as superzip
		FROM smg_students s
		INNER JOIN smg_hosts h ON s.hostid = h.hostid
		LEFT JOIN smg_users u ON s.arearepid = u.userid
		WHERE s.active = '1' 
			AND s.regionassigned = '#current_region#'  
			AND (<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	</cfquery> 

	<cfif get_students.recordcount>
		<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">	
			<tr><th colspan="4">#get_region.regionname#</th></tr>
			<tr>
				<td width="28%"><b>Host Family</b></td>
				<td width="28%"><b>Supervising Rep.</b></td>
				<td width="30%"><b>Student</b></td>
				<th width="14%">Distance in miles</th>
			</tr>
			<cfloop query="get_students">

				<cfquery name="zip1" datasource="MySql">
					SELECT zip, latitude, longitude
					FROM zip_codes
					WHERE zip = '#Left(hostzip, 5)#'
				</cfquery>
				<cfquery name="zip2" datasource="MySql">
					SELECT zip, latitude, longitude
					FROM zip_codes
					WHERE zip = '#Left(superzip, 5)#'
				</cfquery>
				
				<cfset distance = #LatLonDist(zip1.latitude,zip1.longitude,zip2.latitude,zip2.longitude,'sm')#>
							
				<cfif distance GTE 75 OR hostzip EQ '' OR superzip EQ '' OR distance EQ 'Incorrect parameters'>
				<cfset countline = countline + 1>
				<tr bgcolor="#iif(countline MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#hostlastname# (###hostid#) &nbsp; - &nbsp zip: #Left(hostzip, 5)#</td>
					<td>#superfirst# #superlast# (###userid#) &nbsp; - &nbsp zip: #Left(superzip, 5)#</td>
					<td>#firstname# #familylastname# (###studentid#)</td>
					<td align="center"><cfif distance NEQ 'Incorrect parameters'>#Left(distance, 6)#<cfelse>#distance#</cfif></td>
				</tr>
				</cfif>							
			</cfloop>	
		</table><br>				
		
	</cfif>
	
</cfloop>

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

</body>
</html>