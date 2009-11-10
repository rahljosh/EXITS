<cfif isdefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<cfquery name="get_student_info" datasource="mysql">
	SELECT  s.familylastname, s.firstname, s.hostid, s.doubleplace, s.arearepid, s.regionassigned, s.ds2019_no, s.sex,
			h.familylastname as hostlastname, h.city, h.state,
			c.countryname,
			p.programname, p.startdate
	FROM smg_students s
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_hosts h ON h.hostid = s.hostid
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.studentid = #client.studentid#
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfif get_student_info.doubleplace EQ ''>
	This student is not assigned on a Double Placement
	<cfabort>
</cfif>

<!--- Double Placement Student --->
<cfquery name="double_placement" datasource="MySQL">
	SELECT s.firstname, s.familylastname, s.ds2019_no,
			c.countryname, s.sex,
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
	<td valign="top" align="right"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td>
</tr>		
</table>
</cfoutput>
<br>
<br>
<cfoutput>
<table  width=650 align="center" border=0 bgcolor="FFFFFF" >	
<tr><td class="style1" align="left">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br><br>
	VIA FACSIMILE 202-203-5087<br>
	Ms. Sally Lawrence<br>
	Private Sector Programs Division (ECA/EC/PS)<br>
	Office of Exchange Coordination and Designation<br>
	U.S. Department of State - SA-44<br>
	301 4<sup>th</sup> Street, SW, Rm. 734<br>
	Washington, D.C. 20547<br><br>
	<div align="right">REF: #companyshort.iap_auth#</div>
<!---	
	VIA FACSIMILE 202-203-5087<br>
	Ms. Sally Lawrence<br>
	Program Designation Officer<br>
	Academic and Government Programs Division<br>
	Office of Exchange Coordination and Designation<br>
	Room 734<br>
	U.S. Department of State<br>
	301 4<sup>th</sup> Street, S.W.<br>
	Washington, D.C. 20547<br><br>
	<div align="right">REF: #companyshort.iap_auth#</div>
---->
</td></tr>
</table><br>

<table  width=650 align="center" border=0 bgcolor="FFFFFF">	
<tr><td class="style1">Dear Ms. Sally Lawrence:<br><br></td></tr>
<tr><td class="style1">
<div align="justify">This letter is to request approval for a double placement of the two students listed below with the indicated host family,
per the requirements stated in the Exchange Visitor program regulations at CFR 62.25 (1)(1)(ii).</div><br><br></td></tr>
</table>

<table width=650 align="center" cellpadding=12 cellspacing="0" frame="below">
<tr>
	<td colspan="4" class="style1">Host Family: &nbsp; #get_student_info.hostlastname# Family residing in #get_student_info.city#, #get_student_info.state#</td>
</tr>
<tr>
	<td width="20" class="style1" valign="top">1.</td>
	<td width="300" class="style1" valign="top">#UCASE(RTRIM(get_student_info.firstname))# #UCASE(RTRIM(get_student_info.familylastname))# <br>
		DS2019 no.: &nbsp; #get_student_info.ds2019_no# <br>
		Program Start Date: &nbsp; #DateFormat(get_student_info.startdate, 'mm/dd/yyyy')#</td>
	<td class="style1" valign="top"><p>FROM</p>
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
	<td class="style1" valign="top"><p>FROM</p>
	  <p>GENDER</p></td>
	<td class="style1" valign="top"><p>#UCASE(RTRIM(get_student_info.countryname))#</p>
	  <p>#UCASE(RTRIM(get_student_info.sex))#</p></td>
	</cfif>
</tr>
</table>


<BR><BR>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
<tr><td class="style1" >Signed agreements for this arrangement from the host family, students and their natural parents, and the
						host school are enclosed for your records.<br><br></td></tr>
<tr>
	<td class="style1" colspan="2"><div align="justify">
	Sincerely,<br><br><br>
	#companyshort.dos_letter_sig#<br>
	#companyshort.dos_letter_title#<br>
	#companyshort.companyname#</td>
</tr>
</table>
<br><br>
</cfoutput>