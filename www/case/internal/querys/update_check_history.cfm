<cftransaction action="begin" isolation="SERIALIZABLE">
<cfquery name="update_check_list" datasource="caseusa">
UPDATE smg_hostdocshistory
	SET date_pis_received = <cfif #form.date_pis_received# EQ ''>NULL<cfelse>#CreateODBCDate(form.date_pis_received)#</cfif>,
		doc_full_host_app_date = <cfif #form.doc_full_host_app_date# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_full_host_app_date)#</cfif>,
		doc_letter_rec_date = <cfif #form.doc_letter_rec_date# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_letter_rec_date)#</cfif>,
		doc_rules_rec_date = <cfif #form.doc_rules_rec_date# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_rules_rec_date)#</cfif>,
		doc_photos_rec_date = <cfif #form.doc_photos_rec_date# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_photos_rec_date)#</cfif>,
		
		doc_school_accept_date = <cfif #form.doc_school_accept_date# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_school_accept_date)#</cfif>,
		doc_school_sign_date = <cfif #form.doc_school_sign_date# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_school_sign_date)#</cfif>,
		
		doc_school_profile_rec = <cfif #form.doc_school_profile_rec# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_school_profile_rec)#</cfif>,
		
		doc_conf_host_rec = <cfif #form.doc_conf_host_rec# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_conf_host_rec)#</cfif>,
		doc_date_of_visit = <cfif #form.doc_date_of_visit# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_date_of_visit)#</cfif>,
		
		doc_ref_form_1 = <cfif #form.doc_ref_form_1# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_ref_form_1)#</cfif>,
		doc_ref_check1 = <cfif #form.doc_ref_check1# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_ref_check1)#</cfif>,
		doc_ref_form_2 = <cfif #form.doc_ref_form_2# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_ref_form_2)#</cfif>,
		doc_ref_check2 = <cfif #form.doc_ref_check2# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_ref_check2)#</cfif>,
		
		doc_host_orientation = <cfif #form.doc_host_orientation# EQ ''>NULL<cfelse>#CreateODBCDate(form.doc_host_orientation)#</cfif>
	WHERE historyid = #form.historyid#
	LIMIT 1
</cfquery>
</cftransaction>

<cflocation url="../forms/place_paperwork_log.cfm?historyid=#form.historyid#&upd=yes" addtoken="no">