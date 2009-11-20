<CFIF not isdefined("form.school")>
	<CFSET form.school = "0">
</cfif>

<cfif form.schoolname is '' and form.address is '' and form.city is ''> <!--- IF THERE'S NO INFORMATION, NOTHING IS INSERTED --->
	<cflocation url="?curdoc=forms/host_fam_pis_6" addtoken="no">

<cfelse>
	<!--- ADD NEW SCHOOL --->
	<cfif form.school EQ 0>  
		<cfquery name="check_new_school" datasource="mysql">
			SELECT schoolid, schoolname
			FROM php_schools 
			WHERE schoolname = '#form.schoolname#' 
				AND	city = '#form.city#'
				AND state = '#form.state#'
		</cfquery>
		
		<cfif check_new_school.recordcount NEQ 0><br>
			<table width="540" align="center">
			<tr><td align="center"><h3>Sorry, but this school has been entered in the database as follow:</h3></td></tr>
			<tr><td align="center"><cfoutput query="check_new_school">
				<a href="?curdoc=forms/view_school&sc=#schoolid#">School: &nbsp; #name# (ID: #schoolid#) - #city#/#state#</cfoutput></a><br><br></td></tr>
			<tr><td align="center"><input type="image" value="back" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
			</table>
			<cfabort> 
		</cfif>
			
		<cftransaction action="begin" isolation="SERIALIZABLE">
			<cfquery name="insert_school" datasource="mysql">
				INSERT INTO php_schools
					(schoolname,address,address2,city,state,zip,phone,fax,email,website,contact)								
				VALUES ("#form.schoolname#", "#form.address#", "#form.address2#", "#form.city#", "#form.state#", "#form.zip#", "#form.phone#",
						"#form.fax#", "#form.email#", "#form.website#", "#form.contact#")
			</cfquery>
		
			<cfquery name="schoolid" datasource="mysql"> <!--- get the newest school --->
				SELECT MAX(schoolid) as newschoolid
				FROM php_schools
			</cfquery>
		</cftransaction>
		<cfset client.schoolid = #schoolid.newschoolid#>

	<!--- UPDATE SCHOOL INFORMATION --->	
	<cfelse>  
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfquery name="update_school" datasource="mysql">
				UPDATE php_schools
				SET 	schoolname = '#form.schoolname#',
						address = '#form.address#',
						address2 = '#form.address2#',
						city = '#form.city#',
						state = '#form.state#',
						zip = '#form.zip#',
						phone = '#form.phone#',
						fax = '#form.fax#',
						email = '#form.email#',
						website = '#form.website#',
						contact = '#form.contact#'
				WHERE schoolid = '#form.school#'
				LIMIT 1					
			</cfquery>
		</cftransaction>
		<cfset client.schoolid = #form.school#>
	</cfif>
	
	<!--- SCHOOL DATES --->
	<cfif form.count EQ '0' OR form.seasonid NEQ '0'>
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfquery name="insert_dates" datasource="mysql">
				INSERT INTO php_school_dates
							(schoolid, seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends)
				VALUES ('#client.schoolid#', '#form.seasonid#',
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
				<cfquery name="update_school" datasource="mysql">
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

	<cfquery name="add_School" datasource="mysql">
		update smg_hosts
		set schoolid = '#client.schoolid#'
		where hostid = '#client.hostid#'
		LIMIT 1 
	</cfquery>		
	
</cfif>

<cflocation url="index.cfm?curdoc=forms/host_fam_pis_6" addtoken="no">