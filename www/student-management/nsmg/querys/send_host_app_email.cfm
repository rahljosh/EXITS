
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="check_host_app" datasource="MySQL">
Select email, applicationsent
from smg_hosts
where email = "#form.email#"
</cfquery>
<cfif check_host_app.recordcount is 0>
<cfquery name="start_host_app" datasource="MySQL">
insert into smg_hosts (email, uniquecookieid, applicationsent)
	values ( "#form.email#", "#createuuid()#", #now()#)
</cfquery>
<cfquery name="get_uuid" datasource="MySQL">
select uniquecookieid
from smg_hosts
where email = "#form.email#"
</cfquery>

<cfoutput>
<cfmail to="#form.email#" from="support@student-management.com" subject="Requested Host Application">
To begin the host family application, please click on the following link. 
#CLIENT.exits_url#/newsmg/host.cfm?id=#get_uuid.uniquecookieid#

If the above is not a link, you can copy the link into your browser window.

If you have any questions as you are filling out the host application, please contact
Rep name and email.

Thank you.
Company Name

**This is an unmonitored email address, if you reply to this message it will not be recived.**
For email corespondance, please contact your area rep at the email address above.

</cfmail>
</cfoutput>
The link has been sent.

<cfelse>
<cfoutput>
The email address you have entered, #form.email# had an application link sent to them on #dateformat('#check_host_app.applicationsent#', 'mm/dd/yyyy')# at #timeformat('#check_host_app.applicationsent#', 'h:mm:ss tt')# EST
To resend 
</cfoutput>
</cfif>