<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New International Representative</title>
</head>

<body>

<cftry>

<cftransaction action="begin" isolation="serializable">

	<cfif form.businessname EQ ''>
		<br />Business name is required. Please go back and try again.<br />
		<cfabort>
	<cfelseif form.username EQ ''>
		<br />Username name is required. Please go back and try again.<br />
		<cfabort>
	<cfelseif form.password EQ ''>
		<br />Password name is required. Please go back and try again.<br />
		<cfabort>		
	</cfif>

	<cfquery name="update" datasource="MySql">
		UPDATE smg_users
		SET businessname = '#form.businessname#',
			<cfif IsDefined('form.active')>active = '#form.active#',</cfif>
			address = '#form.address#',
			city = '#form.city#',
			country = '#form.country#',
			zip = '#form.zip#',
			phone = '#form.phone#',
			fax = '#form.fax#',
			usebilling = <cfif IsDefined('form.usebilling')>'1'<cfelse>'0'</cfif>, 
			billing_company = '#form.billing_company#', 
			billing_contact = '#form.billing_contact#',
			billing_email = '#form.billing_email#',
			billing_address = '#form.billing_address#',
			billing_address2 = '#form.billing_address2#',
			billing_city = '#form.billing_city#',
			billing_country = '#form.billing_country#',
			billing_zip = '#form.billing_zip#',
			billing_phone = '#form.billing_phone#',
			billing_fax = '#form.billing_fax#',
			firstname = '#form.firstname#', 
			middlename = '#form.middlename#',
			lastname = '#form.lastname#',
			dob = <cfif form.dob EQ ''>NULL<cfelse>#CreateODBCDate(dob)#</cfif>,
			sex = <cfif IsDefined('form.sex')>'#form.sex#'<cfelse>''</cfif>, 
			email = '#form.email#', 
			email2 = '#form.email2#',
			username = '#form.username#',
			password = '#form.password#'
		WHERE userid = '#form.userid#'
		LIMIT 1
	</cfquery>

	<cfoutput>
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page.");
		//location.replace("?curdoc=candidate/candidate_form2&unqid=#uniqueid#");
		location.replace("?curdoc=intrep/intrep_info&uniqueid=#form.uniqueid#");
	-->
	</script>
	</head>
	</html> 
	</cfoutput>		

</cftransaction>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>
