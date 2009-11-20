<cfset form.email = #Replace(form.email, '"', "", "all")#>
<cfset form.password = #Replace(form.password, '"', "", "all")#>
<cfset form.email = #Replace(form.email, "'", "", "all")#>
<cfset form.password = #Replace(form.password, "'", "", "all")#>
<cfquery name="check_username" datasource="mysql">
select *
from smg_users 
where email = '#form.email#'
</cfquery>
<cfif #check_username.recordcount# gt 0>
The username  you have entered, <cfoutput>#form.email#</cfoutput> is already registered with another account.  Please go back and select another username.<br>
<div align="center"><input name="back" type="image" src="pics/back.gif" align="center" alt="back" border=0 onClick="history.back()">
</div>
<cfabort>
</cfif>

<cfset datecreated =#DateFormat(#now()#,'yyyymmdd')#>

<cfif not isdefined("form.listing")>
	<cfset form.listing= "">
</cfif>

<cfif form.usertype is 3>
	<cfquery  name="insert_user_info" datasource="mysql">
	insert into smg_users ( firstname, lastname, address, address2, city, country, zip, phone, email, fax, datecreated, password, usertype,businessname,whocreated)
				values   ("#form.contact_first_name#", "#form.contact_last_name#","#form.companyaddress#", "#form.companyaddress2#", "#form.intcity#", "#form.country#", "#form.companyzip#", "#form.phone#", "#form.email#", "#form.fax#", #datecreated#, "#form.password#",#form.usertype#,"#form.companyname#", #client.userid#)
	</cfquery>
<cfelse>
	<cfquery  name="insert_user_info" datasource="mysql">
	insert into smg_users (firstname, lastname, address, address2, city, state, zip, phone, email, fax, datecreated, password, usertype, whocreated)
				values   ("#form.user_first_name#", "#form.user_last_name#","#form.address#", "#form.address2#", "#form.city#", "#form.state#", "#form.zip#", "#form.phone#", "#form.email#", "#form.fax#", #datecreated#, "#form.password#",#form.usertype#, #client.userid#)
	</cfquery>
</cfif>
<cfquery name="get_id" datasource="mysql">
select MAX(userid) as userid
from smg_users
</cfquery>
<cflocation url="index.cfm?curdoc=lists/users" addtoken="No">