<style type="text/css" media="print">
	.page-break {page-break-after: always}
	.page-header{text-align:right; width:650px; }
</style>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_studentss" datasource="mysql">
	SELECT s.studentid, s.familylastname, s.firstname, s.arearepid, s.regionassigned, s.hostid, s.dateplaced, 
		s.schoolid, s.grades, s.countryresident, s.sex, s.dateplaced,
		h.hostid, h.familylastname AS h_lastname, h.address AS h_address, h.address2 AS h_address2, h.city AS h_city, h.state AS h_state, h.zip AS h_zip, h.phone as h_phone,
		sc.schoolid, sc.schoolname, sc.principal, sc.address AS sc_address, sc.address2 AS sc_address2, sc.city AS sc_city, sc.state AS sc_state, sc.zip AS sc_zip, sc.phone AS sc_phone,
		ar.userid, ar.lastname AS ar_lastname, ar.firstname AS ar_firstname, ar.address AS ar_address, ar.address2 AS ar_address2, ar.city AS ar_city, 
		ar.state AS ar_state, ar.zip AS ar_zip, ar.phone AS ar_phone,
		c.countryname,
		p.programname, p.startdate, p.enddate
	FROM smg_students s
	INNER JOIN smg_hosts h ON s.hostid = h.hostid
	INNER JOIN smg_schools sc ON s.schoolid = sc.schoolid
	INNER JOIN smg_users ar ON s.arearepid = ar.userid
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
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
	ORDER BY s.familylastname, s.firstname	
</cfquery>

<cfoutput query="get_studentss">
<div class="page-break">
<!--- letter header --->
<div class="page-header">
<img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left">
	
		
		#companyshort.companyname#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif>
</div>

<!--- line --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr><td><hr width=90% align="center"></td></tr>
</table>

<!--- School info --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td align="left">
			#principal#<br>
			#schoolname#<br>
			#sc_address#<br>
			<Cfif sc_address2 is ''><cfelse>#sc_address2#<br></cfif>
			#sc_city#, #sc_state# #sc_zip#<br>
		</td>
		<td align="right" valign="top">
			Program: #programname#<br>
			From: #DateFormat(startdate, 'mmm dd, yyyy')# to #DateFormat(enddate, 'mmm dd, yyyy')#	
		</td>
	</tr>
	<tr><td align="right" colspan="2"><cfif dateplaced LTE '2007-07-30'>#DateFormat(dateplaced, 'dddd, mmmm dd, yyyy')#<cfelse>#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</cfif></td></tr>
</table>
<br>
<!--- student info --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr><td><b>Student: #firstname# #familylastname# from #countryname#</b></td></tr>
</table>
<br>
<!--- host family + Area Rep --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td align="left">
			<b>Host Family:</b><br>
			#h_lastname# Family<br>
			#h_address#<br>
			<Cfif h_address2 is ''><cfelse>#h_address2#<br></Cfif>
			#h_city#, #h_state# #h_zip#<br>
			<Cfif h_phone is ''><cfelse>Phone: &nbsp; #h_phone#<br></Cfif>
		</td>
		<td align="right">
			<b>Area Representative:</b><br>
			#ar_firstname# #ar_lastname#<br>
			#ar_address#<br>
			<Cfif ar_address2 is ''><cfelse>#ar_address2#<br></Cfif>
			#ar_city#, #ar_state# #ar_zip#<br>
			<Cfif ar_phone is ''><cfelse>Phone: &nbsp; #ar_phone#<br></Cfif>
		</td>
	</tr>
</table>
<br>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td align="justify">
			<p>#companyshort.companyname# would like to thank you for allowing #firstname# #familylastname#
			to attend your school. #companyshort.companyshort# has issued a DS 2019 for #firstname# and 
			#firstname# is now in the process of securing a J1 visa.
			</p>
			
			<p>We have asked the #h_lastname# family to help #firstname# in enrolling and registering
			in your school.
			</p>
			
			<p>We wish to let you know that #firstname# is being supervised by #ar_firstname# 
			#ar_lastname#, <cfif companyshort.companyid is 4>a <cfelse>an </cfif>#companyshort.companyshort# Area Representative. 
			#companyshort.companyshort# Area Representatives act as a counselor to assist the student, school and host family should there be any
			concerns during #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> stay in the US.
			</p>
			
			<p>Please feel free to contact #ar_firstname# #ar_lastname# anytime you feel it would be appropriate.
			In addition, the #companyshort.companyshort# Student Services Department, at #companyshort.toll_free#, is available to your school,
			host family and student should there ever be a serious concern with the host family, student or area representative.
			</p>
			
			<!--- GRADUATE STUDENTS - COUNTRY 49 = COLOMBIA / COUNTRY 237 = VENEZUELA --->
			<cfif grades EQ 12 OR (grades EQ 11 AND (countryresident EQ '49' OR countryresident EQ '237'))>
			<p>We hope that #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
			help to increase global understanding and friendship in your school and community. We would like to note that #firstname#
			will have completed secondary school in <cfif sex EQ 'male'>his<cfelse>her</cfif> native country upon arrival. Please let us know if we can assist you at 
			any time during #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
			</p>
			<cfelse>
			<p>We hope that #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
			help to increase global understanding and friendship in your school and community. Please let us know if we can assist you at 
			any time during #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
			</p>
			</cfif>
			
			<p>Very truly yours,<br>
			#companyshort.lettersig#<br>
			#companyshort.companyname#<br>
			</p>
			
		</td>
	</tr>
</table>
</td>
</Tr>
</table>
<!----
<div style="page-break-after:always;">&nbsp;</div>
---->
</div>
</cfoutput>

