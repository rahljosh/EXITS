<cfset client.hostid = 80006>
<!----Check School Placement Acceptance---->
<cfquery name="schoolAcceptanceLetter" datasource="#application.dsn#">
select hh.doc_school_accept_date, hh.studentID, hh.schoolID, s.schoolname, h.hostid
from smg_hosts h
left join smg_schools s on s.schoolid = h.schoolid
left outer join smg_hosthistory hh on hh.hostid = h.hostid
where h.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostID#">
</cfquery>



    <!----Get the references ---->
    <cfquery name="references" datasource="#application.dsn#">
    select fr.firstname, fr.lastname, fr.phone, fr.refid, fr.approved, RQT.id
    from smg_family_references fr
    LEFT JOIN hostRefQuestionaireTracking RQT on RQT.hostID = fr.referencefor
    where referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostID#">
    </cfquery>

<h2>There are 4 items that need to be checked / completed before you can approve this application.</h2><br /><br />



    <!----Personal Information---->
		   <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">To Do List for Approval</span> 
                <!--- DOS Usertype does not have access to edit information --->
				
            	</div> <!-- end top --> 
             <div class="rdbox">
 <cfform action="hostApplication/toDoList.cfm" method="post" preloader="no">        
 <cfoutput>  
		<table width=100% cellpadding=8 cellspacing="0">
        	<tr bgcolor="##1b99da">
            	<td><h2><font color="##FFFFFF">Status</h2></font></td>
                <td><h2><font color="##FFFFFF">Item</h2></font></td>
                <td><h2><font color="##FFFFFF">Action</h2></font></td>
                <td><h2><font color="##FFFFFF">Area Rep</h2></font></td>
                <td><h2><font color="##FFFFFF">Manager</h2></font></td>
                <td><h2><font color="##FFFFFF">Facilitator</h2></font></td>
            </tr>
            <tr bgcolor="##F7F7F7">
            	<Td><img src="pics/warning.png" width=16 heigh=16></Td>
                <td>Complete Confidential Host Visit</td>
                <td><a href="forms/pr_add.cfm?studentid=" class='iframe'>Submit Report</a></td>
                <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                
       
         	</tr>
            <tr>
                	<td><img src="pics/warning.png" width=16 heigh=16></td>
                    <td>School Acceptance Letter <cfif schoolAcceptanceLetter.schoolname is ''>- <em>No School Assigned</em><cfelse>-<em>#schoolAcceptanceLetter.schoolname#</em></cfif> </td>
                    <td>
					<cfif schoolAcceptanceLetter.schoolname is ''>
                    	Assign School to Host
                    <Cfelseif schoolAcceptanceLetter.doc_school_accept_date is ''>
                    	<cfinput type="datefield" name="doc_school_accept_date" validate="date" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')"  placeholder="MM/DD/YYYY">
                     
                    <cfelse>
                    #DateFormat(doc_school_accept_date, 'mm/dd/yyyy')#
                    </Cfif>
					</td>
                   <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                </tr>
                <tr>
                	<td>&nbsp;</td>
                </tr>
            <tr bgcolor="##ccc">
            	
                <td colspan="6" align="center" ><h2>&lt;&lt; References &gt;&gt;</h2></td>
            
                
                
                <cfloop query="references">
                <tr <cfif references.currentrow mod 2> bgcolor="##F7F7F7"</cfif>>
                    <td><Cfif approved eq 2><img src="pics/valid.png" width=16 heigh=16>
                    	<cfelse><img src="pics/warning.png" width=16 heigh=16></Cfif></td><td>#firstname# #lastname# - #phone#</td>
                    <td>
						<Cfif approved eq 2>
                            <a class='iframe' href="forms/viewHostRefrencesQuestionaire.cfm?reportid=#id#" >View Report</a>
                        <cfelse>
                            <a class='iframe' href="forms/hostRefrencesQuestionaire.cfm?ref=#refid#&rep=#client.userid#&hostid=#client.hostid#" >Submit Report</a>
                        </Cfif>
                    </td>
                   <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                <td><font color="##CCCCCC">MM/DD/YYYY</font></td>
                </tr>
                </cfloop>
           
            </table>

     </cfoutput> 
</cfform>           
<br /><br />
<table cellpadding=10 align="center">
	<tr>
    	<td><img src="pics/buttons/deny.png" width="90%"/></td><td>&nbsp;</td><Td><img src="pics/buttons/approveBut.png"width="90%" /></Td>
    </tr>
</table> 
			</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
