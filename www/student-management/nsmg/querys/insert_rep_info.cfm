<cfif form.email is ''>
	<cfset username = "#left(form.rep_first_name, 1)##rep_last_name#">
	
<cfelse>
	<cfset username = "#form.email#">
</cfif>
<cfset datecreated =#DateFormat(#now()#,'yyyymmdd')#>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="insert_users_info" datasource="MySQL">
INSERT into smg_users (username, password, companyid,firstname,lastname,ssn,address,address2,city,state,zip,phone,email,occupation,businessname,businessphone,fax,datecreated)
			values("#username#","#form.temp_password#","#form.companyid#","#form.rep_first_name#", "#form.rep_last_name#","#form.social#", "#form.address1#", "#form.address2#",
					"#form.city#", "#form.state#", "#form.zip#", "#form.home_phone#","#form.email#", "#form.occupation#", "#form.business_name#", "#form.work_phone#", "#form.fax#", #datecreated#)
</cfquery>
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="get_id" datasource="MySQL">
select MAX(userid) as rep_id
from smg_users
</cfquery>
</cftransaction>
<cfoutput>
<cflocation url="../forms/rep_details.cfm?userid=#get_id.rep_id#" addtoken="No">
</cfoutput>
