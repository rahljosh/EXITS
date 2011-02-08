<link rel="stylesheet" href="reports.css" type="text/css">
<cfif not IsDefined('form.programid')>
	<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
	<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
	Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
	<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
	</td></tr>
	</table>
	<cfabort>
</cfif>

<cfif NOT IsDefined('form.active')>
	<cfset form.active = 1>
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

<cfquery name="get_facilitators" datasource="MySql">
SELECT userid, firstname, lastname, companyid
FROM smg_users
WHERE usertype = 3 and companyid = #client.companyid#
<cfif form.userid is not 0>
and userid = #form.userid#
</cfif>
Order by Firstname
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid, smg_users.firstname, smg_users.lastname
	FROM smg_regions
	LEFT JOIN smg_users ON smg_regions.regionfacilitator = smg_users.userid
	WHERE company = '#client.companyid#'
		<cfif form.userid is not 0>
			and regionfacilitator = #form.userid#
		</cfif>
		<cfif client.usertype GT 4>
			and regionid like '#client.regions#'
		</cfif>
	ORDER BY smg_users.firstname					
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE companyid = #client.companyid# and active = '1'
		  	AND onhold_approved <= '4'
			AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		AND hostid <> '0' 
</cfquery>

<table width='100%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>Missing Placement Documents Report</cfoutput></span>
</table>
<br>

<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfoutput query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfoutput>
	<cfoutput>Total of Students <b>placed</b> in program: #get_total_students.recordcount#</cfoutput>
	</td></tr>
</table>

<br> <!--- table header --->
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
<tr><td width="85%">Placing Representative</td><td width="15%" align="center">Total</td></tr>
</table>
<br>

<cfloop query="get_region">
	
	<cfset current_region = get_region.regionid>
	
	<Cfquery name="list_repid" datasource="MySQL">
	SELECT placerepid, u.firstname as repname
	FROM smg_students
	LEFT JOIN smg_users u ON placerepid = userid
	where smg_students.active = '1' AND smg_students.regionassigned = '#get_region.regionid#' AND smg_students.companyid = '#client.companyid#' 
		AND onhold_approved <= '4'
		 AND smg_students.hostid <> '0'
		AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	Group by placerepid
	Order by repname
	</cfquery>
	
	<Cfquery name="get_total_in_region" datasource="MySQL">
		select studentid
		from smg_students
		where active = '1' AND regionassigned = '#get_region.regionid#'  AND companyid = '#client.companyid#' 
		   AND onhold_approved <= '4'
		   AND hostid != '0'
		   AND (<cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			AND (doc_full_host_app_date IS NULL or doc_letter_rec_date IS NULL or doc_rules_rec_date IS NULL 
				or doc_photos_rec_date IS NULL or doc_school_accept_date IS NULL or doc_school_profile_rec IS NULL 
				or doc_conf_host_rec IS NULL or doc_date_of_visit IS NULL or doc_ref_form_1 IS NULL 
				or doc_ref_form_2 IS NULL or stu_arrival_orientation IS NULL or host_arrival_orientation IS NULL 
				or doc_class_schedule IS NULL OR
                doc_income_ver_date IS NULL
            OR
            	doc_conf_host_rec2 IS NULL
            OR
            	doc_single_ref_check1 IS NULL
            or
            	doc_single_ref_check2  IS NULL)
	</cfquery> 
	
	<cfif get_total_in_region.recordcount is not 0>
	
	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="#CCCCCC"><cfoutput>Fac. : &nbsp; #get_region.firstname# #get_region.lastname# &nbsp; - &nbsp; #get_region.regionname#</th><td width="15%" align="center" bgcolor="CCCCCC"><b>#get_total_in_region.recordcount#</b></td></cfoutput></tr>
	</table>
	<br>

	<cfloop query="list_repid">

		<Cfquery name="get_rep_info" datasource="MySQL">
			select userid, firstname, lastname
			from smg_users
			where userid = '#list_repid.placerepid#'
		</cfquery>

		<Cfquery name="get_students_region" datasource="MySQL">
			select studentid, countryresident, firstname, familylastname, sex, smg_students.programid, placerepid, hostid,
			date_pis_received, doc_full_host_app_date, doc_letter_rec_date, doc_rules_rec_date, doc_photos_rec_date, doc_school_accept_date, doc_school_profile_rec,
			doc_conf_host_rec, doc_date_of_visit, doc_ref_form_1, doc_ref_form_2, stu_arrival_orientation, host_arrival_orientation, doc_class_schedule, doc_income_ver_date,
            doc_conf_host_rec2, doc_single_ref_check1, doc_single_ref_check2, p.seasonid
			from smg_students
            left join smg_programs p on p.programid = smg_students.programid
			where smg_students.active = '1' AND regionassigned = '#current_region#' AND smg_students.companyid = '#client.companyid#' 
				AND onhold_approved <= '4'
				 AND placerepid = '#list_repid.placerepid#' AND hostid <> '0' 
				 AND (<cfloop list=#form.programid# index='prog'>
					 smg_students.programid = #prog# 
					 <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
					 </cfloop> )						 
				AND (doc_full_host_app_date IS NULL or doc_letter_rec_date IS NULL or doc_rules_rec_date IS NULL 
					or doc_photos_rec_date IS NULL or doc_school_accept_date IS NULL or doc_school_profile_rec IS NULL 
					or doc_conf_host_rec IS NULL or doc_date_of_visit IS NULL or doc_ref_form_1 IS NULL 
					or doc_ref_form_2 IS NULL or stu_arrival_orientation IS NULL or host_arrival_orientation IS NULL 
					or doc_class_schedule IS NULL OR
                doc_income_ver_date IS NULL
            OR
            	doc_conf_host_rec2 IS NULL
            OR
            	doc_single_ref_check1 IS NULL
            or
            	doc_single_ref_check2  IS NULL)
		</cfquery> 
		
		<cfif get_students_region.recordcount is not 0> 

			<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">
				<tr><td width="85%" align="left">
					<cfoutput> &nbsp; <cfif get_rep_info.firstname is '' and get_rep_info.lastname is ''><font color="red">Missing or Unknown</font><cfelse>
					#get_rep_info.firstname# #get_rep_info.lastname#</u></cfif>
					</td>
					<td width="15%" align="center">#get_students_region.recordcount#</td></cfoutput></tr>
			</table>
								
			<table width='100%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr>
					<td width="4%">ID</th>
					<td width="18%">Student</td>
					<td width="8%">Placement</td>
					<td width="70%">Missing Documents</td>
				</tr>	
				<cfoutput query="get_students_region">		
                 <cfquery name="get_host_info" datasource="MySQL">
                        SELECT  h.hostid, h.motherfirstname, h.fatherfirstname, h.familylastname as hostlastname, h.hostid as hostfamid
                        FROM smg_hosts h
                        WHERE hostid = #hostid#
                    </cfquery>
	 				  <!---number kids at home---->
                        <cfquery name="kidsAtHome" datasource="#application.dsn#">
                        select count(childid) as kidcount
                        from smg_host_children
                        where liveathome = 'yes' and hostid =#get_host_info.hostid#
                        </cfquery>
						
						<Cfset father=0>
                        <cfset mother=0>
                      
                        <Cfif get_host_info.fatherfirstname is not ''>
                            <cfset father = 1>
                        </Cfif>
                        <Cfif get_host_info.motherfirstname is not ''>
                            <cfset mother = 1>
                        </Cfif>
                        <cfset client.totalfam = #mother# + #father# + #kidsAtHome.kidcount#>	 
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
							<cfif doc_class_schedule is ''>Class Schedule &nbsp; &nbsp;</cfif>		
							 <cfif seasonid gt 8>
                                <cfif NOT LEN(doc_income_ver_date)>Income Verification &nbsp; &nbsp;</cfif>
                                <cfif NOT LEN(doc_conf_host_rec2)> 2nd Conf. Host Visit &nbsp; &nbsp;</cfif>
                            </cfif>
                            <cfif client.totalfam eq 1>
                                <cfif NOT LEN(doc_single_ref_check1)>Ref Check (Single) &nbsp; &nbsp;</cfif>
                                <cfif NOT LEN(doc_single_ref_check2)>2nd Ref Check (Single) &nbsp; &nbsp;</cfif>
                            </cfif>					
						</font></i></td>		
					</tr>								
				</cfoutput>	
			</table>
			<br>				
		</cfif>  <!--- get_students_region.recordcount is not 0 ---> 
	
	</cfloop> <!--- cfloop query="list_repid" --->
	
	</cfif> <!---  get_total_in_region.recordcount --->
</cfloop> <!--- cfloop query="get_region" --->
<br>