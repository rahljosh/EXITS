
<Cfparam name="url.sendEmail" default="0">
<body>
<cfquery name="sevisReport" datasource="mysql">
select s.batchid, s.datecreated, s.totalstudents, s.totalprint, s.received, s.type,
u.firstname, u.lastname, c.companyshort, (s.totalstudents - s.totalprint) as issues
from smg_sevis s
left join smg_users u on u.userid = s.createdby
left join smg_companies c on c.companyid = s.companyid
where s.datecreated > '2013-06-01'
and (s.received = 'no' or s.totalstudents != s.totalprint)
order by companyshort, datecreated, type 

</cfquery>
 <cfsavecontent variable="emailContent">	
<Table cellspacing="0" cellpadding="4" width=800 >
	<Tr>
    	<td colspan=10><Cfoutput>As of #dateformat(now(), 'mmm. d, yyyy')#</Cfoutput></td>
    </Tr>
    <tr bgcolor="#90b2d5">
    	<th align="left">Company</font></th>
        <th align="left">BatchID</font></th>
        <th align="left">Date Created</font></th>
        <th align="left">Batch Type</font></th>
        <th align="left">## in Batch</font></th>
        <th align="left">## OK</font></th>
        <th align="left">## Probs</font></th>
        
        <th align="left">Received in EXITS</font></th>
    </tr>
    <cfoutput>
    <cfloop query="sevisReport">
    
    <Cfif sevisReport.type is 'host_update'>
    	<cfset linkType = 'host_results'>
    <cfelseif sevisReport.type is 'school_update'>
    	<cfset linkType = 'site_activity_results'>
    <cfelseif sevisReport.type is 'activate'>
    	<cfset linkType = 'activate_results'>
    <cfelseif sevisReport.type is 'new'>
    	<cfset linkType = 'new_forms_results'>
    <cfelse>
    	<cfset linkType = ''>
    </cfif>
    
    	
    <tr <cfif currentrow mod 2>bgcolor="##cccccc"</cfif>>
    	<td>#companyshort#</td>
        <td><cfif len(linkType)><a href="?curdoc=sevis/#linkType#&batch=#batchid#.xml"></cfif>#batchid#</a></td>
        <td><cfif DateDiff('d','#now()#', '#dateCreated#') eq 1>Yesterday<cfelse>#DateFormat(datecreated, 'mmm d, yyyy')#</cfif></td>
        <td>#type#</td>
        <td align="center">#totalstudents#</td>
        <td align="center">#totalprint#</td>
        <td align="center">#issues#</td>
        
        <td align="center">#received#</td>
    </tr>
    </cfloop>
    <tr>
    	<td colspan=10>Report Completed Succesfully</td>
    </tr>
    </cfoutput>
 </Table>
 </cfsavecontent>
 <cfoutput>
 <cfif val(url.sendEmail)>
  	<cfmail to="josh@iseusa.org" subject="SEVIS Batches with Issues" from="sevisBatch@iseusa.org" type="html">
Some cases are resolved in other batches.  If problem is resolved in diff batch, DB need to be updatd to reflect this to remove from list.  ***This is not in place yet****<br /><br />
#emailContent#
    
    </cfmail>
 </cfif>
#emailContent#
 </cfoutput>
