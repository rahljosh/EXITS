<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>View Problem</title>
</head>

<body>
<cfoutput>
<!----Problem Summary---->
<Cfquery name="qGetProblem" datasource="#application.dsn#">
SELECT sp.studentID, 
       sp.idproblem, 
       sp.userID,
       sp.summary,
       sp.date,
       u.firstname as userFirst,
       u.lastname as userLast
FROM services_project sp
LEFT JOIN smg_users u on u.userID = sp.userid
WHERE idProblem = #url.id#

</Cfquery>
<!----Details and File of Problem---->
<Cfquery name="qProblemDetails" datasource="#application.dsn#">
SELECT spd.notes,
		spd.file,
        spd.date,
        spt.description
FROM servicesproject_details spd
LEFT JOIN servicesprojecttype spt on spt.idServicesProjectType = spd.fk_servicesprojecttype
WHERE spd.fk_idProblem = #url.id# 
</Cfquery>
<!----Type of info entering---->
<cfquery name="infoType" datasource="#application.dsn#">
select *
from servicesprojecttype
</cfquery>

Date: #DateFormat(qGetProblem.date, 'mmmm d, yyyy')#<br />
Submitted By: #qGetProblem.userFirst# #qGetProblem.userLast#<br /><br />
Summary: #qGetProblem.summary#<br />
File:
<hr width=75%/>
<br />
Current Info<Br />
<cfloop query="qProblemDetails">
#DateFormat(date, 'mmmm d, yyyy')#<br />
#description#<Br />
#notes#
<br /><br />
</cfloop>
<hr width=75%/>
<form method="post" action="viewIssue.cfm">
New information:<Br />
Type:
<select name="type">
<option value=0></option>
<cfloop query="infoType">
<option value="#idServicesProjectType#">#description#</option>
</cfloop>
More Info:<Br />
<textarea cols=50 rows=10 name="notes"></textarea><br /><br />
Attach any supporting documents:<br /> <input type="file" name="suportDoc" />
       <br />
        <input type="image" src="../pics/next.gif" />
     </form>
</cfoutput>
</body>
</html>