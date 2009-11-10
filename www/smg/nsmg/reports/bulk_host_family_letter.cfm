<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Host Family Welcome Letter</title>
</head>

<body>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_students" datasource="mysql">
	SELECT s.hostid, s.familylastname, s.firstname, s.arearepid, s.regionassigned, s.dateplaced,
			h.familylastname as hostlastname, h.address, h.address2, h.city, h.state, h.zip,  
			c.countryname, 
			p.programname, p.startdate, p.enddate
	FROM smg_students s
	LEFT JOIN smg_hosts h ON h.hostid = s.hostid
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	INNER JOIN smg_users u ON u.userid = s.intrep
	WHERE s.active = '1'
		AND s.hostid != '0'
		AND s.host_fam_approved <= '4'
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
			AND (s.dateplaced between #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#) 
		</cfif>
		AND (<cfloop list="#form.programid#" index="prog">
				s.programid = '#prog#' 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		<cfif form.insurance_typeid NEQ 0>
			AND u.insurance_typeid = '#form.insurance_typeid#'
		</cfif>
	ORDER BY h.familylastname, s.familylastname, s.firstname
</cfquery>

<cfoutput query="get_students">
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
</table><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr><td><hr width=90% align="center"></td></tr>
</table><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td align="left">The #hostlastname# Family<br>
			#address#<br>
			<Cfif address2 is ''><cfelse>#address2#<br></Cfif>
			#city#, #state# #zip#
		</td>
		<td align="right">
			Program: #programname#<br>
			From: #DateFormat(startdate,'mmm. d, yyyy')# thru #DateFormat(enddate,'mmm. d, yyyy')#<br><br>
		</td>
	</tr>
<tr><td align="right" colspan="2"><cfif dateplaced LTE '2007-07-30'>#DateFormat(dateplaced, 'dddd, mmmm dd, yyyy')#<cfelse>#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</cfif></td></tr>
</table><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td><div align="justify">
			Dear #hostlastname# Family,
			
			<p>On behalf of everyone at #companyshort.companyshort_nocolor#, we would like to thank you for opening up your heart and
			home for #firstname# #familylastname# from #countryname#.</p>
			
			<p>We know that this experience will be a wonderful one for you and your family. By sharing
			your life with a young international student, you are giving your student the opportunity of a
			lifetime. Many students dream about living with an American family. It is only through
			families such as yours that this dream can become a reality.</p>
			
			<p>
			<Cfquery name="rep_info" datasource='mysql'>
				SELECT userid, firstname, lastname, phone
				FROM smg_users WHERE userid = '#get_students.arearepid#'
			</cfquery>
			<cfquery name="rd" datasource="MySQL">
				SELECT smg_users.userid, firstname, lastname, phone
				FROM smg_users
				INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid
				WHERE user_access_rights.regionid = '#get_students.regionassigned#' and user_access_rights.usertype = '5'
			</cfquery>
			
			#companyshort.companyshort_nocolor# provides you with full support throughout #get_students.firstname#'<cfif #right(get_students.firstname, 1)# is 's'><cfelse>s</cfif> stay. 
			Your supervising Area Representative is #rep_info.firstname# #rep_info.lastname#, Phone Number: #rep_info.phone#.
			The Regional Director is #rd.firstname# #rd.lastname#, Phone Number: #rd.phone#.
			</p>
			
			<p>
			#get_students.firstname# has already received the insurance information package containing an Insurance ID Card, 
			claim forms and instructions on how to use them. At any time you can also contact #rep_info.firstname# #rep_info.lastname#
			for information regarding the student's insurance, in case the student needs any assistance.
			</p>
			
			<p>
			#rep_info.firstname# #rep_info.lastname# will make monthly contact with #get_students.firstname# and is always available to you should
			you have any concerns during the program. Enclosed is a host family handbook, student and HF evaluation packets and information 
			regarding the student's insurance. Please be sure to read and review all the information contained in the
			handbook. Please also encourage #get_students.firstname# to read and understand the guidelines in the student
			handbook. Sometime before #get_students.firstname#'<cfif #right(get_students.firstname, 1)# is 's'><cfelse>s</cfif>  
			arrival, you will be contacted by your Area Representative for an
			orientation. At this meeting your Area Representative will review the
			handbook with you and will answer any questions you and your family might have.
			</p>
			
			<p>
			Again, we thank you for sharing in our mission of making the world a little smaller, one
			student at a time.
			</p>
			
			<p>
			Very truly yours,<br><br>
			#companyshort.lettersig#<br>
			#companyshort.companyname#<br>
			</p></div>
		</td>
	</tr>
</table>

<div style="page-break-after:always;"></div><br>

</cfoutput>
</body>
</html>