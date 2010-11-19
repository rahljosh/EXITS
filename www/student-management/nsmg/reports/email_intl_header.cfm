<cfoutput>
<table width="650" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px">
	<tr><td  valign="top" width=90>TO:<br>	E-MAIL:<br><br><br><br> Today's Date:<br></td>
	<td  valign="top">
		#GetIntlReps.firstname# #GetIntlReps.lastname# - #GetIntlReps.businessname#<br>
		#GetIntlReps.email#</a><br><br><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#
	</td>
	<td><img src="#CLIENT.exits_url#/nsmg/pics/logos/#client.companyid#.gif"  alt="" border="0" align="right"></td>	
	<td valign="top" align="right"> 
		<div align="right">
		#companyshort.companyshort_nocolor#<br>#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br>
		<cfif LEN(companyshort.phone)> Phone: #companyshort.phone#<br></cfif>
		<cfif LEN(companyshort.toll_free)> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif LEN(companyshort.fax)> Fax: #companyshort.fax#<br></cfif></div>
	</td></tr>		
</table>
</cfoutput>