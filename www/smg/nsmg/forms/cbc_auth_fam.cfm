<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
<style>
.bottom 	{border-bottom: 1px solid #000000;
text-align:center;
}
</style>
</head>

<body>

<cfquery name="original_company_info" datasource="MySQL">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>
<cfquery name="user_info" datasource="mysql">
select firstname, lastname, middlename,  ssn, dob,
drivers_license
from smg_user_family
where userid = #url.userid#
</cfquery>
<cfquery name="address" datasource="mysql">
select smg_users.address, smg_users.address2, smg_users.city, smg_users.state, 
 smg_users.zip, smg_states.statename
from smg_users
LEFT JOIN smg_states  on smg_states.id = smg_users.state
where uniqueid = '#url.id#'
</cfquery>


<cfoutput query=user_info>
<cfif cgi.SERVER_PORT eq 443 and ssn is not ''>
				<cfset key='BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>
				<cfset decryptedssn = decrypt(ssn, key, "desede", "hex")>
				<cfelse>
				<cfset decryptedssn = #ssn#>
				</cfif>
<table width=612 align="center">
	<tr>
		<td><img src="../pics/logos/#original_company_info.companyshort#_clear.gif"></td>
		<td>
		As mandated by the Department of State, a Criminal Background Check on all
		Office Staff, Regional Directors/Managers, Regional Advisors, Area
		Representatives all members of the host family aged 18 and above is required for
		involvement with the J-1 Secondary School Exchange Visitor Program.
		</td>
	</tr>
	<tr>
		<td align="center" colspan=2><br><h3>Applicant Authorization and Release</h2></td>
	</tr>
</table>
<table  width=612 align="center" border=0>
	<tr>
		<Td width=5>I,</Td><td class="bottom" >#firstname#</td><td class="bottom"  >#middlename#&nbsp;</td> <td class="bottom" >#lastname#</td> </td>
	</tr>
	<tr>
		<td></td><td valign="top" align="center"><font size=-2>First Name</font></td><td valign="top" align="center"><font size=-2>Middle Name</font></td><td valign="top" align="center"><font size=-2>Last Name</font></td>
	</tr>
		<tr>
		<Td width=5></Td><td class="bottom">#DateFormat(dob, 'mmm dd, yyyy')#&nbsp;</td><td class="bottom">#decryptedssn#&nbsp;</td> <td class="bottom">#drivers_license#&nbsp;</td> 
	</tr>
	<tr>
		<td></td><td valign="top" align="center"><font size=-2>Date of Birth</font></td><td valign="top" align="center"><font size=-2>Socail Security Number</font></td><td valign="top" align="center"><font size=-2>Driver's License ##</font></td>
	</tr>
	</tr>
		<tr>
		<Td width=5></Td><td class="bottom" colspan=2>#address.address# #address.address2# #address.city#, #address.state# #address.zip# </td> <td class="bottom">&nbsp;</td> 
	</tr>
	<tr>
		<td></td><td valign="top" align="center" colspan=2><font size=-2>Address</font></td><td valign="top" align="center"><font size=-2>Dates of Residence</font></td>
	</tr>
	<tr>
		<Td width=5></Td><td class="bottom" colspan=2>&nbsp; </td> <td class="bottom">&nbsp;</td> 
	</tr>
	<tr>
		<td></td><td valign="top" align="center" colspan=2><font size=-2>Address</font></td><td valign="top" align="center"><font size=-2>Dates of Residence</font></td>
	</tr>
	<tr>
		<td colspan=4>
		<p>do hereby authorize verification of all information in my application for involvement with International
Student Exchange programs from all necessary sources and additionally authorize any duly recognized
agent of IntelliCorp Records, Inc. to obtain the said records and any such disclosures.</p>
<p>Information appearing on this Authorization will be used exclusively by IntelliCorp Records, Inc. for
identification purposes and for the release of information that will be considered in determining any
suitability for participation in the #original_company_info.companyname# programs.</p>
<p>Upon proper identification and via a request submitted directly to IntelliCorp Records, Inc., I have the
right to request from IntelliCorp Records, Inc. information about the nature and substance of all records
on file about me at the time of my request. This may include the type of information requested as well
as those who requested reports from IntelliCorp Records, Inc. within the two-year period preceding my
request.</p>
		</td>
	</tr>
</table>
<br><br>
<table width=612 align="center" border=0>
		<tr>
		<td class="bottom">#firstname#  #lastname# </td><td class="bottom">&nbsp; </td> <td class="bottom">#DateFormat(now(), 'mmm dd, yyyy')#</td> 
	</tr>
	<tr>
		<td valign="top" align="center"><font size=-2>Printed Name</td><td valign="top" align="center"><font size=-2>Applicant Signature</font></td><td valign="top" align="center"><font size=-2>Date</font></td>
	</tr>
	<tr>
	<td colspan=3>
	<br>
<br>
<br>
<strong>As part of our background check reports from several sources may be obtained. Reports may include, but
not be limited to, criminal history reports, Social Security verifications, address histories and Sex Offender
Registries. Should any results from the aforementioned reports indicate that driving history records will
need to be reviewed during a more comprehensive assessment, an additional authorization and release will
be requested at that time. You have the right, upon written request, to a complete and accurate disclosure
of the nature and scope of the background check.</strong>
	</td>
	</tr>
	
</table>



</cfoutput>
</body>
</html>

