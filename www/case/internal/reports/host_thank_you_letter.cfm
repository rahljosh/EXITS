<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="family_info" datasource="caseusa">
	SELECT smg_hosts.familylastname, smg_hosts.address, smg_hosts.address2, smg_hosts.city, smg_hosts.state, smg_hosts.zip, smg_students.hostid, 
			smg_students.familylastname as lastname, smg_students.firstname, smg_students.regionassigned, smg_students.arearepid, smg_students.regionassigned,
			c.countryname
	FROM smg_students
	LEFT OUTER JOIN smg_hosts ON smg_hosts.hostid = smg_students.hostid
	INNER JOIN smg_countrylist c ON c.countryid = smg_students.countryresident
	WHERE smg_students.studentid = #client.studentid#
</cfquery>

<cfquery name="program_info" datasource="caseusa">
	SELECT programname, startdate, enddate
	FROM smg_programs left join smg_students on smg_programs.programid = smg_students.programid 
	WHERE smg_students.studentid = #client.studentid#
</cfquery>

<Cfquery name="rep_info" datasource='caseusa'>
	SELECT firstname, lastname, phone
	FROM smg_users WHERE userid = #family_info.arearepid#
</cfquery>

<cfquery name="regional_manager" datasource="caseusa">
	SELECT u.firstname, u.lastname, u.phone
	FROM smg_users u
	INNER JOIN user_access_rights uar ON uar.userid = u.userid
	WHERE uar.regionid = '#family_info.regionassigned#' 
		AND uar.usertype = '5'
</cfquery>

<cfoutput>
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
		<td align="left">The #family_info.familylastname# Family<br>
			#family_info.address#<br>
			<Cfif family_info.address2 is ''><cfelse>#family_info.address2#<br></Cfif>
			#family_info.city#, #family_info.state# #family_info.zip#
		</td>
	</tr>
<tr><td align="right" colspan="2">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
</table><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
<tr><td><div align="justify">
Dear #family_info.familylastname# Family,

<p>On behalf of everyone at #companyshort.companyname#, we would like to thank you for having hosted
#family_info.firstname# #family_info.lastname#. We hope that your experience has helped your family to increase
their knowledge of a different culture. It is our sincerest hope that the relationship your family has developed with
#family_info.firstname# will continue forever.</p>

<p>Please extend our thanks to people in your community who have helped to make #family_info.city# a home to #family_info.firstname#.
If there is someone special we should acknowledge, please contact us and we will be glad to do so.</p>

<p>
#companyshort.companyshort# is always looking for warm and loving families to participate in this experience. If you know of 
any families who would like to become involved, please let your area representative, #rep_info.firstname# 
#rep_info.lastname#, know whom they might be. #rep_info.firstname# may be contacted at #rep_info.phone# and your regional
office may be contacted at #regional_manager.phone#. We would be happy to explain our program to them.
</p>

<p>
We have enclosed a program evaluation with this letter. Please take a few minutes to complete it and return it to us. We strive
to improve our program and carefully evaluate all suggestions for improvement. In addition, we are always eager to hear about
the good experiences you have had with your student.
</p>

<p>
Again, thank you for your participation. It is only through the efforts of families such as yours that we continue to meet
our mission of sharing the cultures of the world.
</p>

<br><br>

<p>
Very truly yours,<br><br>


#regional_manager.firstname# #regional_manager.lastname#<br>
#companyshort.companyname#<br>
</p></div></td></tr>
</cfoutput>