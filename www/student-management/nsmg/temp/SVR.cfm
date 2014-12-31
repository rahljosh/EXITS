<!----Get all available programs---->
<cfinclude template="../querys/get_programs.cfm">
<!----Get Available Facilitators---->
<cfinclude template="../querys/get_facilitators.cfm">
<!----Get Available Regions---->
<cfinclude template="../querys/get_user_regions.cfm">
<!----Get Available Seasons---->
<cfinclude template="../querys/get_seasons.cfm">
	

				<cfform action="svr.cfm" name="secondVisit" method="POST">
                <input type="hidden" name="process">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Student Arrival Date x CBC Date (No Relocations)</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<td><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" multiple="yes" size="5" required="yes" message="You must select a region" queryPosition="below">
								<option value=0>All Regions</option>
							</cfselect>						
						</td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
			</cfform>
            
<cfif isDefined('form.process')>
<cfquery name="getStudents" datasource="#application.dsn#">
select smg_students.studentid, smg_students.firstname, smg_students.familylastname, smg_students.hostid
from smg_students 

where companyid = #client.companyid#
AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
 <cfif form.regionid is not 0>
		AND (<cfloop list=#form.regionid# index='region'>
			regionassigned = #region# 
			<cfif region is #ListLast(form.regionid)#><Cfelse>or</cfif>
			</cfloop> )
  </cfif>
 
 
</cfquery>
<cfoutput>
<table cellpadding="4" cellspacing="0" border="0">
	<tr>
    	<Td>Student</Td><td>Host Family</td><Td>Date Placed</Td><td>Arrival Date</td><Td>Report Submitted</Td><td>Report Approved</td><Td>Days</Td><Td>Welcome<Td>Compliant</Td>
    </tr>
<Cfloop query="getStudents">
<!----Flight Info---->
	<cfquery name="arrivalInformation" datasource="#application.dsn#">
    select max(dep_date) as arrivalDate
    from smg_flight_info
    where studentid = #getStudents.studentid#
    </Cfquery>
	<Tr <cfif getStudents.currentrow mod 2>bgcolor=##ccc</cfif> >
    	<Td>#firstname# #familylastname# (#studentid#)</Td>
    
    
    <cfquery name="allHostFamilies" datasource="#application.dsn#" >
       SELECT
       distinct h.hostid,
        h.familylastname,        
        ht.dateplaced
    FROM
        smg_hosts h
    INNER JOIN
        smg_hosthistory ht ON h.hostid = ht.hostid
            AND
                ht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">       
            AND
                isActive = 0
    UNION       
     
    SELECT
        h.hostid,
        h.familylastname,       
        sht.dateCreated
    FROM
        smg_hosts h
    INNER JOIN
        smg_hosthistorytracking sht ON h.hostid = sht.fieldID
        AND
            sht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">                    
        AND
            sht.fieldName = 'hostID'           
    GROUP BY
            hostid
          
    </cfquery>
    <cfloop query="allHostFamilies">
     <Cfquery name="checkBlock" datasource="#application.dsn#">
            SELECT hr.id, hr.dateChanged, u.firstname, u.lastname
            FROM smg_hide_reports hr
            LEFT JOIN smg_users u on u.userid = hr.fk_userid
            WHERE hr.fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#getStudents.studentid#">
            AND hr.fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#allHostFamilies.hostid#">
            <!----
            AND hr.fk_secondVisitRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondVisitRepID#">
            ---->
            </cfquery>
            
    	<Cfquery name="reportInfo" datasource="#application.dsn#">
        select pr_ny_approved_date, pr_sr_approved_date, pr_id
        from progress_reports
        where fk_student = #getStudents.studentid# and fk_host = #hostid#
        <!---and  pr_sr_approved_date  <cfqueryparam cfsqltype="cf_sql_date" value="#allHostFamilies.datePlaced#">---->
        and fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="2">  
        order by pr_sr_approved_date 
        </cfquery>
        <Cfquery name="checkWelcome" datasource="#application.dsn#">
        select isWelcomeFamily as isWelcome
        from smg_hosthistory
        where hostid = #allHostFamilies.hostid#
        </cfquery>
        <Cfif #DateFormat(dateplaced, 'mm/dd/yyyy')# is '2011-11-21'>
        	<cfquery name="checkPlacedDate" datasource="#application.dsn#">
            select dateplaced
            from smg_hosthistory
            where studentid = #getStudents.studentid# and hostid = #hostid#
            </cfquery>
           
            <cfset allHostFamilies.datePlaced = #checkPlacedDate.dateplaced#>
        </Cfif>
        <Cfif allHostFamilies.recordcount gt 1 AND allHostFamilies.currentrow gt 1>
        	</tr>
            <tr <cfif getStudents.currentrow mod 2>bgcolor=##ccc</cfif>>
            <td></td>
        </Cfif>
           <Td>&nbsp;#allHostFamilies.familylastname# (#allHostFamilies.hostid#)&nbsp;</Td>
           <tr  ><td>&nbsp;#DateFormat(allHostFamilies.dateplaced, 'mm/dd/yyyy')#&nbsp;</td>
           <td>&nbsp;#DateFormat(arrivalInformation.arrivalDate, 'mm/dd/yyyy')#&nbsp;</td>
       
       
            
            
            <cfif checkBlock.recordcount gt 0>
                <td colspan=6>
                <em>#checkBlock.firstname# #checkBlock.lastname# determined that this report was not required
                                             on #dateFormat(checkBlock.dateChanged, 'mm/dd/yyyy')#</em> 
                </td>            
           <cfelse>  
           
           <cfif reportInfo.pr_sr_approved_date is ''>
                	<td colspan="6" bgcolor="##FFCCCC">This report appears to be missing</td>
                <cfelse> 
                
                   <cfloop query="reportInfo"> 
                                 
                            <Td>&nbsp;<a href="../index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#pr_id#" target="_blank">#DateFormat(reportInfo.pr_sr_approved_date, 'mm/dd/yyyy')#</a>&nbsp;</Td>
                           <Td>&nbsp;<a href="../index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#pr_id#" target="_blank">#DateFormat(reportInfo.pr_ny_approved_date, 'mm/dd/yyyy')#</a>&nbsp;</Td>
                            <Cfif #allHostFamilies.dateplaced# gt #arrivalInformation.arrivalDate#>
                                <cfset compCount = #dateDiff("d", "#allHostFamilies.dateplaced#", "#reportInfo.pr_sr_approved_date#")#>
                            <cfelse>
                                <cfset compCount = #dateDiff("d", "#arrivalInformation.arrivalDate#", "#reportInfo.pr_sr_approved_date#")#>
                            </Cfif>
                            <td>&nbsp;#compCount#&nbsp;</td>
                            <td>&nbsp;<cfif checkWelcome.isWelcome eq 1>Yes<cfelse>No</cfif>&nbsp;</td>
                            <td>&nbsp;<cfif checkWelcome.isWelcome eq 1>
                                    <cfif compCount gt 30><font color="##FF0000"><strong>No</strong></font><cfelse>Yes</cfif>
                                <Cfelse>
                                    <cfif compCount gt 60><font color="##FF0000"><strong>No</strong></font><cfelse>Yes</cfif>
                                </cfif>&nbsp;
                            </td>
                        
                        </cfloop>
                 </cfif>
            </cfif>
	</cfloop>
 </Cfloop>
 </cfoutput> 
 </table>  
</cfif>