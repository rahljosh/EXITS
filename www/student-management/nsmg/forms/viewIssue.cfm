<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>View Problem</title>
</head>

<body>
<cfoutput>
<Cfparam name='form.supportDoc' default="">

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

<cfif isDefined('form.insertDetails')>
	
    		
            
    <cfquery datasource="#application.dsn#">
    insert into  servicesproject_details (fk_idProblem, fk_servicesprojecttype, notes, date)
    				values  (#url.id#, 1, '#form.notes#', #now()#)

    </cfquery>
</cfif>
<!----Details and File of Problem---->
<Cfquery name="qProblemDetails" datasource="#application.dsn#">
SELECT spd.notes,
		spd.file,
        spd.date,
        spd.fk_idproblem,
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
<!--- Display List of incidents--->
<table width=95% align="center" cellpadding=4 cellspacing=0 >

	<Tr>
    	<Th align="left">Probelm ID</Th><Th align="left">Date</Th><Th align="left">Notes</Th><th align="left">File</th>
    </Tr>
    <cfloop query="qProblemDetails">
    <tr>
    	<td>#fk_idproblem#</td>
        <Td>#DateFormat(date, 'mmmm d, yyyy')#</td>
        <td>#notes#</td>
        <td><a href="../uploadedfiles/student-services/#qGetProblem.studentid#/#file#">#file#</a></td>
    </tr>
	</cfloop>
</table>

<hr width=75%/>
<form method="post" action="viewIssue.cfm?id=#url.id#">
<input type="hidden" name="insertDetails" />

New information:<Br /><br />
<!---
Type:
<select name="type">
<option value=0></option>
<cfloop query="infoType">
<option value="#idServicesProjectType#">#description#</option>
</cfloop>
---->
More Info:<Br />
<textarea cols=50 rows=10 name="notes"></textarea><br /><br />

        <input type="image" src="../pics/next.gif" />
     </form>
	
</cfoutput>
</body>
</html>