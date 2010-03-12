<cfquery name="insert_school" datasource="mysql">
	INSERT INTO php_schools 
		(active, schoolname, address, address2, city, state, zip, dateadded, email, phone, fax, website, 
		 nonref_deposit, refund_plan, tuition_notes, contact, contact_title, focus_gender, misc_notes, fk_ny_user)
	VALUES  ('1', '#form.schoolname#', '#form.address#', '#form.address2#', '#form.city#', 
		<cfif form.state EQ ''>0,<cfelse>'#form.state#',</cfif> 
		<cfif form.zip EQ ''>NULL,<cfelse>'#form.zip#',</cfif>
		#CreateODBCDate(now())#, '#form.email#', '#form.phone#', '#form.fax#', '#form.url#', 
		<cfif form.nonref_deposit EQ ''>NULL<cfelse>'#form.nonref_deposit#'</cfif>,
		<cfif NOT IsDefined('form.refund_plan')>NULL<cfelse>'#form.refund_plan#'</cfif>,
		'#form.tuition_notes#',
		'#form.contact#', '#form.contact_title#', '#form.focus_gender#', '#form.notes#',
        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
        )
</cfquery>

<cflocation url="../index.cfm?curdoc=lists/schools" addtoken="no">

