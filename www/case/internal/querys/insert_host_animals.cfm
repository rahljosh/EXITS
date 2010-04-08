<CFIF not isdefined("form.share_room")>
	<CFSET form.share_room = "no">
</cfif>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<!----share room---->
<cfif #form.share_room# is "yes">
<cfquery name="insert_room_share" datasource="caseusa">
update smg_host_children
 set shared = "yes"
 where childid = #form.kid_share#
</cfquery>
</cfif>
<!----Smoking & Allergy Preferences---->
<cfquery name="smoking_pref" datasource="caseusa">
update smg_hosts
	set hostsmokes = '#form.smoke#',
		acceptsmoking = '#form.stu_smoke#',
		smokeconditions = '#form.smoke_conditions#',
		pet_allergies = '#form.allergic#'
	where hostid = #client.hostid#
</cfquery>


<!----Add animals to db---->
<cfif isDefined('form.pets_exist')>
	<cfif isdefined('form.animal1')>
	<cfquery name="update_pets" datasource="caseusa">
	Update smg_host_animals
		set animaltype = "#form.animaltype1#",
			indoor = "#form.indoor1#",
			number = "#form.number_pets1#"
		where animalid = #form.animal1#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal2')>
	<cfquery name="update_pets" datasource="caseusa">
	Update smg_host_animals
		set animaltype = "#form.animaltype2#",
			indoor = "#form.indoor2#",
			number = "#form.number_pets2#"
		where animalid = #form.animal2#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal3')>
	<cfquery name="update_pets" datasource="caseusa">
	Update smg_host_animals
		set animaltype = "#form.animaltype3#",
			indoor = "#form.indoor3#",
			number = "#form.number_pets3#"
		where animalid = #form.animal3#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal4')>
	<cfquery name="update_pets" datasource="caseusa">
	Update smg_host_animals
		set animaltype = "#form.animaltype4#",
			indoor = "#form.indoor4#",
			number = "#form.number_pets4#"
		where animalid = #form.animal4#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal5')>
	<cfquery name="update_pets" datasource="caseusa">
	Update smg_host_animals
		set animaltype = "#form.animaltype5#",
			indoor = "#form.indoor5#",
			number = "#form.number_pets5#"
		where animalid = #form.animal5#
	</cfquery>
	<cfelse>
	</cfif>
<cfelse>
	<cfif #form.animal1# is not ''>
	<cfquery name="add_animal" datasource="caseusa">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal1#", #form.number_pets#, "#form.indoor#")
	</cfquery>
	</cfif>
	<cfif #form.animal2# is not ''>
	<cfquery name="add_animal" datasource="caseusa">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal2#", #form.number_pets2#, "#form.indoor2#")
	</cfquery>
	</cfif>
	<cfif #form.animal3# is not ''>
	<cfquery name="add_animal3" datasource="caseusa">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal3#", #form.number_pets3#, "#form.indoor3#")
	</cfquery>
	</cfif><br>
	<cfif #form.animal4# is not ''>
	<cfquery name="add_animal4" datasource="caseusa">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal4#", #form.number_pets4#, "#form.indoor4#")
	</cfquery>
	</cfif>
	<cfif #form.animal5# is not ''>
	<cfquery name="add_animal5" datasource="caseusa">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal5#", #form.number_pets5#, "#form.indoor5#")
	</cfquery>
	</cfif>
</cfif>
</cftransaction>

<cflocation url="../index.cfm?curdoc=forms/family_app_5" addtoken="no">