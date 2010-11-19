<CFIF not isdefined("form.share_room")>
	<CFSET form.share_room = "no">
</cfif>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<!----share room---->
<cfif isDefined('form.stulist')>
	<Cfloop list = #form.stulist# index='x'>
		<cfif #Evaluate("FORM." & x & "_share_room")# is 'yes'>
			<Cfif #Evaluate("FORM." & x & "_kid_share")# eq 00>
				<cfquery name="get_double_place_id" datasource="mysql">
				select doubleplace from smg_students
				where studentid = #x#
				</cfquery>
					<cfquery name=insert_dbl_room_share datasource="mysql">
						update smg_students
							set double_place_share = #get_double_place_id.doubleplace#
						where studentid = #x#
					</cfquery>
			<Cfelse>
				<cfquery name="insert_room_share" datasource="MySQL">
				update smg_host_children
				 set shared = "yes",
					 roomsharewith = #Evaluate("FORM." & x & "_studentidsharing")#
				 where childid = #Evaluate("FORM." & x & "_kid_share")#
				</cfquery>
			
			</cfif>			

			<cfelseif #Evaluate("FORM." & x & "_share_room")# is 'no'>
				<cfquery name="insert_room_share" datasource="MySQL">
				update smg_host_children
				 set shared = "no",
				 roomsharewith = 0
				 where roomsharewith = #x#
				</cfquery>
				
				<cfquery name=insert_dbl_room_share datasource="mysql">
						update smg_students
							set double_place_share = 0
						where studentid = #x#
					</cfquery>
			</cfif>
	
	</Cfloop>
<cfelse>
			<Cfif #form.share_room# is 'yes'>
				<cfquery name="insert_room_share" datasource="MySQL">
				update smg_host_children
				 set shared = "yes",
					 roomsharewith = 0
				 where childid = #form.kid_share#
				</cfquery>
			</Cfif>

			<cfif #form.share_room# is 'no'>
				<cfquery name="insert_room_share" datasource="MySQL">
				update smg_host_children
				 set shared = "no",
				 roomsharewith = 0
				 where hostid = #client.hostid#
				</cfquery>
			</cfif>
</cfif>
<!----Smoking & Allergy Preferences---->
<cfquery name="smoking_pref" datasource="MySQL">
update smg_hosts
	set acceptsmoking = '#form.stu_smoke#',
		smokeconditions = '#form.smoke_conditions#'
	where hostid = #client.hostid#
</cfquery>


<!----Add animals to db---->
<cfif isDefined('form.pets_exist')>
	<cfif isdefined('form.animal1')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype1#",
			indoor = "#form.indoor1#",
			number = "#form.number_pets1#"
		where animalid = #form.animal1#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal2')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype2#",
			indoor = "#form.indoor2#",
			number = "#form.number_pets2#"
		where animalid = #form.animal2#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal3')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype3#",
			indoor = "#form.indoor3#",
			number = "#form.number_pets3#"
		where animalid = #form.animal3#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal4')>
	<cfquery name="update_pets" datasource="MySQL">
	Update smg_host_animals
		set animaltype = "#form.animaltype4#",
			indoor = "#form.indoor4#",
			number = "#form.number_pets4#"
		where animalid = #form.animal4#
	</cfquery>
	<cfelse>
	</cfif>
	<cfif isdefined('form.animal5')>
	<cfquery name="update_pets" datasource="MySQL">
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
	<cfquery name="add_animal" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal1#", #form.number_pets1#, "#form.indoor1#")
	</cfquery>
	</cfif>
	<cfif #form.animal2# is not ''>
	<cfquery name="add_animal" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal2#", #form.number_pets2#, "#form.indoor2#")
	</cfquery>
	</cfif>
	<cfif #form.animal3# is not ''>
	<cfquery name="add_animal3" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal3#", #form.number_pets3#, "#form.indoor3#")
	</cfquery>
	</cfif><br>
	<cfif #form.animal4# is not ''>
	<cfquery name="add_animal4" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal4#", #form.number_pets4#, "#form.indoor4#")
	</cfquery>
	</cfif>
	<cfif #form.animal5# is not ''>
	<cfquery name="add_animal5" datasource="MySQL">
	insert into smg_host_animals (hostid, animaltype, number, indoor)
				values(#client.hostid#, "#form.animal5#", #form.number_pets5#, "#form.indoor5#")
	</cfquery>
	</cfif>
</cfif>

<Cfquery name="church_info" datasource="MySQL">
Update smg_hosts
	set attendchurch = '#form.attend_church#',
		religious_participation = '#form.religious_participation#',
		churchfam = '#form.churchfam#',
		churchtrans = '#form.churchtrans#'
	where hostid = #client.hostid#
</cfquery>
</cftransaction>

<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_4" addtoken="no">
