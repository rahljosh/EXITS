<cfif not IsDefined('form.schoolid')>
	<table width=680 cellpadding=0 cellspacing=0 border=0 align="center">
		<tr><td>Sorry, an error has ocurred. Please go back try again.</td></tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="update_school" datasource="#application.dsn#">
	UPDATE php_schools
	SET <cfif IsDefined('form.active')>active = '#form.active#',</cfif>
		schoolname = '#form.schoolname#',
		address = '#form.address#',
		address2 = '#form.address2#',
		city = '#form.city#', 
		state = <cfif form.state EQ ''>NULL,<cfelse>'#form.state#',</cfif> 
		zip = <cfif form.zip EQ ''>NULL,<cfelse>'#form.zip#',</cfif>
		phone = '#form.phone#',
		emergency_contact = '#form.emergency_contact#',
		emergency_phone = '#form.emergency_phone#',
		fax = '#form.fax#',
		payhost = #form.payhost#,
		password = '#form.password#',
		email = '#form.email#',
		cell_phone = '#form.cell_phone#',
		supervising_rep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.supervising_rep#" null="#yesNoFormat(trim(form.supervising_rep) EQ '')#">,
		fk_ny_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ny_user#">,
		website = '#form.url#', 
		<cfif isDefined('form.boarding_school')>
			boarding_school = #form.boarding_school#,
		</cfif>
		boarding_notes = '#form.boarding_notes#',
		nonref_deposit = <cfif form.nonref_deposit EQ ''>NULL<cfelse>'#form.nonref_deposit#'</cfif>,
		refund_plan = <cfif NOT IsDefined('form.refund_plan')>NULL<cfelse>'#form.refund_plan#'</cfif>,
		tuition_notes = '#form.tuition_notes#',
		contact = '#form.contact#',
		focus_gender = '#form.focus_gender#',
		misc_notes = '#form.notes#' 
	WHERE schoolid = <cfqueryparam value="#form.schoolid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

	<!--- SCHOOL DATES --->
	<cfif form.count EQ '0' OR form.seasonid NEQ '0'>
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfquery name="insert_dates" datasource="#application.dsn#">
				INSERT INTO php_school_dates
							(schoolid, seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends)
				VALUES ('#form.schoolid#', '#form.seasonid#',
					<cfif form.enrollment EQ ''>NULL<cfelse>#CreateODBCDate(enrollment)#</cfif>,
					<cfif form.year_begins EQ ''>NULL<cfelse>#CreateODBCDate(year_begins)#</cfif>,
					<cfif form.semester_ends EQ ''>NULL<cfelse>#CreateODBCDate(semester_ends)#</cfif>,
					<cfif form.semester_begins EQ ''>NULL<cfelse>#CreateODBCDate(semester_begins)#</cfif>,
					<cfif form.year_ends EQ ''>NULL<cfelse>#CreateODBCDate(year_ends)#</cfif>)
			</cfquery>	
		</cftransaction>
	<!--- UPDATE SCHOOL DATES --->	
	<cfelse>
		
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfloop From = "1" To = "#form.count#" Index = "x">
				<cfquery name="update_school" datasource="#application.dsn#">
					UPDATE php_school_dates 
					SET 	enrollment = <cfif form["enrollment" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["enrollment" & x])#</cfif>,
							year_begins = <cfif form["year_begins" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["year_begins" & x])#</cfif>,
							semester_ends = <cfif form["semester_ends" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["semester_ends" & x])#</cfif>,
							semester_begins = <cfif form["semester_begins" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["semester_begins" & x])#</cfif>,
							year_ends = <cfif form["year_ends" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["year_ends" & x])#</cfif>
					WHERE schooldateid = '#form["schooldateid" & x]#'
					LIMIT 1	
				</cfquery>  
			</cfloop>
		</cftransaction>
		
	</cfif>
	
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	<cfquery name="insert_community_info" datasource="#application.dsn#">
		UPDATE php_schools
		SET	nearbigCity = '#form.nearbigCity#',
			bigcitydistance = '#form.bigcitydistance#',
			<cfif IsDefined('form.communitytype')>
				communitytype= '#form.communitytype#',
			</cfif>
			pert_info = '#form.pert_info#',
			local_air_code = '#form.local_air_code#',
			major_air_code = '#form.major_air_code#',
			airport_city = '#form.airport_city#',
			airport_state = '#form.airport_state#'
		WHERE schoolid = '#form.schoolid#'
		LIMIT 1
	</cfquery>
</cftransaction>

<!--- EXTERNAL WEB SITE INFORMATION --->
<cfif IsDefined('form.show_school')>
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<cfquery name="insert_community_info" datasource="#application.dsn#">
			UPDATE php_schools
			SET	show_school = '#form.show_school#',
				ext_school_type = '#form.ext_school_type#',
				ext_school_grade_offer = '#form.ext_school_grade_offer#',
				ext_major_city = '#form.ext_major_city#',
				ext_school_religion = '#form.ext_school_religion#',
				ext_school_number_students = '#form.ext_school_number_students#',
				ext_school_int_students = '#form.ext_school_int_students#',
				ext_ratio = '#form.ext_ratio#',
				<cfif IsDefined('form.ext_uniform')>ext_esl = '#form.ext_uniform#',</cfif>
				<cfif IsDefined('form.ext_esl')>ext_esl = '#form.ext_esl#',</cfif>
				ext_school_about = '#form.ext_school_about#',
				ext_school_location = '#form.ext_school_location#',
				ext_courses = '#form.ext_courses#',
				ext_dress_code = '#form.ext_dress_code#',
				ext_housing = '#form.ext_housing#',
				ext_athletics = '#form.ext_athletics#'
			WHERE schoolid = '#form.schoolid#'
			LIMIT 1
		</cfquery>
	</cftransaction>

</cfif>

<cflocation url="../index.cfm?curdoc=forms/view_school&sc=#form.schoolid#" addtoken="no">