Listing 1: TextMethod.cfm
<!--- Querying and moving data from a database
to XML - the Text method --->
  
<cfquery name="students" datasource="MySQL">
	SELECT     	studentid,  dob, interests_other, firstname, uniqueid, host_fam_approved, smg_countrylist.countryname, smg_religions.religionname
	FROM       	smg_students
	INNER JOIN 	smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
	LEFT JOIN 	smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
	WHERE 	   	active = '1' 
			 	AND hostid = '0' 
				AND direct_placement = '0'
				AND companyid = '1'
	ORDER BY rand()
	LIMIT 50  
</cfquery>

<cfxml variable="xmlDoc">
<Students>
<cfoutput query="students">

<student><id>#students.uniqueid#"</id>
	<age>#DateDiff('yyyy', students.dob, now())#</age>
	<first>#students.firstname#</first>        
<interests>#students.interests_other#</interests>
<picture>http://www.student-management.com/nsmg/uploadedfiles/web-students/#studentid#.jpg</picture>
<status>#host_fam_approved#</status>
</student>
</cfoutput>
</Students>
</cfxml>

<cfdump var="#xmlDoc#">
<cffile action="WRITE"
file="/var/www/html/student-management/rss/student-feed.xml" 
output="#toString(xmlDoc)#">

<!--- Include the utilities file --->
<cfinclude template="xmlUtilities.cfm"> 
<!--- Output the resulting XML to the browser --->
<cfcontent type="text/xml">
<cfoutput>#XMLIndent(xmlDoc)#</cfoutput>


