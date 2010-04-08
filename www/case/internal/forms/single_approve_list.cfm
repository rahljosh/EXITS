<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.sele_region.options[document.form.sele_region.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET ALL REGIONS --->
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	
	<cfif not isDefined("url.regionid")><cfset url.regionid = list_regions.regionid></cfif>

<cfelse>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET USERS REGION --->
		SELECT user_access_rights.regionid, user_access_rights.usertype, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' AND user_access_rights.companyid = '#client.companyid#'
		ORDER BY default_region DESC, regionname
	</cfquery>
	<!--- getting correct usertype for the region choosen --->
	<cfset client.usertype = list_regions.usertype>
	
	<cfif not IsDefined('url.regionid')><cfset url.regionid = list_regions.regionid></cfif>
</cfif>

<span class="application_section_header">Progress Report Status </span><br><br>

<cfquery name="current_programs" datasource="caseusa">
		select programid from smg_programs
		where startdate < #now()# and companyid = #client.companyid#
		</cfquery>
		
<cfif client.usertype lte 4>
	<Cfoutput>
	
	<Cfquery name="rd_students" datasource="caseusa">
		select smg_students.studentid, smg_students.regionassigned, smg_students.familylastname, smg_students.firstname, smg_students.programid,  smg_users.firstname as rep_firstname, smg_users.lastname as rep_lastname, smg_users.userid
		from smg_students right join smg_users on smg_students.arearepid = smg_users.userid
		where 1=1
			<cfif url.regionid is "All"><cfelse>
				AND smg_students.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			</cfif>
			AND smg_students.companyid = #client.companyid# and smg_students.active =1 and
			 (programid = 
			<Cfloop query="current_programs">
			 #programid# <cfif current_programs.currentrow is #current_programs.recordcount#><cfelse> or programid = </cfif>
			</Cfloop>)
			and smg_students.active =1
			ORDER BY smg_users.lastname, smg_users.userid
		</cfquery>
	</Cfoutput>
<cfelse>
	
	<Cfquery name="rd_students" datasource="caseusa">
	SELECT smg_students.studentid, smg_students.regionassigned, smg_students.familylastname, smg_students.firstname, smg_students.programid,  smg_users.firstname as rep_firstname, smg_users.lastname as rep_lastname, smg_users.userid
	FROM smg_students right join smg_users on smg_students.arearepid = smg_users.userid
	WHERE 1=1
	<cfif url.regionid is "All"><cfelse>
		AND smg_students.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
	</cfif>
		<cfif client.usertype is 6>
		<cfquery name="get_reps" datasource="caseusa">
							select userid 
							from user_access_rights
							where advisorid = #client.userid# and companyid = #client.companyid#
							</cfquery>
							
							and (smg_students.arearepid = 
							<cfloop query="get_reps">
							#userid# <cfif get_reps.currentrow eq #get_reps.recordcount#><cfelse> or smg_students.arearepid =</cfif>
							</cfloop>)
		</cfif>
	and smg_users.usertype < 8
	and smg_students.companyid = #client.companyid# and smg_students.active =1
	and (programid = 
	<Cfloop query="current_programs">
	 #programid# <cfif current_programs.currentrow is #current_programs.recordcount#><cfelse> or programid = </cfif>
	</Cfloop>)
	order by smg_users.lastname,smg_users.userid 
	</Cfquery> 
	
	<cfquery name="get_user_region" datasource="caseusa"> <!--- GET USERTYPE --->
		SELECT user_access_rights.regionid, user_access_rights.usertype, u.usertype as user_access
		FROM user_access_rights
		INNER JOIN smg_usertype u ON  u.usertypeid = user_access_rights.usertype
		WHERE user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  and userid = '#client.userid#'
	</cfquery>  
	<cfset client.usertype = #get_user_region.usertype#>
</cfif>

<!--- REGIONS LIST --->
<cfoutput>
<cfif list_regions.recordcount lte 1><Cfelse>
	<form name="form">
		You have access to multiple regions filter by region:
		<select name="sele_region" onChange="javascript:formHandler()">
		<cfif client.usertype LTE '4'>
		<option value="?curdoc=forms/approve_list&regionid=all" <cfif url.regionid is 'all'>selected</cfif>>All</option>
		</cfif>
		<cfloop query="list_regions">
			<option value="?curdoc=forms/approve_list&regionid=#regionid#" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
		</cfloop>
		</select>
	</form>
</cfif> 
	<cfif client.usertype GTE 5> &nbsp; &middot; &nbsp; Access Level : &nbsp; #get_user_region.user_access#  </cfif><br>
</cfoutput>

<Cfoutput group="lastname">
<table cellpadding = 2 cellspacing = 4 width=100%>
	<tr>
		<td bgcolor="##CCCCCC" colspan=2><span class="get_attention"><b>></b></span>Progress Reports to Approve</u></td>
	</tr>
	<tr>
		<td valign="top" colspan=2>
		<cfif rd_students.recordcount is 0>
		<div align="center">There are no placed students under your supervision.</div>
		<cfelse>
		
		<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
			<tr bgcolor="ABADFC">
				<td></td><td width=35%>Student Name (id)</td><td width=13%>Oct </td><td width=13%>Dec </td><td width=13%>Feb</td><td width=13%>April</td><td width=13%>June</td><td width=13%>Aug</td> 			
			</tr>

		<Cfset prevrep = 0>
		
		<Cfloop query="rd_students">
			<Cfset currentrep = #userid#>
			<cfif currentrep is #prevrep#>
			<cfelse>
		 	<tr>
				<td colspan=8 bgcolor="F0F0F0">#rep_firstname# #rep_lastname#</td>
			</tr>
			</cfif> 
			<cfif rd_students.recordcount is 0>
			<cfelse>
			<cfquery name="program_date" datasource="caseusa">
			select startdate, enddate, type
			from smg_programs 
			where programid = #rd_students.programid#
			</cfquery>

			<tr>
				<td></td><td><a href="student_profile.cfm?studentid=#rd_students.studentid#" target=top>#rd_students.firstname# #rd_students.familylastname# (#rd_students.studentid#)</a></td>
				<!----Oct---->
				<td>
				<!----
			<cfquery name="check_oct_offline" datasource="caseusa">
				select report_number
				from smg_prquestion_details
				where stuid = #studentid# and month_of_report = 10
				and submit_type = 'offline'
			</cfquery>
			<cfif check_oct_offline.recordcount gt 0>
			<a href="?curdoc=forms/view_progress_report&number=#check_oct_offline.report_number#&regionid=#regionid#" title="View Report Number #check_oct_offline.report_number#">0</font>		
			
			<cfelse>
			
			
				<cfif  program_date.type eq 4 or program_date.type eq 5>N/A
				<Cfelseif DateFormat(program_date.startdate, 'mm') gt 9 and DateFormat(program_date.startdate, 'mm') lt 11 and (program_date.type neq 2 and program_date.type neq 4)>N/A<cfelse>
					<cfquery name="october_reports" datasource="caseusa">
						select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
						smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved,smg_document_tracking.saveonly, smg_document_tracking.date_rd_approved,
						smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
						from smg_prquestion_details, smg_document_tracking
						where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 10
					</cfquery>
					
						<cfif october_reports.recordcount eq 0>
							<cfif DateFormat(now(), 'mm') is 9 or DateFormat(now(), 'mm') is 10 or DateFormat(now(), 'mm') is 11><font color="blue">D</font></a><cfelse>U</cfif>
						<cfelse>
							<cfif october_reports.date_rejected is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
								<cfelseif october_reports.ny_accepted is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
								<cfelseif october_reports.date_rd_approved is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="orange"><cfif client.usertype eq 4>W<cfelse>H</cfif></font>
								
								<cfelseif october_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
								
								<cfelseif october_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
								<cfelseif october_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
								<cfelseif october_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
								
								<cfelseif october_reports.ny_accepted is '' and october_reports.date_rd_approved is ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>

								<cfelse><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="660000">P</font>
							</cfif>
							
						
						</cfif>

				</cfif>
		</cfif>---->
				</td>
				<!----Dec---->
				<td>
				<!----
							<cfquery name="check_dec_offline" datasource="caseusa">
				select report_number
				from smg_prquestion_details
				where stuid = #studentid# and month_of_report = 12
				and submit_type = 'offline'
			</cfquery>
			<cfif check_dec_offline.recordcount gt 0>
			<a href="?curdoc=forms/view_progress_report&number=#check_dec_offline.report_number#&regionid=#regionid#" title="View Report Number #check_dec_offline.report_number#">0</font>		
			
			<cfelse>
				<cfif  program_date.type eq 4 or program_date.type eq 5>N/A
				<Cfelseif DateFormat(program_date.startdate, 'mm') gte 11 and (program_date.type neq 2 and program_date.type neq 4)>N/A<cfelse>
					<cfquery name="december_reports" datasource="caseusa">
					select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
					smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved,smg_document_tracking.saveonly, smg_document_tracking.date_rd_approved,
					smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
					from smg_prquestion_details, smg_document_tracking
					where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 12
					</cfquery>
						<cfif december_reports.recordcount eq 0>
							<cfif DateFormat(now(), 'mm') is 11 or dateFormat(now(), 'mm') is 12 or dateFormat(now(), 'mm') is 1><font color="blue">D</font></a><cfelse>U</cfif>
						<cfelse>
						
						<cfif december_reports.date_rejected is not ''><a href="" title="View Report Number #december_reports.report_number#"><font color="red">R</font></a>
								<cfelseif december_reports.ny_accepted is not ''><a href="" title="View Report Number #december_reports.report_number#"><font color="green">A</font></a>
								<cfelseif december_reports.date_rd_approved is not ''><a href="" title="View Report Number #december_reports.report_number#"><font color="orange"><cfif client.usertype eq 4>W<cfelse>H</cfif></font>
								
								<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font>
								
								<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font>
								<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font>
								<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font>
								
								<cfelseif december_reports.ny_accepted is '' and december_reports.date_rd_approved is ''><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">P</font></a>

								<cfelse><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="660000">P</font>
							</cfif>
						
						
						<!----
							<cfif december_reports.date_rejected is not ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="red">R</font></a>
							<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font>
							<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font>
							<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">P</font>
							<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">P</font>
							
							<cfelseif december_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">H</font></a>
							<cfelseif december_reports.ny_accepted is not ''><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="green">A</font></a>
							
							<cfelse><a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#" title="View Report Number #december_reports.report_number#&regionid=#regionid#"><font color="660000">P</font>
							</cfif>
							---->
						</cfif>
						
				</cfif>
			</cfif>---->
				</td>
			<!----Feb---->
				<td>
				<Cfif DateFormat(program_date.startdate, 'mm') lt 7 and (program_date.type neq 4 and program_date.type neq 2 and program_date.type neq 5)>N/A<cfelse>
					<cfquery name="february_reports" datasource="caseusa">
					select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
					smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved,smg_document_tracking.saveonly, smg_document_tracking.date_rd_approved,
					smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
					from smg_prquestion_details, smg_document_tracking
					where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 2
					</cfquery>
						<cfif february_reports.recordcount eq 0>
							<cfif DateFormat(now(), 'mm') is 1 or dateFormat(now(), 'mm') is 2><font color="blue">D</font></a><cfelseif (program_date.type neq 2 and program_date.type neq 4)>N/A<cfelse>U</cfif>
						<cfelse>
								<cfif february_reports.saveonly eq 1>S
								<cfelseif february_reports.date_rejected is not ''><a href="" title="View Report Number #february_reports.report_number#"><font color="red">R</font></a>
								<cfelseif february_reports.ny_accepted is not ''><a href="" title="View Report Number #february_reports.report_number#"><font color="green">A</font></a>
								<cfelseif february_reports.date_rd_approved is not ''><a href="" title="View Report Number #february_reports.report_number#"><font color="orange"><cfif client.usertype eq 4>W<cfelse>H</cfif></font>
								
								<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font>
								
								<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font>
								<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font>
								<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font>
								
								<cfelseif february_reports.ny_accepted is '' and february_reports.date_rd_approved is ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font></a>

								<cfelse><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="660000">P</font>
							</cfif>
						
						
						<!----
							<cfif february_reports.saveonly eq 1>S
							<cfelseif february_reports.date_rejected is not ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="red">R</font></a>
							<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font>
							<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font>
							<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font>
							<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font>
							
							<cfelseif february_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">H</font></a>
							<cfelseif february_reports.ny_accepted is not ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="green">A</font></a>
							
							<cfelse><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="660000">P</font>
								</cfif>
							---->
						</cfif>
				</cfif>

				</td>
				<!----April---->
				<td><!----
				<Cfif DateFormat(program_date.startdate, 'mm') lt 7 and (program_date.type neq 4 and program_date.type neq 2 and program_date.type neq 5)>N/A<cfelse>
					<cfquery name="april_reports" datasource="caseusa">
					select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
					smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved,smg_document_tracking.saveonly, smg_document_tracking.date_rd_approved,
					smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
					from smg_prquestion_details, smg_document_tracking
					where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 4
					</cfquery>
						<cfif april_reports.recordcount eq 0>
							<cfif DateFormat(now(), 'mm') is 3 or dateFormat(now(), 'mm') is 4><font color="blue">D</font></a><cfelse>U</cfif>
						<cfelse>
							<cfif april_reports.date_rejected is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
							<cfelseif april_reports.date_rd_approved is '' and client.usertype eq 5><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
							<cfelseif april_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
							<cfelseif april_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font>
							<cfelseif april_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font>
							
							<cfelseif april_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">H</font></a>
							<cfelseif april_reports.ny_accepted is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
							
							<cfelse><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#" title="View Report Number #october_reports.report_number#&regionid=#regionid#"><font color="660000">P</font>
									</cfif>
						</cfif>
				</cfif>
					---->
				</td>
				<!----june---->
				<td>
				<!----
				<Cfif DateFormat(program_date.startdate, 'mm') lt 7 and (program_date.type neq 4 and program_date.type neq 2 and program_date.type neq 5)>N/A<cfelse>
					<cfquery name="june_reports" datasource="caseusa">
					select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
					smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved,smg_document_tracking.saveonly, smg_document_tracking.date_rd_approved,
					smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
					from smg_prquestion_details, smg_document_tracking
					where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 5
					</cfquery>
						<cfif june_reports.recordcount eq 0>
							<cfif DateFormat(now(), 'mm') is 5 or dateFormat(now(), 'mm') is 6><font color="blue">D</font></a><cfelse>U</cfif>
						<cfelse>
							<cfif june_reports.date_rejected is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
							<cfelseif june_reports.date_rd_approved is '' and client.usertype eq 5><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
							<cfelseif june_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
							<cfelseif june_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font>
							<cfelseif june_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font>
							
							<cfelseif june_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">H</font></a>
							<cfelseif june_reports.ny_accepted is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
							
							<cfelse><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="660000">P</font>
									</cfif>
						</cfif>
				</cfif>
				---->
				</td>
				<!----august---->
				<td>
				<!---
				<Cfif DateFormat(program_date.startdate, 'mm') lt 7 or program_date.type neq 2>N/A<cfelse>
					<cfquery name="august_reports" datasource="caseusa">
					select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
					smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved,smg_document_tracking.saveonly, smg_document_tracking.date_rd_approved,
					smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
					from smg_prquestion_details, smg_document_tracking
					where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 8
					</cfquery>
						<cfif august_reports.recordcount eq 0>
							<cfif DateFormat(now(), 'mm') is 7 or dateFormat(now(), 'mm') is 8><font color="blue">D</font></a><cfelse>U</cfif>
						<cfelse>
							<cfif august_reports.date_rejected is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
							<cfelseif august_reports.date_rd_approved is '' and client.usertype eq 5><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
							<cfelseif august_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font>
							<cfelseif august_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font>
							<cfelseif august_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font>
							
							<cfelseif august_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">H</font></a>
							<cfelseif august_reports.ny_accepted is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
							
							<cfelse><a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="660000">P</font>
							</cfif>
						</cfif>
				</cfif>
				---->
				</td>				
				

			</tr>
			</cfif>
			<cfset prevrep = #userid#>
		</cfloop>
		
		</table>
<br>
<div align="center">Click on Status icon to view report.  Depending on status, various options will be available.</div>
<br>
				<table align="center" cellspacing=0 cellpadding="2">
				<th align="center" colspan=2 bgcolor="CC0000"><font color="white">Status Icon Key</th>
					<tr>
						<td valign="top" bgcolor="ededed"><font size=-2><u>N/A</u> - doesn't apply to student<br>
							<u>U</u> - Reports will be due soon<br>
							<u>D</u> - Reports is Due, has not been submitted <br>
							<u><font color="660000">P</font></u> - Report is waiting for approval<br>
							<u>O</u> - Report was submitted offline</td>
						<td valign="top" bgcolor="ededed">
						<font size=-2>
							<u><font color="orange">W</font></u> - You need to approve this report <br>
						<u><font color="orange">H</font></u> - Headquarters needs to approve <br>
							 <u><font color="green">A</font></u> - Report has been approved<br>
							<u><font color="red">R</font></u> - Report has been rejected<br>
							<u>S</u> - info recorded; not ready for approval.
							
						</td>
					</tr>
				</table>
			
	</cfif>
</Cfoutput>
</table>