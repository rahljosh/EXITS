<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Documents Received per Period</title>
</head>

<body>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfif form.date1 EQ '' OR form.date2 EQ ''>
	You must enter start and/or end date in order to continue.
	<cfabort>
</cfif>

<cfif not IsDefined('form.programid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_regions" datasource="caseusa">
	select regionid, regionname
	from smg_regions
	WHERE company = '#client.companyid#' <cfif form.regionid is '0'><cfelse>AND regionid = '#form.regionid#'</cfif>
	ORDER BY regionname
</cfquery> 

<cfif client.usertype is '6'> <!--- advisors --->
	<cfquery name="get_users_under_adv" datasource="caseusa">
	SELECT userid
	FROM user_access_rights
	WHERE advisorid = '#client.userid#' and companyid = '#client.companyid#'
	</cfquery>
	<cfset ad_users = ValueList(get_users_under_adv.userid, ',')>
	<cfset ad_users = ListAppend(ad_users, #client.userid#)>
</cfif> <!--- advisors --->

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="caseusa">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE companyid = #client.companyid# and active = '1' AND hostid <> '0' 
			<cfif form.regionid is  not 0>
			AND regionassigned = '#form.regionid#'	
			</cfif>
			AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
			<cfif client.usertype is '6'>
				AND ( placerepid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
				'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or placerepid = </cfif> </Cfloop>)
			</cfif>
										
</cfquery>

<table width='100%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Documents Received Per Period Report</cfoutput></span>
</table>
<br>

<cfoutput>
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	Total of Students <b>placed</b> in program: #get_total_students.recordcount#<br>
	Period: From #DateFormat(form.date1, 'mm/dd/yyyy')# To #DateFormat(form.date2, 'mm/dd/yyyy')#
	</td></tr>
</table>

<br> <!--- table header --->
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
<tr><td width="85%">Placing Representative</td><td width="15%" align="center">Total</td></tr>
</table>
<br>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>
	<Cfquery name="list_repid" datasource="caseusa">
		SELECT placerepid, u.firstname as repname
		FROM smg_students
		LEFT JOIN smg_users u ON placerepid = userid
		where smg_students.active = '1' AND smg_students.regionassigned = '#get_regions.regionid#' AND smg_students.companyid = '#client.companyid#' 
							AND smg_students.hostid != '0' 
							AND (<cfloop list=#form.programid# index='prog'>
								smg_students.programid = #prog# 
								<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
								</cfloop> )
							<cfif client.usertype is '6'>
								AND ( placerepid = 
								<cfloop list="#ad_users#" index='i' delimiters = ",">
								'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or placerepid = </cfif> </Cfloop>)
							</cfif>				
		Group by placerepid
		Order by repname
	</cfquery>
	
	<Cfquery name="get_total_in_region" datasource="caseusa">
		select studentid
		from smg_students
		where active = '1' AND regionassigned = '#get_regions.regionid#'  AND companyid = '#client.companyid#' 
		   AND hostid <> '0'
		   AND (<cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
		<cfif client.usertype is '6'>
			AND ( placerepid = 
			<cfloop list="#ad_users#" index='i' delimiters = ",">
			'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or placerepid = </cfif> </Cfloop>)
		</cfif>	
		    AND (doc_full_host_app_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)#
				OR doc_letter_rec_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_rules_rec_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_photos_rec_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_school_accept_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)#
				OR doc_school_profile_rec BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_conf_host_rec BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_date_of_visit BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_ref_form_1 BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_ref_form_2 BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)#
				OR stu_arrival_orientation BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR host_arrival_orientation BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)#)
	</cfquery> 
	
	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="##CCCCCC">#get_regions.regionname#</th><td width="15%" align="center" bgcolor="##CCCCCC"><b>#get_total_in_region.recordcount#</b></td></tr>
	</table><br>

	<cfif get_total_in_region.recordcount NEQ 0>

	<cfloop query="list_repid">

		<Cfquery name="get_rep_info" datasource="caseusa">
			select userid, firstname, lastname
			from smg_users
			where userid = '#list_repid.placerepid#'
		</cfquery>

		<Cfquery name="get_students_region" datasource="caseusa">
			select studentid, countryresident, firstname, familylastname, sex, programid, placerepid,
			date_pis_received, doc_full_host_app_date, doc_letter_rec_date, doc_rules_rec_date, doc_photos_rec_date, doc_school_accept_date, doc_school_profile_rec,
			doc_conf_host_rec, doc_date_of_visit, doc_ref_form_1, doc_ref_form_2, stu_arrival_orientation, host_arrival_orientation
			from smg_students
			where active = '1' AND regionassigned = '#current_region#' AND companyid = '#client.companyid#' 
			 AND placerepid = '#list_repid.placerepid#' AND hostid <> '0' 
			 AND (<cfloop list=#form.programid# index='prog'>
					programid = #prog# 
					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
					</cfloop> )
		    AND (doc_full_host_app_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)#
				OR doc_letter_rec_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_rules_rec_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_photos_rec_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_school_accept_date BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)#
				OR doc_school_profile_rec BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_conf_host_rec BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_date_of_visit BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_ref_form_1 BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR doc_ref_form_2 BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)#
				OR stu_arrival_orientation BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)# 
				OR host_arrival_orientation BETWEEN #CreateODBCDate(form.date1)# AND #CreateODBCDate(form.date2)#)		
		</cfquery> 
		
		<cfif get_students_region.recordcount is not 0> 
			<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">
				<tr><td width="85%" align="left">
					&nbsp; 
					<cfif get_rep_info.firstname EQ '' and get_rep_info.lastname EQ ''>
						<font color="red">Missing or Unknown</font>
					<cfelse>
						#get_rep_info.firstname# #get_rep_info.lastname#</u>
					</cfif>
					</td>
					<td width="15%" align="center">#get_students_region.recordcount#</td></tr>
			</table>
								
			<table width='100%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr>
					<td width="4%">ID</th>
					<td width="18%">Student</td>
					<td width="8%">Placement</td>
					<td width="70%">Documents Received from #DateFormat(form.date1, 'mm/dd/yyyy')# to #DateFormat(form.date2, 'mm/dd/yyyy')#</td>
				</tr>	
				<cfloop query="get_students_region">			 
					<tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
						<td>#studentid#</td>
						<td>#firstname# #familylastname#</td>
						<td>#DateFormat(date_pis_received, 'mm/dd/yyyy')#</td>
						<td align="left"><i><font size="-2">
							<cfif doc_full_host_app_date GTE #CreateODBCDate(form.date1)# AND doc_full_host_app_date LTE #CreateODBCDate(form.date2)#>Host Family &nbsp; #DateFormat(doc_full_host_app_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_letter_rec_date GTE #CreateODBCDate(form.date1)# AND doc_letter_rec_date LTE #CreateODBCDate(form.date2)#> -  &nbsp; HF Letter &nbsp; #DateFormat(doc_letter_rec_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_rules_rec_date GTE #CreateODBCDate(form.date1)# AND doc_rules_rec_date LTE #CreateODBCDate(form.date2)#> -  &nbsp; HF Rules &nbsp; #DateFormat(doc_rules_rec_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_photos_rec_date GTE #CreateODBCDate(form.date1)# AND doc_photos_rec_date LTE #CreateODBCDate(form.date2)#> -  &nbsp; HF Photos &nbsp; #DateFormat(doc_photos_rec_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_school_accept_date GTE #CreateODBCDate(form.date1)# AND doc_school_accept_date LTE #CreateODBCDate(form.date2)#> -  &nbsp; School Acceptance &nbsp; #DateFormat(doc_school_accept_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_school_profile_rec GTE #CreateODBCDate(form.date1)# AND doc_school_profile_rec LTE #CreateODBCDate(form.date2)#> -  &nbsp; School & Community Profile &nbsp;#DateFormat(doc_school_profile_rec,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_conf_host_rec GTE #CreateODBCDate(form.date1)# AND doc_conf_host_rec LTE #CreateODBCDate(form.date2)#> -  &nbsp; Visit Form &nbsp; #DateFormat(doc_conf_host_rec,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_date_of_visit GTE #CreateODBCDate(form.date1)# AND doc_date_of_visit LTE #CreateODBCDate(form.date2)#> -  &nbsp; Date of Visit &nbsp; #DateFormat(doc_date_of_visit,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_ref_form_1 GTE #CreateODBCDate(form.date1)# AND doc_ref_form_1 LTE #CreateODBCDate(form.date2)#> -  &nbsp; Ref. 1 &nbsp; #DateFormat(doc_ref_form_1,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_ref_form_2 GTE #CreateODBCDate(form.date1)# AND doc_ref_form_2 LTE #CreateODBCDate(form.date2)#> -  &nbsp; Ref. 2 &nbsp; #DateFormat(doc_ref_form_2,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif stu_arrival_orientation GTE #CreateODBCDate(form.date1)# AND stu_arrival_orientation LTE #CreateODBCDate(form.date2)#> -  &nbsp; Student Orientation &nbsp;#DateFormat(stu_arrival_orientation, 'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif host_arrival_orientation GTE #CreateODBCDate(form.date1)# AND host_arrival_orientation LTE #CreateODBCDate(form.date2)#> -  &nbsp; HF Orientation &nbsp;#DateFormat(host_arrival_orientation,'mm/dd/yyyy')# &nbsp;</cfif>
						</font></i></td>		
					</tr>								
				</cfloop>	
			</table>
			<br>				
		</cfif>  <!--- get_students_region.recordcount is not 0 ---> 
	
	</cfloop> <!--- cfloop query="list_repid" --->
	
	<cfelse><!---  get_total_in_region.recordcount --->
			<table width='100%' cellpadding=4 cellspacing="0" align="center">
			<tr><td>None documents were received from #DateFormat(form.date1, 'mm/dd/yyyy')# to #DateFormat(form.date2, 'mm/dd/yyyy')#.</td></tr>
			</table><br>
	</cfif> <!---  get_total_in_region.recordcount --->
</cfloop> <!--- cfloop query="get_regions" --->
</cfoutput><br>

</body>
</html>