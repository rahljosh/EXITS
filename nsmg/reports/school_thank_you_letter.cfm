<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="program_info" datasource="MySQL">
SELECT programname, startdate, enddate
FROM smg_programs LEFT JOIN smg_students on smg_programs.programid = smg_students.programid 
WHERE smg_students.studentid = #client.studentid#
</cfquery>

<cfquery name="get_letter_info" datasource="mysql">
SELECT 
	stu.studentid, stu.familylastname, stu.firstname, stu.arearepid, stu.regionassigned, stu.hostid, stu.schoolid,
	sc.schoolid, sc.schoolname, sc.principal, sc.address AS sc_address, sc.address2 AS sc_address2, sc.city AS sc_city, 
	sc.state AS sc_state, sc.zip AS sc_zip, sc.phone AS sc_phone,
	c.countryname
FROM smg_students stu
LEFT OUTER JOIN smg_schools sc ON sc.schoolid = stu.schoolid
INNER JOIN smg_countrylist c ON c.countryid = stu.countryresident
WHERE stu.studentid = #client.studentid#
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
			Mr. #get_letter_info.principal#<br>
			#get_letter_info.schoolname#<br>
			#get_letter_info.sc_address#<br>
			<Cfif get_letter_info.sc_address2 is ''><cfelse>#get_letter_info.sc_address2#<br></cfif>
			#get_letter_info.sc_city#, #get_letter_info.sc_state# #get_letter_info.sc_zip#<br>
		</td>
	</tr>
	<tr><td align="right">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
</table>
<br><br>
<!--- student info --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr><td><b>Student: #get_letter_info.firstname# #get_letter_info.familylastname# from #get_letter_info.countryname#</b></td></tr>
</table>
<br><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr><td><div align="justify">
<p>
On behalf of everyone at the #companyshort.companyname#, we would like to thank you for having allowed #get_letter_info.firstname# 
#get_letter_info.familylastname# to attend #get_letter_info.schoolname#. We hope that this experience has helped your school and
community to increase their knowledge of a different culture. It is our sincerest hope that the friendships that were developed
between #get_letter_info.firstname# and the school community will continue forever.
</p>

<p>
Please extend our thanks to your faculty and staff who have helped #get_letter_info.firstname# learn first hand about the American
educational system and American culture. We hope that #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif>
interaction with your school and community has helped to foster an increased sense of global awareness.
</p>

<p>
We have enclosed a program evaluation form with this letter. Please take a few minutes to complete it and return it to us.
We strive to improve our program and carefully evaluate all suggestions for improvement. In addition we are always eager to hear
about the good experiences you have had with your student.
</p>

<p>
Again, thank you for your school's participation. It is only through the efforts of school such as yours that we can continue
to meet our mission of making the world a little smaller, one person at a time.
</p>

<br>

<p>
Very truly yours,<br><br><br>

#companyshort.companyname#<br>
</p></div></td></tr>
</cfoutput>