<!----
<cfquery name="get_students" datasource="MySQL">
  SELECT 	s.firstname, s.familylastname, s.sex, s.dob, s.candidateid,
			u.insurance_typeid,
			p.insurance_enddate, 
			c.countrycode,
			co.orgcode,
			insu_codes.policycode
  FROM 	extra_candidates s
  INNER JOIN smg_users u 		ON u.userid = s.intrep  
  INNER JOIN smg_programs p 	ON s.programid = p.programid
  INNER JOIN smg_countrylist c 	ON s.countryresident = c.countryid
  INNER JOIN smg_companies co 	ON s.companyid = co.companyid	

  WHERE candidateid = <cfqueryparam value="#url.candidate#" cfsqltype="cf_sql_integer">
</cfquery>
---->
<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<cfquery name="flight_notes" datasource="MySQL">
	UPDATE extra_candidates
		SET flight_info_notes = "#form.flight_notes#"
	WHERE candidateid = #url.candidateid#
	LIMIT 1
</cfquery> 

<!--- ARRIVAL INFORMATION --->
<!--- NEW FLIGHT ARRIVAL UP TO 4 LEGS --->
<cfif form.ar_update is 'new'> 
	<cfloop From = "1" To = "4" Index = "i">
		<cfif form["ar_departDate" & i] EQ ''><cfelse>
			<cfquery name="insert_flight" datasource="MySQL">
				INSERT INTO extra_flight_information
				(candidateid, departDate, departCity, departAirportCode, arriveCity, arriveAirportCode, flightNumber, departTime, arriveTime,
				isOvernightFlight, flightType)
				VALUES ('#url.candidateid#', 
					<cfif form["ar_departDate" & i] EQ ''>'',<cfelse>#CreateODBCDate(form["ar_departDate" & i])#,</cfif>
					'#form["ar_departCity" & i]#',  
					'#form["ar_departAirportCode" & i]#',
					'#form["ar_arriveCity" & i]#',
					'#form["ar_arriveAirportCode" & i]#',
					'#form["ar_flightNumber" & i]#',
					<cfif form["ar_departTime" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["ar_departTime" & i])#,</cfif>
					<cfif form["ar_arriveTime" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["ar_arriveTime" & i])#,</cfif>
					<cfif isdefined('form.ar_isOvernightFlight#i#')> '1', <cfelse> '0', </cfif>
					'arrival'
					)
			</cfquery>
		</cfif>
	</cfloop>
<!--- UPDATE FLIGHT ARRIVAL INFORMATION --->
<cfelseif form.ar_update is 'update'> 
	<cfloop From = "1" To = "#form.ar_count#" Index = "i">
			<cfquery name="update_arrival" datasource="MySQL">
			UPDATE extra_flight_information
			SET departDate = <cfif form["ar_departDate" & i] EQ ''>'',<cfelse>#CreateODBCDate(form["ar_departDate" & i])#,</cfif>
				departCity = '#form["ar_departCity" & i]#',  
				departAirportCode = '#form["ar_departAirportCode" & i]#',
				departAirportCode = '#form["ar_departAirportCode" & i]#',
				arriveCity = '#form["ar_arriveCity" & i]#',
				arriveAirportCode = '#form["ar_arriveAirportCode" & i]#',
				flightNumber = '#form["ar_flightNumber" & i]#',
				departTime = <cfif form["ar_departTime" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["ar_departTime" & i])#,</cfif>
				arriveTime = <cfif form["ar_arriveTime" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["ar_arriveTime" & i])#,</cfif>
				isOvernightFlight = <cfif isdefined('form.ar_isOvernightFlight#i#')> '1' <cfelse> '0' </cfif>
			WHERE ID = '#form["ar_ID" & i]#'
			LIMIT 1
			</cfquery>
	</cfloop>
</cfif> <!--- END OF FLIGHT ARRIVAL --->

<!--- DEPARTURE INFORMATION --->
<!--- NEW FLIGHT DEPARTURE UP TO 4 LEGS --->
<cfif form.dp_update is 'new'>
	<cfloop From = "1" To = "4" Index = "i">
		<cfif form["dp_departDate" & i] EQ ''><cfelse>
			<cfquery name="insert_flight" datasource="MySQL">
				INSERT INTO extra_flight_information
				(candidateid, departDate, departCity, departAirportCode, arriveCity, arriveAirportCode, flightNumber, departTime, arriveTime,
				isOvernightFlight, flightType)
				VALUES ('#url.candidateid#', 
					<cfif form["dp_departDate" & i] EQ ''>'',<cfelse>#CreateODBCDate(form["dp_departDate" & i])#,</cfif>
					'#form["dp_departCity" & i]#',  
					'#form["dp_departAirportCode" & i]#',
					'#form["dp_arriveCity" & i]#',
					'#form["dp_arriveAirportCode" & i]#',
					'#form["dp_flightNumber" & i]#',
					<cfif form["dp_departTime" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["dp_departTime" & i])#,</cfif>
					<cfif form["dp_arriveTime" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["dp_arriveTime" & i])#,</cfif>
					<cfif isdefined('form.dp_isOvernightFlight#i#')> '1', <cfelse> '0', </cfif>
					'departure'
					)
			</cfquery>
		</cfif>
	</cfloop>
<!--- UPDATE FLIGHT DEPARTURE --->	
<cfelseif form.dp_update is 'update'> 
	<cfloop From = "1" To = "#form.dp_count#" Index = "i">
			<cfquery name="update_arrival" datasource="MySQL">
			UPDATE extra_flight_information
			SET departDate = <cfif form["dp_departDate" & i] EQ ''>'',<cfelse>#CreateODBCDate(form["dp_departDate" & i])#,</cfif>
				departCity = '#form["dp_departCity" & i]#',  
				departAirportCode = '#form["dp_departAirportCode" & i]#',
				arriveCity = '#form["dp_arriveCity" & i]#',
				arriveAirportCode = '#form["dp_arriveAirportCode" & i]#',
				flightNumber = '#form["dp_flightNumber" & i]#',
				departTime = <cfif form["dp_departTime" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["dp_departTime" & i])#,</cfif>
				arriveTime = <cfif form["dp_arriveTime" & i] EQ ''>NULL,<cfelse>#CreateODBCTime(form["dp_arriveTime" & i])#,</cfif>
				isOvernightFlight = <cfif isdefined('form.dp_isOvernightFlight#i#')> '1' <cfelse> '0' </cfif>
			WHERE ID = '#form["dp_ID" & i]#'
			LIMIT 1
			</cfquery>
	</cfloop>
</cfif> <!--- END OF DEPARTURE INFORMATION --->

<!--- D E P A R T U R E      I N F O R M A T I O N    |    T E R M I N A T I O N    D A T E --->
<!----
<cfif get_students.insurance_typeid GT '1'> 
	<cfquery name="update_arrival" datasource="MySQL">
		UPDATE extra_candidates
		SET termination_date = <cfif form.termination_date EQ ''>NULL<cfelse>#CreateODBCDate(termination_date)#</cfif>
		WHERE candidateid = '#get_students.candidateid#'
		LIMIT 1
	</cfquery>
</cfif>
---->
</cftransaction>
<cflocation url="../flight_info/flight_info.cfm?candidateid=#url.candidateid#"> 

<!---- INSURANCE DELETED FROM FLIGHT INFORMATION 

<!--- CAREMED - INSURANCE INFORMATION --->
<cfif get_students.insurance_typeid GT '1'> 
	<!--- NEW ARRIVAL INFORMATION --->
	<cfif form.insu_new_date NEQ '' AND not IsDefined('form.insuranceid')> 
		<cfquery name="check_insu" datasource="MySql">
			SELECT candidateid
			FROM smg_insurance WHERE sent_to_caremed is NULL AND candidateid = '#url.candidateid#' AND (transtype = 'new' OR transtype = 'correction')
		</cfquery>
		<cfif check_insu.recordcount is '0'>
			<cfquery name="insert_new_correction" datasource="MySql">
				INSERT INTO smg_insurance
					(candidateid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
				VALUES
					('#url.candidateid#', '#get_students.firstname#', '#get_students.familylastname#', '#get_students.sex#', 
					#CreateODBCDate(get_students.dob)#, '#get_students.countrycode#', #CreateODBCDate(form.insu_new_date)#,
					 #CreateODBCDate(get_students.insurance_enddate)#, '#get_students.orgcode#', '#get_students.policycode#', 'correction');	
			</cfquery>
		</cfif>
	</cfif>
	<!--- UPDATE ARRIVAL --->
	<cfif form.insu_new_date NEQ '' and IsDefined('form.insuranceid')> 
		<cfquery name="update_correction" datasource="MySql">
			UPDATE smg_insurance
			set new_date = #CreateODBCDate(form.insu_new_date)#
			WHERE insuranceid = '#form.insuranceid#'
			LIMIT 1
		</cfquery>
	</cfif>
	
	<!--- NEW DEPARTURE INFORMATION --->
	<cfif form.insu_dp_trans_type NEQ '0' AND form.insu_dp_new_date NEQ '' AND form.insu_dp_end_date NEQ '' AND not IsDefined('form.dp_insuranceid')> 
		<cfquery name="check_insu" datasource="MySql">
			SELECT candidateid
			FROM smg_insurance WHERE sent_to_caremed is NULL AND candidateid = '#url.candidateid#' AND (transtype = 'extension' OR transtype = 'early return')
		</cfquery>
		<cfif check_insu.recordcount is '0'>
			<cfquery name="insert_new" datasource="MySql">
				INSERT INTO smg_insurance
					(candidateid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
				VALUES
					('#url.candidateid#', '#get_students.firstname#', '#get_students.familylastname#', '#get_students.sex#', 
					#CreateODBCDate(get_students.dob)#, '#get_students.countrycode#', #CreateODBCDate(form.insu_dp_new_date)#,
					 #CreateODBCDate(form.insu_dp_end_date)#, '#get_students.orgcode#', '#get_students.policycode#', '#form.insu_dp_trans_type#');	
			</cfquery>
		</cfif>
	</cfif>
	<!--- UPDATE DEPARTURE --->
	<cfif form.insu_dp_new_date NEQ '' and IsDefined('form.dp_insuranceid')> 
		<cfquery name="update_caremed" datasource="MySql">
			UPDATE smg_insurance
			SET new_date = #CreateODBCDate(form.insu_dp_new_date)#,
				end_date = #CreateODBCDate(form.insu_dp_end_date)#
			WHERE insuranceid = '#form.dp_insuranceid#'
			LIMIT 1
		</cfquery>
	</cfif>		
</cfif>

--->