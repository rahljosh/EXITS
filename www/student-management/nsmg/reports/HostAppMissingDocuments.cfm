<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>

<!----Get students with issues that are not resolved in paperwork---->
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


        <cfquery name="qGetStudentWithMissingCompliance" datasource="#application.dsn#">
            select hh.studentid, hh.hostid, hh.historyid, ah.actions, s.firstname, s.familylastname, s.studentid, h.familylastname as hostLast, s.regionassigned, s.arearepid, u.firstname as repFirst, u.lastname as repLast, r.regionname
            from smg_hosthistory hh
            left join smg_students s on s.studentid = hh.studentid 
            left join applicationhistory ah on ah.foreignid = hh.historyid
            left join smg_hosts h on h.hostid = hh.hostid
            left join smg_regions r on r.regionid = s.regionassigned
            left join smg_users u on u.userid = s.arearepid
            <Cfif client.usertype lte  4>
                 where s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            <Cfelseif client.usertype eq 5>
                    where s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            <cfelseif client.usertype eq 6>
                    where s.arearepid in (#userUnderList#) 
            <cfelseif client.usertype eq 7>
                  where s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            </Cfif>
           
            and s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> and ah.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosthistorycompliance">
            and ah.isResolved = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            <Cfif isDefined('url.region')>
            and s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.region#">
            </Cfif>
             <Cfif isDefined('url.rep')>
            and s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.rep#">
            </Cfif>
            order by regionname
        </cfquery>
        
        
        
        <cfif qGetStudentWithMissingCompliance.recordcount eq 0>
                            <em> There are student with compliance issues.</em>
                        <cfelse>
                        <cfquery name="numberHostProbs" dbtype="query">
                        select distinct hostid
                        from qGetStudentWithMissingCompliance
                        </cfquery>
                        
                      <br />
							<!----Get Regions---->
                            <cfquery name="regions" dbtype="query">
                            select distinct regionassigned, regionname
                            from qGetStudentWithMissingCompliance
                            
                            </cfquery>
                            <cfoutput>
                            <table cellpadding="4" cellspacing="0" width=95% align="center">
                                
                            
                            <Cfloop query="regions">
                                <Cfquery name="RepsInRegion" dbtype="query">
                                select distinct repFirst, repLast, arearepid
                                from qGetStudentWithMissingCompliance
                                where regionassigned = #regionassigned# 
                               </Cfquery>
                             <Cfquery name="appsInRegion" dbtype="query">
                                select distinct hostid
                                from qGetStudentWithMissingCompliance
                                where regionassigned = #regionassigned# 
                               </Cfquery>
                            
                            
                            <tr bgcolor="##0b5886">
                              <td><font color="white">#regionname#</td><td align="right"><font color="white">Apps with issues: #appsInRegion.recordcount#</td>
                            </tr>
                           
                           
                                <cfloop query="RepsInRegion">
                                <cfquery name="studentList" dbtype="query">
                                select distinct repFirst, repLast, arearepid, firstname, familylastname, studentid, hostlast, hostid
                                from qGetStudentWithMissingCompliance
                                where arearepid = #arearepid#
                                </cfquery>
                                    
                                   
                                    
                          
                                <tr bgcolor="##7aaac7">
                                    <td>Representative: #repFirst# #repLast# (#arearepid#)</td><td align="right"> Apps with Issues: #studentList.recordcount#</td>
                                </tr>
                             
                                 
                                <cfloop query="studentList">
                               
                                <cfquery name="unresolvedIssues" dbtype="query">
                               select actions
                               from qGetStudentWithMissingCompliance
                               where studentid =<Cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#"> and hostid = <Cfqueryparam cfsqltype="cf_sql_integer" value="#hostid#">
                               </cfquery>
                                <tr bgcolor="##c4d9e6" >
                            
                                    <td>Student: #firstname# #familylastname# (#studentid#) </td><td>Host: #hostLast# (#hostid#)</td>
                                <tr>
                                		
                                    <cfloop query="unresolvedIssues">
                                    <Tr id="issue#unresolvedIssues.currentRow#"  bgcolor="##efefef">
                                      <td colspan=2>
                                      <Cfif unresolvedIssues.currentrow eq 1><em><font color="##006699">Issues</font></em><br /></Cfif>
                                      #unresolvedIssues.currentrow#. #actions#</td>
                                    </Tr>
                                    <!----end of fourth loop---->
                                    </cfloop>
                                   
                                <!---end of third loop---->
                                </cfloop>
                              
                                <!---end of second loop---->
                                </cfloop>
                                	
                            <!----end of first loop---->
                            </Cfloop>
                            
                            </table>
                            
                            </cfoutput>
                            </cfif>
                          
</body>
</html>