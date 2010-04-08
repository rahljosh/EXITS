<!----Scripts for Regions and Months---->
<cfset total_students_per_rep.total_number = 0>
<cfset current_students_per_rep.total_showing = 0>
<cfif NOT isDefined('url.rmonth')>
<!--- SET THE CURRENT PROGRESS REPORT --->
	<cfif DateFormat(now(), 'mm') EQ 9 OR dateFormat(now(), 'mm') EQ 10> 
		<cfset url.rmonth = 10> <!--- OCT --->
	<cfelseif DateFormat(now(), 'mm') EQ 11 OR dateFormat(now(), 'mm') EQ 12> 
		<cfset url.rmonth = 12> <!--- DEC --->
	<cfelseif DateFormat(now(), 'mm') EQ 1 OR dateFormat(now(), 'mm') EQ 2> 
		<cfset url.rmonth = 2> <!--- FEB --->
	<cfelseif DateFormat(now(), 'mm') eq 3 OR dateFormat(now(), 'mm') EQ 4> 
		<cfset url.rmonth = 4> <!--- APRIL --->
	<cfelseif DateFormat(now(), 'mm') EQ 5 OR dateFormat(now(), 'mm') EQ 6> 
		<cfset url.rmonth = 6> <!--- JUNE --->
	<cfelseif DateFormat(now(), 'mm') EQ 7 OR dateFormat(now(), 'mm') EQ 8> 
		<cfset url.rmonth = 8> <!--- August --->
	</cfif>
</cfif>


<!--- REPORTS PER PROGRAM
	10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 1
	12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 2
	1ST SEMESTER - OCT - DEC - FEB - TYPE = 3
	2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 4
	
	PRIVATE HIGH SCHOOL PROGRAM
	10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 5
	12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 24
	1ST SEMESTER - OCT - DEC - FEB - TYPE = 25
	2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 26
---->

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.sele_region.options[document.form.sele_region.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler2(form){
var URL = document.formmonth.month.options[document.formmonth.month.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<!--- OFFICE - GET ALL REGIONS --->
<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="caseusa"> 
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	<cfif not isDefined("url.regionid")><cfset url.regionid = list_regions.regionid></cfif>
<!--- FIELD - GET USERS REGION --->
<cfelse>	
	<cfquery name="list_regions" datasource="caseusa"> 
		SELECT user_access_rights.regionid, user_access_rights.usertype, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' 
			AND user_access_rights.companyid = '#client.companyid#'
			AND user_access_rights.usertype <= '6'
		ORDER BY default_region DESC, regionname
	</cfquery>
	<!--- getting correct usertype for the region choosen --->
	<!----
	<cfset client.usertype = list_regions.usertype>
	---->
	<cfif NOT IsDefined('url.regionid')><cfset url.regionid = list_regions.regionid></cfif>
</cfif>


<!----Querys for Reports---->






<!----Students with Reports---->
<cfquery name="students_in_region" datasource="caseusa">
SELECT distinct smg_prquestion_details.report_number, 
smg_students.firstname, smg_students.familylastname, smg_students.arearepid, smg_students.studentid,
smg_users.firstname as rep_first, smg_users.lastname as rep_last,
smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved,
smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.saveonly, smg_document_tracking.note,
user_access_rights.advisorid
FROM smg_students
INNER JOIN smg_users ON smg_users.userid = smg_students.arearepid
RIGHT OUTER JOIN smg_prquestion_details ON  smg_prquestion_details.stuid = smg_students.studentid
INNER JOIN smg_document_tracking on smg_document_tracking.report_number = smg_prquestion_details.report_number
INNER JOIN user_access_rights on user_access_rights.userid = smg_students.arearepid
INNER JOIN smg_programs on smg_programs.programid = smg_students.programid
WHERE smg_students.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer"> 
AND smg_students.active = 1
AND smg_prquestion_details.month_of_report = <cfqueryparam value="#url.rmonth#" cfsqltype="cf_sql_integer">
AND user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
AND smg_programs.progress_reports_active = 1
order by advisorid, rep_last, ny_Accepted, familylastname
</cfquery>

<!----Students with out reports---->


<cfquery name="total_students" datasource="caseusa">
select smg_students.studentid, smg_students.arearepid
from smg_students
inner join smg_programs on smg_programs.programid = smg_students.programid
where smg_students.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
and smg_programs.hold = 0
and smg_students.active= 1 

</cfquery>




<!----Page Output---->
<cfoutput>
#total_Students.recordcount# vs #students_in_region.recordcount#<br />
<table width=90% cellpadding=0 cellspacing=0 border=0 height=24 align="center">
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
		<td background="pics/header_background.gif"><h2>Progress Reports for the month of April</td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

	<table cellpadding=2 cellspacing=4 width=90% bgcolor="##ffffe6" align="center" class="section">
				<tr><td bgcolor="##e2efc7" colspan=2>
				<Table align="center">
					<tr>
						<th colspan=6 align=center>Summary & Report Choices</th>
					</tr>
					<Tr>
											<td>Region:</td>
						<td> <cfif list_regions.recordcount GT 1>
									<form name="form">
									
										<select name="sele_region" onChange="javascript:formHandler()">
										<cfif client.usertype LTE '3'>
				
										</cfif>
										<cfloop query="list_regions">
											<option value="?curdoc=forms/progress_report_list&regionid=#regionid#&rmonth=#url.rmonth#" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
										</cfloop>
										</select>
									</form>
									<cfelse>
									<Cfquery name="region_name" datasource="caseusa">
									select regionname
									from smg_regions
									where regionid = #url.regionid#
									</Cfquery>
									#region_name.regionname#
								</cfif> 
								</td>
						
						<td width=20>
						</td>
						<td>Due:</td><Td> #total_Students.recordcount#</Td>
						
						
					</Tr>
					<tr>
<td>Month:</td>
						<td>
								<form name="formmonth">
	
		<select name="month" onChange="javascript:formHandler2()">
		<option value="?curdoc=forms/progress_report_list&rmonth=0&regionid=#regionid#&clearpage=0&RequestTimeout=240" <cfif url.rmonth is '0'>selected</cfif>>All</option>
		<option value="?curdoc=forms/progress_report_list&rmonth=10&regionid=#regionid#&clearpage=0" <cfif url.rmonth is '10'>selected</cfif>>October</option>
		<option value="?curdoc=forms/progress_report_list&rmonth=12&regionid=#regionid#&clearpage=0" <cfif url.rmonth is '12'>selected</cfif>>December</option>
		<option value="?curdoc=forms/progress_report_list&rmonth=2&regionid=#regionid#&clearpage=0" <cfif url.rmonth is '2'>selected</cfif>>February</option>
		<option value="?curdoc=forms/progress_report_list&rmonth=4&regionid=#regionid#&clearpage=0" <cfif url.rmonth is '4'>selected</cfif>>April</option>
		<option value="?curdoc=forms/progress_report_list&rmonth=6&regionid=#regionid#&clearpage=0" <cfif url.rmonth is '6'>selected</cfif>>June</option>
		<option value="?curdoc=forms/progress_report_list&rmonth=8&regionid=#regionid#&clearpage=0" <cfif url.rmonth is '8'>selected</cfif>>August</option>
		</select>
	</form>
						
						</td>
								<td>
								</td>
								<td>Received:</td><td> #students_in_region.recordcount#</td>
				</tr>
				<tr>
				<td></td><td></td><td></td><td><cfset waitingon = #total_students.recordcount# - #students_in_region.recordcount#>
				Waiting On:</td><td> #waitingon#</td>
				</Tr>
				</Table>
				
				</td></tr>
	<tr>
		<td colspan=10>
		<table width=100% align="center" cellspacing="0" cellpadding=2 border=0>
				<tr bgcolor="##cccccc">
					<td colspan=10 >Regional Advisor</TD>
				</tr>
				<tr bgcolor="##FFDDBB">
					<td colspan=10><strong>Supervising Rep</strong></TD>
				</tr>
			
							<tr bgcolor="##FFDDBB">
		<td></td><td>Student</td><td>Date Submitted</td><td>RA Approved</td><td>RD Approved</td><TD>NY Approved</TD><TD>Rejected</TD>
	</tr>

	

		
		<cfset currentra=1>
		<Cfset prevrep = 0>	
<cfloop query=students_in_Region>
		<!---Figure out if you need to display an RA---->
		 <cfif currentra NEQ #advisorid#>
		 <Cfset currentra = #advisorid#>
		 
		 
		 <cfset rawaiting = 1>
			<cfif advisorid eq 0>
				<tr bgcolor="##CCCCCC">
					<td colspan=10>Reports Directly to Regional Director</td>
				</tr>
			<cfelse>
				<Cfquery name="advisor_info" datasource="caseusa">
				select firstname, lastname
				from smg_users
				where userid = #advisorid#
				</Cfquery>
					<tr bgcolor="##CCCCCC">
						<Td colspan=10><strong>#advisor_info.firstname# #advisor_info.lastname#</strong> </Td>
					</tr>
			</cfif>
		<cfelse>
			<cfset rawaiting = 0>
		</cfif>
		 <!----Figure out if you need to dispaly the Supervising Rep Name---->
		<Cfset currentrep = #arearepid#>
		<cfif currentrep NEQ #prevrep#>
		<cfset prevrep = #arearepid#>
		<!---Query to see if missing reports for students---->
		<Cfquery name="total_students_per_rep" dbtype=query>
		SELECT count(studentid) as total_number 
		FROM  total_students
		WHERE arearepid = #arearepid#
		
		</Cfquery>
	
	

		<Cfquery name="current_students_per_rep" dbtype=query>
		SELECT count(studentid) total_showing
		FROM  students_in_region
		WHERE arearepid = #arearepid#
		</Cfquery>
	
<!----
		<Cfquery name="current_students_per_rep_ids" dbtype=query>
		SELECT studentid
		FROM  total_students
		WHERE arearepid = #arearepid#
		</Cfquery>
	---->
				<tr>
					<td colspan=10><strong>#rep_first# #rep_last# (#arearepid#)</strong>
				<Cfset tspr =  #total_students_per_rep.total_number#>
		<cfif tspr is "">
			<cfset tspr = 0>
		</cfif>

		<cfif current_students_per_rep.total_showing is ''>
			<cfset current_students_per_rep.total_showing = 0>
		</cfif>
	<cfquery name="total_students_under_rep" datasource="caseusa">
select smg_students.studentid, smg_students.arearepid
from smg_students
inner join smg_programs on smg_programs.programid = smg_students.programid
where smg_students.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
and smg_programs.hold = 0
and smg_students.active= 1 
and smg_students.arearepid = #arearepid#
</cfquery>
::#total_students_under_rep.recordcount#::
					<cfset sw = 0>
				
					<cfset sw = #tspr# - #current_students_per_rep.total_showing#>
					<!----
					<cfif sw neq 0>
					<font color="##CC0000"> - Waiting on #sw# report<cfif sw neq 1>s</cfif></font>
					
					</cfif>
					---->
				<tr>
				<!----Student Info---->
				
				
				<tr class="btnav" onmouseover="style.backgroundColor='##FFDDBB';" onMouseOut="style.backgroundColor='##FFFFE6';">
					<td width=10></td><td><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#firstname# #familylastname# (#studentid#)</td>
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_submitted, 'mm/dd/yyyy')#</td>
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_ra_approved, 'mm/dd/yyyy')#  </td> 
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_rd_approved, 'mm/dd/yyyy')#  </td>
					<TD><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(ny_accepted, 'mm/dd/yyyy')#  </TD>
					<TD><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_rejected, 'mm/dd/yyyy')#  </TD>
					
				</tr>
				
		<cfelse>
			<tr class="btnav" onmouseover="style.backgroundColor='##FFDDBB';" onMouseOut="style.backgroundColor='##FFFFE6';">
					<td width=10></td><td><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#firstname# #familylastname# (#studentid#)</td>
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_submitted, 'mm/dd/yyyy')# </td>
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_ra_approved, 'mm/dd/yyyy')#  </td> 
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_rd_approved, 'mm/dd/yyyy')#  </td>
					<TD><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(ny_accepted, 'mm/dd/yyyy')#  </TD>
					<TD><a href="?curdoc=forms/view_progress_report&number=#report_number#&regionid=#regionid#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_rejected, 'mm/dd/yyyy')#  </TD>
					
				</tr>
		</cfif>
			
</cfloop>

</table>

</cfoutput>
</table>
<!----footer of table---->
<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
</table>
</body>
</html>

