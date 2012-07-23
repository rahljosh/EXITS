<cfquery name="students" datasource="#application.dsn#">
select comp.companyshort,s.studentid, p.programname, s.programid, s.sevis_batchid,
s.familylastname, s.firstname, s.ds2019_no, h.hostid, c.countryname, h.isWelcomeFamily,
s.date_host_fam_approved,
 h.dateofchange, u.firstname as repfirst, u.lastname as replast, u.zip,
sch.schoolid, sch.schoolname, sch.address as schooladdress, sch.address2 as schooladdress2, sch.city as schoolcity,
sch.state  as schoolstate, sch.zip  as schoolzip,
h.reason
from smg_hosthistory h
left join smg_students s on s.studentid = h.studentid
left join smg_programs p on p.programid = s.programid
left join smg_users u on u.userid = s.placerepid
left join smg_countrylist c on c.countryid = s.countryresident
left join smg_schools sch on sch.schoolid = s.schoolid
left join smg_companies comp on comp.companyid = s.companyid
where isRelocation ='yes'
and (s.programid = 291  or s.programid = 311 or s.programid = 284)
and h.dateofchange >= '2010-09-01'
and (s.companyid < 5 or s.companyid = 12)
</cfquery>
<Cfoutput>
<Table>
<Cfloop query="students">
    <cfquery name="qSevisStatus" datasource="#application.dsn#">
        SELECT 
        	batchid, 
            received, 
            datecreated
        FROM 
        	smg_sevis
        INNER JOIN 
        	smg_students s ON s.sevis_activated = smg_sevis.batchid
        WHERE 
        	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(studentID)#">
        AND 
        	received = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
    </cfquery>
    <cfquery name="hostInfo" datasource="#application.dsn#">
    select fatherlastname, fatherfirstname, motherlastname, motherfirstname, address, address2, city, state, zip
    from smg_hosts
    where hostid = #hostid#
    </Cfquery>
	<Tr>
    	<Td></Td>
        <td>#programname#</td>
        <td>#familylastname#</td>
        <td>#firstname#</td>
        <td>#countryname#</td>
        <td>#ds2019_no#</td>
        <Td><cfif qSevisStatus.recordcount> Active<cfelseif sevis_batchid NEQ 0> Initial <cfelse> N/A </cfif></Td>
        <Td>#hostid#</Td>
        <Td>#DateFormat(dateofchange, 'mm/dd/yyyy')#</Td>
        <td>#hostInfo.fatherlastname#</td>
        <td>#hostinfo.fatherfirstname#</td>
        <td>#hostinfo.motherlastname#</td>
        <td>#hostinfo.motherfirstname#</td>
        <td><cfif isWelcomeFamily eq 1>Welcome Family<cfelse>Permanent</cfif></td>
        <td>#hostinfo.address# #hostinfo.address2#</td>
        <Td>#hostinfo.city#</Td>
        <td>#hostinfo.state#</td>
        <td>#hostinfo.zip#</td>
        <td>#schoolid#</td>
        <td>#schoolname#</td>
        <td>#schooladdress# #schooladdress2#</td>
        <td>#schoolcity#</td>
        <td>#schoolstate#</td>
        <td>#schoolzip#</td>
        <td>#replast#</td>
        <td>#repfirst#</td>
        <td>#zip#</td>
        <td></td>
        <Td>#reason#</Td>
     </Tr>
  </Cfloop>
 </Table>
</Cfoutput> 
        
     
        
        





