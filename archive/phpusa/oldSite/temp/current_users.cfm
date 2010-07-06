<cfquery name="get_current_reps" datasource="phpfinder">
select * from reps 
</cfquery>
<cfquery name="delete_current" datasource="mysql">
delete from users where userid > 6
</cfquery>
<cfdump var="#get_current_reps#">

<cfloop query="get_current_reps">
	<cfquery name="get_State" datasource="mysql">
	select id
	from states
	where state = '#iserep_state#'
	</cfquery>
	<cfquery name="update__new_php" datasource="mysql">
	insert into users (firstname, lastname, email, address, address2, city, state, zip, phone, fax,
						active, password, oldid, businessname)
				values('#iserep_first_name#', '#iserep_last_name#', '#iserep_email#', '#iserep_add_1#',
				 '#iserep_add_2#', '#iserep_city#', #get_state.id#, '#iserep_zip#', '#iserep_phone#', '#iserep_fax#', #iserep_active#,
				 '#iserep_password#', #iserep_id#, '#ISEREP_BUS_NAME#' )
	</cfquery>
</cfloop>