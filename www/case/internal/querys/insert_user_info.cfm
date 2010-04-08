<cfif not isDefined('form.sex')>
	You must specify the sex of the new user.  Please go back and correct this error.
	<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
	<cfabort>
</cfif>

<cfif form.username is ''>
	The username can't not be blank, this should be the users email address unless you want to specify a different username.  Filling out the email address field should auto
	poplulate the username.  Please go back and enter a username/email address.
	<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
	<cfabort>
</cfif>

<cfset form.username = #Replace(form.username, '"', "", "all")#>
<cfset form.password = #Replace(form.password, '"', "", "all")#>
<cfset form.username = #Replace(form.username, "'", "", "all")#>
<cfset form.password = #Replace(form.password, "'", "", "all")#>
<cfquery name="check_username" datasource="caseusa">
	select *
	from smg_users 
	where username = '#form.username#'
</cfquery>

<cfif #check_username.recordcount# gt 0>
	The username  you have entered, <cfoutput>#form.username#</cfoutput> is already registered with another account.  Please go back and select another username.
	<div class="button"><input name="back" type="image" src="pics/back.gif" align="right" border=0 onClick="history.back()"></div>
	<cfabort>
</cfif>

<cfset datecreated =#DateFormat(#now()#,'yyyymmdd')#>

<cfif not isdefined("form.listing")>
	<cfset form.listing= "">
</cfif>

<cfif form.usertype is 8>
	<cfquery  name='insert_user_info' datasource='caseusa'>
			insert into smg_users (uniqueid, username, firstname, lastname, address, address2, city, country, zip, phone, email, fax, datecreated, password, phone_listing, usertype,businessname)
				values   ('#form.uniqueid#', '#form.username#','#form.contact_first_name#', '#form.contact_last_name#','#form.companyaddress#', '#form.companyaddress2#', '#form.intcity#', '#form.country#', '#form.companyzip#', '#form.phone#', '#form.email#', '#form.fax#', #datecreated#, '#form.password#', '#form.listing#',#form.usertype#,'#form.companyname#')
	</cfquery>
<cfelse>
	<cfset EncryptSSN = ''>
	<cfif IsDefined('form.ssn') AND form.ssn NEQ ''>
		<cfset EncryptSSN = encrypt("#form.ssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
	<cfelse>
		<cfset EncryptSSN = ''>
	</cfif>
	<cfquery  name='insert_user_info' datasource='caseusa'>
		insert into smg_users (uniqueid, username, firstname, lastname, address, address2, city, state, zip, phone, work_phone, cell_phone, email, fax, datecreated, password, phone_listing, usertype, sex, ssn)
				values   ('#form.uniqueid#','#form.username#','#form.user_first_name#', '#form.user_last_name#','#form.address#', '#form.address2#', '#form.city#', '#form.state#', '#form.zip#', '#form.phone#', '#form.work_phone#', '#form.cell_phone#', '#form.email#', '#form.fax#', #datecreated#, '#form.password#', '#form.listing#',#form.usertype#, '#form.sex#','#EncryptSSN#')
	</cfquery>
</cfif>

<cfquery name="get_id" datasource="caseusa">
	select MAX(userid) as userid
	from smg_users
</cfquery>

<cfquery name="update_default" datasource="caseusa">
	update smg_users
	set defaultcompany = #client.companyid#
	where userid = #get_id.userid#
</cfquery>

<!----
<cfquery name="add_user_regions" datasource="caseusa">
Update smg_users
Set whocreatedaccount = #client.userid#
where userid = #url.userid#
</cfquery>
---->

<cfquery name="get_info_for_email" datasource="caseusa">
	select smg_users.firstname, smg_users.lastname, smg_users.username, smg_users.password, smg_users.email, smg_users.defaultcompany, smg_users.usertype, smg_users.whocreatedaccount,
	smg_companies.url, smg_companies.companyshort, smg_companies.companyname 
	from smg_users right join smg_companies on smg_users.defaultcompany = smg_companies.companyid 
	where smg_users.userid = #get_id.userid#
</cfquery>

<cfif get_info_for_email.usertype is 8>

<cfelse>
		<Cfif #get_info_for_email.email# is ''>
	
		<cfelse>
	
			<cfoutput>
			
			
<cfmail from="support@case-usa.org" to="#get_info_for_email.email#" subject="New Account Created / Login Information">
An account has been created for you on the #get_info_for_email.companyname# website.  Your account login information is below.  

Login ID / Username: #get_info_for_email.username#
Password: #get_info_for_email.password#

Upon your first login, you will need to activate your account by providing your zip code and the last four digits of your phone number. 
You will then be prompted to change your password from the temporary password to one of your choosing.  Once you have changed your password 
you will have to login again with your new password.

After you have successfully completed your login, you can change your password, username or any other account information by going to Users 
from the main menu and clicking on your name, then on Edit.  All changes that you make will be immediate. 

Two things to keep in mind when changing your password:
*your password MUST be at least 6 characters long
*you password can not start with the word 'temp'

You can login immediately by visiting:  http://www.case-usa.org/  and log in with the information above. 

If you have any questions or problems with logging in please contact support@case-usa.org or  reply to this email.


Sincerely-

EXITS Technical Support
--
Internal Ref: u#get_id.userid#eb#get_info_for_email.whocreatedaccount#

</cfmail>

</cfoutput>
	
		</cfif>
</cfif>
<cflocation url="index.cfm?curdoc=forms/region_access_rights&userid=#get_id.userid#&n=1" addtoken="No">
<!----
<cflocation url="index.cfm?curdoc=forms/user_details&userid=#get_id.userid#" addtoken="No">
---->
