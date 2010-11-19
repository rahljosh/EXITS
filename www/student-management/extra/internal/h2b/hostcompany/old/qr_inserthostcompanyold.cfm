<cfif form.business_type eq 00>
	<cfif form.other is ''>
		You have indicated that the Business Type is Other, but did not specify any thing in Other.  Please use your browswers back button to correct that and resubmit.
		<cfabort>
	<cfelse>
		<cfquery name="update_type" datasource="mysql">
		insert into extra_typebusiness (business_type) values ('#form.other#')
		</cfquery>
		<cfquery name="get_new_id" datasource="mysql">
		select business_typeid 
		from extra_typebusiness
		where business_type = '#form.other#'
		</cfquery>
		<cfset form.business_type = #get_new_id.business_typeid#>
	</cfif>
</cfif>

<cfquery name="hostcompany" datasource="MySql">
	INSERT INTO extra_hostcompany(entrydate, name, address, city, state, zip, phone, fax, email, active, supervisor, supervisor_title, description, closest_airport, observations, recruteddirectly, enteredby, companyid, business_typeid) 
	VALUES (#now()#, '#form.name#', '#form.address#', '#form.city#', '#form.state#', '#form.zip#', '#form.phone#', '#form.fax#', '#form.email#', <CFif isdefined('form.active')>1 <cfelse>0 </cfif>, '#form.supervisor#', '#form.supervisor_title#', '#form.description#', '#form.closest_airport#', '#form.observations#', <cfif NOT IsDefined('form.recruteddirectly')> 1 <cfelse> #form.recruteddirectly#</cfif>, #client.userid#, #client.companyid#, #form.business_type#)
	
</cfquery>

<cflocation url="../index.cfm?curdoc=hostcompany/hostcompanies&order=name">
