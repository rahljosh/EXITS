
<cfif not isDefined('form.approve')>
Please verify that you want to transfer the app on the previous page.  You can use your back button to verify the process.
<cfelse>
    <cfquery name="update_company" datasource="#application.dsn#">
    update smg_students set companyid = 10
    where studentid = #form.approve#
    </cfquery>

<cfquery name="email_info" datasource="#application.dsn#">
select u.businessname, u.email, s.firstname, s.familylastname
from smg_students s 
LEFT join smg_users u on u.userid = s.intrep
where studentid = #form.approve#
</cfquery>
<cfoutput>
<cfsavecontent variable="email_message">
#email_info.businessname#<br><Br>

The application for #email_info.firstname# #email_info.familylastname# has been transfered to CASE.
<br>
You will receive notification from CASE with final approval information.
<Br><br>
Regards-<br>
#client.name#<br><br>
<font size=-2>Companies that use EXITS systems are able to transfer applications to each other, if desired.  You are receiving this notice as an application has been transfered from one company to another.  Please contact #client.email# with any questions.</font>     
</cfsavecontent>
</cfoutput>

<cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#email_info.email#, josh@pokytrails.com">
                <cfinvokeargument name="reply_to" value="#client.email#">
                <cfinvokeargument name="email_subject" value="EXITS Application Transferred">
                <cfinvokeargument name="email_message" value="#email_message#">
            </cfinvoke>
</cfif>