<cfif isdefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<cfquery name="get_student_info" datasource="mysql">
	SELECT s.familylastname, s.address, s.address2, s.city, s.zip, s.hostid, s.doubleplace, s.familylastname, s.firstname, s.ds2019_no, s.sex,
			s.arearepid, s.regionassigned, s.programid, s.intrep,
			c.countryname,
			p.startdate
	FROM smg_students s
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.studentid = '#client.studentid#'
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Double Placement Student --->
<cfquery name="double_placement" datasource="MySQL">
	SELECT s.firstname, s.familylastname, s.ds2019_no, s.sex,
			c.countryname,
			p.startdate
	FROM smg_students s
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.studentid = #get_student_info.doubleplace#
</cfquery>

<link rel="stylesheet" href="../profile.css" type="text/css">

<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>

<!--- include template page header --->
<cfinclude template="report_header.cfm">

<cfoutput>
<table  width=650 align="center" border=0 bgcolor="FFFFFF" >	
	<tr><td class="style1">
    <div align="justify">		
		<p>Request for a Double Placement</p>
		<p>#companyshort.companyname# is requesting a double placement for the following two students:</p>
	 </div></td></tr>
</table>
<br>
<table width=650 align="center" cellpadding=12 cellspacing="0" frame="below">
<tr>
	<td width="20" class="style1" valign="top">1.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(get_student_info.firstname))# #UCASE(RTRIM(get_student_info.familylastname))# <br>
		DS2019 no.: &nbsp; #get_student_info.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(get_student_info.startdate, 'mm/dd/yyyy')#</td>
	<td width="80" class="style1" valign="top"><p>FROM</p>
    <p>GENDER</p></td>
	<td class="style1" valign="top"><p>#UCASE(RTRIM(get_student_info.countryname))#</p>
	  <p>#UCASE(RTRIM(get_student_info.sex))#</p></td>
</tr>
<tr>
	<cfif get_student_info.doubleplace is 0>
		<td colspan="4" class="style1"><b><font color="FF0000">There is no double placement assigned for the student above.</font><font color="FF0000"></font></b></td>
	<cfelse>
	<td class="style1" valign="top">2.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(double_placement.firstname))# #UCASE(RTRIM(double_placement.familylastname))# <br>
		DS2019 no.: &nbsp; #double_placement.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(double_placement.startdate, 'mm/dd/yyyy')#</td>

	
	 <td width="80" class="style1" valign="top"><p>FROM</p>
    <p>GENDER</p></td>
	<td class="style1" valign="top"><p>#UCASE(RTRIM(double_placement.countryname))#</p>
	  <p>#UCASE(RTRIM(double_placement.sex))#</p></td>
	</cfif>

</table>

<BR>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
<tr><td class="style1"><div align="justify">
	<p>As you may know, the Department of State requires that the student, the natural family and the international representative 
	agree in writing to any double placements.</p>
	<p>Please sign on the lines below and return to #companyshort.companyshort_nocolor# so that we may finalize the placement.</p>
	<p>Thank you.</p>
	</div>
</td></tr>
</table>
</cfoutput>
		
<BR>

<table width=650 border=0 align="center" bgcolor="FFFFFF" cellpadding=6 cellspacing="0">
<tr>
	<td class="style1" width="150" align="right">Student:</td>
	<td class="style1" width="260">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1" width="200"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date </cfoutput></td>
</tr>
<tr><td class="style1"><br></td></tr>
<tr>
	<td class="style1" align="right">Print Name:</td>
	<td class="style1" colspan="2">___________________________________________</td>
</tr>
<tr><td class="style1"><br></td></tr>
<tr>
	<td class="style1" align="right">Student:</td>
	<td class="style1">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1"><cfoutput><u>#dateFormat(now(), 'mmm. dd, yyyy')#</u><br>date </cfoutput></td>
</tr>
<tr><td class="style1"><br></td></tr>
<tr>
	<td class="style1" align="right">Print Name:</td>
	<td class="style1" colspan="2">___________________________________________</td>
</tr>
<tr><td class="style1"><br><br></td></tr>
<tr><td class="style1" colspan="3">By signing this, we agree to the double placement.</td></tr>
</table>