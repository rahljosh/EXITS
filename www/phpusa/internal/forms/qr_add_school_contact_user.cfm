<cfquery name="get_contact" datasource="mysql">
select contact, address, address2, city, state, zip, email, phone, fax, password
from php_schools
where schoolid = #url.school#
</cfquery>
<!----check for duplicate---->
<cfquery name="check_user" datasource="mysql">
select userid, firstname, lastname
from smg_users
where email = '#get_contact.email#'
</cfquery>
<cfoutput>
	<cfif check_user.recordcount gt 0> 
		The email address assoiciated with the user you are trying to add is already associated with  #check_user.firstname# #check_user.lastname# (#check_user.userid#).
		<br /><br />
		Use the grant access feature under Users->Add User to give access to people that are already in the sytem.
		<cfabort>
	</cfif>
</cfoutput>
<cftransaction action="begin" isolation="serializable">
<cfoutput query="get_contact">
<cfquery name="insert_contact" datasource="mysql">
insert into smg_users (uniqueid, firstname, address, address2, city, state, zip, phone, fax, email, companyid, username, password, datecreated, defaultcompany, firstlogin)
	values ('#createUUID()#', '#contact#', '#address#', '#address2#', '#city#', '#state#', '#zip#', '#phone#', '#fax#', '#email#', 6, '#email#', '#password#', #now()#, 6, 1)
</cfquery>
<cfquery name="get_user" datasource="mysql">
select userid
from smg_users
where email = '#email#'
</cfquery>
<cfquery name="insert_contact_usertype" datasource="mysql">
insert into user_Access_rights (userid, companyid, usertype)
	values (#get_user.userid#, 6, 7)
</cfquery>

</cfoutput>
</cftransaction>
<cflocation url="../index.cfm?curdoc=forms/edit_user_info&id=#get_user.userid#">


