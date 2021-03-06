<link rel="stylesheet" href="../smg.css" type="text/css">

<cfif not IsDefined('url.studentid')>
	Sorry, an error has ocurred. Please try again.
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_rep" datasource="caseusa">
	SELECT u.userid, u.email, u.firstname, u.lastname,
 		uar.usertype, uar.regionid
	FROM smg_users u 
	INNER JOIN user_access_rights uar ON uar.userid = u.userid
	WHERE u.userid = '#client.userid#'
		AND uar.regionid = '#get_student_info.regionassigned#'
		AND uar.usertype > '4'
</cfquery>

<cfquery name="get_facilitator" datasource="caseusa">
	SELECT s.regionassigned, 
		r.regionname, r.regionfacilitator, r.regionid, r.company,
		u.firstname, u.lastname, u.email
	FROM smg_students s
	INNER JOIN smg_regions r ON s.regionassigned = r.regionid
	INNER JOIN smg_users u ON r.regionfacilitator = u.userid
	WHERE s.studentid = #get_student_info.studentid#
</cfquery>

<cfoutput query="get_student_info">
	
<cfif form.reason EQ 0>
	<cfinclude template="../forms/placement_status_header.cfm">
	<table width="480" align="center"><tr><td align="center"><h3>In order to continue you must select a reason for changing family.</h3></td></tr></table><br>
	<table width="480" align="center">
		<tr><td align="center"><input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
<cfelseif not IsDefined('form.welcome_family')>
	<cfinclude template="../forms/placement_status_header.cfm">
	<table width="480" align="center"><tr><td align="center"><h3>In order to continue you must answer the welcome family question.</h3></td></tr></table><br>
	<table width="480" align="center">
		<tr><td align="center"><input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
<cfelseif not IsDefined('form.relocation')>
	<cfinclude template="../forms/placement_status_header.cfm">
	<table width="480" align="center"><tr><td align="center"><h3>In order to continue you must answer the relocation question.</h3></td></tr></table><br>
	<table width="480" align="center">
		<tr><td align="center"><input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<!--- insert new row into host history --->
<cfquery name="host_history" datasource="caseusa"> 
	INSERT INTO smg_hosthistory	
		(hostid, studentid, reason, dateofchange, arearepid, placerepid, schoolid, changedby, relocation, welcome_family)
	VALUES ('#get_student_info.hostid#', '#get_student_info.studentid#', '#form.reason#', #CreateODBCDateTime(now())#, 
		'#get_student_info.arearepid#', '#get_student_info.placerepid#', '#get_student_info.schoolid#', 
	    '#client.userid#', '#form.relocation#', '#form.welcome_family#')
</cfquery>

<!--- GET LAST HISTORY TO INSERT HOST DOCUMENTS --->
<cfquery name="get_last_history" datasource="caseusa">
	SELECT MAX(historyid) as historyid
	FROM smg_hosthistory
</cfquery>
	
<!--- INSERT HISTORY DOCUMENTS --->
<cfquery name="host_docs_history" datasource="caseusa">
	INSERT INTO smg_hostdocshistory
			(historyid, hostid, studentid, date_pis_received, doc_full_host_app_date, doc_letter_rec_date, doc_rules_rec_date,
			doc_photos_rec_date, doc_school_accept_date, doc_school_sign_date, doc_class_schedule, doc_school_profile_rec, 
			doc_conf_host_rec, doc_date_of_visit, doc_ref_form_1, doc_ref_check1, doc_ref_form_2, doc_ref_check2, doc_host_orientation)
	 VALUES ('#get_last_history.historyid#', '#hostid#', '#studentid#',
			<cfif date_pis_received EQ ''>NULL<cfelse>#CreateODBCDateTime(date_pis_received)#</cfif>,		
			<cfif doc_full_host_app_date EQ ''>NULL<cfelse>#CreateODBCDate(doc_full_host_app_date)#</cfif>,
			<cfif doc_letter_rec_date EQ ''>NULL<cfelse>#CreateODBCDate(doc_letter_rec_date)#</cfif>,
			<cfif doc_rules_rec_date EQ ''>NULL<cfelse>#CreateODBCDate(doc_rules_rec_date)#</cfif>,
			<cfif doc_photos_rec_date EQ ''>NULL<cfelse>#CreateODBCDate(doc_photos_rec_date)#</cfif>,
			<cfif doc_school_accept_date EQ ''>NULL<cfelse>#CreateODBCDate(doc_school_accept_date)#</cfif>,
			<cfif doc_school_sign_date EQ ''>NULL<cfelse>#CreateODBCDate(doc_school_sign_date)#</cfif>,
			<cfif doc_class_schedule EQ ''>NULL<cfelse>#CreateODBCDate(doc_class_schedule)#</cfif>,
			<cfif doc_school_profile_rec EQ ''>NULL<cfelse>#CreateODBCDate(doc_school_profile_rec)#</cfif>,
			
			<cfif doc_conf_host_rec EQ ''>NULL<cfelse>#CreateODBCDate(doc_conf_host_rec)#</cfif>,
			<cfif doc_date_of_visit EQ ''>NULL<cfelse>#CreateODBCDate(doc_date_of_visit)#</cfif>,
			
			<cfif doc_ref_form_1 EQ ''>NULL<cfelse>#CreateODBCDate(doc_ref_form_1)#</cfif>,
			<cfif doc_ref_check1 EQ ''>NULL<cfelse>#CreateODBCDate(doc_ref_check1)#</cfif>,
			<cfif doc_ref_form_2 EQ ''>NULL<cfelse>#CreateODBCDate(doc_ref_form_2)#</cfif>,
			<cfif doc_ref_check2 EQ ''>NULL<cfelse>#CreateODBCDate(doc_ref_check2)#</cfif>,
			
			<cfif host_arrival_orientation EQ ''>NULL<cfelse>#CreateODBCDate(host_arrival_orientation)#</cfif>)
</cfquery>
#form.available_families#<Br />
#get_facilitator.recordcount#<br />
#get_rep.recordcount#<br />

<cfif form.available_families EQ '0' and get_facilitator.recordcount GT 0>
	<CFMAIL SUBJECT="EXITS - Unplaced Notification for #firstname# #familylastname# ( #studentid# )" TO="#get_facilitator.email#" FROM="support@case-usa.org">
		This e-mail is to inform you that #get_student_info.firstname# #get_student_info.familylastname# - (#get_student_info.studentid#) - Region
		#get_facilitator.regionname# has been unplaced as of #DateFormat(now(), 'mm/dd/yyyy')# by #get_rep.firstname# #get_rep.lastname# (#get_rep.userid#).
		
		Reason for unplacing the student: 
		#form.reason#
		
		Best Regards,
		EXITS
	</cfmail>
</cfif>

<cfquery name="change_host" datasource="caseusa"> 
	UPDATE smg_students
	SET <!--- change to unplaced set to 0 --->
		<cfif form.available_families EQ '0'> 
			hostid = '0',
			schoolid = '0',
			arearepid = '0',
			placerepid = '0',
			dateplaced = NULL,
			date_pis_received = NULL,
			welcome_family = '0',
			<!--- SCHOOL SECTION --->
			doc_school_accept_date = NULL,
			doc_school_sign_date = NULL,
			doc_class_schedule = NULL,
		<!--- changing host family only --->	
		<cfelse> 
			hostid = '#form.available_families#',
			dateplaced = #CreateODBCDateTime(now())#,
			date_pis_received = #CreateODBCDateTime(now())#,
			welcome_family = '#form.welcome_family#',
		</cfif>
		date_host_fam_approved = #CreateODBCDateTime(now())#,
		host_fam_approved = '7',
		doubleplace = '0',
		doc_full_host_app_date = NULL,
		doc_letter_rec_date = NULL,
		doc_rules_rec_date = NULL,
		doc_photos_rec_date = NULL,
		doc_school_profile_rec = NULL,
		doc_conf_host_rec = NULL,
		doc_ref_form_1 = NULL,
		doc_ref_check1 = NULL,
		doc_ref_form_2 = NULL,
		doc_ref_check2 = NULL,
		host_arrival_orientation = NULL
	WHERE studentid = '#get_student_info.studentid#'
	LIMIT 1
</cfquery>
</cftransaction>

<cflocation url="../forms/place_menu.cfm?studentid=#client.studentid#" addtoken="no">	

</cfoutput>