<cfif isdefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_info" datasource="mysql">
	SELECT s.familylastname, s.address, s.address2, s.city, s.zip, s.hostid, s.doubleplace, s.familylastname, s.firstname, s.ds2019_no, s.sex,
			s.arearepid, s.regionassigned, s.programid, s.schoolid,
			c.countryname,
			p.programname, p.startdate
	FROM smg_students s
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.studentid = '#client.studentid#'
</cfquery>

<!--- Double Placement Student --->
<cfquery name="double_placement" datasource="MySQL">
	SELECT s.firstname, s.familylastname, s.countryresident, c.countryname, s.schoolid, s.hostid, s.ds2019_no, s.sex,
			p.programname, p.startdate
	FROM smg_students s
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.studentid = '#get_student_info.doubleplace#'
</cfquery>

<cfquery name="get_hf" datasource="MySql">
	SELECT hostid, familylastname, fatherfirstname, fatherlastname, motherfirstname, motherlastname, address, city, state, zip
	FROM smg_hosts
	WHERE hostid = '#get_student_info.hostid#'
</cfquery>

<cfquery name="get_school" datasource="MySql">
	SELECT schoolid, schoolname, address, city, state, zip
	FROM smg_schools
	WHERE schoolid = '#get_student_info.schoolid#'
</cfquery>

<link rel="stylesheet" href="../profile.css" type="text/css">

<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>

<!--- template page header --->
<cfoutput>
<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr>
	<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>	
	<td align="center">
		<br><br>
		<font size="+1">REQUEST FOR A DOUBLE PLACEMENT</font>
		<br><br>
	</td>
	<td  align="right"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort_nocolor#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td>
</tr>		
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" >	
	<tr><td class="style1">
		TO : &nbsp; <cfif get_student_info.schoolid is double_placement.schoolid>#get_school.schoolname#</cfif><br><br></td></tr>
	<tr><td class="style1">
		FROM :  &nbsp; #companyshort.companyname#<br><br></td></tr>
	<tr><td class="style1">
		DATE : &nbsp; #DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br><br></td></tr>
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" >	
	<tr><td class="style1">
    <div align="justify">		
		<p>Request for a Double Placement</p>
		<p>#companyshort.companyname# is requesting a double placement for the following two students:</p>
	 </div></td></tr>
</table>

<table width=650 align="center" cellpadding=8 cellspacing="0" frame="below">
<tr>
	<td width="20" class="style1" valign="top">1.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(get_student_info.firstname))# #UCASE(RTRIM(get_student_info.familylastname))# <br>
		DS2019 no.: &nbsp; #get_student_info.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(get_student_info.startdate, 'mm/dd/yyyy')#</td>
	<td width="80" class="style1" valign="top"><p>FROM</p>
	  <p>GENDER</p>
	  </td>
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
</tr>
</table>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
<tr><td class="style1"><div align="justify">
	<p>As you may know, the Department of State requires that the student, the natural family and the international representative 
	agree in writing to any double placements.</p>
	<p>Please sign on the lines below and return to #companyshort.companyshort_nocolor# so that we may finalize the placement.</p>
	</div>
</td></tr>
</table>

<table width=650 border=0 align="center" bgcolor="FFFFFF" cellpadding=4 cellspacing="0">
<tr valign="top">
	<td class="style1" width="280" align="right">Host Mother Name: </td>
	<td class="style1" width="260">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1" width="110">____/____/____<br>date </td>
</tr>
<tr>
	<td class="style1" align="right">Print Name: </td>
	<td class="style1" colspan="2"><cfif get_student_info.hostid is double_placement.hostid><u>#get_hf.motherfirstname# #get_hf.motherlastname#</u><cfelse>__________________________________________________ </cfif> </td>
</tr>
<tr valign="top">
	<td class="style1" align="right">Host Father Name:</td>
	<td class="style1">___________________________________________<br><font size="-1">signature</font> </td>
	<td class="style1">____/____/____<br>date </td>
</tr>
<tr>
	<td class="style1" align="right">Print Name: </td>
	<td class="style1" colspan="2"><cfif get_student_info.hostid is double_placement.hostid><u>#get_hf.fatherfirstname# #get_hf.fatherlastname#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr>
	<td class="style1" align="right">Address: &nbsp; </td>
	<td class="style1" colspan="2"><cfif get_student_info.hostid is double_placement.hostid><u>#get_hf.address#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr>
	<td class="style1" align="right">&nbsp;</td>
	<td class="style1" colspan="2"><cfif get_student_info.hostid is double_placement.hostid><u>#get_hf.city#, #get_hf.state# #get_hf.zip#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td class="style1" align="right">School Name: </td>
	<td class="style1" colspan="2"><cfif get_student_info.schoolid is double_placement.schoolid><u>#get_school.schoolname#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr>
	<td class="style1" align="right">School: </td>
	<td class="style1">___________________________________________<br><font size="-1"><font size="-1">signature</font></font> </td>
	<td class="style1">______________<br>title </td>
</tr>
<tr valign="top">
	<td class="style1" align="right">Print Name: </td>
	<td class="style1">___________________________________________ </td>
	<td class="style1">____/____/____<br>date </td>
</tr>
<tr>
	<td class="style1" align="right">Address: </td>
	<td class="style1" colspan="2"><cfif get_student_info.schoolid is double_placement.schoolid><u>#get_school.address#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr>
	<td class="style1" align="right">&nbsp;</td>
	<td class="style1" colspan="2"><cfif get_student_info.schoolid is double_placement.schoolid><u>#get_school.city#, #get_school.state# #get_school.zip#</u><cfelse>__________________________________________________ </cfif></td>
</tr>
<tr><td><br></td></tr>
<tr><td class="style1" colspan="2">
	<div align="justify">
		By signing this, we agree that the two students listed above will live with the above host
		 family while participating in the #companyshort.companyshort_nocolor# Program.</div></td></tr>
<tr><td class="style1">Thank you.</td></tr>
</table>
</cfoutput>		 