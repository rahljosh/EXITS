<cfif not IsDefined('FORM.schoolid')>
	<table width=680 cellpadding=0 cellspacing=0 border=0 align="center">
		<tr><td>Sorry, an error has ocurred. Please go back try again.</td></tr>
	</table>
	<cfabort>
</cfif>

<!--- Param FORM Variables --->
<cfparam name="FORM.ext_uniform" default="0">
<cfparam name="FORM.ext_esl" default="0">

<cfquery name="update_school" datasource="#application.dsn#">
	UPDATE php_schools
	SET <cfif IsDefined('FORM.active')>active = '#FORM.active#',</cfif>
		schoolname = '#FORM.schoolname#',
		address = '#FORM.address#',
		address2 = '#FORM.address2#',
		city = '#FORM.city#', 
		state = <cfif FORM.state EQ ''>NULL,<cfelse>'#FORM.state#',</cfif> 
		zip = <cfif FORM.zip EQ ''>NULL,<cfelse>'#FORM.zip#',</cfif>
		phone = '#FORM.phone#',
		emergency_contact = '#FORM.emergency_contact#',
		emergency_phone = '#FORM.emergency_phone#',
		fax = '#FORM.fax#',
		payhost = #FORM.payhost#,
		password = '#FORM.password#',
		email = '#FORM.email#',
		cell_phone = '#FORM.cell_phone#',
		supervising_rep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.supervising_rep#" null="#yesNoFormat(trim(FORM.supervising_rep) EQ '')#">,
		fk_ny_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_ny_user#">,
		website = '#FORM.url#', 
		<cfif isDefined('FORM.boarding_school')>
			boarding_school = #FORM.boarding_school#,
		</cfif>
		boarding_notes = '#FORM.boarding_notes#',
		nonref_deposit = <cfif FORM.nonref_deposit EQ ''>NULL<cfelse>'#FORM.nonref_deposit#'</cfif>,
		refund_plan = <cfif NOT IsDefined('FORM.refund_plan')>NULL<cfelse>'#FORM.refund_plan#'</cfif>,
		tuition_notes = '#FORM.tuition_notes#',
		contact = '#FORM.contact#',
		focus_gender = '#FORM.focus_gender#',
		misc_notes = '#FORM.notes#' 
	WHERE schoolid = <cfqueryparam value="#FORM.schoolid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

	<!--- SCHOOL DATES --->
	<cfif FORM.count EQ '0' OR FORM.seasonid NEQ '0'>
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfquery name="insert_dates" datasource="#application.dsn#">
				INSERT INTO php_school_dates
							(schoolid, seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends)
				VALUES ('#FORM.schoolid#', '#FORM.seasonid#',
					<cfif FORM.enrollment EQ ''>NULL<cfelse>#CreateODBCDate(enrollment)#</cfif>,
					<cfif FORM.year_begins EQ ''>NULL<cfelse>#CreateODBCDate(year_begins)#</cfif>,
					<cfif FORM.semester_ends EQ ''>NULL<cfelse>#CreateODBCDate(semester_ends)#</cfif>,
					<cfif FORM.semester_begins EQ ''>NULL<cfelse>#CreateODBCDate(semester_begins)#</cfif>,
					<cfif FORM.year_ends EQ ''>NULL<cfelse>#CreateODBCDate(year_ends)#</cfif>)
			</cfquery>	
		</cftransaction>
	<!--- UPDATE SCHOOL DATES --->	
	<cfelse>
		
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfloop From = "1" To = "#FORM.count#" Index = "x">
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
		SET	nearbigCity = '#FORM.nearbigCity#',
			bigcitydistance = '#FORM.bigcitydistance#',
			<cfif IsDefined('FORM.communitytype')>
				communitytype= '#FORM.communitytype#',
			</cfif>
			pert_info = '#FORM.pert_info#',
			local_air_code = '#FORM.local_air_code#',
			major_air_code = '#FORM.major_air_code#',
			airport_city = '#FORM.airport_city#',
			airport_state = '#FORM.airport_state#'
		WHERE schoolid = '#FORM.schoolid#'
		LIMIT 1
	</cfquery>
</cftransaction>

<!--- EXTERNAL WEB SITE INFORMATION --->
<cfif IsDefined('FORM.show_school')>
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<cfquery name="insert_community_info" datasource="#application.dsn#">
			UPDATE php_schools
			SET	show_school = '#FORM.show_school#',
				ext_school_type = '#FORM.ext_school_type#',
				ext_school_grade_offer = '#FORM.ext_school_grade_offer#',
				ext_major_city = '#FORM.ext_major_city#',
				ext_school_religion = '#FORM.ext_school_religion#',
				ext_school_number_students = '#FORM.ext_school_number_students#',
				ext_school_int_students = '#FORM.ext_school_int_students#',
				ext_ratio = '#FORM.ext_ratio#',
				ext_uniform = '#FORM.ext_uniform#',
				ext_esl = '#FORM.ext_esl#',
				ext_school_about = '#FORM.ext_school_about#',
				ext_school_location = '#FORM.ext_school_location#',
				ext_courses = '#FORM.ext_courses#',
				ext_dress_code = '#FORM.ext_dress_code#',
				ext_housing = '#FORM.ext_housing#',
				ext_athletics = '#FORM.ext_athletics#'
			WHERE schoolid = '#FORM.schoolid#'
			LIMIT 1
		</cfquery>
	</cftransaction>

</cfif>

<cflocation url="../index.cfm?curdoc=forms/view_school&sc=#FORM.schoolid#" addtoken="no">