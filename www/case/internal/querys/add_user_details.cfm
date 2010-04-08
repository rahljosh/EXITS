
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
	<!----
	<cfquery name="add_rep_details" datasource="caseusa">
	update smg_users
	Set companyid = "#form.companyid#",
		defaultcompany = #form.companyid#
	where userid = #url.userid#
	</cfquery>
	---->
	<!----
		<cfquery name="user_type" datasource="caseusa">
		select usertype
		from smg_users
		where userid=#url.userid#
		</cfquery>
	---->
	
		<cfquery name="add_user_regions" datasource="caseusa">
		Update smg_users
		Set whocreatedaccount = #client.userid#
		where userid = #url.userid#
		</cfquery>
	
<!----
			<cfloop list = #form.regions# index=x>
				<cfquery name="get_regions_company" datasource="caseusa">
				select company
				from smg_regions
				where regionid = #x#
				</cfquery>
				
				<cfquery name="insert_regions" datasource="caseusa">
				insert into user_access_rights (companyid, regionid, usertype, userid)
					values (#get_regions_company.company#, #x#, #user_type.usertype#, #url.userid#)
				</cfquery>
						
			</cfloop>
			<cfif isdefined ('form.regions')>
		</cfif>
	---->
	</cftransaction>
	
<cfquery name="get_info_for_email" datasource="caseusa">
select smg_users.firstname, smg_users.lastname, smg_users.username, smg_users.password, smg_users.email, smg_users.defaultcompany, smg_users.usertype, smg_users.whocreatedaccount,
smg_companies.url, smg_companies.companyshort, smg_companies.companyname 
from smg_users right join smg_companies on smg_users.defaultcompany = smg_companies.companyid 
where smg_users.userid = #url.userid#
</cfquery>

<cfif get_info_for_email.usertype is 8>

<cfelse>
		<Cfif #get_info_for_email.email# is ''>
	
		<cfelse>
	
			<cfoutput>
			mail would have been sent.
			<!----
			<cfmail from="#client.email#" to="#get_info_for_email.email#" subject="New Account Created / Login Information">
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
			
			You can login immediately by visiting:  http://www.student-management.com/  and log in with the information above. 
			
			If you have any questions or problems with logging in please contact support@student-management.com  or by replying to this email.
			
			If you have questions regarding your account access levels, please contact your Regional Advisor or Regional Director. 
			
			
			Sincerely-
			
			SMG Technical Support
			--
			Internal Ref: u#url.userid#eb#get_info_for_email.whocreatedaccount#
			
			</cfmail>
			---->
			</cfoutput>
	
		</cfif>
</cfif>
<!--- <cfoutput>
<meta http-equiv="Refresh" content="5;url=../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#&n=1">
</cfoutput> --->
<!----
<cflocation url="?curdoc=forms/region_access_rights&userid=#url.userid#&n=1" addtoken="no">
---->
<!----
<cflocation url="../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#&n=1" addtoken="no">
---->
