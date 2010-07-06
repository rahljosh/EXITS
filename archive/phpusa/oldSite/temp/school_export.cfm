<cfquery name=schools datasource="phpfinder">
select *
from school
</cfquery>

<cfloop query= schools>
<cfif sch_sta is ''>
	<cfset get_state_id.id = 0>
<cfelse>
<cfquery name=get_state_id datasource="mysql">
select id 
from states
where state = '#sch_sta#'
</cfquery>
</cfif>
	<cfquery name="update_schools" datasource="mysql">
	insert into schools (principal, name, address, city, state, zip, phone, dateadded, lastupdated, email, fax, website,
	active, boarding_school, airport_city)
	values('#sch_principal#','#sch_name#','#sch_add#','#sch_city#',#get_state_id.id#,'#sch_zip#','#sch_pho#',#now()#,#now()#,'#sch_email#','#sch_fax#','#webpage#',
	<Cfif active is 'yes'>1<cfelse>0</Cfif>,'#sch_boarding#','#stuSch_arrival_airport#')
	 
	</cfquery>
	
</cfloop>
