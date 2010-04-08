<cfif isdefined('form.update')>
	<cfloop From = "1" To = "#form.count#" Index = "x">
		<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<cfquery name="update_siblings" datasource="caseusa">
		Update smg_student_siblings
			set name = '#form["name" & x]#',
				<cfif form["dob" & x] is ''>
				
				<cfelse>
				birthdate = #CreateODBCDate(form["dob" & x])#,				
				</cfif>	
				sex = '#form["sex" & x]#',
				liveathome = '#form["athome" & x]#'
			where childid = '#form["childid" & x]#'
		</cfquery>
		</cftransaction>
	</cfloop>
	
<cfelse>

	<!--- NEW SIBLINGS UP TO 5 PER TIME --->
	<cfloop From = "1" To = "5" Index = "x">
		<cfif form["name" & x] is ''><cfelse>
			<cftransaction action="BEGIN" isolation="SERIALIZABLE">
			<cfquery name="insert_kids" datasource="caseusa">
			insert into smg_student_siblings(name, studentid, <cfif form["dob" & x] is ''><cfelse>birthdate, </cfif>sex, liveathome)
					values(
					'#form["name" & x]#',
					'#client.studentid#',
					<cfif form["dob" & x] is ''><cfelse>#CreateODBCDate(form["dob" & x])#,</cfif>
					'#form["sex" & x]#',
					'#form["athome" & x]#'
					)
			</cfquery>
			</cftransaction>
		</cfif>
	</cfloop>

</cfif>

<cflocation url="../index.cfm?curdoc=forms/student_app_4" addtoken="no">