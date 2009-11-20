<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<cfif isdefined('form.update')>   
	
	<cfloop From = "1" To = "#form.count#" Index = "x">
		<!--- FORMS --->
		<cfif isdefined('form.name#x#')>
			<cfquery name="update_children" datasource="mysql">
				UPDATE smg_host_children
				SET name = '#form["name" & x]#',
					birthdate = <cfif form["dob" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["dob" & x])#</cfif>,
					sex =  <cfif IsDefined('form.sex'&x)>'#form["sex" & x]#'<cfelse>''</cfif>,
					membertype = '#form["membertype" & x]#',
					liveathome = <cfif IsDefined('form.athome'&x)>'#form["athome" & x]#'<cfelse>''</cfif>
				WHERE childid = '#form["childid" & x]#'
			</cfquery>
		</cfif>
	</cfloop>
	
<cfelse><!--- NEW CHILDREN UP TO 5 PER TIME --->
	<cfloop From = "1" To = "5" Index = "x">
		<cfif form["name" & x] NEQ ''>
			<cfquery name="insert_kids" datasource="mysql">
				INSERT INTO smg_host_children(name, hostid, membertype, birthdate, sex, liveathome)
				VALUES('#form["name" & x]#',
					'#form.hostid#',
					'#form["membertype" & x]#',
					<cfif form["dob" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["dob" & x])#</cfif>,
					<cfif IsDefined('form.sex'&x)>'#form["sex" & x]#'<cfelse>''</cfif>,
					<cfif IsDefined('form.athome'&x)>'#form["athome" & x]#'<cfelse>''</cfif>)
			</cfquery>
		</cfif>
	</cfloop>

</cfif>

</cftransaction>

<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_3" addtoken="no">