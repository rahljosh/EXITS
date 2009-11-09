	</td>
    </tr>
    </table>
<cfoutput>

 <Cfquery name="company_info" datasource="#application.dsn#">
 select fax, toll_free, phone
 from smg_companies
 where companyid = #client.companyid#
 </Cfquery>
<table width="600">
	  <tr>
     	<td colspan=2 bgcolor="#companycolor#" align="center"><font color="##FFFFFF" size=-2>Toll-free: #company_info.toll_free# &middot; Local: #company_info.phone# &middot; Fax: #company_info.fax# </font></td>
	</tr>
</table>
</div>
 </cfoutput>