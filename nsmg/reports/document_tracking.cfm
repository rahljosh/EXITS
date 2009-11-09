<link rel="stylesheet" href="reports.css" type="text/css">

<cfif not IsDefined('form.programid') OR not IsDefined('form.regionid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
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
<cfquery name="get_regions" datasource="MySQL">
	SELECT regionid, regionname
	FROM smg_regions
	WHERE company = '#client.companyid#' 
		AND (<cfloop list="#form.regionid#" index='reg'>
				regionid = #reg# 
				<cfif reg is #ListLast(form.regionid)#><Cfelse>or</cfif>
			</cfloop> )
	ORDER BY regionname
</cfquery> 

<cfif client.usertype is '6'> <!--- advisors --->
	<cfquery name="get_users_under_adv" datasource="MySql">
	SELECT userid
	FROM user_access_rights
	WHERE advisorid = '#client.userid#' AND companyid = '#client.companyid#'
	</cfquery>
	<cfset ad_users = ValueList(get_users_under_adv.userid, ',')>
	<cfset ad_users = ListAppend(ad_users, #client.userid#)>
</cfif> <!--- advisors --->

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE companyid = #client.companyid# AND active = '1' 
		AND onhold_approved <= '4'
		AND hostid != '0' 
			AND (<cfloop list="#form.regionid#" index='reg'>
				regionassigned = #reg# 
				<cfif reg is #ListLast(form.regionid)#><Cfelse>or</cfif>
				</cfloop> )			
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

<table width="100%" cellpadding=4 cellspacing="0" align="center">
	<tr><td><span class="application_section_header"><cfoutput>#companyshort.companyshort# - Missing Placement Documents Report</cfoutput></span></td></tr>
</table><br>

<table width="100%" cellpadding=4 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfoutput query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfoutput>
		<cfoutput>Total of Students <b>placed</b> in program: #get_total_students.recordcount#</cfoutput>
	</td></tr>
</table><br>

<!--- table header --->
<table width="100%" cellpadding=4 cellspacing="0" align="center" frame="box">	
	<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
	<tr><td width="85%">Placing Representative</td><td width="15%" align="center">Total</td></tr>
</table><br>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>
	<Cfquery name="list_repid" datasource="MySQL">
		SELECT placerepid, u.firstname as repname
		FROM smg_students
		LEFT JOIN smg_users u ON placerepid = userid
		WHERE smg_students.active = '1' 
			AND smg_students.regionassigned = '#get_regions.regionid#' 
			AND smg_students.companyid = '#client.companyid#' 
			AND onhold_approved <= '4'
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
		ORDER BY repname
	</cfquery>
	
	<Cfquery name="get_total_in_region" datasource="MySQL">
		SELECT studentid
		FROM smg_students
		WHERE active = '1' 
			AND regionassigned = '#get_regions.regionid#'  
			AND companyid = '#client.companyid#' 
		   AND onhold_approved <= '4'
		   AND hostid <> '0'
		   AND (<cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
		   AND (doc_full_host_app_date IS NULL or doc_letter_rec_date IS NULL or doc_rules_rec_date IS NULL or
				 doc_photos_rec_date IS NULL or doc_school_accept_date IS NULL or doc_school_profile_rec IS NULL or
				 doc_conf_host_rec IS NULL or doc_date_of_visit IS NULL or doc_ref_form_1 IS NULL or doc_ref_form_2 IS NULL
				 or stu_arrival_orientation IS NULL or host_arrival_orientation IS NULL)
		<cfif client.usertype is '6'>
			AND ( placerepid = 
			<cfloop list="#ad_users#" index='i' delimiters = ",">
			'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or placerepid = </cfif> </Cfloop>)
		</cfif>				
	</cfquery> 
	
	<table width="100%" cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="#CCCCCC"><cfoutput>#get_regions.regionname#</th><td width="15%" align="center" bgcolor="CCCCCC"><b>#get_total_in_region.recordcount#</b></td></cfoutput></tr>
	</table><br>

	<cfif get_total_in_region.recordcount is not 0>

	<cfloop query="list_repid">

		<Cfquery name="get_rep_info" datasource="MySQL">
			SELECT userid, firstname, lastname
			FROM smg_users
			WHERE userid = '#list_repid.placerepid#'
		</cfquery>

		<Cfquery name="get_students_region" datasource="MySQL">
			SELECT studentid, countryresident, firstname, familylastname, sex, programid, placerepid,
			date_pis_received, doc_full_host_app_date, doc_letter_rec_date, doc_rules_rec_date, doc_photos_rec_date, doc_school_accept_date, doc_school_profile_rec,
			doc_conf_host_rec, doc_date_of_visit, doc_ref_form_1, doc_ref_form_2, stu_arrival_orientation, host_arrival_orientation
			FROM smg_students
			WHERE active = '1' AND regionassigned = '#current_region#' AND companyid = '#client.companyid#' 
				 AND onhold_approved <= '4'
				 AND placerepid = '#list_repid.placerepid#' AND hostid <> '0' 
				 AND (<cfloop list=#form.programid# index='prog'>
						programid = #prog# 
						<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
						</cfloop> )
				 AND (doc_full_host_app_date IS NULL or doc_letter_rec_date IS NULL or doc_rules_rec_date IS NULL or doc_photos_rec_date IS NULL or 
				  doc_school_accept_date IS NULL or doc_school_profile_rec IS NULL or doc_conf_host_rec IS NULL or doc_date_of_visit IS NULL or
				  doc_ref_form_1 IS NULL or doc_ref_form_2 IS NULL or stu_arrival_orientation IS NULL or host_arrival_orientation IS NULL) 
		</cfquery> 
		
		<cfif get_students_region.recordcount is not 0> 

			<table width="100%" cellpadding=4 cellspacing="0" align="center" frame="below">
				<tr><td width="85%" align="left">
					<cfoutput> &nbsp; <cfif get_rep_info.firstname is '' AND get_rep_info.lastname is ''><font color="red">Missing or Unknown</font><cfelse>
					#get_rep_info.firstname# #get_rep_info.lastname#</u></cfif>
					</td>
					<td width="15%" align="center">#get_students_region.recordcount#</td></cfoutput></tr>
			</table>
								
			<table width="100%" frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr>
					<td width="4%">ID</th>
					<td width="18%">Student</td>
					<td width="8%">Placement</td>
					<td width="70%">Missing Documents</td>
				</tr>	
				<cfoutput query="get_students_region">			 
					<tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
						<td>#studentid#</td>
						<td>#firstname# #familylastname#</td>
						<td>#DateFormat(date_pis_received, 'mm/dd/yyyy')#</td>
						<td align="left"><i><font size="-2">
							<cfif doc_full_host_app_date is ''>Host Family &nbsp; &nbsp;</cfif>
							<cfif doc_letter_rec_date is ''>HF Letter &nbsp; &nbsp;</cfif>
							<cfif doc_rules_rec_date is ''>HF Rules &nbsp; &nbsp;</cfif>
							<cfif doc_photos_rec_date is ''>HF Photos &nbsp; &nbsp;</cfif>
							<cfif doc_school_accept_date is ''>School Acceptance &nbsp; &nbsp;</cfif>
							<cfif doc_school_profile_rec is ''>School & Community Profile &nbsp; &nbsp;</cfif>
							<cfif doc_conf_host_rec is ''>Visit Form &nbsp; &nbsp;</cfif>
							<cfif doc_date_of_visit is ''>Date of Visit &nbsp; &nbsp; </cfif>
							<cfif doc_ref_form_1 is ''>Ref. 1 &nbsp; &nbsp;</cfif>
							<cfif doc_ref_form_2 is ''>Ref. 2 &nbsp; &nbsp;</cfif>
							<cfif stu_arrival_orientation is ''>Student Orientation &nbsp; &nbsp;</cfif>
							<cfif host_arrival_orientation is ''>HF Orientation &nbsp; &nbsp;</cfif>
						</font></i></td>		
					</tr>								
				</cfoutput>	
			</table>
			<br>				
		</cfif>  <!--- get_students_region.recordcount is not 0 ---> 
	
	</cfloop> <!--- cfloop query="list_repid" --->
	
	<cfelse><!---  get_total_in_region.recordcount --->
			<table width="100%" cellpadding=4 cellspacing="0" align="center">
			<tr><td>There are none students missing documents.</td></tr>
			</table>
	</cfif> <!---  get_total_in_region.recordcount --->
</cfloop> <!--- cfloop query="get_regions" --->
<br>