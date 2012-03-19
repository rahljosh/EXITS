	</td>
    </tr>
    </table>
<cfoutput>

 <Cfquery name="company_info" datasource="#application.dsn#">
 select fax, toll_free, phone, company_color
 from smg_companies
 where companyid = #client.companyid#
 </Cfquery>
<table width="98%">
	  <tr>
     	<td colspan=2 bgcolor="#company_info.company_color#" align="center"><font color="##FFFFFF" size=-2><cfif company_info.toll_free is not ''>Toll-free: #company_info.toll_free# &middot;</cfif><cfif company_info.phone is not ''> Local: #company_info.phone# &middot;</cfif> <cfif company_info.fax is not ''>Fax: #company_info.fax#</cfif> </font></td>
	 </tr>
</table>
</div>
</cfoutput>