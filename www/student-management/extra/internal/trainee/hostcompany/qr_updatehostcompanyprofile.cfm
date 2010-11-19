<!----- qr_updatehostcompanyprofile.cfm ---->
<cfquery name="qr_updatehostcompanyprofile" datasource="MySql">
UPDATE extra_hostcompany 
SET 
<cfif NOT IsDefined('form.business')>  
business_typeid = '',
<cfelse>
business_typeid = '#form.business#',
</cfif>


address = '#form.address#',
state = #form.state#,
name = '#form.name#',

<cfif NOT IsDefined('form.housing')>  
housing_options = '',
<cfelse>
housing_options = '#form.housing#',
</cfif>

email = '#form.email#',
city = '#form.city#',
fax = '#form.fax#',
zip = '#form.zip#',
phone = '#form.phone#',
supervisor = '#form.supervisor#',
db_number = '#form.db_number#',
<cfif NOT IsDefined('form.comp_received')>  comp_received = '0', <cfelse> comp_received = '#form.comp_received#', </cfif>
enteredby = '#client.userid#'

WHERE hostcompanyid = #url.hostcompanyid#
</cfquery>

<cflocation url="index.cfm?curdoc=hostcompany/hostcompany_profile&hostcompanyid=#url.hostcompanyid#">