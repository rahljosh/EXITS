<cfif isdefined('form.update')>   
	
	<cfloop From = "1" To = "#form.count#" Index = "x">
		
		<!--- FORMS --->
		<cfif isdefined('form.name#x#')>
			
			<cftransaction action="BEGIN" isolation="SERIALIZABLE">
			<cfquery name="update_children" datasource="caseusa">
				Update smg_host_children
				set name = '#form["name" & x]#',
					<cfif form["dob" & x] is ''>
					birthdate = null,
					<cfelse>
					birthdate = #CreateODBCDate(form["dob" & x])#,				
					</cfif>	
					sex = '#form["sex" & x]#',
					membertype = '#form["membertype" & x]#',
					liveathome = '#form["athome" & x]#'
				where childid = '#form["childid" & x]#'
			</cfquery>
			</cftransaction>

		</cfif>
	</cfloop>
	
<cfelse><!--- NEW CHILDREN UP TO 5 PER TIME --->

	<cfloop From = "1" To = "5" Index = "x">
		<cfif form["name" & x] is ''><cfelse>
			<cftransaction action="BEGIN" isolation="SERIALIZABLE">
			<cfquery name="insert_kids" datasource="caseusa">
			insert into smg_host_children(name, hostid, membertype,<cfif form["dob" & x] is ''><cfelse>birthdate, </cfif>sex,liveathome)
					values(
					'#form["name" & x]#',
					'#client.hostid#',
					'#form["membertype" & x]#',
					<cfif form["dob" & x] is ''><cfelse>#CreateODBCDate(form["dob" & x])#,</cfif>
					'#form["sex" & x]#',
					'#form["athome" & x]#'
					)
			</cfquery>
			</cftransaction>
		</cfif>
	</cfloop>

</cfif>

<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_3" addtoken="no">