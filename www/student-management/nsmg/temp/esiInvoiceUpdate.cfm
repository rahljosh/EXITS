<cfquery name="invoiceCharges" datasource="#application.dsn#">
select *
from smg_charges
where companyid = 14
</cfquery>
<cfoutput>
<cfset stucount = 0>
<cfloop query="invoiceCharges">
<Cfset stucount = #stucount# + 1>
::#stucount#::


<cfif programid eq 318 AND companyid eq 14>
<Cfquery datasource="#application.dsn#">
	update smg_charges set programid = 352, description = '11/12 SY - ESI'
    where chargeid = #chargeid#
 </Cfquery>
</cfif>
<cfif programid eq 319 AND companyid eq 14>
<Cfquery datasource="#application.dsn#">
	update smg_charges set programid = 353, description = 'Aug 11 - Jan 12 - ESI'
    where chargeid = #chargeid#
 </Cfquery>
</cfif>
<cfif programid eq 330 AND companyid eq 14>
<Cfquery datasource="#application.dsn#">
	update smg_charges set programid = 354, description = 'Jan 12 - Jun 12 - ESI'
    where chargeid = #chargeid#
</Cfquery>
</cfif>
<cfif programid eq 332 AND companyid eq 14>
<Cfquery datasource="#application.dsn#">
	update smg_charges set programid = 346, description = '12/13 SY - ESI'
    where chargeid = #chargeid#
</Cfquery>
</cfif>
<cfif programid eq 333 AND companyid eq 14>
<Cfquery datasource="#application.dsn#">
	update smg_charges set programid = 347, description = 'Aug 12 - Jan 13 - ESI'
    where chargeid = #chargeid#
    </Cfquery>
</cfif>
<cfif programid eq 340 AND companyid eq 14>
<Cfquery datasource="#application.dsn#">
	update smg_charges set programid = 348, description = '13/14 SY - ESI'
    where chargeid = #chargeid#
 </Cfquery>
</cfif>
<cfif programid eq 343 AND companyid eq 14>
<Cfquery datasource="#application.dsn#">
	update smg_charges set programid = 351, description = 'Jan 13 - Jun 13 - ESI'
    where chargeid = #chargeid#
 </Cfquery>
</cfif>


<br>
</cfloop>
</cfoutput>