<!--- <cftry>
 --->
<cfif isdefined('url.unqid')>
	<cfquery name="get_unqid" datasource="MySql">
		SELECT *
		FROM smg_students
		WHERE uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = #get_unqid.studentid#>
</cfif>

<cfquery name="get_students" datasource="MySQL">
  SELECT 	s.firstname, s.familylastname, s.sex, s.dob, s.studentid, s.intrep,
			u.insurance_typeid,
			p.insurance_enddate, 
			c.countrycode,
			co.orgcode
			FROM 	smg_students s
  INNER JOIN smg_users u 		ON u.userid = s.intrep  
  INNER JOIN smg_programs p 	ON s.programid = p.programid
  INNER JOIN smg_countrylist c 	ON s.countryresident = c.countryid
  INNER JOIN smg_companies co 	ON s.companyid = co.companyid	
  WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="flight_notes" datasource="MySQL">
	UPDATE smg_students
		SET flight_info_notes = "#form.flight_notes#"
	WHERE studentid = #client.studentid#
	LIMIT 1
</cfquery> 

<!--- ARRIVAL INFORMATION --->
<!--- NEW FLIGHT ARRIVAL UP TO 4 LEGS --->
<cfif form.ar_update is 'new'> 
	<cfloop From = "1" To = "4" Index = "i">
		<cfif form["ar_dep_date" & i] is ''><cfelse>
			<cfquery name="insert_flight" datasource="MySQL">
				INSERT INTO smg_flight_info
				(studentid, dep_date, dep_city, dep_aircode, arrival_city, arrival_aircode, flight_number, dep_time, arrival_time,
				overnight, flight_type)
				VALUES ('#client.studentid#', 
					<cfif form["ar_dep_date" & i] is ''>NULL,<cfelse>#CreateODBCDate(form["ar_dep_date" & i])#,</cfif>
					'#form["ar_dep_city" & i]#',  
					'#form["ar_dep_aircode" & i]#',
					'#form["ar_arrival_city" & i]#',
					'#form["ar_arrival_aircode" & i]#',
					'#form["ar_flight_number" & i]#',
					<cfif form["ar_dep_time" & i] is ''>null,<cfelse>#CreateODBCTime(form["ar_dep_time" & i])#,</cfif>
					<cfif form["ar_arrival_time" & i] is ''>null,<cfelse>#CreateODBCTime(form["ar_arrival_time" & i])#,</cfif>
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
			SET dep_date = <cfif form["ar_dep_date" & i] is ''>NULL,<cfelse>#CreateODBCDate(form["ar_dep_date" & i])#,</cfif>
				dep_city = '#form["ar_dep_city" & i]#',  
				dep_aircode = '#form["ar_dep_aircode" & i]#',
				dep_aircode = '#form["ar_dep_aircode" & i]#',
				arrival_city = '#form["ar_arrival_city" & i]#',
				arrival_aircode = '#form["ar_arrival_aircode" & i]#',
				flight_number = '#form["ar_flight_number" & i]#',
				dep_time = <cfif form["ar_dep_time" & i] is ''>null,<cfelse>#CreateODBCTime(form["ar_dep_time" & i])#,</cfif>
				arrival_time = <cfif form["ar_arrival_time" & i] is ''>null,<cfelse>#CreateODBCTime(form["ar_arrival_time" & i])#,</cfif>
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
		<cfif form["dp_dep_date" & i] is ''><cfelse>
			<cfquery name="insert_flight" datasource="MySQL">
				INSERT INTO smg_flight_info
				(studentid, dep_date, dep_city, dep_aircode, arrival_city, arrival_aircode, flight_number, dep_time, arrival_time,
				overnight, flight_type)
				VALUES ('#client.studentid#', 
					<cfif form["dp_dep_date" & i] is ''>NULL,<cfelse>#CreateODBCDate(form["dp_dep_date" & i])#,</cfif>
					'#form["dp_dep_city" & i]#',  
					'#form["dp_dep_aircode" & i]#',
					'#form["dp_arrival_city" & i]#',
					'#form["dp_arrival_aircode" & i]#',
					'#form["dp_flight_number" & i]#',
					<cfif form["dp_dep_time" & i] is ''>null,<cfelse>#CreateODBCTime(form["dp_dep_time" & i])#,</cfif>
					<cfif form["dp_arrival_time" & i] is ''>null,<cfelse>#CreateODBCTime(form["dp_arrival_time" & i])#,</cfif>
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
			SET dep_date = <cfif form["dp_dep_date" & i] is ''>NULL,<cfelse>#CreateODBCDate(form["dp_dep_date" & i])#,</cfif>
				dep_city = '#form["dp_dep_city" & i]#',  
				dep_aircode = '#form["dp_dep_aircode" & i]#',
				arrival_city = '#form["dp_arrival_city" & i]#',
				arrival_aircode = '#form["dp_arrival_aircode" & i]#',
				flight_number = '#form["dp_flight_number" & i]#',
				dep_time = <cfif form["dp_dep_time" & i] is ''>null,<cfelse>#CreateODBCTime(form["dp_dep_time" & i])#,</cfif>
				arrival_time = <cfif form["dp_dep_time" & i] is ''>null,<cfelse>#CreateODBCTime(form["dp_arrival_time" & i])#,</cfif>
				overnight = <cfif isdefined('form.dp_overnight#i#')> '1' <cfelse> '0' </cfif>
			WHERE flightid = '#form["dp_flightid" & i]#'
			LIMIT 1

			</cfquery>
	</cfloop>
</cfif> <!--- END OF DEPARTURE INFORMATION --->

<!--- EMAIL FACILITATORS TO LET THEM KNOW THERE IS A NEW FLIGHT INFORMATION ---->
<cfquery name="get_region_info" datasource="MySQL">
	SELECT s.regionassigned,
			r.regionname, r.regionfacilitator, r.regionid, r.company,
			u.firstname, u.lastname, u.email 
	from smg_students s 
	INNER JOIN smg_regions r ON s.regionassigned = r.regionid
	LEFT JOIN smg_users u ON r.regionfacilitator = u.userid
	WHERE s.studentid = '#client.studentid#'
</cfquery>

<cfquery name="get_int_Agent" datasource="MySQL">
	select companyid, businessname, fax, email, firstname, lastname, businessphone
	from smg_users 
	where userid = #get_students.intrep#
</cfquery>

<cfquery name="check_php" datasource="MySql">
	SELECT studentid
	FROM php_students_in_program
	WHERE studentid = '#client.studentid#'
</cfquery>

<cfoutput>

<cfif check_php.recordcount>
	<cfset email_to = 'luke@phpusa.com'>
<cfelseif get_region_info.email EQ ''>
	<cfset email_to = 'support@student-management.com'>
<cfelse>	
	<cfset email_to = '#get_region_info.email#'>
</cfif>

<CFMAIL SUBJECT="SMG EXITS - Flight Information for #get_students.firstname# #get_students.familylastname# (###get_students.studentid#)"
TO="#email_to#"
FROM="""SMG Support"" <support@student-management.com>"
TYPE="HTML">

<HTML>
<HEAD>
<style type="text/css">
	.thin-border{ border: 1px solid ##000000;}
</style>
</HEAD>
<BODY>	

<table width=550 class="thin-border" cellspacing="3" cellpadding=0>
<tr><td bgcolor=b5d66e><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif" width=550 height=75></td></tr>
<tr><td><br>Dear #get_region_info.firstname# #get_region_info.lastname#,<br><br></td></tr>
<tr><td>This e-mail is just to let you know new or updated flight information for the student 
	#get_students.firstname# #get_students.familylastname# (###get_students.studentid#) has been recorded in EXITS by #get_int_Agent.businessname#.<br><br></td></tr>	
<tr><td>
	Please click 
	<a href="http://www.student-management.com/nsmg/index.cfm?curdoc=student_info&studentid=#get_students.studentid#">here</a>
	to see the student's flight information.<br><br>
</td></tr>	
<tr><td>
	 Sincerely,<br>
	 EXITS - Student Management Group<br><br>
</td></tr>
</table>

</body>
</html>
</CFMAIL>

<script language="JavaScript">
<!-- 
alert("You have successfully updated the flight information for #get_students.firstname# #get_students.familylastname# (###get_students.studentid#). \n Please be adivsed that an email has been sent to #get_region_info.firstname# #get_region_info.lastname# (student's facilitator) to let him/her know about this flight info. Thank You.");
	location.replace("int_flight_info.cfm");
-->
</script>

</cfoutput>

<!--- 	<cfcatch type="any">
		<script language="JavaScript">
		<!-- 
		alert("Sorry, an error has ocurred and we were not possibly to save the flight record submitted. \n Please verify the data you are submitting and try again. Dates must be in the mm/dd/yyyy format. Thank You.");
			location.replace("int_flight_info.cfm");
		-->
		</script>
	</cfcatch>
</cftry> --->