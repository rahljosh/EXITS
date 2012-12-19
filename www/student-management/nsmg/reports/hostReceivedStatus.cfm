<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>
   <!----Get a list of users that report to the person logged in, for displaying hierachy in missing docs section.---->
    <cfset userUnderList ='#client.userid#'>
	<cfquery name="usersUnder" datasource="#application.dsn#">
    select userid
    from user_access_rights
    where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
    AND advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
    <cfloop query="usersUnder">
    <Cfset userUnderList = #ListAppend(userUnderList, userid)#> 
	</cfloop>
<cfquery name="qGetHostAppsReceived" datasource="#application.dsn#">
            select distinct s.hostID,  s.firstname as studentFirst, s.familylastname as studentLast, s.studentid, s.regionassigned, s.arearepid,
            u.firstname as repFirst, u.lastname as repLast,
            hh.dateReceived,
            h.familylastname as hostLast,
             u.firstname as repFirst, u.lastname as repLast,
            p.programname, r.regionname
            from smg_students s
            left outer join smg_hostHistory hh on hh.hostID = s.hostid
            left join smg_hosts h on h.hostid = s.hostid
            left join smg_programs p on p.programid = s.programid
            left join smg_regions r on r.regionid = s.regionassigned
            left join smg_users u  on u.userid = s.arearepid
        
            <Cfif client.usertype lte  4>
                 where s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            <Cfelseif client.usertype eq 5>
                    where s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            <cfelseif client.usertype eq 6>
                    where s.arearepid in (#userUnderList#)  
            <cfelseif client.usertype eq 7>
                  where s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            </Cfif>
               <Cfif isDefined('url.region')>
            and s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.region#">
            </Cfif>
             <Cfif isDefined('url.rep')>
            and s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.rep#">
            </Cfif>
            and s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            and s.hostid > 0 
            order by s.programid desc, studentLast, hostLast
         </cfquery>
         
        
<cfoutput>

<cfif qGetHostAppsReceived.recordcount eq 0>
	<em> There are no active students with host families that havn't had a application received.</em>
<cfelse>
     <br />
							<!----Get Regions---->
                            <cfquery name="regions" dbtype="query">
                            select distinct regionassigned, regionname
                            from qGetHostAppsReceived
                            </cfquery>
                        
    <table width=95% align="center" cellpadding=4 cellspacing=0>
        <Cfloop query="regions">
            <Cfquery name="RepsInRegion" dbtype="query">
            select distinct repFirst, repLast, arearepid
            from qGetHostAppsReceived
            where regionassigned = #regionassigned# 
           </Cfquery>
         <Cfquery name="appsInRegion" dbtype="query">
            select distinct hostid
            from qGetHostAppsReceived
            where regionassigned = #regionassigned# 
           </Cfquery>
     <tr bgcolor="##0b5886">
                              <td colspan=3><font color="white">#regionname#</td><td align="right"><font color="white">#appsInRegion.recordcount#</td>
                            </tr>
                 <cfloop query="RepsInRegion">
                                <cfquery name="studentList" dbtype="query">
                                select distinct repFirst, repLast, studentFirst, studentLast, studentid, hostlast, hostid, programname, dateReceived
                                from qGetHostAppsReceived
                                where arearepid = #arearepid#
                                </cfquery>
                                    
                                   
                                    
                          
                                <tr bgcolor="##7aaac7">
                                    <td colspan=3>Representative: #repFirst# #repLast# (#arearepid#)</td><td align="right">#studentList.recordcount#</td>
                                </tr>
                                  <tr>
                                    <th align="left">Student</th><th align="left">Host Family</th><Th align="left">Progam</Th><th>Date App Received</th>
                                </tr>
                          <cfloop query="studentList">
                               
                               
                               
                                        
                  
                    <tr <cfif currentrow mod 2>bgcolor="##ccc"</cfif>>
                        <td>#studentFirst# #studentLast# (#studentid#)</td>
                        <td>#hostLast#</td>
                        <td>#programname#</td>
                        <td align="Center"><Cfif dateReceived is ''>N/A<cfelse>#dateFormat(dateReceived, 'mm/dd/yyyy')#</Cfif></td>
                    </tr>
                   
<!---end of third loop---->
			</cfloop>
		  
			<!---end of second loop---->
			</cfloop>
	</cfloop>        	
                           
	</table>
    
</cfif>                    
</cfoutput>

</body>
</html>