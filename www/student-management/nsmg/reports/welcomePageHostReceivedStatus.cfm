<cfoutput>
<cfif qGetStudentWithMissingCompliance.recordcount eq 0>
	<em> There are no active students with host families assigned.</em>
<cfelse>
   
    <table width=95% align="center">
        <Tr>
            <td width=75%>
    <h3>There are <strong>#qGetHostAppsReceived.recordcount#</strong> host families with applications.</h3>
            </td>
            <td align="center">
            <a href="reports/HostReceivedStatus.cfm" target="_new"><img src="pics/buttons/viewFullReport.png" height=30 border=0/></a>
            </td>
            <td align="right"><div style="cursor:pointer" onclick="hide('expand1')"></div></td>
        </Tr>
     </table>
     <br />
 
        <!----Get Regions---->
        <cfquery name="regions" dbtype="query">
        select distinct regionassigned, regionname
        from qGetHostAppsReceived
        
        </cfquery>
     
        <table cellpadding="4" cellspacing="0" width=95% align="center">
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
           
   <cfif client.usertype lte 4>
        <tr <Cfif regions.currentrow mod 2>bgcolor="##90B2D5"<Cfelse>bgcolor="##efefef"</cfif>>
          <td><a href="reports/hostReceivedStatus.cfm?region=#regionassigned#" target="_new"><font color="black">#regionname#</font></a></td><td align="right"> #appsInRegion.recordcount#</td>
        </tr>
        </cfif>
        <cfif client.usertype gt 4>
            <cfloop query="RepsInRegion">
            <cfquery name="studentList" dbtype="query">
            select distinct repFirst, repLast, arearepid, studentFirst, studentLast, studentid, hostlast, hostid, programname, dateReceived
            from qGetHostAppsReceived
            where arearepid = #arearepid#
            </cfquery>
                
               
                
            <cfif client.usertype neq 7>
            <tr bgcolor="##7aaac7">
                <td colspan=3><a href="reports/hostReceivedStatus.cfm?rep=#arearepid#" target="_new"><font color="black">Representative: #repFirst# #repLast# (#arearepid#)</font></a></td><td align="right">#studentList.recordcount#</td>
            </tr>
             </cfif>
             
          
        
        
        
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
            </cfif>	
        <!----end of first loop---->
        </Cfloop>
	   
        </table>
</cfif>                    
</cfoutput>
