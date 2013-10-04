<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SEVIS Batch Report</title>
</head>

<body>
<cfquery name="sevisReport" datasource="mysl">
select s.batchid, s.datecreated, s.totalstudents, s.totalprint, s.received, s.type,
u.firstname, u.lastname, c.companyshort, (s.totalstudents - s.totalprint) as issues
from smg_sevis s
left join smg_users u on u.userid = s.createdby
left join smg_companies c on c.companyid = s.companyid
where s.datecreated > '2013-06-01'
and (s.received = 'no' or s.totalstudents != s.totalprint)

</cfquery>
<Table>
	<Tr>
    	<td colspan=10>As of #dateformat(now(), mmm. d, 'yyyy')#</td>
    </Tr>
    <tr bgcolor="#90b2d5">
    	<th align="left"><font color="#CCCCCC">Company</font></th>
        <th align="left"><font color="#CCCCCC">BatchID</font></th>
        <th align="left"><font color="#CCCCCC">Date Created</font></th>
        <th align="left"><font color="#CCCCCC">## in Batch</font></th>
        <th align="left"><font color="#CCCCCC">## OK</font></th>
        <th align="left"><font color="#CCCCCC">## Probs</font></th>
        <th align="left"><font color="#CCCCCC">Batch Type</font></th>
        <th align="left"><font color="#CCCCCC">Received in EXITS</font></th>
    </tr>
    <cfoutput>
    <cfloop query="sevisReport">
    
    <tr <cfif currentrow mod 2>bgcolor="##cccccc"</cfif>>
    	<td>#companyshort#</td>
        <td>#batchid#</td>
        <td>#datecreated#</td>
        <td>#totalstudents#</td>
        <td>#totalprinted#</td>
        <td>#issues#</td>
        <td>#type#</td>
        <td>#received#</td>
    </tr>
    </cfloop>
 </Table>
</body>
</html>