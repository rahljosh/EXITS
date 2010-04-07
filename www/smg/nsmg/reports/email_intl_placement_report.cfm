<link rel="stylesheet" href="reports.css" type="text/css">

<cfsetting requestTimeOut = "500">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	DISTINCT p.programid, p.programname, c.companyshort
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON c.companyid = p.companyid
	WHERE 	<cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop>
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_current_user" datasource="MySql">
	SELECT email, firstname, lastname
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<!--- get Reps  --->
<cfquery name="GetIntlReps" datasource="MYSQL">
	SELECT	intrep, businessname, userid, u.email, u.email2, u.firstname, u.lastname
	FROM smg_students s
	INNER JOIN smg_users u 	ON s.intrep = u.userid
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_hosts h 	ON s.hostid = h.hostid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	WHERE  s.active = '1' 
	AND s.companyid = '#client.companyid#' 
	AND s.host_fam_approved <= '4'
	<cfif form.intrep NEQ 0>AND s.intrep = #form.intrep#</cfif>
	<cfif #client.companyid# NEQ '5'>AND s.companyid = '#client.companyid#'</cfif>
	AND	( <cfloop list="#form.programid#" index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	GROUP BY intrep
	ORDER BY businessname, s.firstname, s.familylastname
</cfquery>  

<cfoutput>

<cfloop query="GetIntlReps">
	
	<cfquery name="get_students" datasource="MYSQL">
		SELECT DISTINCT s.studentid, s.firstname, s.familylastname, s.sex, s.dateplaced, s.dob,
		p.programname, countryname, h.familylastname as hostfamily
		FROM smg_students s
		INNER JOIN smg_users u ON s.intrep = u.userid
		INNER JOIN smg_programs p	ON s.programid = p.programid
		INNER JOIN smg_hosts h ON s.hostid = h.hostid		
		LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
		WHERE s.active = '1' 
			and s.companyid = '#client.companyid#'
			AND s.host_fam_approved <= '4'
			AND  s.intrep = #intrep#
			AND	( <cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
		GROUP BY s.studentid
		ORDER BY u.businessname, s.firstname, s.familylastname
	</cfquery>
	
	<!--- SENDING EMAILS  - send email if the option is checked --->
	<cfif IsDefined('form.send_email')>
		
		<cfif IsDefined('form.copy_user')>
			<cfset get_user_email = #get_current_user.email#>			
		<cfelse>
			<cfset get_user_email = #GetIntlReps.email#>
		</cfif>

		<CFMAIL TO="#GetIntlReps.email#"
			bcc="#get_user_email#"
			SUBJECT="#companyshort.companyshort_nocolor# - Placement & Flight Information"
			FROM="""#client.companyshort# Support"" <#client.support_email#>"
			TYPE="HTML">
			<HTML>
			<HEAD>
			<style type="text/css">
				table.nav_bar { font-size: 10px; background-color: ffffff; border: 1px solid 000000; }
				.style3 {font-size: 13px}
				.application_section_header{
				border-bottom: 1px dashed Gray;
				text-transform: uppercase;
				letter-spacing: 5px;
				width:100%;
				text-align:center;
				background;
				background: DCDCDC;
				font-size: small;
				}
			</style>
			</HEAD>
			<BODY>
			<cfinclude template="email_intl_header.cfm">
			<p>&nbsp; &nbsp; &nbsp; Dear #GetIntlReps.firstname# #GetIntlReps.lastname# &nbsp; - &nbsp; #GetIntlReps.businessname#,</p>
			<p>&nbsp; &nbsp; &nbsp; Please find below a list of placed students. If you have not received a placement yet, please let me know ASAP.</p>
			<p>&nbsp; &nbsp; &nbsp; <b>Please also send all flight information that may be shown on the report below. You can submit Flight Information thru EXITS.</b></p>
			<p>&nbsp; &nbsp; &nbsp; Also remember that you can log on to EXITS yourself and check all placement information at your convenience. Please visit
				#client.site_url# to login.</p>
			<table width='95%' cellpadding=6 cellspacing="0" align="center" frame="box">
				<tr><td align="center">
					Program(s) Included in this Report:<br>
					<cfloop query="get_program"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (#ProgramID#)</b><br></cfloop>
				</td></tr>
			</table><br>
			<table width='95%' cellpadding=6 cellspacing="0" align="center" frame="box">	
				<tr><th width="75%">International Representative</th> <th width="25%">Total</th></tr>
			</table><br>
			<table width='95%' cellpadding=6 cellspacing="0" align="center" frame="box">	
			<tr><th width="75%">#businessname#</th>
				<td width="25%" align="center">#get_students.recordcount#</td></tr>
			</table>
			<table width='95%' frame="below" cellpadding=6 cellspacing="0" align="center">
				<tr><td width="6%" align="center"><b>ID</b></td>
					<td width="20%"><b>Student</b></td>
					<td width="8%" align="center"><b>Sex</b></td>
					<td width="8" align="center"><b>DOB</b></td>
					<td width="12%"><b>Country</b></td>
					<td width="12%"><b>Family</b></td>
					<td width="10" align="center"><b>Program</b></td>
					<td width="12" align="center"><b>Arrival Information</b></td>
					<td width="12" align="center"><b>Departure Information</b></td>
					<td width="12%" align="center"><b>Placement Date</b></td></tr>
				<cfloop query="get_students">
				<cfif isDefined('form.include_arrival')> 
					<cfquery name="get_flight_info_arrival" datasource="MySql">
						SELECT flightid
						FROM smg_flight_info 
						WHERE studentid = '#studentid#' 
							AND flight_type = 'arrival'
					</cfquery>
				</cfif>
				<cfif isDefined('form.include_departure')>
					<cfquery name="get_flight_info_departure" datasource="MySql">
						SELECT flightid
						FROM smg_flight_info 
						WHERE studentid = '#studentid#' 
							AND flight_type = 'departure'
					</cfquery>
				</cfif>
					<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
						<td align="center">#studentid#</td>
						<td>#firstname# #familylastname#</td>
						<td align="center">#sex#</td>
						<td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
						<td>#countryname#</td>
						<td>#hostfamily#</td>
						<td align="center">#programname#</td>
						<td align="center"><cfif not isDefined('form.include_arrival')>N/A<cfelse> <cfif get_flight_info_arrival.recordcount>Received<cfelse><font color="FF0000"><b>Missing</b></font></cfif></cfif></td>	
						<td align="center"><cfif not isDefined('form.include_departure')>N/A<cfelse> <cfif get_flight_info_departure.recordcount>Received<cfelse><font color="FF0000"><b>Missing</b></font></cfif></cfif></td>	
						<td align="center">#DateFormat(dateplaced, 'mm/dd/yyyy')#</td>
					</tr>
				</cfloop>							
			</table><br>
			</body>
			</html>
		</CFMAIL>
	</cfif>	
	
	<!--- SHOW REGULAR REPORT --->	
	<table width='95%' cellpadding=6 cellspacing="0" align="center">
	<span class="application_section_header">#companyshort.companyshort_nocolor# -  Students per International Rep.</span>
	</table><br>
	<table width='95%' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		Total of Agents: #GetIntlReps.recordcount#
	</td></tr>
	</table><br>
	<table width='95%' cellpadding=6 cellspacing="0" align="center" frame="box">	
	<tr><th width="75%">International Representative</th> <th width="25%">Total</th></tr>
	</table><br>
	<table width='95%' cellpadding=6 cellspacing="0" align="center" frame="box">	
	<tr><th width="75%">#businessname#</th>
		<td width="25%" align="center">#get_students.recordcount#</td></tr>
	</table>
	<table width='95%' frame="below" cellpadding=6 cellspacing="0" align="center">
		<tr><td width="6%" align="center"><b>ID</b></td>
			<td width="20%"><b>Student</b></td>
			<td width="8%" align="center"><b>Sex</b></td>
			<td width="8" align="center"><b>DOB</b></td>
			<td width="12%"><b>Country</b></td>
			<td width="12%"><b>Family</b></td>
			<td width="10" align="center"><b>Program</b></td>
					<td width="12" align="center"><b>Arrival Information</b></td>
					<td width="12" align="center"><b>Departure Information</b></td>
			<td width="12%" align="center"><b>Placement Date</b></td></tr>
		<cfloop query="get_students">
					<cfif isDefined('form.include_arrival')> 
					<cfquery name="get_flight_info_arrival" datasource="MySql">
						SELECT flightid
						FROM smg_flight_info 
						WHERE studentid = '#studentid#' 
							AND flight_type = 'arrival'
					</cfquery>
				</cfif>
				<cfif isDefined('form.include_departure')>
					<cfquery name="get_flight_info_departure" datasource="MySql">
						SELECT flightid
						FROM smg_flight_info 
						WHERE studentid = '#studentid#' 
							AND flight_type = 'departure'
					</cfquery>
				</cfif>
			<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td align="center">#studentid#</td>
				<td>#firstname# #familylastname#</td>
				<td align="center">#sex#</td>
				<td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
				<td>#countryname#</td>
				<td>#hostfamily#</td>
				<td align="center">#programname#</td>
						<td align="center"><cfif not isDefined('form.include_arrival')>N/A<cfelse> <cfif get_flight_info_arrival.recordcount>Received<cfelse><font color="FF0000"><b>Missing</b></font></cfif></cfif></td>	
						<td align="center"><cfif not isDefined('form.include_departure')>N/A<cfelse> <cfif get_flight_info_departure.recordcount>Received<cfelse><font color="FF0000"><b>Missing</b></font></cfif></cfif></td>		
				<td align="center">#DateFormat(dateplaced, 'mm/dd/yyyy')#</td>
			</tr>
		</cfloop>										
	</table><br>
	
	<cfif IsDefined('form.send_email')>
	<p><font color="3333CC"><u><b><center>Report was sent to &nbsp; #GetIntlReps.email# &nbsp; on &nbsp; #dateformat(now(), 'mm/dd/yyyy')# &nbsp; at &nbsp; #timeformat(now(), 'hh:mm:ss tt')#</center></b></u></font></p>
	<hr width="80%" align="center"><br>
	</cfif>
	
</cfloop><br><br> <!--- intl rep --->

</cfoutput>