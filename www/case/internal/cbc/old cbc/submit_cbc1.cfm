<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>CBC Submission Form</title>
</head>

<body bgcolor=#e7e5df>

<script>
<!-- Begin
function checkCheckBox(f){
if (f.agree.checked == false )
{
alert('Please check the box to continue.');
return false;
}else
return true;
}
//onsubmit="return checkCheckBox(this)
//  End -->
</script>

<!--- <cftry> --->

<!--- SECURE CONNECTION --->
<cfif cgi.SERVER_PORT NEQ 443>
	<table align="center" width="80%" border="0" bgcolor="white">
		<tr><th><img src="https://www.student-management.com/5.gif" /></th><th valign="middle">HOST FAMILY CBC FORM SIGN IN</th></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">Dear Family,<br /><br /></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">You are not over a https encrypted secure connection. Please click <a href="https://#cgi.http_host##cgi.script_name#?#cgi.QUERY_STRING#">here</a> to login over a secure connection.</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table><br />
	<cfabort>
</cfif>

<cfif NOT IsDefined('form.hostid') AND NOT IsDefined('form.uniqueid')>
	<cflocation url="submit_cbc_menu.cfm" addtoken="no">		
</cfif>

<!--- UPDATE INFORMATION --->
<cfif IsDefined('form.check_father') AND form.fatherfirstname NEQ '' AND form.fatherlastname NEQ '' AND form.fatherdob NEQ '' AND form.fatherssn NEQ ''>
	<cfset fatherEncryptSSN = ''>
	<cfset fatherEncryptSSN = encrypt("#form.fatherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<cftransaction action="begin" isolation="serializable">
		<cfquery name="update_father" datasource="MySql">
			UPDATE smg_hosts
			SET fatherfirstname = '#form.fatherfirstname#',
				fathermiddlename = '#form.fathermiddlename#',
				fatherlastname = '#form.fatherlastname#',
				<cfif IsDefined('form.fatherssn')>fatherssn = '#fatherEncryptSSN#',</cfif>
				fatherdob = <cfif form.fatherdob EQ ''>null<cfelse>#CreateODBCDate(form.fatherdob)#</cfif>				
			WHERE hostid = <cfqueryparam value="#form.hostid#" cfsqltype="cf_sql_integer">
			LIMIT 1
		</cfquery>
	</cftransaction>
</cfif>

	<!--- 	<cfset motherEncryptSSN = ''>
	<cfif IsDefined('form.motherssn')>
		<cfset motherEncryptSSN = encrypt("#form.motherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<cfelse>
		<cfset motherEncryptSSN = ''>
	</cfif> --->

<!--- retrieve host family info --->
<cfquery name="get_host" datasource="MySql">
	SELECT h.hostid, h.familylastname, h.fatherfirstname, h.fathermiddlename, h.fatherlastname, h.fatherssn, h.fatherdob,
		h.motherfirstname, h.mothermiddlename, h.motherlastname, h.motherssn, h.motherdob,
		h.address, h.address2, h.city, h.zip,
		c.companyname, c.companyid
	FROM smg_hosts h
	LEFT JOIN smg_companies c ON h.companyid = c.companyid
	WHERE hostid = <cfqueryparam value="#form.hostid#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="get_family_members" datasource="MySql">
	SELECT childid, hostid, membertype, name, middlename, lastname, sex, ssn, birthdate, (DATEDIFF(now( ) , birthdate)/365)
	FROM smg_host_children 
	WHERE hostid = <cfqueryparam value="#hostid#" cfsqltype="cf_sql_integer">
		AND (DATEDIFF(now( ) , birthdate)/365) > 18
	ORDER BY childid
</cfquery>

<cfoutput>

<cfif IsDefined('form.check_father')>
	<cfform name="authorization" action="" method="post">
	<cfset FatherDecryptedSSN = decrypt(get_host.fatherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<table width="660" align="center" cellpadding="5" cellspacing="5" bgcolor="FFFFFF">
		<tr><td><img src="https://www.student-management.com/#get_host.companyid#.gif" /></td>
			<td><div align="justify">As mandated by the Department of State, a Criminam Background Check on all Office Staff, Regional Directors/Managers, Regional Advisors,
				Area Representatives all members of the host family aged 18 and above is required for involvement with the J-1 Secondary School Exchange
				Visitor Program.</div>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><th colspan="2">Applicant Authorization and Release<br /></th></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="2">
				<table width="100%" cellpadding="1" cellspacing="1">
					<tr>
						<td width="230">1. #get_host.fatherfirstname#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="220" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">First Name</font></div></td>
						<td width="210">#get_host.fathermiddlename#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="200" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Middle Name</font></div></td>
						<td width="210">#get_host.fatherlastname#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="200" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Last Name</font></div></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center">#DateFormat(get_host.fatherdob, 'mm/dd/yyyy')#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="220" height="1" border="0" align="absmiddle"><br /><font size="-2">Date of Birth</font></td>
						<td align="center">***-**-#Right(FatherDecryptedSSN, 4)#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="200" height="1" border="0" align="absmiddle"><br /><font size="-2">Social Security Number</font></td>
						<td align="center"><br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="200" height="1" border="0" align="absmiddle"><br /><font size="-2">Driver's License ##</font></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td colspan="3">
						<table width="100%" cellpadding="1" cellspacing="1">
							<tr>
								<td width="250">#get_host.address#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="240" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Address</font></div></td>
								<td width="150">#get_host.city#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="140" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">City</font></div></td> 
								<td width="100">#get_host.zip#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="90" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Zip</font></div></td>
								<td width="150"><br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="140" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Dates of Residence</font></div></td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>#get_host.address#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="240" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Previous Address</font></div></td>
								<td>#get_host.city#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="140" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Previous City</font></div></td> 
								<td>#get_host.zip#<br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="90" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Previous Zip</font></div></td>
								<td><br><img src="https://www.student-management.com/nsmg/pics/line.gif" width="140" height="1" border="0" align="absmiddle"><br /><div align="center"><font size="-2">Dates of Residence</font></div></td>
							</tr>
						</table>	
					</td></tr>				
					<tr><td>&nbsp;</td></tr>					
				</table>
			</td>
		</tr>
		<tr><td colspan="2"><div align="justify">
				<p>do hereby authorize verification of all information in my application for involvement with #get_host.companyname# programs from all
				necessary sources and additionally authorize any duly recognized agent of Intellicorp Records, Inc. to obtain the said records and
				any such disclosures.</p>
			
				<p>Information appearing on this Authorization will be used exclusively by IntelliCorps Records, Inc. for identification purposes and
				for the release of information that will be considered in determining any suitability for participation in the #get_host.companyname#
				programs.</p>
				
				<p>Upon proper identification and via a request submitted directly to IntelliCorps Records, Inc., I have the right to request from
				IntelliCorps Records, Inc. information about the nature and substance of all records on file about me at the time of my request.
				This may include the type of information requested as well as those who requested reports from IntelliCorps Records, Inc. within
				the two-year period preceding my request.</p></div>
			</td>
		</tr>
		<tr><td colspan="2">
				<div id="tc_id" style="BORDER-RIGHT: ##cccccc 1px solid; PADDING-RIGHT: 14px; BORDER-TOP: ##cccccc 1px solid; DISPLAY: block; PADDING-LEFT: 2px; FONT-SIZE: 10pt; OVERFLOW: scroll; BORDER-LEFT: ##cccccc 1px solid; WIDTH: 100%; PADDING-TOP: 3px; BORDER-BOTTOM: ##cccccc 1px solid; FONT-FAMILY: Courier New; HEIGHT: 100px">
					Terms and Conditions<br /><br />
					I waive and authorize #get_host.companyname# to run Crimial Background Check blah blah blah blah
					<br />
					FOR MORE INFORMATION
					<br />
					Call 1-631-893-4540
				</div>		
			</td>
		</tr>
		<tr><td colspan="2"><cfinput type="checkbox" name="agree"> &nbsp; I agree with the terms above.</td></tr>
		<tr><td colspan="2"><div align="justify">
				<p>As part of our background check reports from several sources may be obtained. Reports may include, but not be limited to,
				criminal history reports, Social Security verifications, address histories and Sex Offender Registries.
				Should any results from the aforementioned reports indicated that driving history records will need to be reviewed during
				a more comprehensive assessment, an additional authorization and relase will be requested at that time. You have the right,
				upon written request, to a complete and accurate disclosure of the nature and scope of the background check.</p>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>	
		<tr><td align="center" colspan="2"><cfinput type="submit" name="submit" value="Submit Authorization"></td></tr>
		<tr><td>&nbsp;</td></tr>	
	</table>
	</cfform>
</cfif>

</cfoutput>

</body>
</html>
