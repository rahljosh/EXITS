<cfquery name="get_students" datasource="caseusa">
  SELECT 	s.firstname, s.familylastname, s.sex, s.dob, s.studentid,
			u.insurance_typeid,
			p.insurance_enddate, 
			c.countrycode,
			co.orgcode,
			insu_codes.policycode
  FROM 	smg_students s
  INNER JOIN smg_users u 		ON u.userid = s.intrep  
  INNER JOIN smg_programs p 	ON s.programid = p.programid
  INNER JOIN smg_countrylist c 	ON s.countryresident = c.countryid
  INNER JOIN smg_companies co 	ON s.companyid = co.companyid	
  LEFT JOIN smg_insurance_codes insu_codes ON (u.insurance_typeid = insu_codes.insutypeid AND s.companyid = insu_codes.companyid)
  WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<cfquery name="flight_notes" datasource="caseusa">
	UPDATE smg_students
		SET flight_info_notes = "#form.flight_notes#"
	WHERE studentid = #client.studentid#
	LIMIT 1
</cfquery> 

<!--- ARRIVAL INFORMATION --->
<!--- NEW FLIGHT ARRIVAL UP TO 4 LEGS --->
<cfif form.ar_update is 'new'> 
	<cfloop From = "1" To = "4" Index = "i">
		<cfif form["ar_dep_date" & i] EQ ''><cfelse>
			<cfquery name="insert_flight" datasource="caseusa">
				INSERT INTO smg_flight_info
				(studentid, dep_date, dep_city, dep_aircode, arrival_city, arrival_aircode, flight_number, dep_time, arrival_time,
				overnight, flight_type)
				VALUES ('#client.studentid#', 
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
			<cfquery name="update_arrival" datasource="caseusa">
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
			<cfquery name="insert_flight" datasource="caseusa">
				INSERT INTO smg_flight_info
				(studentid, dep_date, dep_city, dep_aircode, arrival_city, arrival_aircode, flight_number, dep_time, arrival_time,
				overnight, flight_type)
				VALUES ('#client.studentid#', 
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
			<cfquery name="update_arrival" datasource="caseusa">
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

<!--- D E P A R T U R E      I N F O R M A T I O N    |    T E R M I N A T I O N    D A T E --->
<cfif get_students.insurance_typeid GT '1'> 
	<cfquery name="update_arrival" datasource="caseusa">
		UPDATE smg_students
		SET termination_date = <cfif form.termination_date EQ ''>NULL<cfelse>#CreateODBCDate(termination_date)#</cfif>
		WHERE studentid = '#get_students.studentid#'
		LIMIT 1
	</cfquery>
</cfif>

</cftransaction>
<cflocation url="../forms/flight_info.cfm"> 