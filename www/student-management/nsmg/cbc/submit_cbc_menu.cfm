<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>CBC Submission Form</title>
</head>

<body bgcolor=#e7e5df>

<script language="JavaScript">
<!--
function enableFields(ftype)
{
	if (document.form.elements["check_"+ftype].checked) {
		document.form.elements[ftype+"firstname"].disabled=false;
		document.form.elements[ftype+"middlename"].disabled=false;
		document.form.elements[ftype+"lastname"].disabled=false;
		document.form.elements[ftype+"dob"].disabled=false;
		document.form.elements[ftype+"ssn"].disabled=false;
		document.form.elements[ftype+"firstname"].focus();
	} else {
		document.form.elements[ftype+"firstname"].disabled=true;
		document.form.elements[ftype+"middlename"].disabled=true;
		document.form.elements[ftype+"lastname"].disabled=true;
		document.form.elements[ftype+"dob"].disabled=true;
		document.form.elements[ftype+"ssn"].disabled=true;
	}
}
function enableFieldsMember(totalm)
{
	for (i=1; i<=totalm; i++){
		if (document.form.elements["check_member"+i].checked) {
			document.form.elements["name"+i].disabled=false;
			document.form.elements["middlename"+i].disabled=false;
			document.form.elements["lastname"+i].disabled=false;
			for (s=0; s<document.form.elements["sex"+i].length; s++) {
			  document.form.elements["sex"+i][s].disabled=false;
		   }
			document.form.elements["birthdate"+i].disabled=false;
			document.form.elements["ssn"+i].disabled=false;
			document.form.elements["name"+i].focus();
		} else {
			document.form.elements["name"+i].disabled=true;
			document.form.elements["middlename"+i].disabled=true;
			document.form.elements["lastname"+i].disabled=true;
			for (s=0; s<document.form.elements["sex"+i].length; s++) {
			  document.form.elements["sex"+i][s].disabled=true;
		   }
			document.form.elements["birthdate"+i].disabled=true;
			document.form.elements["ssn"+i].disabled=true;
		}
	}
}
//-->
</script>

<!--- <cftry> --->

<cfoutput>

<!--- SECURE CONNECTION --->
<cfif cgi.SERVER_PORT NEQ 443>
	<table align="center" width="50%" border="0" bgcolor="white">
		<tr><th><img src="#CLIENT.exits_url#/5.gif" /></th><th valign="middle">HOST FAMILY CBC FORM SIGN IN</th></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">Dear Family,<br /><br /></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">You are not over a https encrypted secure connection. Please click <a href="https://#cgi.http_host##cgi.script_name#?#cgi.QUERY_STRING#">here</a> to login over a secure connection.</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table><br />
	<cfabort>
</cfif>

<cfif NOT IsDefined('form.hostid') AND NOT IsDefined('form.uniqueid')>
	
	<cfform name="form" method="post" action="submit_cbc_menu.cfm" enctype="multipart/form-data"> 
		<table align="center" width="50%" border="0" bgcolor="white">
			<tr><th><img src="#CLIENT.exits_url#/5.gif" /></th><th valign="middle">HOST FAMILY CBC FORM SIGN IN</th></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">Please enter below the information provided by your representative:<br /><br /></td></tr>
			<tr><td width="20%" align="right">Host Family ID:</td><td width="80%"><cfinput type="text" name="hostid" size="10" maxlength="5" required="yes" message="You must enter the Host Family ID in order to continue."></td></tr>
			<tr><td align="right">Unique ID:</td><td><cfinput type="text" name="uniqueid" size="40" maxlength="35" validate="uuid" required="yes" message="You must enter the Unique ID in the following format xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxx in order to continue."></td></tr>
			<tr><td></td><td><font size="-1">* Unique ID Format: xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxx</font></td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">* You are over a https encrypted secure connection.</td></tr>
			<tr><td colspan="2" align="center"><cfinput type="submit" name="submit" value="Log In"></td></tr>
		</table>
	</cfform>

<!--- retrieve host family info --->
<cfelse>

	<cfquery name="get_host" datasource="MySql">
		SELECT h.hostid, h.familylastname, h.fatherfirstname, h.fathermiddlename, h.fatherlastname, h.fatherssn, h.fatherdob,
			h.motherfirstname, h.mothermiddlename, h.motherlastname, h.motherssn, h.motherdob,
			c.companyname
		FROM smg_hosts h
		LEFT JOIN smg_companies c ON h.companyid = c.companyid
		WHERE hostid = <cfqueryparam value="#form.hostid#" cfsqltype="cf_sql_integer">
			AND uniqueid = <cfqueryparam value="#form.uniqueid#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfquery name="get_family_members" datasource="MySql">
		SELECT childid, hostid, membertype, name, middlename, lastname, sex, ssn, birthdate, (DATEDIFF(now( ) , birthdate)/365)
		FROM smg_host_children 
		WHERE hostid = <cfqueryparam value="#hostid#" cfsqltype="cf_sql_integer">
			AND (DATEDIFF(now( ) , birthdate)/365) > 18
		ORDER BY childid
	</cfquery>
		
	<!--- HOST FAMILY CBC --->
	<cfif get_host.recordcount>
	
		<cfform name="form" method="post" action="submit_cbc1.cfm" enctype="multipart/form-data"> 
			<cfinput type="hidden" name="hostid" value="#form.hostid#">
			<cfinput type="hidden" name="uniqueid" value="#form.uniqueid#">
			<table align="center" width="70%" border="0" bgcolor="white">
				<tr><th><img src="#CLIENT.exits_url#/5.gif" /></th><th valign="middle">HOST FAMILY CBC FORM SIGN IN</th></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">Dear #get_host.familylastname# Family,<br /><br /></td></tr>
				<tr><Td colspan="2">Please click the box for each family member you are goin to enter information for:</td></tr>
				<tr><Td colspan="2">For those you checked, please make sure all the information is correct before you advance to the next page.</td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>				
				<tr><td colspan="2">
					<table align="center" width="100%" cellpadding="0" cellspacing="0">
						<!--- HOST FATHER --->
						<tr><th colspan="6" bgcolor="e7e5df">Host Father</th></tr>
						<tr><th>Authorization</th><th>Name</th><th>Middle Name</th><th>Last Name</th><th>DOB</th><th>SSN</th></tr>
						<tr>
							<td valign="top" align="center"><cfinput type="checkbox" name="check_father" onClick="enableFields('father');"></td>
							<td valign="top" align="center"><cfinput type="text" name="fatherfirstname" size="15" value="#get_host.fatherfirstname#" disabled="disabled"></td>
							<td valign="top" align="center"><cfinput type="text" name="fathermiddlename" size="13" value="#get_host.fathermiddlename#" disabled="disabled"></td>
							<td valign="top" align="center"><cfinput type="text" name="fatherlastname" size="15" value="#get_host.fatherlastname#" disabled="disabled"></td>
							<td valign="top" align="center"><cfinput type="text" name="fatherdob" size="10" value="#DateFormat(get_host.fatherdob,'mm-dd-yyyy')#" maxlength="10" validate="date" disabled="disabled"><br>mm-dd-yyyy</td>
							<td valign="top" align="center" width="10%">
								<cfif get_host.fatherssn EQ ''>
									<cfset FatherDecryptedSSN = get_host.fatherssn>
								<cfelse>
									<cfset FatherDecryptedSSN = decrypt(get_host.fatherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
								</cfif>		
								<cfinput type="text" name="fatherssn" size=12 value="#FatherDecryptedSSN#" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for host father in the following format xxx-xx-xxxx" disabled="disabled"><br>xxx-xx-xxxx			
							</td>
						</tr>	
						<tr><td colspan="6">&nbsp;</td></tr>	
						<!--- HOST MOTHER --->
						<tr><th colspan="6" bgcolor="e7e5df">Host Mother</th></tr>
						<tr><th>Authorization</th><th>Name</th><th>Middle Name</th><th>Last Name</th><th>DOB</th><th>SSN</th></tr>
						<tr>
							<td valign="top" align="center"><cfinput type="checkbox" name="check_mother" onClick="enableFields('mother');"></td>
							<td valign="top" align="center"><cfinput type="text" name="motherfirstname" size="15" value="#get_host.motherfirstname#" disabled="disabled"></td>
							<td valign="top" align="center"><cfinput type="text" name="mothermiddlename" size="13" value="#get_host.mothermiddlename#" disabled="disabled"></td>
							<td valign="top" align="center"><cfinput type="text" name="motherlastname" size="15" value="#get_host.motherlastname#" disabled="disabled"></td>
							<td valign="top" align="center"><cfinput type="text" name="motherdob" size="10" value="#DateFormat(get_host.motherdob,'mm-dd-yyyy')#" maxlength="10" validate="date" disabled="disabled"><br>mm-dd-yyyy</td>
							<td valign="top" align="center" width="10%">
								<cfif get_host.motherssn EQ ''>
									<cfset motherDecryptedSSN = get_host.motherssn>
								<cfelse>
									<cfset motherDecryptedSSN = decrypt(get_host.motherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
								</cfif>		
								<cfinput type="text" name="motherssn" size=12 value="#motherDecryptedSSN#" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for host mother in the following format xxx-xx-xxxx" disabled="disabled"><br>xxx-xx-xxxx			
							</td>
						</tr>						
						<tr><td colspan="6">&nbsp;</td></tr>
					</table>
					<!--- HOST FAMILY MEMBERS --->
					<table align="center" width="100%" cellpadding="0" cellspacing="0">						
						<tr><th colspan="7" bgcolor="e7e5df">Host Family Members 18+</th></tr>
						<cfif get_family_members.recordcount>
							<tr><th>Authorization</th><th>Name</th><th>Middle Name</th><th>Last Name</th><th>Sex</th><th>DOB</th><th>SSN</th></tr>
							<cfloop query="get_family_members">
								<cfinput type="hidden" name="childid#currentrow#" value="#childid#">
								<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
									<td valign="top" align="center"><cfinput type="checkbox" name="check_member#currentrow#" onClick="enableFieldsMember(#get_family_members.recordcount#);"></td>
									<td valign="top" align="center"><cfinput type="text" name="name#currentrow#" size="11" value="#name#" disabled="disabled"></td>
									<td valign="top" align="center"><cfinput type="text" name="middlename#currentrow#" size="8" value="#middlename#" disabled="disabled"></td>
									<td valign="top" align="center"><cfinput type="text" name="lastname#currentrow#" size="11" value="#lastname#" disabled="disabled"></td>
									<td valign="top" align="center">
										<cfif sex is 'male'><cfinput type="radio" name="sex#currentrow#" value="male" checked="yes" disabled="disabled">M<cfelse><cfinput type="radio" name="sex#currentrow#" value="male" disabled="disabled">M</cfif>&nbsp; 
										<cfif sex is 'female'><cfinput type="radio" name="sex#currentrow#" value="female" checked="yes" disabled="disabled">F<cfelse><cfinput type="radio" name="sex#currentrow#" value="female" disabled="disabled">F</cfif>
									</td>
									<td valign="top" align="center"><cfinput type="text" name="birthdate#currentrow#" size="7" value="#DateFormat(birthdate,'mm-dd-yyyy')#" maxlength="10" validate="date" disabled="disabled"><br>mm-dd-yyyy</td>
									<td valign="top" align="center" width="10%">
										<cfif ssn EQ ''>
											<cfset DecryptedSSN = ssn>
										<cfelse>
											<cfset DecryptedSSN = decrypt(ssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
										</cfif>		
										<cfinput type="text" name="ssn#currentrow#" size=10 value="#DecryptedSSN#" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for #name# in the following format xxx-xx-xxxx" disabled="disabled"><br>xxx-xx-xxxx			
									</td>
								</tr>
								<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#"><td colspan="6">&nbsp;</td></tr>	
							</cfloop>	
						<cfelse>
							<tr><th colspan="7">There are no members older than 18 years living with your family.</th></tr>	
						</cfif>
					</table>
				</td></tr>		
				<tr><td colspan="2" align="center"><cfinput type="submit" name="submit" value="Proceed"></td></tr>
			</table>
		</cfform>
			
	<!--- NO FAMILY WAS FOUND - RE-ENTER LOGIN --->
	<cfelse>
		
		<cfform name="form" method="post" action="submit_cbc_menu.cfm" enctype="multipart/form-data"> 
			<table align="center" width="50%" border="0" bgcolor="white">
				<tr><th><img src="#CLIENT.exits_url#/5.gif" /></th><th valign="middle">HOST FAMILY CBC FORM SIGN IN</th></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2"><font color="FF0000">SMG could not find any records for the information provided. Please check the login information and try again.</font><br /><br /></td></tr>
				<tr><td width="20%" align="right">Host Family ID:</td><td width="80%"><cfinput type="text" name="hostid" size="10" maxlength="5" required="yes" message="You must enter the Host Family ID in order to continue."></td></tr>
				<tr><td align="right">Unique ID:</td><td><cfinput type="text" name="uniqueid" size="40" maxlength="35" validate="uuid" required="yes" message="You must enter the Unique ID in the following format xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxx in order to continue."></td></tr>
				<tr><td></td><td><font size="-1">* Unique ID Format: xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxx</font></td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">* You are over a https encrypted secure connection.</td></tr>
				<tr><td colspan="2" align="center"><cfinput type="submit" name="submit" value="Log In"></td></tr>
			</table>
		</cfform>	
	</cfif>

</cfif>

</cfoutput>

<!---

<cfquery name="get_host_families" datasource="MySqL">
	SELECT hostid, uniqueid
	FROM smg_hosts
	WHERE uniqueid = ''
</cfquery>

<cfoutput query="get_host_families">
	<cfset newuniqueid = '#CreateUUID()#'>
	<cfquery name="update" datasource="MySql">
		UPDATE smg_hosts
		SET uniqueid = '#newuniqueid#'
		WHERE hostid = '#get_host_families.hostid#'
		LIMIT 1
	</cfquery>
	#hostid# &nbsp; &nbsp; #newuniqueid# <br />
</cfoutput>

16532     F13DE84C-1320-17E0-362E81F8B60AB480 
16533     F13DE85C-1320-17E0-36909566CAF6DD98 
16534     F13DE86B-1320-17E0-36DE5F42344A43FE 
16535     F13DE87B-1320-17E0-36A580AA185032E2 
16536     F13DE88B-1320-17E0-361975385DD1BCDB 
16537     F13DE89A-1320-17E0-3693B1046EF146D0 
16539     F13DE8AA-1320-17E0-36068CC0E56D1271 
16540     F13DE8BA-1320-17E0-364120C876C4B2E0 
16541     F13DE8C9-1320-17E0-36822C832AC3476F 
16542     F13DE8D9-1320-17E0-3616A0C8D44E6B6E 
16543     F13DE8E8-1320-17E0-36C1830D62FED825 

--->
</body>
</html>