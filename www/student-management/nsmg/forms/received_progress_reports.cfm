<link rel="stylesheet" href="../smg.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #2E5872; }
</style>

<title>Progress Reports</title>

<cfif isDefined('form.addReportNow')>
	<cfset form.studentid = #url.stuid#>

    <cfquery name="get_student" datasource="#application.dsn#">
        SELECT
            secondVisitRepID,
            arearepid,
            placerepid,
            intrep,
            regionassigned,
            hostid,
            programid,
            companyid
        FROM
            smg_students
        WHERE
            studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentid)#">
    </cfquery>
    
	<cfset form.companyid = get_student.companyid>
    <cfset form.fk_sr_user = get_student.arearepid>
    <cfset form.fk_pr_user = get_student.placerepid>
    <cfset form.fk_secondVisitRep = form.secondVisitRepID>
    <cfset form.programid = get_student.programid>
    <cfset form.fk_host = form.hostid>
    <cfset form.fk_intrep_user = get_student.intrep>
    
    <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
        SELECT advisorid
        FROM user_access_rights
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(get_student.arearepid)#">
        AND regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student.regionassigned)#">
    </cfquery>
        
    <cfset form.fk_ra_user = get_advisor_for_rep.advisorid>
	
	<!--- advisorid can be 0 and we want null, and the 0 might be phased out later. --->
    <cfif form.fk_ra_user EQ 0>
        <cfset form.fk_ra_user = ''>
    </cfif>
	
    <cfquery name="get_regional_director" datasource="#application.dsn#">
        SELECT smg_users.userid
        FROM smg_users
        INNER JOIN user_access_rights on smg_users.userid = user_access_rights.userid
        WHERE user_access_rights.usertype = 5
        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student.regionassigned)#">
        AND smg_users.active = 1
    </cfquery>
    
	<cfset form.fk_rd_user = get_regional_director.userid>

	<cfif form.fk_rd_user EQ ''>
        Regional Director is missing.  Report may not be added.
        <cfabort>
    </cfif>

    <cfquery name="get_facilitator" datasource="#application.dsn#">
        SELECT regionfacilitator
        FROM smg_regions
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student.regionassigned)#">
    </cfquery>

	<cfset form.fk_ny_user = get_facilitator.regionfacilitator>
    
	<cfif form.fk_ny_user EQ 0 or form.fk_ny_user EQ ''>
        Facilitator is missing.  Report may not be added.
        <cfabort>
    </cfif>
    
    <cfquery datasource="#application.dsn#">
        INSERT INTO progress_reports 
            (
                fk_reportType,
                fk_student,
                pr_uniqueid,
                pr_month_of_report,
                fk_program,
                fk_secondVisitRep,
                fk_sr_user,
                fk_pr_user,
                fk_ra_user,
                fk_rd_user,
                fk_ny_user,
                fk_host,
                fk_intrep_user
            )
        VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="2">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.studentid)#">,
                <cfqueryparam cfsqltype="cf_sql_idstamp" value="#createuuid()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(DatePart('m','#now()#'))#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.programid)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.fk_secondVisitRep)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.fk_sr_user)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.fk_pr_user)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ra_user#" null="#yesNoFormat(trim(form.fk_ra_user) EQ '')#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.fk_rd_user)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.fk_ny_user)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.fk_host)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.fk_intrep_user)#">
            )  
    </cfquery>

    <cfquery name="get_id" datasource="#application.dsn#">
        SELECT MAX(pr_id) AS pr_id
        FROM progress_reports
    </cfquery>

    <cfquery  datasource="#application.dsn#">
        INSERT INTO secondVisitAnswers
            (
                fk_reportID,
                fk_studentID
            )
        VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_id.pr_id)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentid)#">
            )
    </cfquery>

</cfif>
    
<table width="100%" cellspacing="5">
  <tr>
    <td>
    
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>Progress Reports</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfquery name="get_progress_reports" datasource="#application.dsn#">
    SELECT progress_reports.*, reportTrackingType.description
    FROM progress_reports
    LEFT JOIN reportTrackingType on reportTrackingType.reportTypeID = progress_reports.fk_reportType
    WHERE fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(url.stuid)#">
    ORDER BY fk_reportType, pr_id DESC
</cfquery>

<cfquery name="otherHosts" datasource="#application.dsn#">
select distinct smg_hosthistory.hostid, smg_hosts.familylastname, smg_hosts.hostid
from smg_hosthistory
left join smg_hosts on smg_hosts.hostid = smg_hosthistory.hostid
where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(url.stuid)#">

</cfquery>
<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
    	<td colspan=6><span class="get_attention"><b>></b></span> <u>Reports Received</u></td>
    </tr>
    <cfif get_progress_reports.recordCount EQ 0>
        <tr>
            <td colspan=6>There are no reports.</td>
        </tr>
    <cfelse>
        <tr align="left">
            <th>Action</th>
            <th>Type</th>
            <!--- DOS User do not have access to details --->
            <cfif CLIENT.userType NEQ 27>
                <th>SR Approved</th>
                <th>RA Approved</th>
                <th>RD Approved</th>
                <th>Facilitator Approved</th>
                <th>Rejected</th>
            </cfif>
        </tr>
        
        <cfoutput query="get_progress_reports">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td>
                    <form action="../index.cfm?curdoc=progress_report_info" method="post" name="theForm_#pr_id#" id="theForm_#pr_id#" target="_blank">
                        <input type="hidden" name="pr_id" value="#pr_id#">
                        <input type="hidden" name="pr_rmonth" value="#get_progress_reports.pr_month_of_report#" />
                    </form>
                
					<!--- restrict view of report until the supervising rep approves it.
					(we're intentionally not including the other checks to only allow SR, RA, etc. to view like on the progress report list) --->
                    <cfif ( NOT LEN(pr_sr_approved_date) AND fk_sr_user NEQ CLIENT.userid ) OR ( CLIENT.usertype eq 8 AND NOT LEN(pr_ny_approved_date) )>
                        
                        <cfif listFind("1,2,3,4", CLIENT.userType)>
                        
							<!--- Progress Reports --->
                            <cfif fk_reportType eq 1>
                                <a href="javascript:document.theForm_#pr_id#.submit();">View</a>
                            <!--- Second Visit --->
                            <cfelse>
                                <a href="../index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#get_progress_reports.pr_id#" target="_blank">View</a>
                            </cfif>
                            
                        <cfelse>
                         	Pending  
                        </cfif>
                        
                    <cfelse>
                    
                    	<!--- Progress Reports --->
                       	<cfif fk_reportType eq 1>
                       		<a href="javascript:document.theForm_#pr_id#.submit();">View</a>
                       	<!--- Second Visit --->
						<cfelse>
                       		<a href="../index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#get_progress_reports.pr_id#" target="_blank">View</a>
                       	</cfif>
                        
                    </cfif>
                </td>
                <td>
                	<!--- Display the month of the report --->
                    
                	<!--- Display the month of the report --->
                	<cfif get_progress_reports.description EQ 'Progress Reports'>
                     <Cfif (get_progress_reports.pr_month_of_report) eq 1>
                                <cfset thisMonth = 12>
                            <Cfelse>
                                <Cfset thisMonth = get_progress_reports.pr_month_of_report -1>
                            </Cfif>
                     	#MonthAsString(thisMonth)# - Progress Report
                    <cfelse>
                   		#get_progress_reports.description#
                    </cfif>
                                  
                </td>
                <!--- DOS User do not have access to details --->
                <cfif CLIENT.userType NEQ 27>
                    <td>#dateFormat(pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                    <td>
                        <cfif fk_ra_user EQ ''>
                            N/A
                        <cfelse>
                            #DateFormat(get_progress_reports.pr_ra_approved_date, 'mm/dd/yyyy')#
                        </cfif>
                    </td>
                    <td>#DateFormat(pr_rd_approved_date, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(pr_rejected_date, 'mm/dd/yyyy')#</td>
				</cfif>                    
            </tr>	
        </cfoutput>
    </cfif>
</table>

<cfquery name="get_old_progress_reports" datasource="#application.dsn#">
    SELECT distinct smg_prquestion_details.report_number, smg_prquestion_details.submit_type,
        smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved, smg_document_tracking.ny_accepted
    FROM smg_prquestion_details
    INNER JOIN smg_document_tracking ON smg_prquestion_details.report_number = smg_document_tracking.report_number
    WHERE smg_prquestion_details.stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(url.stuid)#">
    ORDER BY smg_prquestion_details.report_number DESC
</cfquery>

<cfif get_old_progress_reports.recordCount>

    <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
        <tr>
            <td colspan=6><span class="get_attention"><b>></b></span> <u>Reports Received prior to 09/16/2009</u></td>
        </tr>
        <tr align="left">
            <th>&nbsp;</th>
            <th>Submitted</th>
            <th>RA</th>
            <th>RD</th>
            <th>NY</th>
            <th>Type</th>
        </tr>
        <cfoutput query="get_old_progress_reports">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td><a href="../index.cfm?curdoc=forms/view_progress_report&number=#report_number#" target="_blank">View</a></td>
                <td>#DateFormat(date_submitted, 'mm/dd/yyyy')#</td>
                <td><cfif date_ra_approved is ''>N/A<cfelse>#DateFormat(date_ra_approved, 'mm/dd/yyyy')#</cfif></td>
                <td>#DateFormat(date_rd_approved, 'mm/dd/yyyy')#</td>
                <td>#DateFormat(ny_accepted, 'mm/dd/yyyy')#</td>
                <td>#submit_type#</td>
            </tr>	
        </cfoutput>
    </table>
    
</cfif>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="center">
        <table>
        	<Tr>
            	<Td>
       				<input type="image" value="close window" src="../pics/close.png"  onClick="javascript:window.close()">
        		</Td>
                <Td>
					<cfif CLIENT.usertype lte 4>
                    <cfoutput>
                    <Form method="post" action="received_progress_reports.cfm?stuid=#url.stuid#"><input type="image" src="../pics/2visit.png" />
                    <input type="hidden" name="addReport" />
                    </Form>
                    </cfoutput>
                    </Cfif>
        		</Td>
            </Tr>
         </table>
        </td>
    	
    </tr>
</table>
<cfif isDefined('form.addReport')>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<Tr>
    	<td>
        	Enter the ID number of the rep for this particular report.  Once you hit submit, the rep will be able to access the report from their online reports matrix.
        </td>
    </Tr>
    <tr>
    	<Td>
        
        <cfoutput>
        <Form method="post" action="received_progress_reports.cfm?stuid=#url.stuid#">
        <input type="hidden" name="addReportNow" />        
        <table>
        	<Tr>
            	<Td>Second Visit Rep ID:</Td><td> <input type="text" name="secondVisitRepID" size=5/></td>
            </Tr>
            <tr>
            	<td>Host Family :</Td><td>
                <select name="hostiD">
                <cfloop query="otherHosts">
                 <option value="#hostID#">#familylastname# (#hostid#)</option>
                </cfloop>
                </select> 
                 </td>
            </tr>
            <tr>
            	<Td colspan=2><input type="image" src="../pics/submit.gif" /> </Td>
            </tr>
          </table>
      	</Form>
        </cfoutput>
        </Td>
    </Tr>
</table>
</cfif>
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>