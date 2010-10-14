<cfquery name="get_student_info" datasource="MySQL">
  SELECT 	s.firstname, s.familylastname, s.sex, s.dob, s.studentid, s.intrep
  FROM smg_students s
  WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="flight_notes" datasource="MySQL">
	UPDATE smg_students
		SET flight_info_notes = "#form.flight_notes#"
	WHERE studentid = '#form.studentid#'
	LIMIT 1
</cfquery> 

<!--- ARRIVAL INFORMATION --->
<!--- NEW FLIGHT ARRIVAL UP TO 4 LEGS --->
<cfif form.ar_update is 'new'> 
	<cfloop From = "1" To = "4" Index = "i">
		<cfif form["ar_dep_date" & i] EQ ''><cfelse>
			<cfquery name="insert_flight" datasource="MySQL">
				INSERT INTO smg_flight_info
				(studentid, companyid, dep_date, dep_city, dep_aircode, arrival_city, arrival_aircode, flight_number, dep_time, arrival_time,
				overnight, flight_type)
				VALUES ('#form.studentid#',
					'#client.companyid#', 
					<cfif form["ar_dep_date" & i] EQ ''>'',<cfelse>#CreateODBCDate(form["ar_dep_date" & i])#,</cfif>
					'#form["ar_dep_city" & i]#',  
					'#form["ar_dep_aircode" & i]#',
					'#form["ar_arrival_city" & i]#',
					'#form["ar_arrival_aircode" & i]#',
					'#form["ar_flight_number" & i]#',
					<cfif form["ar_dep_time" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["ar_dep_time" & i])#,</cfif>
					<cfif form["ar_arrival_time" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["ar_arrival_time" & i])#,</cfif>
					<cfif isdefined('form.ar_overnight#i#')> '1', <cfelse> '0', </cfif>
					'arrival'
					)
			</cfquery>
		</cfif>
	</cfloop>
<!--- UPDATE FLIGHT ARRIVAL INFORMATION --->
<cfelseif form.ar_update is 'update'> 
	<cfloop From = "1" To = "#form.ar_count#" Index = "i">
			<cfquery name="update_arrival" datasource="MySQL">
			UPDATE smg_flight_info
			SET dep_date = <cfif form["ar_dep_date" & i] EQ ''>'',<cfelse>#CreateODBCDate(form["ar_dep_date" & i])#,</cfif>
				dep_city = '#form["ar_dep_city" & i]#',  
				dep_aircode = '#form["ar_dep_aircode" & i]#',
				dep_aircode = '#form["ar_dep_aircode" & i]#',
				arrival_city = '#form["ar_arrival_city" & i]#',
				arrival_aircode = '#form["ar_arrival_aircode" & i]#',
				flight_number = '#form["ar_flight_number" & i]#',
				dep_time = <cfif form["ar_dep_time" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["ar_dep_time" & i])#,</cfif>
				arrival_time = <cfif form["ar_arrival_time" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["ar_arrival_time" & i])#,</cfif>
				overnight = <cfif isdefined('form.ar_overnight#i#')> '1' <cfelse> '0' </cfif>
			WHERE flightid = '#form["ar_flightid" & i]#'
			LIMIT 1
			</cfquery>
	</cfloop>
</cfif> <!--- END OF FLIGHT ARRIVAL --->

<!--- DEPARTURE INFORMATION --->
<!--- NEW FLIGHT DEPARTURE UP TO 4 LEGS --->
<cfif form.dp_update is 'new'>
	<cfloop From = "1" To = "4" Index = "i">
		<cfif form["dp_dep_date" & i] EQ ''><cfelse>
			<cfquery name="insert_flight" datasource="MySQL">
				INSERT INTO smg_flight_info
				(studentid, companyid, dep_date, dep_city, dep_aircode, arrival_city, arrival_aircode, flight_number, dep_time, arrival_time,
				overnight, flight_type)
				VALUES ('#form.studentid#', 
					'#client.companyid#', 
					<cfif form["dp_dep_date" & i] EQ ''>'',<cfelse>#CreateODBCDate(form["dp_dep_date" & i])#,</cfif>
					'#form["dp_dep_city" & i]#',  
					'#form["dp_dep_aircode" & i]#',
					'#form["dp_arrival_city" & i]#',
					'#form["dp_arrival_aircode" & i]#',
					'#form["dp_flight_number" & i]#',
					<cfif form["dp_dep_time" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["dp_dep_time" & i])#,</cfif>
					<cfif form["dp_arrival_time" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["dp_arrival_time" & i])#,</cfif>
					<cfif isdefined('form.dp_overnight#i#')> '1', <cfelse> '0', </cfif>
					'departure'
					)
			</cfquery>
		</cfif>
	</cfloop>
<!--- UPDATE FLIGHT DEPARTURE --->	
<cfelseif form.dp_update is 'update'> 
	<cfloop From = "1" To = "#form.dp_count#" Index = "i">
			<cfquery name="update_arrival" datasource="MySQL">
			UPDATE smg_flight_info
			SET dep_date = <cfif form["dp_dep_date" & i] EQ ''>'',<cfelse>#CreateODBCDate(form["dp_dep_date" & i])#,</cfif>
				dep_city = '#form["dp_dep_city" & i]#',  
				dep_aircode = '#form["dp_dep_aircode" & i]#',
				arrival_city = '#form["dp_arrival_city" & i]#',
				arrival_aircode = '#form["dp_arrival_aircode" & i]#',
				flight_number = '#form["dp_flight_number" & i]#',
				dep_time = <cfif form["dp_dep_time" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["dp_dep_time" & i])#,</cfif>
				arrival_time = <cfif form["dp_arrival_time" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["dp_arrival_time" & i])#,</cfif>
				overnight = <cfif isdefined('form.dp_overnight#i#')> '1' <cfelse> '0' </cfif>
			WHERE flightid = '#form["dp_flightid" & i]#'
			LIMIT 1
			</cfquery>
	</cfloop>
</cfif> <!--- END OF DEPARTURE INFORMATION --->

<cfoutput>

<script language="JavaScript">
<!-- 
alert("You have successfully updated the flight information for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#). Thank You.");
	location.replace("flight_info.cfm?unqid=#form.uniqueid#&assignedID=#FORM.assignedID#");
-->
</script>

</cfoutput>
