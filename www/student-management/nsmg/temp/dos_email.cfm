
<cfquery name="host_emails" datasource="mysql">
select distinct smg_hosts.email, smg_hosts.familylastname as host_last, smg_hosts.hostid
from smg_hosts
left join smg_students on smg_students.hostid = smg_hosts.hostid
where smg_students.active = 1 and smg_students.companyid < 5 and smg_hosts.email <> '' and smg_hosts.hostid > 27007 and smg_hosts.hostid <> 10700 and smg_hosts.hostid <> 14673 and smg_hosts.hostid <> 28135
</cfquery>
<Cfoutput>

<cfset prev_email = 'j'>
<cfset emails_sent = 0>
    <Cfloop query="host_emails">
    <cfset emails_sent = #emails_sent# + 1>

 
 <cfsavecontent variable="email_message">
Dear  #host_last# Family,<br><br>
The Department of State's proposed rule on the high school category of the Exchange Visitor Program, published on May 3, includes a provision prohibiting single parents without school age children in the home from hosting exchange students.  The proposed regulations suggest that single host parents put students at risk, but do not offer any data to support this conclusion.<br /><br />
This provision not only discriminates against an entire class of Americans, but also would reduce the positive impact of high school exchanges by reducing the number of host families available, and thus the number of students who can participate.
ISE and the Alliance for International Educational & Cultural Exchange urges you to contact your Senators and Representatives immediately and ask them to request that the Department of State eliminate this damaging provision. <strong>Take action <a href="http://capwiz.com/alliance-exchange/issues/alert/?alertid=15198646&PROCESS=Take+Action">here</a>!</strong> Using the template letter provided, you can contact your entire Congressional delegation in just a few minutes. Please feel free to edit the letter to include examples from your own experiences. <br /><Br />
As an American host family for ISE, we rely upon your interest in student exchange to move this program forward for the United States. Your assistance in this matter would be greatly appreciated by all host families throughout the country.
Thank you for supporting international exchange programs, and don't hesitate to share this call to action with your family, friends, and/or colleagues.
<br><br>
We respect your privacy and do not wish to send you unwanted email.  While we rarely send out mass emails, we feel this is an important issue and appreciate the feedback. Rest assured that your email has not been sold or added to any mailing list and you are only receiving this email as our records show you will be or are hosting a student with ISE. <br><br>
Thank you,<br>
International Student Exchange 
</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#email#">
                <cfinvokeargument name="email_subject" value="Proposed State Department regulation change">
                <cfinvokeargument name="email_message" value="#email_message#">
                
                <cfinvokeargument name="email_from" value="Bob Keegan <bob@iseusa.com>">
            </cfinvoke>
           
    
   #hostid# #email#<Br />
       
    </Cfloop>
#emails_sent#
</Cfoutput>
	

    <!----End of Email---->

            all complete 