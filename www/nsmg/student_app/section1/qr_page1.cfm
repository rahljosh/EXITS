<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Applicant Information</title>
</head>
<body>

<cftry>

<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="check_username" datasource="MySql">
	SELECT email
	FROM smg_students
	WHERE email = '#form.email#'
	AND studentid != '#form.studentid#'
</cfquery>

<cfif check_username.recordcount NEQ '0'>
	<br><br>
	<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr>
		<td width="100%">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr height="33">
					<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
					<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
					<td class="tablecenter"><h2>Applicant Information</h2></td>
					<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
				</tr>
			</table>
			<div class="section"><br>
			<cfoutput>
			<table width=670 cellpadding=0 cellspacing=0 border=0 align="center">
				<tr><td><h2>Sorry, the e-mail address <b>#form.email#</b> is being used by another account.</h2><br></td></tr>
				<tr><td><h2>Please click on the "back" button below and enter a new e-mail address.</h2><br><br><br>
						<div align="center"><input name="back" type="image" src="../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br></td></tr>
			</table>
			</cfoutput>
			</div>
			<!--- FOOTER OF TABLE --->
			<cfinclude template="../footer_table.cfm">
		</td>
	</tr>
	</table>
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
	
	<cfquery name="update_student" datasource="MySql">
		UPDATE smg_students
		SET	familylastname = '#APPLICATION.CFC.UDF.removeAccent(form.familylastname)#',
			firstname = '#APPLICATION.CFC.UDF.removeAccent(form.firstname)#',
			middlename = '#APPLICATION.CFC.UDF.removeAccent(form.middlename)#',
			app_indicated_program = <cfif form.app_indicated_program EQ '0'>null,<cfelse>'#form.app_indicated_program#',</cfif>  
			app_additional_program = <cfif form.app_additional_program EQ '0'>null,<cfelse> '#form.app_additional_program#',</cfif>  
			address = '#form.address#',
			city = '#form.city#',
			zip = '#form.zip#',
			country = '#form.country#',
			phone = '#form.phone#',
			fax = '#form.fax#',
			email = '#form.email#',
			<cfif IsDefined('form.sex')>sex = '#form.sex#',</cfif> 
			<cfif form.dob is ''>dob = null,<cfelse>dob = #CreateODBCDate(form.dob)#,</cfif>
			citybirth = '#APPLICATION.CFC.UDF.removeAccent(form.citybirth)#',
			countrybirth = '#form.countrybirth#',
			countrycitizen = '#form.countrycitizen#',
			countryresident = '#form.countryresident#',
			religiousaffiliation = '#form.religiousaffiliation#',
			passportnumber = '#form.passportnumber#',
			<!--- father --->
			fathersname = '#APPLICATION.CFC.UDF.removeAccent(form.fathersname)#',
			fatheraddress = '#form.fatheraddress#',
			fathercountry = '#form.fathercountry#',
			<cfif form.fatherbirth is ''>fatherbirth = '0',<cfelse>fatherbirth = '#form.fatherbirth#',</cfif>
			<cfif not IsDefined('form.fatherenglish')><cfelse>fatherenglish = '#form.fatherenglish#',</cfif> 
			fatherworkphone = '#form.fatherworkphone#',
			fathercompany = '#form.fathercompany#',
			fatherworkposition = '#form.fatherworkposition#',
			<!--- mother --->
			mothersname = '#APPLICATION.CFC.UDF.removeAccent(form.mothersname)#',
			motheraddress = '#form.motheraddress#',
			mothercountry = '#form.mothercountry#',
			<cfif form.motherbirth is ''>motherbirth = '0',<cfelse>motherbirth = '#form.motherbirth#',</cfif>
			<cfif not IsDefined('form.motherenglish')><cfelse>motherenglish = '#form.motherenglish#',</cfif>
			motherworkphone = '#form.motherworkphone#',
			mothercompany = '#form.mothercompany#',
			motherworkposition = '#form.motherworkposition#',
			<!--- emergency information --->
			emergency_name = '#APPLICATION.CFC.UDF.removeAccent(form.emergency_name)#',
			emergency_address = '#form.emergency_address#',
			emergency_phone = '#form.emergency_phone#',
			emergency_country = '#form.emergency_country#'
		WHERE studentid = '#form.studentid#'
		LIMIT 1
	</cfquery>
	
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section1/page1&id=1&p=1");
	<cfelse>
		location.replace("?curdoc=section1/page2&id=1&p=2");
	</cfif>
	-->
	</script>
	</head>
	</html> 		
		
</cftransaction>

<cfcatch type="any">
	<cfinclude template="../email_error.cfm">
</cfcatch> 
</cftry>

<!--- <cflocation url="?curdoc=section1/page1&id=1&p=1" addtoken="no"> --->

<!--- REMOVE ACCENTS --->

<!---
<cfif client.usertype EQ '1'>
	<cfoutput>
	
	<cfquery name="get_students" datasource="MYSql">
		SELECT studentid, firstname, middlename, familylastname, citybirth
		FROM smg_students
		WHERE randid != '0'
	</cfquery>
	Total of #get_students.recordcount#<br />
	
	<cfloop query="get_students">
	#studentid#<br />
		
		<cfquery name="update" datasource="MySql">
			UPDATE smg_students
			SET firstname = '#APPLICATION.CFC.UDF.removeAccent(firstname)#',
				middlename = '#APPLICATION.CFC.UDF.removeAccent(middlename)#',
				familylastname = '#APPLICATION.CFC.UDF.removeAccent(familylastname)#',
				citybirth = '#APPLICATION.CFC.UDF.removeAccent(citybirth)#'
			WHERE studentid = '#get_students.studentid#'
			LIMIT 1
		</cfquery>
	</cfloop>
	
	Done!
	</cfoutput>
</cfif>
--->