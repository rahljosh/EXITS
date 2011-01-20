<cfquery name="activateAccount" datasource="#application.dsn#">
update smg_users
set active = 1,
	accountCreationVerified = #client.userid#,
    DateAccountVerified = #CreateODBCDate(now())#
where userid = #url.userid#
	
</cfquery>
<Cfquery name="userEmail" datasource="#application.dsn#">
select email, whocreated, firstname, lastname
from smg_users
where userid = #url.userid#
</Cfquery>
   <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#userEmail.email#">
					
                    <cfinvokeargument name="email_subject" value="New Account Created / Login Information">
                    <cfinvokeargument name="include_content" value="send_login">
                    <cfinvokeargument name="userid" value="#url.userid#">
                </cfinvoke>
 <Cfquery name="created" datasource="#application.dsn#">
 select email 
 from smg_users where userid = #userEmail.whocreated#
  </Cfquery>               

<Cfoutput>
<cfsavecontent variable="email_message">
 Just a quick note to let you know that the account for #userEmail.firstname# #userEmail.lastname# has been approved and is active. 
 

</cfsavecontent>
</Cfoutput>			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#created.email#">
                <cfinvokeargument name="email_subject" value="Account Approved">
                <cfinvokeargument name="email_message" value="#email_message#">
               
                <cfinvokeargument name="email_from" value="#companyshort#-support@exitsapplication.com">
            </cfinvoke>
    <!----End of Email---->
<cflocation url="index.cfm">