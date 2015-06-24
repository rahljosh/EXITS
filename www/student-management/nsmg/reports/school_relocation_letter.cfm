<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>School Relocation Notification Letter</title>
</head>

<body>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="program_info" datasource="MySQL">
SELECT programname, startdate, enddate
FROM smg_programs LEFT JOIN smg_students on smg_programs.programid = smg_students.programid 
WHERE smg_students.studentid = #client.studentid#
</cfquery>

<cfquery name="get_letter_info" datasource="mysql">
	SELECT 
		stu.studentid, stu.familylastname, stu.firstname, stu.arearepid, stu.regionassigned, stu.hostid, 
		stu.schoolid, stu.grades, stu.countryresident, stu.sex,
		h.hostid, h.familylastname AS h_lastname, h.address AS h_address, h.address2 AS h_address2, h.city AS h_city, h.state AS h_state, h.zip AS h_zip, h.phone as h_phone,
		sc.schoolid, sc.schoolname, sc.principal, sc.address AS sc_address, sc.address2 AS sc_address2, sc.city AS sc_city, sc.state AS sc_state, sc.zip AS sc_zip, sc.phone AS sc_phone,
		ar.userid, ar.lastname AS ar_lastname, ar.firstname AS ar_firstname, ar.address AS ar_address, ar.address2 AS ar_address2, ar.city AS ar_city, 
		ar.state AS ar_state, ar.zip AS ar_zip, ar.phone AS ar_phone,
		c.countryname
	FROM smg_students stu
	INNER JOIN smg_hosts h ON stu.hostid = h.hostid
	INNER JOIN smg_schools sc ON stu.schoolid = sc.schoolid
	INNER JOIN smg_users ar ON stu.arearepid = ar.userid
	INNER JOIN smg_countrylist c ON c.countryid = stu.countryresident
	WHERE stu.studentid = '#client.studentid#'
</cfquery>

<cfoutput>
<!--- letter header --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>	
	<td valign="top" align="right"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyname#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td></tr>		
</table>

<br>

<!--- line --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr><td><hr width=90% align="center"></td></tr>
</table>

<br>

<!--- School info --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td align="left">
			#get_letter_info.principal#<br>
			#get_letter_info.schoolname#<br>
			#get_letter_info.sc_address#<br>
			<Cfif get_letter_info.sc_address2 is ''><cfelse>#get_letter_info.sc_address2#<br></cfif>
			#get_letter_info.sc_city#, #get_letter_info.sc_state# #get_letter_info.sc_zip#<br>
		</td>
		<td align="right" valign="top">
			Program: #program_info.programname#<br>
			From: #DateFormat(program_info.startdate, 'mmm dd, yyyy')# to #DateFormat(program_info.enddate, 'mmm dd, yyyy')#	
		</td>
	</tr>
	<tr><td align="right" colspan="2">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
</table>

<br>

<!--- student info --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr><td><b>Relocation of Student: #get_letter_info.firstname# #get_letter_info.familylastname# from #get_letter_info.countryname#</b></td></tr>
</table>

<br>

<!--- host family + Area Rep --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td align="left">
			<b>Host Family:</b><br>
			#get_letter_info.h_lastname# Family<br>
			#get_letter_info.h_address#<br>
			<Cfif get_letter_info.h_address2 is ''><cfelse>#get_letter_info.h_address2#<br></Cfif>
			#get_letter_info.h_city#, #get_letter_info.h_state# #get_letter_info.h_zip#<br>
			<Cfif get_letter_info.h_phone is ''><cfelse>Phone: &nbsp; #get_letter_info.h_phone#<br></Cfif>
		</td>
		<td align="right"><div align="justify">
			<b>Area Representative:</b><br>
			#get_letter_info.ar_firstname# #get_letter_info.ar_lastname#<br>
			#get_letter_info.ar_address#<br>
			<Cfif get_letter_info.ar_address2 is ''><cfelse>#get_letter_info.ar_address2#<br></Cfif>
			#get_letter_info.ar_city#, #get_letter_info.ar_state# #get_letter_info.ar_zip#<br>
			<Cfif get_letter_info.ar_phone is ''><cfelse>Phone: &nbsp; #get_letter_info.ar_phone#<br></Cfif>
		</div></td>
	</tr>
</table>

<br>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr>
	<td>
	<div align="justify">
        <p>
        #companyshort.companyname# would like to thank you for allowing #get_letter_info.firstname# #get_letter_info.familylastname#
        to attend your school. <cfif client.companyid neq 14>#get_letter_info.firstname# is on an #companyshort.companyname# sponsored <cfif client.companyid EQ 15>F-1 <cfelse>J1</cfif> visa.</cfif>
        </p>
        
        <p>
        This letter is to inform you that #get_letter_info.firstname# has relocated to the above mentioned host family.
        </p>
        
        <p>
        We wish to let you know that #get_letter_info.firstname# is being supervised by #get_letter_info.ar_firstname# 
        #get_letter_info.ar_lastname#, <cfif companyshort.companyid is 4>a <cfelse>an </cfif>#companyshort.companyshort_nocolor# Area Representative. 
        #companyshort.companyshort_nocolor# Area Representatives act as a counselor to assist the student, school and host family should there be any
        concerns during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> stay in the US.
        </p>
        
        <p>
        Please feel free to contact #get_letter_info.ar_firstname# #get_letter_info.ar_lastname# anytime you feel it would be appropriate.
        In addition, the #companyshort.companyshort_nocolor# Student Services Department, at #companyshort.toll_free#, is available to your school,
        host family and student should there ever be a serious concern with the host family, student or area representative.
        </p>
        
        <!--- GRADUATE STUDENTS - COUNTRY 49 = COLOMBIA / COUNTRY 237 = VENEZUELA --->
        <cfif get_letter_info.grades EQ 12 OR (get_letter_info.grades EQ 11 AND (get_letter_info.countryresident EQ '49' OR get_letter_info.countryresident EQ '237'))>
        <p>
        We hope that #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
        help to increase global understanding and friendship in your school and community. We would like to note that #get_letter_info.firstname#
        will have completed secondary school in <cfif get_letter_info.sex EQ 'male'>his<cfelse>her</cfif> native country upon arrival. Please let us know if we can assist you at 
        any time during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
        </p>
        <cfelse>
        <p>
        We hope that #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
        help to increase global understanding and friendship in your school and community. Please let us know if we can assist you at 
        any time during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
        </p>
        </cfif>
        
        <p>
        Very truly yours,<br>
        #companyshort.lettersig#<br>
        #companyshort.companyname#<br>
        </p>
        </div>
	</td>
</tr>
</table>
</cfoutput>

</body>
</html>
