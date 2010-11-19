<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Active Email List</title>
</head>

<body>

<cfquery name="active_email_list" datasource="mysql">
    SELECT 
    	candidateid, 
        email, 
        lastname, 
        firstname, 
        startdate,
        enddate,
        dob
    FROM 
    	extra_candidates
    WHERE
    	companyid = 7 
    AND
    	active = 1
    AND     
    	enddate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', -28, now())#">
</cfquery>
<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=active_candidates.xls"> 


<table>
	<tr>
		<td>CandidateID</td><td>Last Name</td><td>First Name</td><td>DOB</td><td>Email</td><td>Program Start Date</td><td>Program End Date</td>
	</tr>
<cfoutput query="active_email_list">
<tr>	
	<td>#candidateid# </td><td>#lastname# </td><td>#firstname#</td><td>#DateFormat(dob, 'mm/dd/yyyy')#</td><td>#email#</td><td> #DateFormat(startdate,'mm/dd/yyyy')#</td><td>#DateFormat(enddate,'mm/dd/yyyy')#</td>
</tr>
</cfoutput>
</table>
</body>
</html>
