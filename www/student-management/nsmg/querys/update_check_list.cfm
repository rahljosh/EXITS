<cftransaction action="begin" isolation="SERIALIZABLE">

<cfscript>
	// Get Second Host Family Visit
	qGetSecondVisitReport = APPLICATION.CFC.PROGRESSREPORT.getSecondHostFamilyVisitReport(studentID=url.studentid, hasNYApproved=1);
</cfscript>

<cfquery name="update_check_list" datasource="MySQL">
	UPDATE smg_students
	SET date_pis_received = <cfif form.date_pis_received EQ ''>NULL<cfelse>#CreateODBCDate(form.date_pis_received)#</cfif>,
		doc_full_host_app_date = <cfif form.doc_full_host_app_date EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_full_host_app_date)#</cfif>,
		doc_letter_rec_date = <cfif form.doc_letter_rec_date EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_letter_rec_date)#</cfif>,
		doc_rules_rec_date = <cfif form.doc_rules_rec_date EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_rules_rec_date)#</cfif>,
		doc_photos_rec_date = <cfif form.doc_photos_rec_date EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_photos_rec_date)#</cfif>,
		doc_school_profile_rec = <cfif form.doc_school_profile_rec EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_school_profile_rec)#</cfif>,
		doc_conf_host_rec = <cfif form.doc_conf_host_rec EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_conf_host_rec)#</cfif>,
        doc_date_of_visit = <cfif form.doc_date_of_visit EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_date_of_visit)#</cfif>,
        doc_ref_form_1 = <cfif form.doc_ref_form_1 EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_ref_form_1)#</cfif>,
		doc_ref_check1 = <cfif form.doc_ref_check1 EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_ref_check1)#</cfif>,	
		doc_ref_form_2 = <cfif form.doc_ref_form_2 EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_ref_form_2)#</cfif>,
		doc_ref_check2 = <cfif form.doc_ref_check2 EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_ref_check2)#</cfif>,
		<cfif client.totalfam eq 1 and url.season gt 7>
        doc_single_place_auth = <cfif form.doc_single_place_auth EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_single_place_auth)#</cfif>,
        doc_single_ref_form_1 = <cfif form.doc_single_ref_form_1 EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_single_ref_form_1)#</cfif>,
		doc_single_ref_check1 = <cfif form.doc_single_ref_check1 EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_single_ref_check1)#</cfif>,	
		doc_single_ref_form_2 = <cfif form.doc_single_ref_form_2 EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_single_ref_form_2)#</cfif>,
		doc_single_ref_check2 = <cfif form.doc_single_ref_check2 EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_single_ref_check2)#</cfif>,
        </cfif>
        
        <!--- Second Visit --->
        doc_conf_host_rec2 = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetSecondVisitReport.pr_sr_approved_date#" null="#NOT IsDate(qGetSecondVisitReport.pr_sr_approved_date)#">,
        doc_date_of_visit2 = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetSecondVisitReport.dateOfVisit#" null="#NOT IsDate(qGetSecondVisitReport.dateOfVisit)#">,
        
		doc_school_accept_date = <cfif form.doc_school_accept_date EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_school_accept_date)#</cfif>,
		doc_school_sign_date = <cfif form.doc_school_sign_date EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_school_sign_date)#</cfif>,
		doc_class_schedule = <cfif form.doc_class_schedule EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_class_schedule)#</cfif>,
		doc_income_ver_date =  <cfif form.doc_income_ver_date EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_income_ver_date)#</cfif>,
        
		orig_app_Sent_host = '#form.orig_app_sent_host#',
		copy_app_school = '#form.copy_app_school#',
		copy_app_super = '#form.copy_app_super#',
		
		stu_arrival_orientation = <cfif form.stu_orientation_date EQ ''>NULL<cfelse>#CreateODBCDate(form.stu_orientation_date)#</cfif>,
		host_arrival_orientation = <cfif form.host_orientation_date EQ ''>NULL<cfelse>#CreateODBCDate(form.host_orientation_date)#</cfif>
		
	where studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

<!--- UPDATE CBC FORM RECEIVED INFORMATION IN HOST FAMILY TABLE --->
<cfquery name="update_cbc_host" datasource="MySql">
	UPDATE smg_hosts
	SET fathercbc_form = <cfif form.fathercbc_form NEQ ''>#CreateODBCDate(form.fathercbc_form)#<cfelse>NULL</cfif>,
		mothercbc_form = <cfif form.mothercbc_form NEQ ''>#CreateODBCDate(form.mothercbc_form)#<cfelse>NULL</cfif>
	WHERE hostid = '#form.hostid#'
	LIMIT 1
</cfquery>

<!--- UPDATE CBC FORM RECEIVED INFORMATION IN HOST MEMBERS TABLE --->
<cfloop From = "1" To = "#form.total_members#" Index = "x">
	<cfquery name="update_cbc_host" datasource="MySql">
		UPDATE smg_host_children
		SET cbc_form_received = <cfif form["cbc_form_received" & x] NEQ ''>#CreateODBCDate(form["cbc_form_received" & x])#<cfelse>NULL</cfif>
		WHERE childid = '#form["childid_" & x]#' 
		LIMIT 1
	</cfquery>
</cfloop>
	
</cftransaction>
<cfoutput><meta http-equiv="Refresh" content="0;url=../forms/place_paperwork.cfm?studentid=#url.studentid#&update=yes"></cfoutput>