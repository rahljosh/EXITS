<cfif isDefined('form.addReport')>
	<Cfquery name="insertReport"  datasource="#application.dsn#">
    insert into smg_submitted_reports (approvalLevel, name, frequency)
    						values(#form.approval#,'#form.report#', '#form.frequency#')
                            
    </Cfquery>
    
</cfif>
<Cfquery name="availableReports" datasource="#application.dsn#">
select *, smg_usertype.usertype
from smg_submitted_reports
left join smg_usertype on smg_usertype.usertypeid = smg_submitted_reports.approvallevel
</Cfquery>

<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Reports</span> 
        <div style="float:right;"><img src="pics/betaTesting.png"></div> 
    </div>
    
    <div class="rdbox">
    <h1>Add Report</h1>
   <Cfoutput> 
    <form method="post" action="#CGI.PATH_INFO#?#CGI.QUERY_STRING#">
    <Table width="80%">
    	<tr>
        	<td>Name: <input type="text" size=30 name="report"/> </td>
            <td>Approval: <select name="approval" >
            <option value="4">Program Manager</option>
            <option value="5">Regional Manager</option>
            <option value="6">Regional Director</option>
            <option value="7">Area Rep</option>
            </select>
            </td>
          	<Td>Frequency <select name="frequency" >
            <option value="once">Once</option></select>
            </Td>
           
      		<td><input name="addReport" id="addReport" type="submit" value="Add Report"  alt="Add Report" border="0" class="basicOrangeButton" /></td>
          </tr>
      </table>
    
    <h1>Current Reports</h1>
    
    <Table width="80%">
   		<tr>
        	<td>Report</td>
            <Td>Who Approves</Td>
            <td>How often Submitted</td>
           
    <cfif availableReports.recordcount eq 0>
    	<Tr>
        	<td colspan = 4 align="center">No reports have been created. </td>
        </Tr>
    <cfelse>
    <Cfloop query="availableReports">
    	<tr>
        	<td><A href="?curdoc=submittedReports/editQuestions&qid=#id#">#name#</A> </td>
            <td>#usertype#</td>
          	<Td>#frequency#</Td>
            
      		
          </tr>
     </Cfloop>
     </cfif>
     </table>
      </cfoutput>
    </div>
  <div class="rdbottom"></div> <!-- end bottom --> 
</div>