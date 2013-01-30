<!--- Replace this with CLIENT/SESSION variables --->
<cfquery name="qGetCompanyInfo" datasource="#application.dsn#">
	select fax, toll_free, phone, company_color
	from smg_companies
	where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
</cfquery>
<cfoutput>
            </td>
        </tr>
    </table>
    
    <table width="90%">
	    <tr>
    		<td align="center" style="background-color:###qGetCompanyInfo.company_color#; font-weight:bold; font-size:12px;">
				<span style="color:##FFF;">
					<cfif LEN(qGetCompanyInfo.toll_free)>Toll-free: #qGetCompanyInfo.toll_free# &nbsp; &middot; &nbsp; </cfif>
                    <cfif LEN(qGetCompanyInfo.phone)>Local: #qGetCompanyInfo.phone# &nbsp; &middot; &nbsp; </cfif> 
                    <cfif LEN(qGetCompanyInfo.fax)>Fax: #qGetCompanyInfo.fax#</cfif> 
                </span>
			</td>	
        </tr>
	</table>
</cfoutput>