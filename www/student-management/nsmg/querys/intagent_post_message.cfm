


<cftransaction action="begin" isolation="SERIALIZABLE" >

<cfquery name="insert_message" datasource="MySQL">
insert into smg_intagent_messages
	(message, messagetype,startdate,expires,details  <cfif isDefined('form.additional_file')>, additional_file</cfif>, parentcompany, postedby)
values
	('#form.message#', '#form.messagetype#', '#form.startdate#', '#form.expires#', '#form.details#'    <cfif isDefined('form.additional_file')>,  '#form.filename#.pdf'</cfif>, #client.parentcompany#, #client.userid#)
</cfquery>


<cfif isDefined('form.send_email')>

<cfquery name="get_email" datasource="MySQL">
select distinct smg_users.userid, smg_users.email,  user_access_rights.usertype, user_access_rights.companyid, user_access_rights.userid 
from smg_users right join user_access_rights on smg_users.userid = user_access_rights.userid
where user_access_rights.usertype <= #form.lowest_level# and user_access_rights.usertype <> 8
and smg_users.email <> ''
<cfif form.companyid eq 0>
<cfelse>
and user_access_rights.companyid = #form.companyid#
</cfif>
group by smg_users.userid
</cfquery>

<cfoutput query="get_email">
<cfmail to="#email#" replyto="support@student-management.com" from="SMG Technical Support <support@student-management.com>" subject="#form.messagetype# message">
The following message was posted on student-management.com  It may contain information that will affect you on your next login. 
This message can also be viewed by logging into #CLIENT.exits_url# until #dateformat(expires, 'mm/d/yyyy')# at #TimeFormat(expires, 'h:mm:ss t')#

Message Type: #form.messagetype#
Message Subject: #form.message#
Message:
#form.details#

Date Sent: #DateFormat(now(), 'mm/dd/yyyy')#  at #TimeFormat(now(), 'h:mm:ss t')#
Effective Dates: #DateFormat(startdate, 'mm/dd/yyyy')#  at #TimeFormat(startdate, 'h:mm:ss t')# thru #DateFormat(expires, 'mm/dd/yyyy')#  at #TimeFormat(expires, 'h:mm:ss t')#


====================================================
This is message was automaticall generated by SMG. 
This message may contain confidential information.
If you have any concerns please immediately contact
support@student-management.com
=====================================================

</cfmail> 
</cfoutput>


</cfif>
</cftransaction>


<cfoutput>
<cflocation url='../index.cfm?curdoc=forms/message_inserted&type=#form.messagetype#'>
</cfoutput>

