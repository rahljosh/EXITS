<!-----Company Information----->
<Cfquery name="companyshort" datasource="caseusa">
SELECT *
FROM smg_companies
WHERE companyid = #client.companyid#
</Cfquery>

<!-----Intl. Agent----->
<cfquery name="int_Agent" datasource="caseusa">
SELECT companyid, businessname, fax, email
FROM smg_users 
WHERE userid = #get_student_info.intrep#
</cfquery>

<cfoutput>
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td  valign="top" width=90><span id="titleleft">
		TO:<br>
		FAX:<br>
		E-MAIL:<br><br><br><br>		
		Today's Date:<br>
	</td>
	<td  valign="top"><span id="titleleft">
		<cfif len(#int_agent.businessname#) gt  40>#Left(int_agent.businessname,40)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		#int_agent.fax#<br>
		<a href="mailto:#int_agent.email#">#int_agent.email#</a><br><br><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>
	</td>
	<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="right"></td>	
	<td valign="top" align="right"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td></tr>		
</table><br>
</cfoutput>

<table  width=650 align="center" border=0 bgcolor="FFFFFF">
	<hr width=80% align="center">
</table><br>
