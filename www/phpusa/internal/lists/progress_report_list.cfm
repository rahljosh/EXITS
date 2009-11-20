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

<cfif NOT isDefined('url.report_limit')>
	<cfset url.report_limit = '<= J'>
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

<!----

<!----
<!--- OFFICE - GET ALL REGIONS --->
<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="MySql"> 
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	<cfif not isDefined("url.regionid")><cfset url.regionid = list_regions.regionid></cfif>
<!--- FIELD - GET USERS REGION --->
<cfelse>	
	<cfquery name="list_regions" datasource="MySql"> 
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
---->


		<!----Code to get students based on school---->
		<cfquery name="students_in_region" datasource="MySQL">
		SELECT distinct  smg_prquestion_details.report_number, smg_prquestion_details.month_of_report,
		smg_students.firstname, smg_students.familylastname, smg_students.studentid, 
		smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved,
		smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.saveonly, smg_document_tracking.note,
		php_students_in_program.schoolid, php_students_in_program.arearepid,
		smg_users.firstname as rep_first, smg_users.lastname as rep_last, smg_users.userid
		FROM php_students_in_program
		LEFT JOIN smg_students on smg_students.studentid = php_students_in_program.studentid 
		RIGHT OUTER JOIN smg_prquestion_details ON  smg_prquestion_details.stuid = smg_students.studentid
		INNER JOIN smg_document_tracking on smg_document_tracking.report_number = smg_prquestion_details.report_number
		LEFT JOIN smg_users on smg_users.userid = php_students_in_program.arearepid
		WHERE php_students_in_program.active = 1
		AND smg_prquestion_details.companyid = 6
		AND smg_prquestion_details.month_of_report = <cfqueryparam value="#url.rmonth#" cfsqltype="cf_sql_integer"> 
		</cfquery>
---->
		<!----Code for all users with reports---->
	
		<cfquery name="students_in_region1" datasource="MySQL">
		SELECT distinct  smg_prquestion_details.report_number, smg_prquestion_details.month_of_report,
		smg_students.firstname, smg_students.familylastname, smg_students.studentid, 
		smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved,
		smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.saveonly, smg_document_tracking.note,
		php_students_in_program.schoolid, php_students_in_program.arearepid,
		smg_users.firstname as rep_first, smg_users.lastname as rep_last, smg_users.userid
		FROM php_students_in_program
		LEFT JOIN smg_students on smg_students.studentid = php_students_in_program.studentid 
		RIGHT OUTER JOIN smg_prquestion_details ON  smg_prquestion_details.stuid = smg_students.studentid
		INNER JOIN smg_document_tracking on smg_document_tracking.report_number = smg_prquestion_details.report_number
		LEFT JOIN smg_users on smg_users.userid = php_students_in_program.arearepid
		WHERE php_students_in_program.active = 1
		
		AND smg_prquestion_details.companyid = 6
		AND smg_prquestion_details.month_of_report = <cfqueryparam value="#url.rmonth#" cfsqltype="cf_sql_integer"> 
		ORDER BY familylastname
		Limit 0,10
		</cfquery>
---->

<!----Querys for Reports---->






<!----Students with Reports---->

<!----Total Active Students---->


<!----
<cfquery name="students_in_region" datasource="MySQL">
SELECT distinct smg_prquestion_details.report_number, 
smg_students.firstname, smg_students.familylastname, smg_students.studentid,
smg_users.firstname as rep_first, smg_users.lastname as rep_last, smg_users.userid,
smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved,
smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.saveonly, smg_document_tracking.note,
php_students_in_program.programid, smg_programs.programname, php_students_in_program.schoolid
FROM smg_students
left  join php_students_in_program on php_students_in_program.studentid = smg_students.studentid
INNER JOIN smg_users ON smg_users.userid = php_schools.arearepid
LEFT JOIN php_school_contacts ON php_school_contacts.userid = smg_users.userid
RIGHT OUTER JOIN smg_prquestion_details ON  smg_prquestion_details.stuid = smg_students.studentid
INNER JOIN smg_document_tracking on smg_document_tracking.report_number = smg_prquestion_details.report_number
INNER JOIN smg_programs on smg_programs.programid = smg_students.programid

AND smg_students.active = 1
AND smg_prquestion_details.month_of_report = <cfqueryparam value="#url.rmonth#" cfsqltype="cf_sql_integer">
AND smg_programs.progress_reports_active = 1
order by rep_last, ny_Accepted, familylastname
limit 1
</cfquery>

---->
<!----
<cfdump var="#students_in_region#">
---->


<!----Students with out reports---->


<cfquery name="total_students" datasource="#REQUEST.MySQL#">
select smg_students.studentid, smg_students.arearepid, smg_students.familylastname
from smg_students
inner join smg_programs on smg_programs.programid = smg_students.programid
where smg_programs.hold = 0
and smg_students.active= 1 
</cfquery>

<!--- Start displaying with record 1 if not specified via url --->
<CFPARAM name="start" default="1">
<!--- Number of records to display on a page --->
<CFPARAM name="disp" default="5">

<!--- Fetch records --->
<CFQUERY name="total_students" datasource="MySQL">
 select smg_students.studentid, smg_students.arearepid
from smg_students
inner join smg_programs on smg_programs.programid = smg_students.programid
where smg_programs.hold = 0
and smg_students.active= 1 
</CFQUERY>



<CFSET end=Start + disp>
<CFIF start + disp GREATER THAN total_students.RecordCount>
  <CFSET end=10>
<CFELSE>
  <CFSET end=disp>
</CFIF>

<CFOUTPUT query="total_students" startrow="#start#" maxrows="#end#">
  #familylastname#. #studentID#<br>
</CFOUTPUT>
<CFOUTPUT>
<br>
<table border="0" cellpadding="10">
<tr>
<!--- Display prev link --->
<CFIF start NOT EQUAL 1>
  <CFIF start GTE disp>
    <CFSET prev=disp>
    <CFSET prevrec=start - disp>
  <CFELSE>
    <CFSET prev=start - 1>
    <CFSET prevrec=1>
  </CFIF>
  <td><font face="wingdings">ç</font> <a
href="NextN.cfm?start=#prevrec#">Previous #prev#
records</a></td>

</CFIF>
<!--- Display next link --->
<CFIF end LT total_students.RecordCount>
  <CFIF start + disp * 2 GTE total_students.RecordCount>
    <CFSET next=total_students.RecordCount - start - disp + 1>
  <CFELSE>
    <CFSET next=disp>
  </CFIF>
  <td><a href="NextN.cfm?start=#Evaluate("start + disp")#">Next
#next# records</a> <font face="wingdings">è</font></td>
</cfif>
</table>
</CFOUTPUT>


<!----Page Output---->
<cfoutput>
<h3>Progress Reports for the month of 
<cfif url.rmonth is '9'>September</cfif>
<cfif url.rmonth is '12'>December</cfif>
<cfif url.rmonth is '2'>February</cfif>
<cfif url.rmonth is '4'>April</cfif>
<cfif url.rmonth is '6'>June</cfif>
	

 </h3>

	<table cellpadding=2 cellspacing=4 width=90% bgcolor="##8d8d8d" align="center" class="section">
				<tr><td bgcolor="##ffffff" colspan=2>
				<Table align="center">
					<tr>
						<th colspan=6 align=center>Summary & Report Choices</th>
					</tr>
					<Tr>
											<td>Region:</td>
						<td> 
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
		
		<option value="?curdoc=lists/progress_report_list&rmonth=9&clearpage=0" <cfif url.rmonth is '9'>selected</cfif>>September</option>
		<option value="?curdoc=lists/progress_report_list&rmonth=12&clearpage=0" <cfif url.rmonth is '12'>selected</cfif>>December</option>
		<option value="?curdoc=lists/progress_report_list&rmonth=2&clearpage=0" <cfif url.rmonth is '2'>selected</cfif>>February</option>
		<option value="?curdoc=lists/progress_report_list&rmonth=4&clearpage=0" <cfif url.rmonth is '4'>selected</cfif>>April</option>
		<option value="?curdoc=lists/progress_report_list&rmonth=6&clearpage=0" <cfif url.rmonth is '6'>selected</cfif>>June</option>
	
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
		<td></td><td>Student</td><td>Date Submitted</td><td>RD Approved</td><TD>NY Approved</TD><TD>Rejected</TD>
	</tr>

	<cfset advisorid = 1>

		
		<cfset currentra=1>
		<Cfset prevrep = 0>	
<cfloop query=students_in_Region  startrow="#URL.StartRow#" endrow="#EndRow#">
		<!---Figure out if you need to display an RA---->
		 <cfif currentra NEQ #advisorid#>
		 <Cfset currentra = #advisorid#>
		 
		 
		 <cfset rawaiting = 1>
			<cfif advisorid eq 0>
				<tr bgcolor="##CCCCCC">
					<td colspan=10>Reports Directly to Regional Director</td>
				</tr>
			<cfelse>
				<Cfquery name="advisor_info" datasource="mysql">
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
	

		<Cfquery name="current_students_per_rep_ids" dbtype=query>
		SELECT studentid
		FROM  total_students
		WHERE arearepid = #arearepid#
		</Cfquery>
	
				<tr>
					<td colspan=10><strong>#rep_first# #rep_last# (#arearepid#)</strong>
				<Cfset tspr =  #total_students_per_rep.total_number#>
		<cfif tspr is "">
			<cfset tspr = 0>
		</cfif>
			<cfif current_students_per_rep.total_showing is ''>
			<cfset current_students_per_rep.total_showing = 0>
		</cfif>
				
					<cfset sw = 0>
				
					<cfset sw = #current_students_per_rep.total_showing# - #tspr# >
					
					<cfif sw neq 0>
					<font color="##CC0000"> - Waiting on #sw# report<cfif sw neq 1>s</cfif></font>
					</cfif>
				<tr>
				<!----Student Info---->
				<tr class="btnav" onmouseover="style.backgroundColor='##FFDDBB';" onMouseOut="style.backgroundColor='##FFFFE6';">
					<td width=10></td><td>  <a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#familylastname# (#studentid#)#firstname#</td>
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_submitted, 'mm/dd/yyyy')#</td>
					<!----RA approval not applicable <td><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_ra_approved, 'mm/dd/yyyy')#  </td> ---->
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_rd_approved, 'mm/dd/yyyy')#  </td>
					<TD><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(ny_accepted, 'mm/dd/yyyy')#  </TD>
					<TD><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_rejected, 'mm/dd/yyyy')#  </TD>
				</tr>
				
		<cfelse>
			<tr class="btnav" onmouseover="style.backgroundColor='##FFDDBB';" onMouseOut="style.backgroundColor='##FFFFE6';">
					<td width=10></td><td><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#firstname# #familylastname# (#studentid#)</td>
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_submitted, 'mm/dd/yyyy')# </td>
				<!----RA approval not applicable	<td><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_ra_approved, 'mm/dd/yyyy')#  </td> ---->
					<td><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_rd_approved, 'mm/dd/yyyy')#  </td>
					<TD><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(ny_accepted, 'mm/dd/yyyy')#  </TD>
					<TD><a href="?curdoc=forms/view_progress_report&number=#report_number#" title="View Report Number #report_number#"><font color="##000000">#DateFormat(date_rejected, 'mm/dd/yyyy')#  </TD>
				</tr>
		</cfif>
</cfloop>
</table>

</cfoutput>
</table>

</body>
</html>

---->