<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Student Services</title>
</head>

<body>

 <script type="text/javascript">
  function DoNav(theUrl)
  {
  document.location.href = theUrl;
  }
 </script>
<cfoutput>
<!----Current Issues---->
<Cfquery name="qCheckCurrent" datasource="#application.dsn#">
SELECT sp.studentID, 
       sp.idproblem, 
       sp.userID,
       sp.summary,
       sp.date,
       u.firstname as userFirst,
       u.lastname as userLast
FROM services_project sp
LEFT JOIN smg_users u on u.userID = sp.userid
WHERE studentid = #url.studentid#

</Cfquery>



<!---Insert new issue---->
<cfif isDefined('form.insertNew')>
	<cfquery datasource="#application.dsn#">
    insert into services_project (studentid, userid, date, summary)
    			values(#url.studentid#, #client.userid#, #now()#, "#form.summary#")
    </cfquery>
    <cfquery name="get_ProblemID" datasource="#application.dsn#">
    select max(idProblem) currentProblem 
    from services_project
    </cfquery>
    <cfset client.studentProblem.idProblem = #get_ProblemID.currentProblem#>
    <cfset client.studentProblem.problemsummary = "#form.summary#">
</cfif>
<cfif isDefined('form.related')>
	<cfquery datasource="#application.dsn#">
    update services_project
    	set relatedto = #form.indicatedPreviousProblem#
     where idProblem = #client.studentProblem.idProblem#
    </cfquery>
</cfif>
<cfif isDefined('form.insertDetails')>
	<cfquery datasource="#application.dsn#">
    insert into  servicesproject_details (fk_idProblem, fk_servicesprojecttype, notes)
    				values  (#client.studentproblem.idProblem#, 1, '#form.notes#')

    </cfquery>
    <Cffile action="upload" destination="c:\uploadedfiles\student-services\" filefield="suportDoc" mode="777" nameconflict="makeunique" >
</cfif>
<h2 align="center">Student Services</h2>
<Br />
<div align="Center">
<cfif isDefined('form.newInitial')>
	<!----Initial Incident Entered---->
    <form method="post" action="ssp.cfm?studentid=#url.studentid#" >
    <input type="hidden" name="insertNew" />
        Please enter a brief  description of the issue.<Br /><em>(40 chareacters or less)</em><Br /><br />
        <input name="summary" type ="text" size="30" maxlength="40"/><br />
        <br />
        <br />
        <input type="image" src="../pics/next.gif" />
    </form>
<cfelseif isDefined('form.insertNew') AND qCheckCurrent.recordcount gt 0>
	<form method="post" action="ssp.cfm?studentid=#url.studentid#">
    <input type="hidden" name="related" />
   If you feel that this current issue:<br /> <strong>#client.studentProblem.problemsummary#</strong><br />is related to a previous problem please indicate which problem:
   <br /><br />
   <select name="indicatedPreviousProblem">
   <option value="0">N/A</option>
   <cfloop query="qCheckCurrent">
   <option value="#idProblem#">#dateFormat(date, 'm/d/yy')# - #summary#</option>
   </cfloop>
   </select>        
   		<br />
        <br />
        <input type="image" src="../pics/next.gif" />
	</form>
<cfelseif isDefined('related')>
	<form method="post" action="ssp.cfm?studentid=#studentid#" enctype="multipart/form-data">
    <input type="hidden" name="insertDetails" />
        Please enter as much  additional information as necessary.<Br /><br />
        <textarea cols=50 rows=10 name="notes"></textarea><br /><br />
        
        Attach any supporting documents:<br /> <input type="file" name="suportDoc" />
        <br />
        <br />
        <input type="image" src="../pics/next.gif" />
     </form>
<cfelseif qCheckCurrent.recordcount eq 0>
<!--- No incidnets, dispaly message --->
<div align="Center">Great! There are no issues on record.</div>
<cfform method="post" action="ssp.cfm?studentid=#url.studentid#">
<br /><br />
<input type="hidden" name="newInitial" /><br /><br />
<div align="Center"><input name="" type="image" src="../pics/newticket.gif" />
</cfform>
 
<cfelse>
<!--- Display List of incidents--->
<table width=95% align="center" cellpadding=4 cellspacing=0>

	<Tr>
    	<Th align="left">Probelm ID</Th><Th align="left">Date</Th><Th align="left">Summary</Th><th align="left">Submitted By</th>
    </Tr>
<cfloop query="qCheckCurrent">
  <tr bgcolor="<cfif qCheckCurrent.currentrow mod 2>##F7F7F7<cfelse>##ffe1ba</cfif>" onMouseOver="this.bgColor='##cccccc';" onMouseOut="this.bgColor='<cfif qCheckCurrent.currentrow mod 2>##F7F7F7<cfelse>##ffe1ba</cfif>';" onclick="DoNav('viewIssue.cfm?id=#idProblem#');">
    	<td>#idProblem#</td>
        <Td>#DateFormat(date, 'mmm d, yyyy')#</Td>
        <td>#summary#</td>
        <td>#userFirst# #userLast#</td>
</tr>
</cfloop>
</table>
<cfform method="post" action="ssp.cfm?studentid=#url.studentid#">
<input type="hidden" name="newInitial" /><br /><br />
<div align="Center"><input name="" type="image" src="../pics/newticket.gif" />
</cfform>
</cfif>
</div>
</cfoutput>
</body>
</html>