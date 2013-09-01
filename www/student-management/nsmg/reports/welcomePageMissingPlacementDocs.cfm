<cfoutput>
<!----
<Cfif cgi.REMOTE_ADDR is '184.155.135.147'>
	<cfdump var="#qGetStudentWithMissingCompliance#">
</Cfif>
---->
<cfif qGetStudentWithMissingCompliance.recordcount eq 0>
	<em> There are no students with compliance issues.</em>
<cfelse>
   
    <table width=95% align="center">
        <Tr>
            <td width=75%>
    <h3>There are<strong> #numberHostProbs.recordcount#</strong> host families with issues on their applications.</h3>
            </td>
            <td align="center">
            <a href="reports/HostAppMissingDocuments.cfm" target="_new"><img src="pics/buttons/viewFullReport.png" height=30 border=0/></a>
            </td>
            <td align="right"><div style="cursor:pointer" onclick="hide('expand1')"></div></td>
        </Tr>
     </table>
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
        
        <cfif client.usertype lte 4>
        <tr <Cfif regions.currentrow mod 2>bgcolor="##90B2D5"<Cfelse>bgcolor="##efefef"</cfif>>
          <td><a href="reports/HostAppMissingDocuments.cfm?region=#regionassigned#" target="_new"><font color="black">#regionname#</font></a></td><td align="right"> #appsInRegion.recordcount#</td>
        </tr>
        </cfif>
        <cfif client.usertype gt 4>
            <cfloop query="RepsInRegion">
            <cfquery name="studentList" dbtype="query">
            select distinct repFirst, repLast, arearepid, firstname, familylastname, studentid, hostlast, hostid
            from qGetStudentWithMissingCompliance
            where arearepid = #arearepid#
            </cfquery>
                
               
                
            <cfif client.usertype neq 7>
            <tr bgcolor="##7aaac7">
                <td><a href="reports/HostAppMissingDocuments.cfm?rep=#arearepid#" target="_new"><font color="black">Representative: #repFirst# #repLast# (#arearepid#)</font></a></td><td align="right"> #studentList.recordcount#</td>
            </tr>
             </cfif>
             
            <cfloop query="studentList">
           
            <cfquery name="unresolvedIssues" dbtype="query">
           select actions
           from qGetStudentWithMissingCompliance
           where studentid =<Cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
           </cfquery>
            <tr bgcolor="##c4d9e6" >
        
                <td>Student: #firstname# #familylastname# (#studentid#) </td><td>Host: #hostLast# (#hostid#)</td>
            <tr>
                    <cfif client.usertype eq 7 or  #appsInRegion.recordcount# lte 5 >
                <cfloop query="unresolvedIssues">
                <Tr id="issue#unresolvedIssues.currentRow#"  bgcolor="##efefef">
                  <td colspan=2>
                  <Cfif unresolvedIssues.currentrow eq 1><em><font color="##006699">Issues</font></em><br /></Cfif>
                  #unresolvedIssues.currentrow#. #actions#</td>
                </Tr>
                <!----end of fourth loop---->
                </cfloop>
                </cfif>
            <!---end of third loop---->
            </cfloop>
          
            <!---end of second loop---->
            </cfloop>
            </cfif>	
        <!----end of first loop---->
        </Cfloop>
        <tr>
        	
        </tr>
        </table>
        
        </cfoutput>
</cfif>
</cfoutput>