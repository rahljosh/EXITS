<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Create Caremed Corrections File According to the Flight Information</title>
</head>

<body>
<!--- CREATES EXTENSION OR EARLY RETURN DATA --->
<cfif NOT IsDefined('form.programid') AND form.newdate EQ ''>
	You must select a program Please go back and try again.
	<cfabort>
</cfif>

<cfsetting requestTimeOut = "300">

<!--- GET STUDENTS WITH CAREMED ON FILE AND FLIGHT INFORMATION --->
<cfquery name="get_students" datasource="MySql">
	SELECT DISTINCT s.firstname, s.familylastname, s.sex, s.dob, s.studentid, s.termination_date,
		 u.businessname,
		 p.insurance_startdate, p.insurance_enddate,
		 c.countrycode
	FROM smg_students s
	INNER JOIN smg_users u ON s.intrep = u.userid 
	INNER JOIN smg_insurance insu ON s.studentid = insu.studentid	
	INNER JOIN smg_programs p ON s.programid = p.programid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	WHERE s.active = '1'
		AND cancelinsurancedate IS NULL
		AND insu.sent_to_caremed IS NOT NULL
		AND (<cfloop list="#form.programid#" index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop>)
		<!--- AND s.studentid NOT IN (SELECT studentid FROM smg_flight_info WHERE flight_type = 'arrival') --->
	ORDER BY u.businessname, s.firstname
</cfquery>

<cfoutput>

	<cfloop query="get_students">
		<Cfquery name="get_history" datasource="MySQL">
			SELECT insuranceid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, sent_to_caremed, 
			org_code, policy_code, transtype
			FROM smg_insurance
			WHERE studentid = <cfqueryparam value="#get_students.studentid#" cfsqltype="cf_sql_integer">
			ORDER BY insuranceid DESC
		</cfquery>
		<cfquery name="get_flight" datasource="MySql">
			SELECT studentid, dep_date, flight_type
			FROM smg_flight_info
			WHERE studentid = <cfqueryparam value="#get_students.studentid#" cfsqltype="cf_sql_integer">
				AND flight_type = 'arrival'
			ORDER BY dep_date
		</cfquery>
		<!--- there is no flight information, there is no caremed pending transaction and new date is not what it's in file --->
		<cfif get_flight.recordcount EQ '0' AND get_history.sent_to_caremed NEQ '' AND get_history.new_date NEQ form.newdate AND form.newdate GT get_history.new_date>
			<cfquery name="insurance_correction" datasource="MySql">
				INSERT INTO smg_insurance
					(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
				VALUES
					('#get_students.studentid#', '#get_students.firstname#', '#get_students.familylastname#', '#get_students.sex#', 
					#CreateODBCDate(get_students.dob)#, '#get_students.countrycode#', #CreateODBCDate(form.newdate)#,
					#CreateODBCDate(get_students.insurance_enddate)#, '#get_history.org_code#', '#get_history.policy_code#', 'correction');	
			</cfquery>
			Correction file created for #firstname# #familylastname# (###studentid#) - New Date #DateFormat(form.newdate, 'mm/dd/yyyy')# - Previous Insurance Start - #DateFormat(get_history.new_date, 'mm/dd/yyyy')#<br>
		</cfif>
		
	</cfloop>
</cfoutput>

</body>
</html>