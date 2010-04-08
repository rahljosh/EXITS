<cfoutput>
<table width="650" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px">
	<tr><td  valign="top" width=90>TO:<br>	E-MAIL:<br><br><br><br> Today's Date:<br></td>
	<td  valign="top">
		#GetIntlReps.firstname# #GetIntlReps.lastname# - #GetIntlReps.businessname#<br>
		#GetIntlReps.email#</a><br><br><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#
	</td>
	<td><img src="#ImgScrPath#/nsmg/pics/logos/#companyshort.companyid#.gif"  alt="" border="0" align="right"></td>	
	<td valign="top" align="right"> 
		<div align="right">
		#companyshort.companyshort#<br>#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td></tr>		
</table>
</cfoutput>