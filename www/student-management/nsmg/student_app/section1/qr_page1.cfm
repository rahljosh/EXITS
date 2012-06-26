<cftry>

<cfif not IsDefined('FORM.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- Param Form Variables --->
<cfparam name="FORM.dob" default="">
<cfparam name="FORM.fatherDOB" default="">
<cfparam name="FORM.motherDOB" default="">
<cfparam name="FORM.app_indicated_program" default="0">
<cfparam name="FORM.app_canada_area" default="0">
<cfparam name="FORM.internalProgram" default="0">
<cfparam name="FORM.app_additional_program" default="0">

<cfquery name="check_username" datasource="MySql">
	SELECT email
	FROM smg_students
	WHERE email = '#FORM.email#'
	AND studentid != '#FORM.studentid#'
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
				<tr><td><h2>Sorry, the e-mail address <b>#FORM.email#</b> is being used by another account.</h2><br></td></tr>
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

<cfinvoke component="//nsmg/extensions/components/program" method="addHistory" studentID="#FORM.studentID#" programID="#FORM.internalProgram#" reason="Changed in app">

<cftransaction action="begin" isolation="serializable">

	<cfquery name="update_student" datasource="MySql">
		UPDATE smg_students
		SET	familylastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(FORM.familylastname))#">,
			firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(FORM.firstName))#">,
			middlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(FORM.middleName))#">,
			app_indicated_program = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.app_indicated_program#">,  
            programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.internalProgram#" >,
			app_additional_program = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.app_additional_program#">,  
			app_canada_area = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.app_canada_area)#">,
            address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
			city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
			zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
			country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.country#">,
			phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
			fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
			email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
			<cfif IsDefined('FORM.sex')>
            	sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
            </cfif> 
            dob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#NOT IsDate(FORM.dob)#">,
			citybirth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(FORM.cityBirth))#">,
			countrybirth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.countrybirth#">,
			countrycitizen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.countrycitizen#">,
			countryresident = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.countryresident#">,
			religiousaffiliation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.religiousaffiliation#">,
			passportnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.passportnumber#">,
			<!--- father --->
			fathersname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(FORM.fathersname))#">,
			fatheraddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatheraddress#">,
			fathercountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fathercountry#">,
			fatherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherDOB#" null="#NOT IsDate(FORM.fatherDOB)#">,
			<cfif IsDefined('FORM.fatherenglish')>
            	fatherenglish = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherenglish#">,
            </cfif> 
			fatherworkphone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherworkphone#">,
			fathercompany = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fathercompany#">,
			fatherworkposition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherworkposition#">,
			<!--- mother --->
			mothersname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(FORM.mothersname))#">,
			motheraddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motheraddress#">,
			mothercountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mothercountry#">,
            motherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherDOB#" null="#NOT IsDate(FORM.motherDOB)#">,
			<cfif IsDefined('FORM.motherenglish')>
            	motherenglish = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherenglish#">,
            </cfif>
			motherworkphone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherworkphone#">,
			mothercompany = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mothercompany#">,
			motherworkposition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherworkposition#">,
			<!--- emergency information --->
			emergency_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(FORM.emergency_name))#">,
			emergency_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_address#">,
			emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#">,
			emergency_country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_country#">
		WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
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